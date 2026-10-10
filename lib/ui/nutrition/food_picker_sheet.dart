import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_scope.dart';
import '../../data/nutrition_repository.dart';
import 'api_key_dialogs.dart';
import 'barcode_scanner_screen.dart';
import 'food_edit_screen.dart';

Future<Food?> showFoodPicker(BuildContext context, {String initialQuery = ''}) {
  return showModalBottomSheet<Food>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => FractionallySizedBox(heightFactor: 0.9, child: _FoodPicker(initialQuery: initialQuery)),
  );
}

class _FoodPicker extends StatefulWidget {
  const _FoodPicker({required this.initialQuery});

  final String initialQuery;

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
    final local = await _repo.searchLocal(_text, limit: 40);
    if (!mounted || generation != _generation) return;
    setState(() {
      _local = local;
      if (_remoteQuery != _text) {
        _remote = null;
        _remoteError = null;
      }
    });
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
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('This ingredient is no longer available')));
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
        final create = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Product not found'),
            content: Text(
              'Open Food Facts does not know the barcode $code yet. You can enter the values from the label instead.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create my own')),
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
          () => _scanError = e.kind == NutritionErrorKind.unreachable
              ? 'Open Food Facts could not be reached. Check your internet connection.'
              : e.message,
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
    final remote = _remote;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: _query,
            autofocus: widget.initialQuery.isEmpty,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search ingredients, e.g. "flour wheat"',
              border: OutlineInputBorder(),
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
                title: const Text('Create my own ingredient'),
                subtitle: const Text('Enter values from a package label'),
                onTap: _opening == null ? _createOwn : null,
              ),
              if (_repo.hasSource(FoodSource.openFoodFacts))
                ListTile(
                  leading: Icon(canScanBarcodes ? Icons.qr_code_scanner : Icons.pin_outlined),
                  title: Text(canScanBarcodes ? 'Scan a package barcode' : 'Enter a package barcode'),
                  subtitle: const Text('Looks the product up in Open Food Facts'),
                  trailing: _opening == 'barcode'
                      ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : null,
                  onTap: _opening == null ? _scan : null,
                ),
              if (_scanError != null)
                ListTile(
                  leading: Icon(Icons.cloud_off, color: theme.colorScheme.error),
                  title: Text(_scanError!),
                  subtitle: Text('Barcode $_scannedCode'),
                  trailing: TextButton(onPressed: () => _scan(_scannedCode), child: const Text('Retry')),
                ),
              if (_local.isEmpty && _text.isNotEmpty)
                ListTile(dense: true, title: Text('Nothing found on this device', style: theme.textTheme.bodySmall)),
              for (final f in _local) _tile(f),
              if (_repo.hasRemote) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    _text.length < 2 ? 'Search online' : 'Search online for "$_text"',
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
                        (FoodSource.usda, 'USDA ingredients', Icons.eco_outlined),
                        (FoodSource.openFoodFacts, 'Store products', Icons.shopping_basket_outlined),
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
                          _remoteSource == FoodSource.usda
                              ? 'Asking USDA, this can take a few seconds…'
                              : 'Asking Open Food Facts…',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                if (_remoteError != null)
                  ListTile(
                    leading: Icon(Icons.cloud_off, color: theme.colorScheme.error),
                    title: Text(_remoteError!),
                    trailing: TextButton(onPressed: () => _searchRemote(), child: const Text('Retry')),
                  ),
                if (remote != null && remote.isEmpty)
                  ListTile(dense: true, title: Text('No additional online results', style: theme.textTheme.bodySmall)),
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

  Widget _tile(FoodSummary f) => ListTile(
    leading: Icon(switch (f.source) {
      FoodSource.user => Icons.person_outline,
      FoodSource.openFoodFacts => Icons.shopping_basket_outlined,
      FoodSource.usda => Icons.eco_outlined,
    }),
    title: Text(f.name),
    subtitle: f.detail == null || f.detail!.isEmpty ? null : Text(f.detail!),
    trailing: _opening == f.key
        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : null,
    enabled: _opening == null,
    onTap: () => _open(f),
  );
}

class _OffAttribution extends StatelessWidget {
  const _OffAttribution();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      leading: const Icon(Icons.info_outline, size: 18),
      title: Text(
        'Product data from Open Food Facts, made by its contributors under the Open Database License (ODbL).',
        style: theme.textTheme.bodySmall,
      ),
      onTap: () => launchUrl(Uri.parse('https://world.openfoodfacts.org'), mode: LaunchMode.externalApplication),
    );
  }
}
