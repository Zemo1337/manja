import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/wheel_layout.dart';
import '../../domain/wheel_service.dart';
import '../recipes/recipe_detail_screen.dart';
import '../recipes/recipe_photo.dart';
import 'wheel_image_cache.dart';
import 'wheel_painter.dart';
import 'wheel_settings_sheet.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 4200));
  final _random = Random();
  StreamSubscription<void>? _subscription;
  WheelState? _state;
  List<Recipe> _available = const [];
  List<WheelEntry> _entries = const [];
  String? _entriesKey;
  double _rotation = 0;
  Animation<double>? _spin;
  Recipe? _picked;
  Recipe? _result;
  WheelImageCache? _images;

  WheelService get _wheel => AppScope.of(context).wheel;

  bool get _spinning => _controller.isAnimating;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AppScope.of(context);
    _images ??= WheelImageCache(scope.photos, onLoaded: () {
      if (mounted) setState(() {});
    });
    _subscription ??= scope.db.watchWheelInputs().listen((_) => _reload());
    _reload();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    _images?.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final state = await _wheel.computeState();
    if (!mounted) return;
    setState(() {
      _state = state;
      if (!_spinning) {
        _available = state.available;
        final key = '${state.appearance.maxSlices}:${[for (final r in _available) r.id].join(',')}';
        if (key != _entriesKey) {
          _entriesKey = key;
          _entries = buildEntries(_available, state.appearance.maxSlices, _random);
        }
        if (_result != null && !_available.any((r) => r.id == _result!.id)) _result = null;
      }
    });
    _retainImages();
  }

  void _retainImages() {
    final state = _state;
    if (state == null) return;
    _images!.retain({
      if (state.appearance.content != WheelContent.text) ...[
        for (final e in _entries)
          if (e.recipe?.photoPath != null) e.recipe!.photoPath!,
        if (_picked?.photoPath != null) _picked!.photoPath!,
      ],
    });
  }

  List<WheelSliceData> _sliceData() => [
        for (final e in _entries)
          if (!e.isOverflow)
            WheelSliceData(label: e.recipe!.name, image: _images![e.recipe!.photoPath])
          else if (_result != null && e.represents(_result!))
            WheelSliceData(label: _result!.name, image: _images![_result!.photoPath], isOverflow: true)
          else
            WheelSliceData(label: '+${e.hidden.length}', isOverflow: true),
      ];

  void _spinWheel() {
    if (_entries.isEmpty || _spinning) return;
    final picked = _wheel.pickRecipe(_available);
    final sweeps = sliceSweeps(_entries.length);
    final index = entryIndexFor(_entries, picked);
    _picked = picked;
    _retainImages();
    final end = targetRotation(
      current: _rotation,
      sweeps: sweeps,
      index: index,
      fullSpins: 5 + _random.nextInt(3),
      jitter: (_random.nextDouble() - 0.5) * 0.7,
    );
    _spin = Tween(begin: _rotation, end: end).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    setState(() => _result = null);
    _controller
      ..reset()
      ..forward().whenComplete(() {
        if (!mounted) return;
        setState(() {
          _rotation = end % fullTurn;
          _spin = null;
          _result = picked;
        });
      });
  }

  Future<void> _confirm(Recipe recipe) async {
    await _wheel.confirmMeal(recipe);
    if (!mounted) return;
    setState(() => _result = null);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enjoy your ${recipe.name}!')));
  }

  Future<void> _resetCycle() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the wheel?'),
        content: const Text('All recipes will be back on the wheel. Your meal history is kept.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
        ],
      ),
    );
    if (ok == true) await _wheel.resetCycle();
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manja Manja'),
        actions: [
          IconButton(
            tooltip: 'Reset wheel',
            icon: const Icon(Icons.restart_alt),
            onPressed: _spinning || state == null || state.eaten == 0 ? null : _resetCycle,
          ),
          IconButton(
            tooltip: 'Wheel settings',
            icon: const Icon(Icons.tune),
            onPressed: state == null ? null : () => showWheelSettings(context, state.settings, state.appearance),
          ),
        ],
      ),
      body: state == null ? const Center(child: CircularProgressIndicator()) : _body(context, state),
    );
  }

  Widget _body(BuildContext context, WheelState state) {
    final theme = Theme.of(context);
    if (state.total == 0) {
      return const _EmptyMessage(
        icon: Icons.menu_book_outlined,
        title: 'No recipes yet',
        message: 'Add your favourite dishes in the Recipes tab and they will show up here.',
      );
    }
    if (_entries.isEmpty) {
      return _EmptyMessage(
        icon: Icons.celebration_outlined,
        title: 'You ate everything!',
        message: 'Every dish on the wheel has been cooked this round.',
        action: FilledButton.icon(onPressed: _resetCycle, icon: const Icon(Icons.restart_alt), label: const Text('Reset wheel')),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth - 32, constraints.maxHeight - 260).clamp(200.0, 560.0);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Text('${_available.length} of ${state.total} dishes left', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _spinWheel,
                child: SizedBox(
                  width: size,
                  height: size + 18,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 18,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) => CustomPaint(
                            size: Size.square(size),
                            painter: WheelPainter(
                              slices: _sliceData(),
                              sweeps: sliceSweeps(_entries.length),
                              rotation: _spin?.value ?? _rotation,
                              rimColor: theme.colorScheme.onSurface,
                              content: state.appearance.content,
                              flipText: state.appearance.flipText,
                              labelStyle: theme.textTheme.labelLarge ?? const TextStyle(),
                            ),
                          ),
                        ),
                      ),
                      CustomPaint(size: const Size(28, 34), painter: WheelPointerPainter(theme.colorScheme.onSurface)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_result == null)
                FilledButton.icon(
                  onPressed: _spinning ? null : _spinWheel,
                  icon: const Icon(Icons.casino),
                  label: Text(_spinning ? 'Spinning…' : 'Spin'),
                  style: FilledButton.styleFrom(minimumSize: const Size(180, 52)),
                )
              else
                _ResultCard(
                  recipe: _result!,
                  onConfirm: () => _confirm(_result!),
                  onSpinAgain: _spinWheel,
                  onOpen: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: _result!.id)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.recipe, required this.onConfirm, required this.onSpinAgain, required this.onOpen});

  final Recipe recipe;
  final VoidCallback onConfirm;
  final VoidCallback onSpinAgain;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (recipe.photoPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 280,
                  child: AspectRatio(aspectRatio: 16 / 9, child: RecipePhoto(recipe: recipe, cacheWidth: 840)),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text('Today you cook', style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onOpen,
              child: Text(recipe.name, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(onPressed: onSpinAgain, icon: const Icon(Icons.refresh), label: const Text('Spin again')),
                FilledButton.icon(onPressed: onConfirm, icon: const Icon(Icons.check), label: const Text("Let's cook it")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.icon, required this.title, required this.message, this.action});

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
