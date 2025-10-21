// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimalEventImpl _$$AnimalEventImplFromJson(Map<String, dynamic> json) =>
    _$AnimalEventImpl(
      id: json['id'] as String,
      animalId: json['animal_id'] as String,
      date: DateTime.parse(json['event_date'] as String),
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      weight: (json['weight'] as num?)?.toDouble(),
      qtyFeed: (json['qty_feed'] as num?)?.toDouble(),
      deathCause: json['death_cause'] as String?,
      batchId: json['batch_id'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$AnimalEventImplToJson(_$AnimalEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'animal_id': instance.animalId,
      'event_date': instance.date.toIso8601String(),
      'type': instance.type,
      'data': instance.data,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'weight': instance.weight,
      'qty_feed': instance.qtyFeed,
      'death_cause': instance.deathCause,
      'batch_id': instance.batchId,
      'description': instance.description,
    };
