// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BatchImpl _$$BatchImplFromJson(Map<String, dynamic> json) => _$BatchImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  headcountStart: (json['headcount_start'] as num?)?.toInt() ?? 0,
  corralId: json['corral_id'] as String?,
  initialAvgWeight: (json['initial_avg_weight'] as num?)?.toDouble(),
  status: json['status'] as String? ?? 'active',
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$BatchImplToJson(_$BatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
      'headcount_start': instance.headcountStart,
      'corral_id': instance.corralId,
      'initial_avg_weight': instance.initialAvgWeight,
      'status': instance.status,
      'notes': instance.notes,
    };
