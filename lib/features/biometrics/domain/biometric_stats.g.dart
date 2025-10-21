// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BiometricStatsImpl _$$BiometricStatsImplFromJson(Map<String, dynamic> json) =>
    _$BiometricStatsImpl(
      adg: (json['adg'] as num).toDouble(),
      fcr: (json['fcr'] as num).toDouble(),
      mortalityRate: (json['mortality_rate'] as num).toDouble(),
      mortalityByCause: (json['mortality_by_cause'] as List<dynamic>)
          .map((e) => MortalityByCause.fromJson(e as Map<String, dynamic>))
          .toList(),
      weightTimeline: (json['weight_timeline'] as List<dynamic>)
          .map((e) => WeightPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BiometricStatsImplToJson(
        _$BiometricStatsImpl instance) =>
    <String, dynamic>{
      'adg': instance.adg,
      'fcr': instance.fcr,
      'mortality_rate': instance.mortalityRate,
      'mortality_by_cause':
          instance.mortalityByCause.map((e) => e.toJson()).toList(),
      'weight_timeline':
          instance.weightTimeline.map((e) => e.toJson()).toList(),
    };

_$MortalityByCauseImpl _$$MortalityByCauseImplFromJson(
        Map<String, dynamic> json) =>
    _$MortalityByCauseImpl(
      cause: json['cause'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$MortalityByCauseImplToJson(
        _$MortalityByCauseImpl instance) =>
    <String, dynamic>{
      'cause': instance.cause,
      'count': instance.count,
    };

_$WeightPointImpl _$$WeightPointImplFromJson(Map<String, dynamic> json) =>
    _$WeightPointImpl(
      date: DateTime.parse(json['date'] as String),
      avgWeight: (json['avg_weight'] as num).toDouble(),
    );

Map<String, dynamic> _$$WeightPointImplToJson(_$WeightPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'avg_weight': instance.avgWeight,
    };
