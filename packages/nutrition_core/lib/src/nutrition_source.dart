import 'food.dart';

abstract interface class NutritionSource {
  FoodSource get source;

  Future<List<FoodSummary>> search(String query, {int limit = 25});

  Future<Food?> fetch(String sourceId);
}

class NutritionSourceException implements Exception {
  const NutritionSourceException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'NutritionSourceException: $message${cause == null ? '' : ' ($cause)'}';
}
