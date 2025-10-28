import 'biometric_local_models.dart';

extension BiometricSyncServiceExtension on LocalAnimalMeasurement {
  /// Genera un ID local único que combina el ID del animal y la fecha
  String get uniqueMeasurementKey {
    final date = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day,
    );
    return '${animalId}_${date.toIso8601String()}';
  }

  /// Compara con otra medición para determinar si son del mismo día
  bool isSameDayAs(LocalAnimalMeasurement other) {
    return uniqueMeasurementKey == other.uniqueMeasurementKey;
  }
}
