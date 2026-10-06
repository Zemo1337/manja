import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';

import '../../app_scope.dart';
import '../../data/nutrition_repository.dart';
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
  List<FoodSummary> _remote = const [];
  bool _remoteLoading = false;
  String? _remoteError;
  String? _opening;

  NutritionRepository get _repo => AppScope.of(context).nutrition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_generation == 0) _search(_query.text);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(text));
  }

  Future<void> _search(String text) async {
    final generation = ++_generation;
    final repo = _repo;
    final local = await repo.searchLocal(text);
    if (!mounted || generation != _generation) return;
    setState(() {
      _local = local;
      _remote = const [];
      _remoteError = null;
      _remoteLoading = text.trim().length >= 2;
    });
    if (!_remoteLoading) return;
    try {
      final localKeys = {for (final f in local) f.key};
      final remote = await repo.searchRemote(text);
      if (!mounted || generation != _generation) return;
      setState(() => _remote = [for (final f in remote) if (!localKeys.contains(f.key)) f]);
    } on NutritionSourceException catch (e) {
      if (!mounted || generation != _generation) return;
      setState(() => _remoteError = e.message);
    } finally {
      if (mounted && generation == _generation) setState(() => _remoteLoading = false);
    }
  }

  Future<void> _open(FoodSummary summary) async {
    setState(() => _opening = summary.key);
    try {
      final food = await _repo.food(summary.key, keep: true);
      if (!mounted) return;
      if (food == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This ingredient is no longer available')));
        return;
      }
      Navigator.pop(context, food);
    } on NutritionSourceException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  Future<void> _createOwn() async {
    final food = await Navigator.push<Food>(
      context,
      MaterialPageRoute(builder: (_) => FoodEditScreen(initialName: _query.text.trim())),
    );
    if (food != null && mounted) Navigator.pop(context, food);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            onSubmitted: _search,
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
              if (_local.isNotEmpty) ...[
                _Header('On this device'),
                for (final f in _local) _tile(f),
              ],
              _Header('USDA FoodData Central'),
              if (_remoteLoading) const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
              if (_remoteError != null)
                ListTile(
                  leading: Icon(Icons.cloud_off, color: theme.colorScheme.error),
                  title: Text(_remoteError!),
                  trailing: TextButton(onPressed: () => _search(_query.text), child: const Text('Retry')),
                ),
              if (!_remoteLoading && _remoteError == null && _remote.isEmpty)
                ListTile(
                  dense: true,
                  title: Text(
                    _query.text.trim().length < 2 ? 'Type at least 2 letters to search online' : 'No online results',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              for (final f in _remote) _tile(f),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile(FoodSummary f) => ListTile(
        leading: Icon(f.source == FoodSource.user ? Icons.person_outline : Icons.eco_outlined),
        title: Text(f.name),
        subtitle: f.detail == null || f.detail!.isEmpty ? null : Text(f.detail!),
        trailing: _opening == f.key
            ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : null,
        enabled: _opening == null,
        onTap: () => _open(f),
      );
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(text, style: Theme.of(context).textTheme.labelLarge),
      );
}
