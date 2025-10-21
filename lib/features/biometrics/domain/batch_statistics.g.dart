// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BatchStatisticsImpl _$$BatchStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$BatchStatisticsImpl(
      avgWeight: (json['avg_weight'] as num).toDouble(),
      avgAdg: (json['avg_adg'] as num).toDouble(),
      minWeight: (json['min_weight'] as num).toDouble(),
      maxWeight: (json['max_weight'] as num).toDouble(),
      weightStdDev: (json['weight_std_dev'] as num).toDouble(),
      uniformityPercent: (json['uniformity_percent'] as num).toDouble(),
    );

Map<String, dynamic> _$$BatchStatisticsImplToJson(
        _$BatchStatisticsImpl instance) =>
    <String, dynamic>{
      'avg_weight': instance.avgWeight,
      'avg_adg': instance.avgAdg,
      'min_weight': instance.minWeight,
      'max_weight': instance.maxWeight,
      'weight_std_dev': instance.weightStdDev,
      'uniformity_percent': instance.uniformityPercent,
    };
