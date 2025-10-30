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
      activeBatchName: json['active_batch_name'] as String?,
      activeBatchEntryDate: json['active_batch_entry_date'] == null
          ? null
          : DateTime.parse(json['active_batch_entry_date'] as String),
      lastBiometryAvgWeight:
          (json['last_biometry_avg_weight'] as num?)?.toDouble(),
      batches: (json['batches'] as List<dynamic>?)
          ?.map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeBatchId: json['active_batch_id'] as String?,
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
      'active_batch_name': instance.activeBatchName,
      'active_batch_entry_date':
          instance.activeBatchEntryDate?.toIso8601String(),
      'last_biometry_avg_weight': instance.lastBiometryAvgWeight,
      'batches': instance.batches?.map((e) => e.toJson()).toList(),
      'active_batch_id': instance.activeBatchId,
    };

const _$CorralStatusEnumMap = {
  CorralStatus.disponible: 'disponible',
  CorralStatus.ocupado: 'ocupado',
  CorralStatus.mantenimiento: 'mantenimiento',
};
