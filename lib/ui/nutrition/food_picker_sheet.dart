import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../data/nutrition_repository.dart';
import '../../data/recipe_foods.dart';
import '../../domain/text_fold.dart';
import '../../l10n/l10n.dart';
import 'api_key_dialogs.dart';
import 'barcode_scanner_screen.dart';
import 'food_edit_screen.dart';

/// With [recipes], recipes tagged as ingredients are offered too, except [forRecipe] and the recipes using it.
Future<Food?> showFoodPicker(BuildContext context, {String initialQuery = '', bool recipes = false, int? forRecipe}) {
  return showModalBottomSheet<Food>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.9,
      child: _FoodPicker(initialQuery: initialQuery, recipes: recipes, forRecipe: forRecipe),
    ),
  );
}

class _FoodPicker extends StatefulWidget {
  const _FoodPicker({required this.initialQuery, required this.recipes, this.forRecipe});

  final String initialQuery;
  final bool recipes;
  final int? forRecipe;

  @override
  State<_FoodPicker> createState() => _FoodPickerState();
}

class _FoodPickerState extends State<_FoodPicker> {
  late final _query = TextEditingController(text: widget.initialQuery);
  Timer? _debounce;
  int _generation = 0;
  List<FoodSummary> _local = const [];
  List<FoodSummary>? _remote;
  String? _remoteQuery;
  FoodSource _remoteSource = FoodSource.usda;
  String? _scanError;
  String? _scannedCode;
  bool _remoteLoading = false;
  String? _remoteError;
  String? _opening;
  Map<String, int>? _uses;
  List<Recipe>? _ingredientRecipes;
  List<FoodSummary> _recipes = const [];

  NutritionRepository get _repo => AppScope.of(context).nutrition;

  String get _text => _query.text.trim();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_generation == 0) _searchLocal();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _searchLocal);
  }

  Future<void> _searchLocal() async {
    final generation = ++_generation;
    final uses = _uses ??= await _repo.db.foodUseCounts();
    final local = await _repo.searchLocal(_text, limit: 40, uses: uses);
    final candidates = _ingredientRecipes ??= widget.recipes ? await _loadIngredientRecipes() : const [];
    if (!mounted || generation != _generation) return;
    final query = foldText(_text);
    final recipeDetail = context.l10n.pickerRecipeDetail;
    setState(() {
      _local = local;
      _recipes = [
        for (final r in candidates)
          if (foldText(r.name).contains(query))
            FoodSummary(source: FoodSource.recipe, sourceId: '${r.id}', name: r.name, detail: recipeDetail),
      ]..sort((a, b) => (uses[b.key] ?? 0).compareTo(uses[a.key] ?? 0));
      if (_remoteQuery != _text) {
        _remote = null;
        _remoteError = null;
      }
    });
  }

  Future<List<Recipe>> _loadIngredientRecipes() async {
    final db = _repo.db;
    final tag = await db.tagOfKind(TagKind.ingredient);
    if (tag == null) return const [];
    final ids = await db.recipeIdsWithTag(tag.id);
    final blocked = widget.forRecipe == null ? const <int>{} : await recipesUsing(db, widget.forRecipe!);
    return [
      for (final r in await db.allRecipes())
        if (ids.contains(r.id) && !blocked.contains(r.id)) r,
    ]..sort((a, b) => compareNames(a.name, b.name));
  }

  Future<void> _searchRemote([FoodSource? source]) async {
    final query = _text;
    final from = source ?? _remoteSource;
    setState(() {
      _remoteLoading = true;
      _remoteError = null;
      _remoteQuery = query;
      _remoteSource = from;
      _remote = null;
    });
    NutritionSourceException? error;
    try {
      final localKeys = {for (final f in _local) f.key};
      final remote = await _repo.searchRemote(query, source: from);
      if (!mounted || _remoteQuery != query || _remoteSource != from) return;
      setState(
        () => _remote = [
          for (final f in remote)
            if (!localKeys.contains(f.key)) f,
        ],
      );
    } on NutritionSourceException catch (e) {
      error = e;
      if (mounted && _remoteQuery == query) setState(() => _remoteError = e.message);
    } finally {
      if (mounted) setState(() => _remoteLoading = false);
    }
    if (error != null && mounted) await handleNutritionError(context, error);
  }

  Future<void> _open(FoodSummary summary) async {
    setState(() => _opening = summary.key);
    NutritionSourceException? error;
    try {
      final food = await _repo.food(summary.key);
      if (!mounted) return;
      if (food == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.pickerNoLongerAvailable)));
        return;
      }
      Navigator.pop(context, food);
    } on NutritionSourceException catch (e) {
      error = e;
    } finally {
      if (mounted) setState(() => _opening = null);
    }
    if (error != null && mounted) await handleNutritionError(context, error);
  }

  Future<void> _scan([String? known]) async {
    final code = known ?? await scanOrEnterBarcode(context);
    if (code == null || !mounted) return;
    setState(() {
      _opening = 'barcode';
      _scanError = null;
      _scannedCode = code;
    });
    try {
      final food = await _repo.productByBarcode(code);
      if (!mounted) return;
      if (food == null) {
        setState(() => _opening = null);
        final l = context.l10n;
        final create = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l.pickerProductNotFound),
            content: Text(l.pickerProductNotFoundBody(code)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.nutritionCancel)),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.pickerCreateOwnButton)),
            ],
          ),
        );
        if (create == true && mounted) await _createOwn();
        return;
      }
      Navigator.pop(context, food);
    } on NutritionSourceException catch (e) {
      if (mounted) {
        setState(
          () =>
              _scanError = e.kind == NutritionErrorKind.unreachable ? context.l10n.nutritionOffUnreachable : e.message,
        );
      }
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  Future<void> _createOwn() async {
    final food = await Navigator.push<Food>(
      context,
      MaterialPageRoute(builder: (_) => FoodEditScreen(initialName: _text)),
    );
    if (food != null && mounted) Navigator.pop(context, food);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final remote = _remote;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: _query,
            autofocus: widget.initialQuery.isEmpty,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l.pickerSearchHint,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
            onChanged: _onChanged,
            onSubmitted: (_) => _searchLocal(),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: Text(l.pickerCreateOwn),
                subtitle: Text(l.pickerCreateOwnSubtitle),
                onTap: _opening == null ? _createOwn : null,
              ),
              if (_repo.hasSource(FoodSource.openFoodFacts))
                ListTile(
                  leading: Icon(canScanBarcodes ? Icons.qr_code_scanner : Icons.pin_outlined),
                  title: Text(canScanBarcodes ? l.pickerScanBarcode : l.pickerEnterBarcode),
                  subtitle: Text(l.pickerBarcodeSubtitle),
                  trailing: _opening == 'barcode'
                      ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : null,
                  onTap: _opening == null ? _scan : null,
                ),
              if (_scanError != null)
                ListTile(
                  leading: Icon(Icons.cloud_off, color: theme.colorScheme.error),
                  title: Text(_scanError!),
                  subtitle: Text(l.pickerBarcodeCode('$_scannedCode')),
                  trailing: TextButton(onPressed: () => _scan(_scannedCode), child: Text(l.nutritionRetry)),
                ),
              for (final f in _recipes) _tile(f),
              if (_local.isEmpty && _recipes.isEmpty && _text.isNotEmpty)
                ListTile(dense: true, title: Text(l.pickerNothingLocal, style: theme.textTheme.bodySmall)),
              for (final f in _local) _tile(f),
              if (_repo.hasRemote) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    _text.length < 2 ? l.pickerSearchOnline : l.pickerSearchOnlineFor(_text),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final (source, label, icon) in [
                        (FoodSource.usda, l.pickerUsdaIngredients, Icons.eco_outlined),
                        (FoodSource.openFoodFacts, l.pickerStoreProducts, Icons.shopping_basket_outlined),
                      ])
                        if (_repo.hasSource(source))
                          (remote != null || _remoteLoading) && _remoteSource == source
                              ? FilledButton.tonalIcon(
                                  onPressed: _text.length < 2 || _remoteLoading ? null : () => _searchRemote(source),
                                  icon: Icon(icon),
                                  label: Text(label),
                                )
                              : OutlinedButton.icon(
                                  onPressed: _text.length < 2 || _remoteLoading ? null : () => _searchRemote(source),
                                  icon: Icon(icon),
                                  label: Text(label),
                                ),
                    ],
                  ),
                ),
                if (_remoteLoading)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LinearProgressIndicator(),
                        const SizedBox(height: 8),
                        Text(
                          _remoteSource == FoodSource.usda ? l.pickerAskingUsda : l.pickerAskingOff,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                if (_remoteError != null)
                  ListTile(
                    leading: Icon(Icons.cloud_off, color: theme.colorScheme.error),
                    title: Text(_remoteError!),
                    trailing: TextButton(onPressed: () => _searchRemote(), child: Text(l.nutritionRetry)),
                  ),
                if (remote != null && remote.isEmpty)
                  ListTile(dense: true, title: Text(l.pickerNoMoreOnline, style: theme.textTheme.bodySmall)),
                if (remote != null)
                  for (final f in remote) _tile(f),
                if (remote != null && _remoteSource == FoodSource.openFoodFacts) const _OffAttribution(),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile(FoodSummary f) {
    final uses = _uses?[f.key] ?? 0;
    final subtitle = [
      if (uses > 0) context.l10n.pickerUses(uses),
      if (f.detail case final detail? when detail.isNotEmpty) detail,
    ].join(' · ');
    return ListTile(
      leading: Icon(switch (f.source) {
        FoodSource.user => Icons.person_outline,
        FoodSource.openFoodFacts => Icons.shopping_basket_outlined,
        FoodSource.usda => Icons.eco_outlined,
        FoodSource.recipe => Icons.menu_book_outlined,
      }),
      title: Text(f.name),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: _opening == f.key
          ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : null,
      enabled: _opening == null,
      onTap: () => _open(f),
    );
  }
}

class _OffAttribution extends StatelessWidget {
  const _OffAttribution();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      leading: const Icon(Icons.info_outline, size: 18),
      title: Text(context.l10n.pickerOffAttribution, style: theme.textTheme.bodySmall),
      onTap: () => launchUrl(Uri.parse('https://world.openfoodfacts.org'), mode: LaunchMode.externalApplication),
    );
  }
}
