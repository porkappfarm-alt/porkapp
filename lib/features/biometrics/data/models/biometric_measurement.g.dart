// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BiometricMeasurementImpl _$$BiometricMeasurementImplFromJson(
        Map<String, dynamic> json) =>
    _$BiometricMeasurementImpl(
      id: json['id'] as String,
      batchMeasurementId: json['biometric_id'] as String,
      animalId: json['animal_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      previousWeight: (json['previous_weight'] as num?)?.toDouble(),
      weightGain: (json['weight_gain'] as num?)?.toDouble(),
      daysSinceLast: (json['days_since_last'] as num?)?.toInt(),
      averageDailyGain: (json['adg'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$BiometricMeasurementImplToJson(
        _$BiometricMeasurementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'biometric_id': instance.batchMeasurementId,
      'animal_id': instance.animalId,
      'weight': instance.weight,
      'previous_weight': instance.previousWeight,
      'weight_gain': instance.weightGain,
      'days_since_last': instance.daysSinceLast,
      'adg': instance.averageDailyGain,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
    };
