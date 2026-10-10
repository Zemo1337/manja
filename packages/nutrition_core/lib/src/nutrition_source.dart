import 'food.dart';

abstract interface class NutritionSource {
  FoodSource get source;

  Future<List<FoodSummary>> search(String query, {int limit = 25});

  Future<Food?> fetch(String sourceId);
}

enum NutritionErrorKind { rateLimited, unauthorized, unreachable, other }

class NutritionSourceException implements Exception {
  const NutritionSourceException(
    this.message, {
    this.kind = NutritionErrorKind.other,
    this.cause,
    this.source = FoodSource.usda,
  });

  final String message;
  final NutritionErrorKind kind;
  final Object? cause;
  final FoodSource source;

  @override
  String toString() => 'NutritionSourceException($kind): $message${cause == null ? '' : ' ($cause)'}';
}
