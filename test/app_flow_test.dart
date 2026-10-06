import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/main.dart';

void main() {
  testWidgets('add a recipe, spin the wheel, cook it, see it in history', (tester) async {
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));

    await tester.pumpWidget(AppScope(db: db, wheel: WheelService(db), child: const ManjaManjaApp()));
    await tester.pumpAndSettle();
    expect(find.text('1 of 1 dishes left'), findsOneWidget);

    await tester.tap(find.text('Recipes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add recipe'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Ćevapi');
    await tester.enterText(find.widgetWithText(TextFormField, 'Qty'), '500');
    await tester.enterText(find.widgetWithText(TextFormField, 'Ingredient'), 'Minced beef');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Ćevapi'), findsOneWidget);

    await tester.tap(find.text('Wheel'));
    await tester.pumpAndSettle();
    expect(find.text('2 of 2 dishes left'), findsOneWidget);

    await tester.tap(find.text('Spin'));
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Today you cook'), findsOneWidget);

    await tester.tap(find.text("Let's cook it"));
    await tester.pumpAndSettle();
    expect(find.text('1 of 2 dishes left'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    final logs = await db.select(db.mealLogs).get();
    expect(logs, hasLength(1));
    final eaten = (await db.allRecipes()).firstWhere((r) => r.id == logs.single.recipeId);
    expect(find.descendant(of: find.byType(ListTile), matching: find.text(eaten.name)), findsOneWidget);
  });
}
