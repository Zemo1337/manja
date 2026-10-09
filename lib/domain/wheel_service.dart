import 'dart:math';

import 'package:flutter/foundation.dart';

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

enum WheelThemeKind {
  classic('Classic'),
  pizza('Pizza'),
  burek('Burek'),
  sacher('Sachertorte'),
  baklava('Baklava');

  const WheelThemeKind(this.label);

  final String label;
}

class WheelAppearance {
  const WheelAppearance({
    this.content = WheelContent.both,
    this.maxSlices = 20,
    this.winnerPercent = 100,
    this.flipText = true,
    this.theme = WheelThemeKind.classic,
    this.spinSeconds = 8,
  });

  static const minSlices = 4;
  static const maxSlicesLimit = 50;
  static const minWinnerPercent = 30;
  static const minSpinSeconds = 2;
  static const maxSpinSeconds = 20;

  final WheelContent content;
  final int maxSlices;
  final int winnerPercent;
  final bool flipText;
  final WheelThemeKind theme;
  final int spinSeconds;

  WheelAppearance copyWith({
    WheelContent? content,
    int? maxSlices,
    int? winnerPercent,
    bool? flipText,
    WheelThemeKind? theme,
    int? spinSeconds,
  }) => WheelAppearance(
    content: content ?? this.content,
    maxSlices: maxSlices ?? this.maxSlices,
    winnerPercent: winnerPercent ?? this.winnerPercent,
    flipText: flipText ?? this.flipText,
    theme: theme ?? this.theme,
    spinSeconds: spinSeconds ?? this.spinSeconds,
  );
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
  static const _keyMaxSlices = 'wheel.maxSlices';
  static const _keyWinnerPercent = 'wheel.winnerPercent';
  static const _keyFlipText = 'wheel.flipText';
  static const _keyTheme = 'wheel.theme';
  static const _keySpinSeconds = 'wheel.spinSeconds';

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
    final maxSlices = int.tryParse(await db.getSetting(_keyMaxSlices) ?? '') ?? d.maxSlices;
    final winner = int.tryParse(await db.getSetting(_keyWinnerPercent) ?? '') ?? d.winnerPercent;
    final spin = int.tryParse(await db.getSetting(_keySpinSeconds) ?? '') ?? d.spinSeconds;
    return WheelAppearance(
      content: WheelContent.values.asNameMap()[await db.getSetting(_keyContent)] ?? d.content,
      maxSlices: maxSlices.clamp(WheelAppearance.minSlices, WheelAppearance.maxSlicesLimit),
      winnerPercent: winner.clamp(WheelAppearance.minWinnerPercent, 100),
      flipText: (await db.getSetting(_keyFlipText) ?? '${d.flipText}') == 'true',
      theme: WheelThemeKind.values.asNameMap()[await db.getSetting(_keyTheme)] ?? d.theme,
      spinSeconds: spin.clamp(WheelAppearance.minSpinSeconds, WheelAppearance.maxSpinSeconds),
    );
  }

  Future<void> saveAppearance(WheelAppearance a) async {
    await db.setSetting(_keyContent, a.content.name);
    await db.setSetting(_keyMaxSlices, '${a.maxSlices}');
    await db.setSetting(_keyWinnerPercent, '${a.winnerPercent}');
    await db.setSetting(_keyFlipText, '${a.flipText}');
    await db.setSetting(_keyTheme, a.theme.name);
    await db.setSetting(_keySpinSeconds, '${a.spinSeconds}');
  }

  Future<DateTime> resetCycle([DateTime? at]) async {
    var start = at ?? DateTime.now();
    final latest = await db.latestMealAt();
    if (latest != null && !start.isAfter(latest)) start = latest.add(const Duration(microseconds: 1));
    await db.setSetting(_keyCycleStart, start.toIso8601String());
    return start;
  }

  Future<WheelState> computeState({DateTime? now}) async {
    now ??= DateTime.now();
    var settings = await loadSettings();
    if (settings.mode == ResetMode.afterDays &&
        now.difference(settings.cycleStartedAt) >= Duration(days: settings.resetDays)) {
      final start = await resetCycle(now);
      settings = WheelSettings(mode: settings.mode, resetDays: settings.resetDays, cycleStartedAt: start);
    }
    final recipes = await db.allRecipes();
    final eatenIds = {for (final log in await db.mealLogsSince(settings.cycleStartedAt)) log.recipeId};
    var available = [
      for (final r in recipes)
        if (!eatenIds.contains(r.id)) r,
    ];
    if (available.isEmpty && recipes.isNotEmpty && settings.mode == ResetMode.whenEmpty) {
      final start = await resetCycle(now);
      settings = WheelSettings(mode: settings.mode, resetDays: settings.resetDays, cycleStartedAt: start);
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

  final focus = ValueNotifier<Set<int>?>(null);

  Recipe pickRecipe(List<Recipe> available) => available[_random.nextInt(available.length)];

  Future<void> confirmMeal(Recipe recipe) => db.logMeal(recipe.id, DateTime.now());
}
