import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_core/nutrition_core.dart' show Food, gramsFor;

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/units.dart';
import '../nutrition/food_picker_sheet.dart';
import 'recipe_photo.dart';

class RecipeEditScreen extends StatefulWidget {
  const RecipeEditScreen({super.key, this.existing});

  final RecipeFull? existing;

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _IngredientRow {
  _IngredientRow({String name = '', String amount = '', this.unit = CookingUnit.g, this.foodKey})
    : name = TextEditingController(text: name),
      amount = TextEditingController(text: amount);

  final TextEditingController name;
  final TextEditingController amount;
  CookingUnit unit;
  String? foodKey;
  Food? food;

  void dispose() {
    name.dispose();
    amount.dispose();
  }
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _portions;
  late final TextEditingController _prep;
  late final TextEditingController _cook;
  late final TextEditingController _info;
  late final List<_IngredientRow> _ingredients;
  late final List<TextEditingController> _steps;
  final _picker = ImagePicker();
  XFile? _pickedPhoto;
  bool _photoRemoved = false;
  bool _saving = false;
  bool _foodsLoaded = false;

  String? get _existingPhoto => widget.existing?.recipe.photoPath;

  bool get _hasPhoto => _pickedPhoto != null || (_existingPhoto != null && !_photoRemoved);

  bool get _isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final r = widget.existing?.recipe;
    _name = TextEditingController(text: r?.name ?? '');
    _portions = TextEditingController(text: '${r?.portions ?? 2}');
    _prep = TextEditingController(text: r?.prepMinutes?.toString() ?? '');
    _cook = TextEditingController(text: r?.cookMinutes?.toString() ?? '');
    _info = TextEditingController(text: r?.cookingInfo ?? '');
    _ingredients = [
      for (final i in widget.existing?.ingredients ?? const <RecipeIngredient>[])
        _IngredientRow(
          name: i.name,
          amount: formatAmount(i.amount),
          unit: CookingUnit.fromName(i.unit),
          foodKey: i.foodKey,
        ),
    ];
    if (_ingredients.isEmpty) _ingredients.add(_IngredientRow());
    _steps = [for (final s in widget.existing?.steps ?? const <RecipeStep>[]) TextEditingController(text: s.body)];
    if (_steps.isEmpty) _steps.add(TextEditingController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_foodsLoaded) {
      _foodsLoaded = true;
      _loadFoods();
    }
  }

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

  Future<void> _linkFood(_IngredientRow row) async {
    final food = await showFoodPicker(context, initialQuery: row.name.text.trim());
    if (food == null || !mounted) return;
    setState(() {
      row.food = food;
      row.foodKey = food.key;
      if (row.name.text.trim().isEmpty) row.name.text = food.name;
    });
  }

  void _unlinkFood(_IngredientRow row) => setState(() {
    row.food = null;
    row.foodKey = null;
  });

  Widget _foodLink(BuildContext context, _IngredientRow row) {
    final theme = Theme.of(context);
    if (row.foodKey == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _linkFood(row),
          icon: const Icon(Icons.link, size: 18),
          label: const Text('Link nutrition'),
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
                  food?.name ?? 'Linked ingredient (not on this device)',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (food != null && !convertible)
                  Text(
                    'No gram weight for "${row.unit.symbol}". Use g or ml, or add a portion to the ingredient.',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Change',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.swap_horiz, size: 20),
            onPressed: () => _linkFood(row),
          ),
          IconButton(
            tooltip: 'Unlink',
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
    for (final c in [_name, _portions, _prep, _cook, _info, ..._steps]) {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not load the photo: $e')));
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
      isFavorite: widget.existing?.recipe.isFavorite ?? false,
      photoPath: photoPath,
      ingredients: [
        for (final row in _ingredients)
          if (row.name.text.trim().isNotEmpty)
            IngredientDraft(
              name: row.name.text.trim(),
              amount: _parseAmount(row.amount.text) ?? 0,
              unit: row.unit.name,
              foodKey: row.foodKey,
            ),
      ],
      steps: [
        for (final s in _steps)
          if (s.text.trim().isNotEmpty) s.text.trim(),
      ],
    );
    await scope.db.saveRecipe(draft);
    await scope.photos.delete(stalePhoto);
    if (mounted) Navigator.pop(context);
  }

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
                label: const Text('Camera'),
              ),
            TextButton.icon(
              onPressed: () => _pickPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(camera ? 'Gallery' : 'Choose photo'),
            ),
            if (_hasPhoto)
              TextButton.icon(
                onPressed: _removePhoto,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove'),
              ),
          ],
        ),
      ],
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _optionalMinutes(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final n = int.tryParse(v.trim());
    return n == null || n < 0 ? 'Whole minutes' : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New recipe' : 'Edit recipe'),
        actions: [TextButton(onPressed: _saving ? null : _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _photoSection(context),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.sentences,
              validator: _required,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _portions,
                    decoration: const InputDecoration(labelText: 'Portions', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (v) => (int.tryParse(v?.trim() ?? '') ?? 0) < 1 ? 'At least 1' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _prep,
                    decoration: const InputDecoration(labelText: 'Prep (min)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: _optionalMinutes,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _cook,
                    decoration: const InputDecoration(labelText: 'Cook (min)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: _optionalMinutes,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Ingredients', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final (index, row) in _ingredients.indexed)
              Padding(
                key: ObjectKey(row),
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 72,
                          child: TextFormField(
                            controller: row.amount,
                            decoration: const InputDecoration(labelText: 'Qty', border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (v) =>
                                row.name.text.trim().isNotEmpty && _parseAmount(v ?? '') == null ? '?' : null,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 104,
                          child: DropdownButtonFormField<CookingUnit>(
                            initialValue: row.unit,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'Unit', border: OutlineInputBorder()),
                            items: [
                              for (final u in CookingUnit.values)
                                DropdownMenuItem(
                                  value: u,
                                  child: Text(u.symbol, overflow: TextOverflow.ellipsis),
                                ),
                            ],
                            onChanged: (u) => setState(() => row.unit = u ?? row.unit),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextFormField(
                            controller: row.name,
                            decoration: const InputDecoration(labelText: 'Ingredient', border: OutlineInputBorder()),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove',
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _ingredients.removeAt(index).dispose()),
                        ),
                      ],
                    ),
                    _foodLink(context, row),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _ingredients.add(_IngredientRow())),
                icon: const Icon(Icons.add),
                label: const Text('Add ingredient'),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _info,
              decoration: const InputDecoration(
                labelText: 'Cooking info',
                hintText: 'Oven temperature, pan size, tips…',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            Text('Preparation steps', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final (index, step) in _steps.indexed)
              Padding(
                key: ObjectKey(step),
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      tooltip: 'Remove',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _steps.removeAt(index).dispose()),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _steps.add(TextEditingController())),
                icon: const Icon(Icons.add),
                label: const Text('Add step'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
