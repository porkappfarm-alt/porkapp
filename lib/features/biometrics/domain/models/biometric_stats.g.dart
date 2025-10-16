// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BiometricStatsImpl _$$BiometricStatsImplFromJson(Map<String, dynamic> json) =>
    _$BiometricStatsImpl(
      adg: (json['adg'] as num).toDouble(),
      fcr: (json['fcr'] as num).toDouble(),
      mortalityRate: (json['mortalityRate'] as num).toDouble(),
      mortalityByCause: (json['mortalityByCause'] as List<dynamic>)
          .map((e) => MortalityByCause.fromJson(e as Map<String, dynamic>))
          .toList(),
      weightTimeline: (json['weightTimeline'] as List<dynamic>)
          .map((e) => WeightPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BiometricStatsImplToJson(
        _$BiometricStatsImpl instance) =>
    <String, dynamic>{
      'adg': instance.adg,
      'fcr': instance.fcr,
      'mortalityRate': instance.mortalityRate,
      'mortalityByCause': instance.mortalityByCause,
      'weightTimeline': instance.weightTimeline,
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
      avgWeight: (json['avgWeight'] as num).toDouble(),
    );

Map<String, dynamic> _$$WeightPointImplToJson(_$WeightPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'avgWeight': instance.avgWeight,
    };
