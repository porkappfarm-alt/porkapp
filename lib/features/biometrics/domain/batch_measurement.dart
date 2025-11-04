import '../data/local/biometric_local_models.dart';
import 'animal_measurement.dart';

/// Modelo de BatchMeasurement - Convertido de freezed a clase plana
class BatchMeasurement {
  final String id;
  final String batchId;
  final DateTime measurementDate;
  final double averageWeight;
  final int animalCount;
  final String? notes;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final String? batchName;
  final String? measurementName;
  final List<AnimalMeasurement> measurements;

  const BatchMeasurement({
    required this.id,
    required this.batchId,
    required this.measurementDate,
    required this.averageWeight,
    required this.animalCount,
    this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.status = 'active',
    this.batchName,
    this.measurementName,
    this.measurements = const [],
  });

  factory BatchMeasurement.fromJson(Map<String, dynamic> json) {
    return BatchMeasurement(
      id: json['id'] as String,
      batchId: json['batch_id'] as String,
      measurementDate: DateTime.parse(json['measurement_date'] as String),
      averageWeight: (json['average_weight'] as num).toDouble(),
      animalCount: json['animal_count'] as int,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      status: json['status'] as String? ?? 'active',
      batchName: json['batch_name'] as String?,
      measurementName: json['measurement_name'] as String?,
      measurements: (json['measurements'] as List<dynamic>?)
              ?.map((e) => AnimalMeasurement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batch_id': batchId,
      'measurement_date': measurementDate.toIso8601String(),
      'average_weight': averageWeight,
      'animal_count': animalCount,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'batch_name': batchName,
      'measurement_name': measurementName,
      'measurements': measurements.map((e) => e.toJson()).toList(),
    };
  }

  BatchMeasurement copyWith({
    String? id,
    String? batchId,
    DateTime? measurementDate,
    double? averageWeight,
    int? animalCount,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    String? batchName,
    String? measurementName,
    List<AnimalMeasurement>? measurements,
  }) {
    return BatchMeasurement(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      measurementDate: measurementDate ?? this.measurementDate,
      averageWeight: averageWeight ?? this.averageWeight,
      animalCount: animalCount ?? this.animalCount,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      batchName: batchName ?? this.batchName,
      measurementName: measurementName ?? this.measurementName,
      measurements: measurements ?? this.measurements,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BatchMeasurement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
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
