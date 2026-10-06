import 'dart:math';

import '../data/database.dart';

enum ResetMode {
  whenEmpty('When every dish was eaten'),
  afterDays('After a number of days'),
  manual('Only manually');

  const ResetMode(this.label);

  final String label;
}

class WheelSettings {
  const WheelSettings({required this.mode, required this.resetDays, required this.cycleStartedAt});

  final ResetMode mode;
  final int resetDays;
  final DateTime cycleStartedAt;
}

class WheelState {
  const WheelState({required this.available, required this.total, required this.settings});

  final List<Recipe> available;
  final int total;
  final WheelSettings settings;

  int get eaten => total - available.length;
  bool get exhausted => total > 0 && available.isEmpty;
}

class WheelService {
  WheelService(this.db, {Random? random}) : _random = random ?? Random();

  static const _keyMode = 'wheel.resetMode';
  static const _keyDays = 'wheel.resetDays';
  static const _keyCycleStart = 'wheel.cycleStartedAt';

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
    return WheelState(available: available, total: recipes.length, settings: settings);
  }

  int pickIndex(int count) => _random.nextInt(count);

  Future<void> confirmMeal(Recipe recipe) => db.logMeal(recipe.id, DateTime.now());
}
