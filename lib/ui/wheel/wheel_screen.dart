import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/wheel_layout.dart';
import '../../domain/wheel_service.dart';
import '../recipes/recipe_detail_screen.dart';
import '../app_theme.dart';
import '../app_logo.dart';
import '../pantry/pantry_screen.dart';
import '../recipes/recipe_photo.dart';
import '../settings/wheel_look_screen.dart';
import 'wheel_image_cache.dart';
import 'wheel_painter.dart';
import 'wheel_themes.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
    animationBehavior: AnimationBehavior.preserve,
  );
  late final AnimationController _grow = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final Animation<double> _growCurve = CurvedAnimation(parent: _grow, curve: Curves.easeInOutCubic);
  int? _winner;
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
  ValueNotifier<Set<int>?>? _focus;
  bool _focused = false;
  int _reloadGeneration = 0;

  WheelService get _wheel => AppScope.of(context).wheel;

  bool get _spinning => _controller.isAnimating || _grow.isAnimating;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AppScope.of(context);
    _images ??= WheelImageCache(
      scope.photos,
      onLoaded: () {
        if (mounted) setState(() {});
      },
    );
    _subscription ??= scope.db.watchWheelInputs().listen((_) => _reload());
    if (_focus == null) {
      _focus = scope.wheel.focus;
      _focus!.addListener(_reload);
    }
    _reload();
  }

  @override
  void dispose() {
    _focus?.removeListener(_reload);
    _subscription?.cancel();
    _controller.dispose();
    _grow.dispose();
    _images?.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final generation = ++_reloadGeneration;
    final state = await _wheel.computeState();
    if (!mounted || generation != _reloadGeneration) return;
    setState(() {
      _state = state;
      if (!_spinning) {
        final focus = _focus?.value;
        final focused = focus == null
            ? null
            : [
                for (final r in state.available)
                  if (focus.contains(r.id)) r,
              ];
        _available = focused == null || focused.isEmpty ? state.available : focused;
        _focused = focused != null && focused.isNotEmpty;
        final key = '${state.appearance.maxSlices}:${[for (final r in _available) r.id].join(',')}';
        if (key != _entriesKey) {
          _entriesKey = key;
          _entries = buildEntries(_available, state.appearance.maxSlices, _random);
          _winner = null;
          _grow.value = 0;
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

  ({List<double> sweeps, double rotation}) _frame() {
    final count = _entries.length;
    final spin = _spin;
    final winner = _winner;
    if (spin != null) return (sweeps: sliceSweeps(count), rotation: spin.value);
    if (winner == null) return (sweeps: sliceSweeps(count), rotation: _rotation);
    final fraction = (_state?.appearance.winnerPercent ?? 100) / 100;
    final progress = _growCurve.value;
    return (
      sweeps: sliceSweeps(count, winner: winner, winnerFraction: fraction, progress: progress),
      rotation: winnerRotation(
        landing: _rotation,
        count: count,
        winner: winner,
        winnerFraction: fraction,
        progress: progress,
      ),
    );
  }

  void _spinWheel() {
    if (_entries.isEmpty || _spinning) return;
    final picked = _wheel.pickRecipe(_available);
    final sweeps = sliceSweeps(_entries.length);
    final index = entryIndexFor(_entries, picked);
    if (_winner != null) {
      _rotation = centeredRotation(sweeps, _winner!);
      _winner = null;
      _grow.value = 0;
    }
    _picked = picked;
    _retainImages();
    final end = targetRotation(
      current: _rotation,
      sweeps: sweeps,
      index: index,
      fullSpins: 5 + _random.nextInt(3),
      jitter: (_random.nextDouble() - 0.5) * 0.7,
    );
    _controller.duration = Duration(seconds: _state?.appearance.spinSeconds ?? const WheelAppearance().spinSeconds);
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
          _winner = index;
        });
        _grow.forward(from: 0);
      });
  }

  Future<void> _confirm(Recipe recipe) async {
    await _wheel.confirmMeal(recipe);
    _wheel.focus.value = null;
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
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(size: 34),
            SizedBox(width: 10),
            Flexible(child: Text('Manja Manja', overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'What can I cook?',
            icon: const Icon(Icons.soup_kitchen_outlined),
            onPressed: _spinning
                ? null
                : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantryScreen())),
          ),
          IconButton(
            tooltip: 'Reset wheel',
            icon: const Icon(Icons.restart_alt),
            onPressed: _spinning || state == null || state.eaten == 0 ? null : _resetCycle,
          ),
          IconButton(
            tooltip: 'Wheel look',
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WheelLookScreen())),
          ),
        ],
      ),
      body: state == null ? const Center(child: CircularProgressIndicator()) : _body(context, state),
    );
  }

  Widget _body(BuildContext context, WheelState state) {
    final theme = Theme.of(context);
    final wheelTheme = WheelTheme.of(state.appearance.theme, theme.colorScheme);
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
        action: FilledButton.icon(
          onPressed: _resetCycle,
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset wheel'),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth - 32, constraints.maxHeight - 280).clamp(200.0, 560.0);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  final badge = HighlightColors.of(context);
                  return DecoratedBox(
                    decoration: BoxDecoration(color: badge.background, borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 14, right: _focused ? 4 : 14, top: 4, bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              _focused
                                  ? '${_available.length} ${_available.length == 1 ? 'dish' : 'dishes'} you can make now'
                                  : '${_available.length} of ${state.total} dishes left',
                              style: theme.textTheme.titleMedium?.copyWith(color: badge.foreground),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_focused)
                            IconButton(
                              tooltip: 'Show all dishes',
                              visualDensity: VisualDensity.compact,
                              icon: Icon(Icons.close, size: 18, color: badge.foreground),
                              onPressed: _spinning ? null : () => _wheel.focus.value = null,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                key: const ValueKey('wheel'),
                onTap: _result == null ? _spinWheel : null,
                child: SizedBox(
                  width: size,
                  height: size + 18,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 18,
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_controller, _grow]),
                          builder: (context, _) {
                            final frame = _frame();
                            return CustomPaint(
                              size: Size.square(size),
                              painter: WheelPainter(
                                slices: _sliceData(),
                                sweeps: frame.sweeps,
                                rotation: frame.rotation,
                                theme: wheelTheme,
                                content: state.appearance.content,
                                flipText: state.appearance.flipText,
                                labelStyle: theme.textTheme.labelLarge ?? const TextStyle(),
                                highlight: _winner,
                              ),
                            );
                          },
                        ),
                      ),
                      CustomPaint(
                        size: const Size(28, 34),
                        painter: WheelPointerPainter(wheelTheme.pointer, outline: theme.colorScheme.onSurface),
                      ),
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onOpen,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    if (recipe.photoPath != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox.square(dimension: 56, child: RecipePhoto(recipe: recipe, cacheWidth: 168)),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Today you cook', style: theme.textTheme.labelLarge),
                          Text(
                            recipe.name,
                            key: const ValueKey('result-name'),
                            style: theme.textTheme.titleLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSpinAgain,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Spin again'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onConfirm,
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text("Let's cook it"),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
