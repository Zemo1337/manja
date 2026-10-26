import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_core/nutrition_core.dart' show CookingUnit, Food, FoodSource, gramsFor;

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../data/recipe_foods.dart';
import '../../data/recipe_importer.dart';
import '../../domain/ingredient_suggestions.dart';
import '../../domain/tag_matching.dart';
import '../../domain/units.dart';
import '../../l10n/l10n.dart';
import '../nutrition/food_picker_sheet.dart';
import '../settings/tags_screen.dart';
import 'recipe_photo.dart';
import '../app_theme.dart';

class RecipeEditScreen extends StatefulWidget {
  const RecipeEditScreen({super.key, this.existing, this.template});

  final RecipeFull? existing;
  final RecipeTemplate? template;

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _IngredientRow {
  _IngredientRow({String name = '', String amount = '', this.unit = CookingUnit.g, this.foodKey})
    : name = TextEditingController(text: name),
      amount = TextEditingController(text: amount),
      heading = false;

  _IngredientRow.heading([String text = ''])
    : name = TextEditingController(text: text),
      amount = TextEditingController(),
      unit = CookingUnit.g,
      heading = true;

  final bool heading;

  final TextEditingController name;
  final TextEditingController amount;
  final focus = FocusNode();
  CookingUnit unit;
  String? foodKey;
  Food? food;

  void dispose() {
    name.dispose();
    amount.dispose();
    focus.dispose();
  }
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _portions;
  late final TextEditingController _prep;
  late final TextEditingController _cook;
  late final TextEditingController _info;
  late final TextEditingController _finishedWeight;
  late final List<_IngredientRow> _ingredients;
  late final List<TextEditingController> _steps;
  final _picker = ImagePicker();
  XFile? _pickedPhoto;
  bool _photoRemoved = false;
  bool _saving = false;
  bool _foodsLoaded = false;
  List<Tag> _tags = const [];
  List<IngredientSuggestion> _suggestions = const [];
  Set<int>? _tagIds;

  String? get _existingPhoto => widget.existing?.recipe.photoPath;

  bool get _hasPhoto => _pickedPhoto != null || (_existingPhoto != null && !_photoRemoved);

  bool get _isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final r = widget.existing?.recipe;
    final t = widget.template;
    _name = TextEditingController(text: r?.name ?? t?.name ?? '');
    _portions = TextEditingController(text: '${r?.portions ?? t?.portions ?? 2}');
    _prep = TextEditingController(text: (r?.prepMinutes ?? t?.prepMinutes)?.toString() ?? '');
    _cook = TextEditingController(text: (r?.cookMinutes ?? t?.cookMinutes)?.toString() ?? '');
    _info = TextEditingController(text: r?.cookingInfo ?? t?.cookingInfo ?? '');
    _finishedWeight = TextEditingController(text: r?.finishedWeightG == null ? '' : formatAmount(r!.finishedWeightG!));
    _ingredients = [];
    String? section;
    for (final i in widget.existing?.ingredients ?? const <RecipeIngredient>[]) {
      if (i.section != null && i.section != section) _ingredients.add(_IngredientRow.heading(i.section!));
      section = i.section;
      _ingredients.add(
        _IngredientRow(
          name: i.name,
          amount: i.amount > 0 ? formatAmount(i.amount) : '',
          unit: CookingUnit.fromName(i.unit),
          foodKey: i.foodKey,
        ),
      );
    }
    for (final i in t?.ingredients ?? const <({String name, double? amount, CookingUnit unit})>[]) {
      _ingredients.add(
        _IngredientRow(name: i.name, amount: i.amount == null ? '' : formatAmount(i.amount!), unit: i.unit),
      );
    }
    if (_ingredients.isEmpty) _ingredients.add(_IngredientRow());
    _steps = [
      for (final s in widget.existing?.steps ?? const <RecipeStep>[]) TextEditingController(text: s.body),
      for (final s in t?.steps ?? const <String>[]) TextEditingController(text: s),
    ];
    if (_steps.isEmpty) _steps.add(TextEditingController());
    if (t?.photoPath != null) _pickedPhoto = XFile(t!.photoPath!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_foodsLoaded) {
      _foodsLoaded = true;
      _loadFoods();
      _loadTags();
      _loadSuggestions();
    }
  }

  Future<void> _loadSuggestions() async {
    final uses = await AppScope.of(context).db.ingredientNameUses();
    if (mounted) _suggestions = ingredientSuggestions(uses);
  }

  Future<void> _useSuggestion(_IngredientRow row, IngredientSuggestion suggestion) async {
    final key = suggestion.foodKey;
    if (row.foodKey != null || key == null) return;
    final food = (await AppScope.of(context).nutrition.foodsByKey({key}))[key];
    if (!mounted || row.foodKey != null) return;
    setState(() => _setLink(row, key, food));
  }

  /// Recipes are measured in portions or by weight, other ingredients in anything but portions.
  void _setLink(_IngredientRow row, String? key, Food? food) {
    final wasRecipe = recipeIdOfFoodKey(row.foodKey) != null;
    row.foodKey = key;
    row.food = food;
    final units = _unitsFor(row);
    if (!units.contains(row.unit) || (!wasRecipe && recipeIdOfFoodKey(key) != null)) row.unit = units.first;
  }

  static List<CookingUnit> _unitsFor(_IngredientRow row) => recipeIdOfFoodKey(row.foodKey) != null
      ? recipeUnits
      : [
          for (final u in CookingUnit.values)
            if (u != CookingUnit.portion) u,
        ];

  /// Quantity, unit and name; the name suggestions open below all three so long names fit.
  Widget _ingredientFields(_IngredientRow row) => RawAutocomplete<IngredientSuggestion>(
    textEditingController: row.name,
    focusNode: row.focus,
    optionsBuilder: (value) => matchIngredientSuggestions(_suggestions, value.text),
    displayStringForOption: (s) => s.name,
    onSelected: (s) => _useSuggestion(row, s),
    fieldViewBuilder: (context, controller, focusNode, onSubmitted) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: TextFormField(
            controller: row.amount,
            decoration: InputDecoration(labelText: context.l10n.recipeQty, border: const OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) => (v ?? '').trim().isNotEmpty && _parseAmount(v!) == null ? '?' : null,
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 96,
          child: DropdownButtonFormField<CookingUnit>(
            key: ValueKey((row.unit, recipeIdOfFoodKey(row.foodKey) != null)),
            initialValue: row.unit,
            isExpanded: true,
            decoration: InputDecoration(labelText: context.l10n.recipeUnit, border: const OutlineInputBorder()),
            items: [
              for (final u in _unitsFor(row))
                DropdownMenuItem(
                  value: u,
                  child: Text(u.symbolIn(context.l10n), overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (u) => setState(() => row.unit = u ?? row.unit),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(labelText: context.l10n.recipeIngredient, border: const OutlineInputBorder()),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
      ],
    ),
    optionsViewBuilder: (context, onSelected, options) => Material(
      elevation: 3,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 264),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            for (final s in options)
              ListTile(
                dense: true,
                leading: Icon(s.foodKey == null ? Icons.history : Icons.link, size: 20),
                title: Text(s.name),
                trailing: Text(context.l10n.recipeSuggestionRecipes(s.recipes)),
                onTap: () => onSelected(s),
              ),
          ],
        ),
      ),
    ),
  );

  Future<void> _loadFoods() async {
    final keys = {for (final r in _ingredients) ?r.foodKey};
    if (keys.isEmpty) return;
    final foods = await AppScope.of(context).nutrition.foodsByKey(keys);
    if (!mounted) return;
    setState(() {
      for (final r in _ingredients) {
        r.food = foods[r.foodKey];
      }
    });
  }

  Future<void> _loadTags() async {
    final tags = await AppScope.of(context).db.allTags();
    if (!mounted) return;
    final Set<int> selected;
    if (widget.existing case final existing?) {
      selected = {for (final t in existing.tags) t.id};
    } else {
      final matched = matchTags(widget.template?.categories ?? const [], tags);
      selected = matched.isEmpty
          ? {
              for (final t in tags)
                if (t.kind == TagKind.main) t.id,
            }
          : {for (final t in matched) t.id};
    }
    setState(() {
      _tags = tags;
      _tagIds = selected;
    });
  }

  Future<void> _newTag() async {
    final name = await showTagNameDialog(context);
    if (name == null || !mounted) return;
    final db = AppScope.of(context).db;
    final id = await db.addTag(name);
    final tags = await db.allTags();
    if (!mounted) return;
    setState(() {
      _tags = tags;
      _tagIds = {...?_tagIds, id};
    });
  }

  Widget _tagSection(BuildContext context) {
    final selected = _tagIds ?? const <int>{};
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final t in _tags)
          FilterChip(
            label: Text(t.name),
            selected: selected.contains(t.id),
            onSelected: (on) => setState(() {
              final ids = {...?_tagIds};
              on ? ids.add(t.id) : ids.remove(t.id);
              _tagIds = ids;
            }),
          ),
        ActionChip(avatar: const Icon(Icons.add, size: 18), label: Text(context.l10n.recipeNewTag), onPressed: _newTag),
      ],
    );
  }

  Future<void> _linkFood(_IngredientRow row) async {
    final food = await showFoodPicker(
      context,
      initialQuery: row.name.text.trim(),
      recipes: true,
      forRecipe: widget.existing?.recipe.id,
    );
    if (food == null || !mounted) return;
    setState(() {
      _setLink(row, food.key, food);
      if (row.name.text.trim().isEmpty) row.name.text = food.name;
    });
  }

  void _unlinkFood(_IngredientRow row) => setState(() => _setLink(row, null, null));

  Widget _foodLink(BuildContext context, _IngredientRow row) {
    final theme = Theme.of(context);
    final l = context.l10n;
    if (row.foodKey == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _linkFood(row),
          icon: const Icon(Icons.link, size: 18),
          label: Text(l.recipeLinkNutrition),
          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
        ),
      );
    }
    final food = row.food;
    final convertible = food != null && gramsFor(food, 1, row.unit) != null;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Icon(Icons.link, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food?.name ??
                      (recipeIdOfFoodKey(row.foodKey) != null
                          ? l.recipeLinkedRecipeDeleted
                          : l.recipeLinkedIngredientMissing),
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (food != null && !convertible)
                  Text(
                    food.source == FoodSource.recipe
                        ? l.recipePortionWeightUnknown(food.name)
                        : l.recipeNoGramWeight(row.unit.symbolIn(l)),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: l.recipeChangeLink,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.swap_horiz, size: 20),
            onPressed: () => _linkFood(row),
          ),
          IconButton(
            tooltip: l.recipeUnlink,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.link_off, size: 20),
            onPressed: () => _unlinkFood(row),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final c in [_name, _portions, _prep, _cook, _info, _finishedWeight, ..._steps]) {
      c.dispose();
    }
    for (final row in _ingredients) {
      row.dispose();
    }
    super.dispose();
  }

  double? _parseAmount(String text) => double.tryParse(text.trim().replaceAll(',', '.'));

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, maxWidth: 1600, maxHeight: 1600, imageQuality: 85);
      if (picked == null || !mounted) return;
      setState(() {
        _pickedPhoto = picked;
        _photoRemoved = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.recipePhotoLoadError('$e'))));
    }
  }

  void _removePhoto() => setState(() {
    _pickedPhoto = null;
    _photoRemoved = true;
  });

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final scope = AppScope.of(context);
    var photoPath = _photoRemoved ? null : _existingPhoto;
    String? stalePhoto = _photoRemoved ? _existingPhoto : null;
    if (_pickedPhoto != null) {
      photoPath = await scope.photos.save(_pickedPhoto!.path);
      stalePhoto = _existingPhoto;
    }
    final draft = RecipeDraft(
      id: widget.existing?.recipe.id,
      name: _name.text.trim(),
      portions: int.parse(_portions.text.trim()),
      prepMinutes: int.tryParse(_prep.text.trim()),
      cookMinutes: int.tryParse(_cook.text.trim()),
      cookingInfo: _info.text.trim(),
      finishedWeightG: _parseAmount(_finishedWeight.text),
      sourceUrl: widget.existing?.recipe.sourceUrl ?? widget.template?.sourceUrl,
      isFavorite: widget.existing?.recipe.isFavorite ?? false,
      photoPath: photoPath,
      ingredients: _ingredientDrafts(),
      steps: [
        for (final s in _steps)
          if (s.text.trim().isNotEmpty) s.text.trim(),
      ],
      tagIds: _tagIds?.toList(),
    );
    await scope.db.saveRecipe(draft);
    await scope.photos.delete(stalePhoto);
    if (mounted) Navigator.pop(context);
  }

  List<IngredientDraft> _ingredientDrafts() {
    final drafts = <IngredientDraft>[];
    String? section;
    for (final row in _ingredients) {
      final name = row.name.text.trim();
      if (name.isEmpty) continue;
      if (row.heading) {
        section = name;
        continue;
      }
      drafts.add(
        IngredientDraft(
          name: name,
          amount: _parseAmount(row.amount.text) ?? 0,
          unit: row.unit.name,
          foodKey: row.foodKey,
          section: section,
        ),
      );
    }
    return drafts;
  }

  void _addHeading() => setState(() {
    final first = !_ingredients.any((r) => r.heading);
    _ingredients.insert(first ? 0 : _ingredients.length, _IngredientRow.heading());
  });

  Widget _photoSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Widget image;
    if (_pickedPhoto != null) {
      image = PickedPhoto(file: File(_pickedPhoto!.path));
    } else if (_hasPhoto) {
      image = RecipePhoto(recipe: widget.existing!.recipe, cacheWidth: 1200);
    } else {
      image = ColoredBox(
        color: scheme.surfaceContainerHighest,
        child: Center(child: Icon(Icons.add_a_photo_outlined, size: 48, color: scheme.onSurfaceVariant)),
      );
    }
    final camera = _picker.supportsImageSource(ImageSource.camera);
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: InkWell(onTap: () => _pickPhoto(ImageSource.gallery), child: image),
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          children: [
            if (camera)
              TextButton.icon(
                onPressed: () => _pickPhoto(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l.recipeCamera),
              ),
            TextButton.icon(
              onPressed: () => _pickPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(camera ? l.recipeGallery : l.recipeChoosePhoto),
            ),
            if (_hasPhoto)
              TextButton.icon(
                onPressed: _removePhoto,
                icon: const Icon(Icons.delete_outline),
                label: Text(l.recipeRemove),
              ),
          ],
        ),
      ],
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? context.l10n.recipeRequired : null;

  String? _optionalMinutes(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final n = int.tryParse(v.trim());
    return n == null || n < 0 ? context.l10n.recipeWholeMinutes : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l.recipeEditTitleNew : l.recipeEditTitleEdit),
        actions: [HeaderTextButton(onPressed: _saving ? null : _save, label: l.recipeSave)],
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            _section(top: 16, [
              _photoSection(context),
              const SizedBox(height: 12),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: l.recipeName, border: const OutlineInputBorder()),
                textCapitalization: TextCapitalization.sentences,
                validator: _required,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _portions,
                      decoration: InputDecoration(labelText: l.recipePortions, border: const OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (v) => (int.tryParse(v?.trim() ?? '') ?? 0) < 1 ? l.recipeAtLeastOne : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _prep,
                      decoration: InputDecoration(labelText: l.recipePrepMinutes, border: const OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: _optionalMinutes,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _cook,
                      decoration: InputDecoration(labelText: l.recipeCookMinutes, border: const OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: _optionalMinutes,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l.recipeTags, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _tagSection(context),
              const SizedBox(height: 24),
              Text(l.recipeIngredients, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
            ]),
            _reorderable(_ingredients, _ingredientTile),
            _section([
              Wrap(
                spacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() => _ingredients.add(_IngredientRow())),
                    icon: const Icon(Icons.add),
                    label: Text(l.recipeAddIngredient),
                  ),
                  TextButton.icon(
                    onPressed: _addHeading,
                    icon: const Icon(Icons.title),
                    label: Text(l.recipeAddHeading),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _finishedWeight,
                decoration: InputDecoration(
                  labelText: l.recipeFinishedWeight,
                  helperText: l.recipeFinishedWeightHelp,
                  helperMaxLines: 2,
                  suffixText: 'g',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final g = _parseAmount(v);
                  return g == null || g <= 0 ? l.recipeFinishedWeightInvalid : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _info,
                decoration: InputDecoration(
                  labelText: l.recipeCookingInfo,
                  hintText: l.recipeCookingInfoHint,
                  border: const OutlineInputBorder(),
                ),
                minLines: 2,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              Text(l.recipePreparationSteps, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
            ]),
            _reorderable(_steps, _stepTile),
            _section([
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _steps.add(TextEditingController())),
                  icon: const Icon(Icons.add),
                  label: Text(l.recipeAddStep),
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _section(List<Widget> children, {double top = 0}) => SliverPadding(
    padding: EdgeInsets.fromLTRB(16, top, 16, 0),
    sliver: SliverList.list(children: children),
  );

  Widget _reorderable<T extends Object>(List<T> items, Widget Function(int index, T item) tile) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    sliver: SliverReorderableList(
      itemCount: items.length,
      itemBuilder: (context, index) => KeyedSubtree(key: ObjectKey(items[index]), child: tile(index, items[index])),
      onReorderItem: (from, to) => setState(() => items.insert(to, items.removeAt(from))),
      proxyDecorator: (child, index, animation) => Material(
        elevation: 6,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    ),
  );

  Widget _dragHandle(int index) => ReorderableDragStartListener(
    index: index,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 6, 16),
      child: Icon(Icons.drag_indicator, semanticLabel: context.l10n.recipeDragToReorder),
    ),
  );

  Widget _ingredientTile(int index, _IngredientRow row) => row.heading
      ? _headingTile(index, row)
      : Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dragHandle(index),
                  Expanded(child: _ingredientFields(row)),
                  IconButton(
                    tooltip: context.l10n.recipeRemove,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _ingredients.removeAt(index).dispose()),
                  ),
                ],
              ),
              Padding(padding: const EdgeInsets.only(left: 30), child: _foodLink(context, row)),
            ],
          ),
        );

  Widget _headingTile(int index, _IngredientRow row) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dragHandle(index),
        Expanded(
          child: TextFormField(
            controller: row.name,
            decoration: InputDecoration(
              labelText: context.l10n.recipeHeading,
              hintText: context.l10n.recipeHeadingHint,
              prefixIcon: const Icon(Icons.title),
              border: const OutlineInputBorder(),
            ),
            style: Theme.of(context).textTheme.titleMedium,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        IconButton(
          tooltip: context.l10n.recipeRemove,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _ingredients.removeAt(index).dispose()),
        ),
      ],
    ),
  );

  Widget _stepTile(int index, TextEditingController step) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dragHandle(index),
        Padding(
          padding: const EdgeInsets.only(top: 12, right: 8),
          child: CircleAvatar(radius: 14, child: Text('${index + 1}')),
        ),
        Expanded(
          child: TextFormField(
            controller: step,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            minLines: 1,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        IconButton(
          tooltip: context.l10n.recipeRemove,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _steps.removeAt(index).dispose()),
        ),
      ],
    ),
  );
}
