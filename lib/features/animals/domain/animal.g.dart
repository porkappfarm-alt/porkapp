// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimalImpl _$$AnimalImplFromJson(Map<String, dynamic> json) => _$AnimalImpl(
      id: json['id'] as String,
      batchId: json['batch_id'] as String,
      identifier: json['identifier'] as String,
      birthDate: _nullableDateFromString(json['birth_date'] as String?),
      sex: json['sex'] as String?,
      weight: (json['weight_at_entry'] as num?)?.toDouble(),
      breed: json['breed'] as String,
      type: json['animal_type'] as String,
      entryDate: _nullableDateFromString(json['entry_date'] as String?),
      createdAt: _nullableDateFromString(json['created_at'] as String?),
      updatedAt: _nullableDateFromString(json['updated_at'] as String?),
      gender: json['gender'] as String? ?? 'unknown',
      status: json['status'] as String? ?? 'active',
      notes: json['notes'] as String?,
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      parityNumber: (json['parity_number'] as num?)?.toInt(),
      serviceCount: (json['service_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AnimalImplToJson(_$AnimalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batch_id': instance.batchId,
      'identifier': instance.identifier,
      'birth_date': _nullableDateToString(instance.birthDate),
      'sex': instance.sex,
      'weight_at_entry': instance.weight,
      'breed': instance.breed,
      'animal_type': instance.type,
      'entry_date': _nullableDateToString(instance.entryDate),
      'created_at': _nullableDateToString(instance.createdAt),
      'updated_at': _nullableDateToString(instance.updatedAt),
      'gender': instance.gender,
      'status': instance.status,
      'notes': instance.notes,
      'target_weight': instance.targetWeight,
      'parity_number': instance.parityNumber,
      'service_count': instance.serviceCount,
    };
