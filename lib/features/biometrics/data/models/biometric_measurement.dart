import 'package:freezed_annotation/freezed_annotation.dart';

part 'biometric_measurement.freezed.dart';
part 'biometric_measurement.g.dart';

/// Modelo que representa una medición biométrica individual de un animal
/// dentro de una medición de lote.
@freezed
class BiometricMeasurement with _$BiometricMeasurement {
  /// Crea una nueva medición biométrica
  @Assert('weight > 0', 'El peso debe ser mayor a 0')
  @Assert(
      'averageDailyGain == null || (averageDailyGain >= 0 && averageDailyGain <= 2)',
      'La ganancia diaria debe estar entre 0 y 2 kg/día')
  const factory BiometricMeasurement({
    /// Identificador único de la medición
    required String id,

    /// ID de la medición de lote a la que pertenece
    @JsonKey(name: 'biometric_id') required String batchMeasurementId,

    /// ID del animal medido
    @JsonKey(name: 'animal_id') required String animalId,

    /// Peso actual en kilogramos
    required double weight,

    /// Peso anterior en kilogramos
    @JsonKey(name: 'previous_weight') double? previousWeight,

    /// Ganancia de peso desde la última medición
    @JsonKey(name: 'weight_gain') double? weightGain,

    /// Días transcurridos desde la última medición
    @JsonKey(name: 'days_since_last') int? daysSinceLast,

    /// Ganancia diaria promedio (kg/día)
    @JsonKey(name: 'adg') double? averageDailyGain,

    /// Notas u observaciones sobre la medición
    String? notes,

    /// Fecha y hora de la medición
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BiometricMeasurement;

  /// Crea una instancia de [BiometricMeasurement] a partir de un Map
  factory BiometricMeasurement.fromJson(Map<String, dynamic> json) =>
      _$BiometricMeasurementFromJson(json);
}
