import 'package:nutrition_core/nutrition_core.dart';

import '../../l10n/l10n.dart';

extension NutrientL10n on Nutrient {
  String labelIn(AppLocalizations l) => switch (this) {
    Nutrient.energy => l.nutrientEnergy,
    Nutrient.protein => l.nutrientProtein,
    Nutrient.fat => l.nutrientFat,
    Nutrient.saturatedFat => l.nutrientSaturatedFat,
    Nutrient.carbohydrate => l.nutrientCarbohydrate,
    Nutrient.sugars => l.nutrientSugars,
    Nutrient.fiber => l.nutrientFiber,
    Nutrient.sodium => l.nutrientSodium,
    Nutrient.cholesterol => l.nutrientCholesterol,
    Nutrient.calcium => l.nutrientCalcium,
    Nutrient.iron => l.nutrientIron,
    Nutrient.magnesium => l.nutrientMagnesium,
    Nutrient.potassium => l.nutrientPotassium,
    Nutrient.zinc => l.nutrientZinc,
    Nutrient.vitaminA => l.nutrientVitaminA,
    Nutrient.vitaminC => l.nutrientVitaminC,
    Nutrient.vitaminD => l.nutrientVitaminD,
    Nutrient.vitaminE => l.nutrientVitaminE,
    Nutrient.vitaminB12 => l.nutrientVitaminB12,
    Nutrient.folate => l.nutrientFolate,
  };
}

extension FoodSourceL10n on FoodSource {
  String labelIn(AppLocalizations l) => switch (this) {
    FoodSource.usda || FoodSource.openFoodFacts => label,
    FoodSource.user => l.foodSourceUser,
    FoodSource.recipe => l.foodSourceRecipe,
  };
}
