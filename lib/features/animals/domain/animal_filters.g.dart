// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalTypeConverter _$AnimalTypeConverterFromJson(Map<String, dynamic> json) =>
    AnimalTypeConverter();

Map<String, dynamic> _$AnimalTypeConverterToJson(
        AnimalTypeConverter instance) =>
    <String, dynamic>{};

AnimalStatusConverter _$AnimalStatusConverterFromJson(
        Map<String, dynamic> json) =>
    AnimalStatusConverter();

Map<String, dynamic> _$AnimalStatusConverterToJson(
        AnimalStatusConverter instance) =>
    <String, dynamic>{};

AnimalEventTypeConverter _$AnimalEventTypeConverterFromJson(
        Map<String, dynamic> json) =>
    AnimalEventTypeConverter();

Map<String, dynamic> _$AnimalEventTypeConverterToJson(
        AnimalEventTypeConverter instance) =>
    <String, dynamic>{};

_$AnimalFiltersImpl _$$AnimalFiltersImplFromJson(Map<String, dynamic> json) =>
    _$AnimalFiltersImpl(
      type: _$JsonConverterFromJson<String, AnimalType>(
          json['type'], const AnimalTypeConverter().fromJson),
      status: _$JsonConverterFromJson<String, AnimalStatus>(
          json['status'], const AnimalStatusConverter().fromJson),
      dateFrom: json['date_from'] == null
          ? null
          : DateTime.parse(json['date_from'] as String),
      dateTo: json['date_to'] == null
          ? null
          : DateTime.parse(json['date_to'] as String),
      batchId: json['batch_id'] as String?,
      corralId: json['corral_id'] as String?,
      minWeight: (json['min_weight'] as num?)?.toDouble(),
      maxWeight: (json['max_weight'] as num?)?.toDouble(),
      isMale: json['is_male'] as bool?,
      searchQuery: json['search_query'] as String?,
    );

Map<String, dynamic> _$$AnimalFiltersImplToJson(_$AnimalFiltersImpl instance) =>
    <String, dynamic>{
      'type': _$JsonConverterToJson<String, AnimalType>(
          instance.type, const AnimalTypeConverter().toJson),
      'status': _$JsonConverterToJson<String, AnimalStatus>(
          instance.status, const AnimalStatusConverter().toJson),
      'date_from': instance.dateFrom?.toIso8601String(),
      'date_to': instance.dateTo?.toIso8601String(),
      'batch_id': instance.batchId,
      'corral_id': instance.corralId,
      'min_weight': instance.minWeight,
      'max_weight': instance.maxWeight,
      'is_male': instance.isMale,
      'search_query': instance.searchQuery,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
