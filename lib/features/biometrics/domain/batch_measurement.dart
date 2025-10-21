import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch_measurement.freezed.dart';
part 'batch_measurement.g.dart';

@freezed
class BatchMeasurement with _$BatchMeasurement {
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
  }) = _BatchMeasurement;

  factory BatchMeasurement.fromJson(Map<String, dynamic> json) =>
      _$BatchMeasurementFromJson(json);
}
