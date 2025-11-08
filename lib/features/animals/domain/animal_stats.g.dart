// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimalStatsImpl _$$AnimalStatsImplFromJson(Map<String, dynamic> json) =>
    _$AnimalStatsImpl(
      currentWeight: (json['currentWeight'] as num).toDouble(),
      initialWeight: (json['initialWeight'] as num).toDouble(),
      lastWeightGain: (json['lastWeightGain'] as num?)?.toDouble(),
      avgWeightGain: (json['avgWeightGain'] as num).toDouble(),
      birthDate: DateTime.parse(json['birthDate'] as String),
      ageInDays: (json['ageInDays'] as num).toInt(),
      initialCount: (json['initialCount'] as num?)?.toInt(),
      currentCount: (json['currentCount'] as num?)?.toInt(),
      mortalityRate: (json['mortalityRate'] as num?)?.toDouble(),
      feedConversionRatio: (json['feedConversionRatio'] as num?)?.toDouble(),
      dailyFeedIntake: (json['dailyFeedIntake'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AnimalStatsImplToJson(_$AnimalStatsImpl instance) =>
    <String, dynamic>{
      'currentWeight': instance.currentWeight,
      'initialWeight': instance.initialWeight,
      'lastWeightGain': instance.lastWeightGain,
      'avgWeightGain': instance.avgWeightGain,
      'birthDate': instance.birthDate.toIso8601String(),
      'ageInDays': instance.ageInDays,
      'initialCount': instance.initialCount,
      'currentCount': instance.currentCount,
      'mortalityRate': instance.mortalityRate,
      'feedConversionRatio': instance.feedConversionRatio,
      'dailyFeedIntake': instance.dailyFeedIntake,
    };
