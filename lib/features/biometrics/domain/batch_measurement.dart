import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/local/biometric_local_models.dart';
import 'animal_measurement.dart';

part 'batch_measurement.freezed.dart';
part 'batch_measurement.g.dart';

@freezed
class BatchMeasurement with _$BatchMeasurement {
  const BatchMeasurement._(); // Añadimos este constructor privado

  const factory BatchMeasurement({
    required String id,
    required String batchId,
    required DateTime measurementDate,
    required double averageWeight,
    required int animalCount,
    String? notes,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('active') String status,
    String? batchName,
    String? measurementName,
    @Default([]) List<AnimalMeasurement> measurements,
  }) = _BatchMeasurement;

  factory BatchMeasurement.fromJson(Map<String, dynamic> json) =>
      _$BatchMeasurementFromJson(json);
}

extension BatchMeasurementLocalExtension on BatchMeasurement {
  LocalBatchMeasurement toLocal() {
    final local = LocalBatchMeasurement()
      ..remoteId = id
      ..batchId = batchId
      ..measurementDate = measurementDate
      ..averageWeight = averageWeight
      ..animalCount = animalCount
      ..notes = notes
      ..createdBy = createdBy
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..status = status
      ..syncStatus = SyncStatus.pending;
    return local;
  }
}
