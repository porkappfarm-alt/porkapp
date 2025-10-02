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
  imageUrl: json['imageUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  activeBatchCount: (json['activeBatchCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$CorralImplToJson(_$CorralImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'capacity': instance.capacity,
      'notes': instance.notes,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'activeBatchCount': instance.activeBatchCount,
    };
