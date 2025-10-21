// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CorralImpl _$$CorralImplFromJson(Map<String, dynamic> json) => _$CorralImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      activeBatchCount: (json['active_batch_count'] as num?)?.toInt() ?? 0,
      status: $enumDecodeNullable(_$CorralStatusEnumMap, json['status']) ??
          CorralStatus.disponible,
    );

Map<String, dynamic> _$$CorralImplToJson(_$CorralImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'capacity': instance.capacity,
      'notes': instance.notes,
      'image_url': instance.imageUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'created_by': instance.createdBy,
      'updated_at': instance.updatedAt.toIso8601String(),
      'active_batch_count': instance.activeBatchCount,
      'status': _$CorralStatusEnumMap[instance.status]!,
    };

const _$CorralStatusEnumMap = {
  CorralStatus.disponible: 'disponible',
  CorralStatus.ocupado: 'ocupado',
  CorralStatus.mantenimiento: 'mantenimiento',
};
