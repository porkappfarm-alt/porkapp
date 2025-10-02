// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimalEventImpl _$$AnimalEventImplFromJson(Map<String, dynamic> json) =>
    _$AnimalEventImpl(
      id: json['id'] as String,
      animalId: json['animalId'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$AnimalEventImplToJson(_$AnimalEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'animalId': instance.animalId,
      'date': instance.date.toIso8601String(),
      'type': instance.type,
      'data': instance.data,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
    };
