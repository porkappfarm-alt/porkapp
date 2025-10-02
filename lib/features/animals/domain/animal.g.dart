// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimalImpl _$$AnimalImplFromJson(Map<String, dynamic> json) => _$AnimalImpl(
  id: json['id'] as String,
  batchId: json['batch_id'] as String,
  identifier: json['identifier'] as String,
  birthDate: DateTime.parse(json['birth_date'] as String),
  weight: (json['weight'] as num).toDouble(),
  breed: json['breed'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  status: json['status'] as String? ?? 'active',
);

Map<String, dynamic> _$$AnimalImplToJson(_$AnimalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batch_id': instance.batchId,
      'identifier': instance.identifier,
      'birth_date': instance.birthDate.toIso8601String(),
      'weight': instance.weight,
      'breed': instance.breed,
      'created_at': instance.createdAt.toIso8601String(),
      'status': instance.status,
    };
