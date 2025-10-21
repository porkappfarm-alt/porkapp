import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_measurement.freezed.dart';
part 'animal_measurement.g.dart';

@freezed
class AnimalMeasurement with _$AnimalMeasurement {
  const factory AnimalMeasurement({
    required String id,
    required String batchMeasurementId,
    required String animalId,
    required double weight,
    double? previousWeight,
    double? weightGain,
    int? daysSinceLast,
    double? adg,
    String? notes,
    required DateTime createdAt,
  }) = _AnimalMeasurement;

  factory AnimalMeasurement.fromJson(Map<String, dynamic> json) =>
      _$AnimalMeasurementFromJson(json);
}
