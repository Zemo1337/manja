import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/main.dart';

void main() {
  testWidgets('pantry and cravings find dishes and the wheel spins only those', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 6000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final wheel = WheelService(db);
    Future<void> add(String name, List<String> ingredients) => db.saveRecipe(
      RecipeDraft(
        name: name,
        portions: 2,
        ingredients: [for (final i in ingredients) IngredientDraft(name: i, amount: 1, unit: 'piece')],
      ),
    );
    await add('Omelette', ['eggs', 'salt', 'water']);
    await add('Garlic pasta', ['spaghetti', 'garlic', 'olive oil', 'salt']);
    await add('Burek', ['yufka', 'minced beef', 'onion', 'oil']);
    await add('Sarma', ['cabbage', 'rice', 'minced beef', 'onion']);

    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: wheel,
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db),
        child: const ManjaManjaApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('4 of 4 dishes left'), findsOneWidget);

    await tester.tap(find.byTooltip('What can I cook?'));
    await tester.pumpAndSettle();
    expect(find.text('You can make (0)'), findsOneWidget);

    await tester.tap(find.widgetWithText(ActionChip, 'Salt'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ActionChip, 'Eggs'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Add a basic, e.g. olive oil'), 'olive oil');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect((await db.pantry()).map((p) => p.name), containsAll(['Salt', 'Eggs', 'olive oil']));
    expect(find.text('You can make (1)'), findsOneWidget);
    expect(find.text('Omelette'), findsOneWidget);
    expect(find.text('Missing: spaghetti, garlic'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Add an ingredient, e.g. chicken'), 'garlic');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Omelette'), findsNothing, reason: 'only dishes with a craving');
    expect(find.text('Missing: spaghetti'), findsOneWidget);

    final garlic = find.byWidgetPredicate((w) => w is InputChip && (w.label as Text).data == 'garlic');
    await tester.tap(find.descendant(of: garlic, matching: find.byTooltip('Delete')));
    await tester.pumpAndSettle();
    expect(find.text('Omelette'), findsOneWidget);

    await tester.tap(find.text('Spin with these 1'));
    await tester.pumpAndSettle();
    expect(find.text('1 dish you can make now'), findsOneWidget);
    expect(wheel.focus.value, isNotNull);

    await tester.tap(find.byTooltip('Show all dishes'));
    await tester.pumpAndSettle();
    expect(find.text('4 of 4 dishes left'), findsOneWidget);
  });
}
