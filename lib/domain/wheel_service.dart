import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:nutrition_core/nutrition_core.dart';

import '../data/database.dart';
import '../data/nutrition_repository.dart';

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

class WheelFilters {
  const WheelFilters({this.maxKcal, this.maxMinutes, this.includeUnknown = true});

  static const kcalMin = 200;
  static const kcalMax = 1500;
  static const kcalStep = 50;
  static const minutesMin = 10;
  static const minutesMax = 180;
  static const minutesStep = 5;

  final int? maxKcal;
  final int? maxMinutes;
  final bool includeUnknown;

  bool get active => maxKcal != null || maxMinutes != null;

  WheelFilters copyWith({int? Function()? maxKcal, int? Function()? maxMinutes, bool? includeUnknown}) => WheelFilters(
    maxKcal: maxKcal == null ? this.maxKcal : maxKcal(),
    maxMinutes: maxMinutes == null ? this.maxMinutes : maxMinutes(),
    includeUnknown: includeUnknown ?? this.includeUnknown,
  );

  bool allows({double? kcal, int? minutes}) {
    if (maxKcal case final limit?) {
      if (kcal == null ? !includeUnknown : kcal > limit) return false;
    }
    if (maxMinutes case final limit?) {
      if (minutes == null ? !includeUnknown : minutes > limit) return false;
    }
    return true;
  }
}

int? totalMinutes(Recipe r) =>
    r.prepMinutes == null && r.cookMinutes == null ? null : (r.prepMinutes ?? 0) + (r.cookMinutes ?? 0);

class WheelSettings {
  const WheelSettings({required this.mode, required this.resetDays, required this.cycleStartedAt});

  final ResetMode mode;
  final int resetDays;
  final DateTime cycleStartedAt;
}

class WheelState {
  const WheelState({
    required this.available,
    required this.total,
    required this.settings,
    required this.appearance,
    this.tags = const [],
    this.tag,
    this.filters = const WheelFilters(),
    this.filteredOut = 0,
  });

  final List<Recipe> available;
  final int total;
  final WheelSettings settings;
  final WheelAppearance appearance;
  final List<Tag> tags;
  final Tag? tag;
  final WheelFilters filters;
  final int filteredOut;

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
  static const _keyTag = 'wheel.tag';
  static const _keyMaxKcal = 'wheel.filter.maxKcal';
  static const _keyMaxMinutes = 'wheel.filter.maxMinutes';
  static const _keyIncludeUnknown = 'wheel.filter.includeUnknown';

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
    final tags = await db.allTags();
    final tagId = int.tryParse(await db.getSetting(_keyTag) ?? '');
    final tag = tags.where((t) => t.id == tagId).firstOrNull;
    var pool = recipes;
    if (tag != null) {
      final ids = await db.recipeIdsWithTag(tag.id);
      pool = [
        for (final r in pool)
          if (ids.contains(r.id)) r,
      ];
    }
    final filters = await loadFilters();
    var filteredOut = 0;
    if (filters.active) {
      final kcal = filters.maxKcal == null ? const <int, double?>{} : await kcalPerPortion(pool);
      final before = pool.length;
      pool = [
        for (final r in pool)
          if (filters.allows(kcal: kcal[r.id], minutes: totalMinutes(r))) r,
      ];
      filteredOut = before - pool.length;
    }
    final allowed = {for (final r in pool) r.id};
    available = [
      for (final r in available)
        if (allowed.contains(r.id)) r,
    ];
    final total = pool.length;
    available.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return WheelState(
      available: available,
      total: total,
      settings: settings,
      appearance: await loadAppearance(),
      tags: tags,
      tag: tag,
      filters: filters,
      filteredOut: filteredOut,
    );
  }

  Future<WheelFilters> loadFilters() async => WheelFilters(
    maxKcal: int.tryParse(await db.getSetting(_keyMaxKcal) ?? ''),
    maxMinutes: int.tryParse(await db.getSetting(_keyMaxMinutes) ?? ''),
    includeUnknown: (await db.getSetting(_keyIncludeUnknown) ?? 'true') == 'true',
  );

  Future<void> saveFilters(WheelFilters f) async {
    if (f.maxKcal == null) {
      await db.deleteSetting(_keyMaxKcal);
    } else {
      await db.setSetting(_keyMaxKcal, '${f.maxKcal}');
    }
    if (f.maxMinutes == null) {
      await db.deleteSetting(_keyMaxMinutes);
    } else {
      await db.setSetting(_keyMaxMinutes, '${f.maxMinutes}');
    }
    await db.setSetting(_keyIncludeUnknown, '${f.includeUnknown}');
  }

  Future<Map<int, double?>> kcalPerPortion(List<Recipe> recipes) async {
    final ids = {for (final r in recipes) r.id};
    final ingredients = [
      for (final i in await db.allRecipeIngredients())
        if (ids.contains(i.recipeId)) i,
    ];
    final foods = {
      for (final row in await db.foodRows({for (final i in ingredients) ?i.foodKey})) row.key: foodFromRow(row),
    };
    final byRecipe = <int, List<IngredientLine>>{};
    for (final i in ingredients) {
      byRecipe
          .putIfAbsent(i.recipeId, () => [])
          .add(IngredientLine(name: i.name, amount: i.amount, unit: CookingUnit.fromName(i.unit), food: foods[i.foodKey]));
    }
    return {
      for (final r in recipes)
        r.id: () {
          final lines = byRecipe[r.id] ?? const [];
          if (!lines.any((l) => l.food != null)) return null;
          final n = RecipeNutrition.calculate(lines, portions: r.portions, finishedWeightG: r.finishedWeightG);
          return n.lines.any((l) => l.counted) ? n.perPortion[Nutrient.energy] : null;
        }(),
    };
  }

  Future<void> selectTag(int? tagId) => tagId == null ? db.deleteSetting(_keyTag) : db.setSetting(_keyTag, '$tagId');

  final focus = ValueNotifier<Set<int>?>(null);

  Recipe pickRecipe(List<Recipe> available) => available[_random.nextInt(available.length)];

  Future<void> confirmMeal(Recipe recipe) => db.logMeal(recipe.id, DateTime.now());
}
