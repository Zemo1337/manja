import 'package:flutter/widgets.dart';

import 'data/database.dart';
import 'data/nutrition_repository.dart';
import 'data/photo_store.dart';
import 'domain/wheel_service.dart';
import 'ui/app_theme.dart';

class AppScope extends InheritedWidget {
  AppScope({
    super.key,
    required this.db,
    required this.wheel,
    required this.photos,
    required this.nutrition,
    AppearanceController? appearance,
    required super.child,
  }) : appearance = appearance ?? AppearanceController(db);

  final AppDatabase db;
  final WheelService wheel;
  final PhotoStore photos;
  final NutritionRepository nutrition;
  final AppearanceController appearance;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      db != oldWidget.db ||
      wheel != oldWidget.wheel ||
      photos != oldWidget.photos ||
      nutrition != oldWidget.nutrition ||
      appearance != oldWidget.appearance;
}
