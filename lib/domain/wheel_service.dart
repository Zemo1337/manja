import 'dart:math';

import '../data/database.dart';

enum ResetMode {
  whenEmpty('When every dish was eaten'),
  afterDays('After a number of days'),
  manual('Only manually');

  const ResetMode(this.label);

  final String label;
}

enum WheelContent {
  text('Text'),
  photo('Photo'),
  both('Both');

  const WheelContent(this.label);

  final String label;
}

class WheelAppearance {
  const WheelAppearance({this.content = WheelContent.both, this.flipText = true});

  final WheelContent content;
  final bool flipText;

  WheelAppearance copyWith({WheelContent? content, bool? flipText}) =>
      WheelAppearance(content: content ?? this.content, flipText: flipText ?? this.flipText);
}

class WheelSettings {
  const WheelSettings({required this.mode, required this.resetDays, required this.cycleStartedAt});

  final ResetMode mode;
  final int resetDays;
  final DateTime cycleStartedAt;
}

class WheelState {
  const WheelState({required this.available, required this.total, required this.settings, required this.appearance});

  final List<Recipe> available;
  final int total;
  final WheelSettings settings;
  final WheelAppearance appearance;

  int get eaten => total - available.length;
  bool get exhausted => total > 0 && available.isEmpty;
}

class WheelService {
  WheelService(this.db, {Random? random}) : _random = random ?? Random();

  static const _keyMode = 'wheel.resetMode';
  static const _keyDays = 'wheel.resetDays';
  static const _keyCycleStart = 'wheel.cycleStartedAt';
  static const _keyContent = 'wheel.content';
  static const _keyFlipText = 'wheel.flipText';

  final AppDatabase db;
  final Random _random;

  Future<WheelSettings> loadSettings() async {
    final mode = ResetMode.values.asNameMap()[await db.getSetting(_keyMode)] ?? ResetMode.whenEmpty;
    final days = int.tryParse(await db.getSetting(_keyDays) ?? '') ?? 7;
    final start = DateTime.tryParse(await db.getSetting(_keyCycleStart) ?? '');
    if (start == null) {
      final now = DateTime.now();
      await db.setSetting(_keyCycleStart, now.toIso8601String());
      return WheelSettings(mode: mode, resetDays: days, cycleStartedAt: now);
    }
    return WheelSettings(mode: mode, resetDays: days, cycleStartedAt: start);
  }

  Future<void> saveSettings(ResetMode mode, int resetDays) async {
    await db.setSetting(_keyMode, mode.name);
    await db.setSetting(_keyDays, resetDays.toString());
  }

  Future<WheelAppearance> loadAppearance() async {
    const d = WheelAppearance();
    return WheelAppearance(
      content: WheelContent.values.asNameMap()[await db.getSetting(_keyContent)] ?? d.content,
      flipText: (await db.getSetting(_keyFlipText) ?? '${d.flipText}') == 'true',
    );
  }

  Future<void> saveAppearance(WheelAppearance a) async {
    await db.setSetting(_keyContent, a.content.name);
    await db.setSetting(_keyFlipText, '${a.flipText}');
  }

  Future<void> resetCycle([DateTime? at]) =>
      db.setSetting(_keyCycleStart, (at ?? DateTime.now()).toIso8601String());

  Future<WheelState> computeState({DateTime? now}) async {
    now ??= DateTime.now();
    var settings = await loadSettings();
    if (settings.mode == ResetMode.afterDays &&
        now.difference(settings.cycleStartedAt) >= Duration(days: settings.resetDays)) {
      await resetCycle(now);
      settings = WheelSettings(mode: settings.mode, resetDays: settings.resetDays, cycleStartedAt: now);
    }
    final recipes = await db.allRecipes();
    final eatenIds = {for (final log in await db.mealLogsSince(settings.cycleStartedAt)) log.recipeId};
    var available = [for (final r in recipes) if (!eatenIds.contains(r.id)) r];
    if (available.isEmpty && recipes.isNotEmpty && settings.mode == ResetMode.whenEmpty) {
      await resetCycle(now);
      settings = WheelSettings(mode: settings.mode, resetDays: settings.resetDays, cycleStartedAt: now);
      available = recipes;
    }
    available.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return WheelState(
      available: available,
      total: recipes.length,
      settings: settings,
      appearance: await loadAppearance(),
    );
  }

  Recipe pickRecipe(List<Recipe> available) => available[_random.nextInt(available.length)];

  Future<void> confirmMeal(Recipe recipe) => db.logMeal(recipe.id, DateTime.now());
}
