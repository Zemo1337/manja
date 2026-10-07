import 'food.dart';

abstract interface class NutritionSource {
  FoodSource get source;

  Future<List<FoodSummary>> search(String query, {int limit = 25});

  Future<Food?> fetch(String sourceId);
}

enum NutritionErrorKind { rateLimited, unauthorized, unreachable, other }

class NutritionSourceException implements Exception {
  const NutritionSourceException(this.message, {this.kind = NutritionErrorKind.other, this.cause});

  final String message;
  final NutritionErrorKind kind;
  final Object? cause;

  @override
  String toString() => 'NutritionSourceException($kind): $message${cause == null ? '' : ' ($cause)'}';
}
