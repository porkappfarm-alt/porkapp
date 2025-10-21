// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimalStatsImpl _$$AnimalStatsImplFromJson(Map<String, dynamic> json) =>
    _$AnimalStatsImpl(
      currentWeight: (json['current_weight'] as num).toDouble(),
      initialWeight: (json['initial_weight'] as num).toDouble(),
      lastWeightGain: (json['last_weight_gain'] as num?)?.toDouble(),
      avgWeightGain: (json['avg_weight_gain'] as num).toDouble(),
      birthDate: DateTime.parse(json['birth_date'] as String),
      ageInDays: (json['age_in_days'] as num).toInt(),
      initialCount: (json['initial_count'] as num?)?.toInt(),
      currentCount: (json['current_count'] as num?)?.toInt(),
      mortalityRate: (json['mortality_rate'] as num?)?.toDouble(),
      feedConversionRatio: (json['feed_conversion_ratio'] as num?)?.toDouble(),
      dailyFeedIntake: (json['daily_feed_intake'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AnimalStatsImplToJson(_$AnimalStatsImpl instance) =>
    <String, dynamic>{
      'current_weight': instance.currentWeight,
      'initial_weight': instance.initialWeight,
      'last_weight_gain': instance.lastWeightGain,
      'avg_weight_gain': instance.avgWeightGain,
      'birth_date': instance.birthDate.toIso8601String(),
      'age_in_days': instance.ageInDays,
      'initial_count': instance.initialCount,
      'current_count': instance.currentCount,
      'mortality_rate': instance.mortalityRate,
      'feed_conversion_ratio': instance.feedConversionRatio,
      'daily_feed_intake': instance.dailyFeedIntake,
    };
