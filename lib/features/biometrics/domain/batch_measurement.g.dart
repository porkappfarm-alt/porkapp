// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BatchMeasurementImpl _$$BatchMeasurementImplFromJson(
        Map<String, dynamic> json) =>
    _$BatchMeasurementImpl(
      id: json['id'] as String,
      batchId: json['batch_id'] as String,
      measurementDate: DateTime.parse(json['measurement_date'] as String),
      averageWeight: (json['average_weight'] as num).toDouble(),
      animalCount: (json['animal_count'] as num).toInt(),
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      status: json['status'] as String? ?? 'active',
      batchName: json['batch_name'] as String?,
    );

Map<String, dynamic> _$$BatchMeasurementImplToJson(
        _$BatchMeasurementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batch_id': instance.batchId,
      'measurement_date': instance.measurementDate.toIso8601String(),
      'average_weight': instance.averageWeight,
      'animal_count': instance.animalCount,
      'notes': instance.notes,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'status': instance.status,
      'batch_name': instance.batchName,
    };
