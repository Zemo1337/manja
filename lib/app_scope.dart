import 'package:flutter/widgets.dart';

import 'data/database.dart';
import 'domain/wheel_service.dart';

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.db, required this.wheel, required super.child});

  final AppDatabase db;
  final WheelService wheel;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => db != oldWidget.db || wheel != oldWidget.wheel;
}
