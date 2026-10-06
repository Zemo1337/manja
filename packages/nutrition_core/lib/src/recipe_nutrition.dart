import 'conversion.dart';
import 'food.dart';
import 'nutrients.dart';
import 'units.dart';

enum LineIssue { noFood, unknownWeight }

class IngredientLine {
  const IngredientLine({required this.name, required this.amount, required this.unit, this.food});

  final String name;
  final double amount;
  final CookingUnit unit;
  final Food? food;
}

class LineNutrition {
  const LineNutrition(this.line, {this.grams, this.nutrients, this.issue});

  final IngredientLine line;
  final double? grams;
  final Nutrients? nutrients;
  final LineIssue? issue;

  bool get counted => issue == null;
}

class RecipeNutrition {
  const RecipeNutrition._({
    required this.lines,
    required this.total,
    required this.ingredientWeightG,
    required this.portions,
    required this.partial,
    this.finishedWeightG,
  });

  factory RecipeNutrition.calculate(List<IngredientLine> lines, {required int portions, double? finishedWeightG}) {
    if (portions < 1) throw ArgumentError.value(portions, 'portions', 'must be at least 1');
    final results = <LineNutrition>[];
    var total = Nutrients.empty;
    var weight = 0.0;
    final partial = <Nutrient>{};
    final counted = <Food>[];
    for (final line in lines) {
      final food = line.food;
      if (food == null) {
        results.add(LineNutrition(line, issue: LineIssue.noFood));
        continue;
      }
      final grams = gramsFor(food, line.amount, line.unit);
      if (grams == null) {
        results.add(LineNutrition(line, issue: LineIssue.unknownWeight));
        continue;
      }
      final nutrients = food.per100g.scaled(grams / 100);
      results.add(LineNutrition(line, grams: grams, nutrients: nutrients));
      total += nutrients;
      weight += grams;
      counted.add(food);
    }
    for (final n in Nutrient.values) {
      final known = counted.where((f) => f.per100g.has(n)).length;
      if (known > 0 && known < counted.length) partial.add(n);
    }
    return RecipeNutrition._(
      lines: results,
      total: total,
      ingredientWeightG: weight,
      portions: portions,
      partial: partial,
      finishedWeightG: finishedWeightG != null && finishedWeightG > 0 ? finishedWeightG : null,
    );
  }

  final List<LineNutrition> lines;
  final Nutrients total;
  final double ingredientWeightG;
  final double? finishedWeightG;
  final int portions;
  final Set<Nutrient> partial;

  double get totalWeightG => finishedWeightG ?? ingredientWeightG;

  List<LineNutrition> get missing => [for (final l in lines) if (!l.counted) l];

  bool get complete => missing.isEmpty;

  Nutrients get perPortion => total.scaled(1 / portions);

  double get portionWeightG => totalWeightG / portions;

  Nutrients perWeight(double grams) => totalWeightG <= 0 ? Nutrients.empty : total.scaled(grams / totalWeightG);

  Nutrients get per100g => perWeight(100);
}
