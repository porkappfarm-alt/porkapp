import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/local/biometric_local_models.dart';

part 'animal_measurement.freezed.dart';
part 'animal_measurement.g.dart';

@freezed
class AnimalMeasurement with _$AnimalMeasurement {
  const AnimalMeasurement._(); // Añadimos este constructor privado

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

extension AnimalMeasurementLocalExtension on AnimalMeasurement {
  LocalAnimalMeasurement toLocal() {
    final local = LocalAnimalMeasurement()
      ..remoteId = id
      ..animalId = animalId
      ..weight = weight
      ..previousWeight = previousWeight
      ..weightGain = weightGain
      ..daysSinceLast = daysSinceLast
      ..adg = adg
      ..notes = notes
      ..createdAt = createdAt
      ..syncStatus = SyncStatus.pending;
    return local;
  }
}
