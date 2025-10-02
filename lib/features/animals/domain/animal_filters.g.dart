// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalTypeConverter _$AnimalTypeConverterFromJson(Map<String, dynamic> json) =>
    AnimalTypeConverter();

Map<String, dynamic> _$AnimalTypeConverterToJson(
  AnimalTypeConverter instance,
) => <String, dynamic>{};

AnimalStatusConverter _$AnimalStatusConverterFromJson(
  Map<String, dynamic> json,
) => AnimalStatusConverter();

Map<String, dynamic> _$AnimalStatusConverterToJson(
  AnimalStatusConverter instance,
) => <String, dynamic>{};

AnimalEventTypeConverter _$AnimalEventTypeConverterFromJson(
  Map<String, dynamic> json,
) => AnimalEventTypeConverter();

Map<String, dynamic> _$AnimalEventTypeConverterToJson(
  AnimalEventTypeConverter instance,
) => <String, dynamic>{};

_$AnimalFiltersImpl _$$AnimalFiltersImplFromJson(Map<String, dynamic> json) =>
    _$AnimalFiltersImpl(
      type: _$JsonConverterFromJson<String, AnimalType>(
        json['type'],
        const AnimalTypeConverter().fromJson,
      ),
      status: _$JsonConverterFromJson<String, AnimalStatus>(
        json['status'],
        const AnimalStatusConverter().fromJson,
      ),
      dateFrom: json['dateFrom'] == null
          ? null
          : DateTime.parse(json['dateFrom'] as String),
      dateTo: json['dateTo'] == null
          ? null
          : DateTime.parse(json['dateTo'] as String),
      batchId: json['batchId'] as String?,
      corralId: json['corralId'] as String?,
      minWeight: (json['minWeight'] as num?)?.toDouble(),
      maxWeight: (json['maxWeight'] as num?)?.toDouble(),
      isMale: json['isMale'] as bool?,
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$AnimalFiltersImplToJson(_$AnimalFiltersImpl instance) =>
    <String, dynamic>{
      'type': _$JsonConverterToJson<String, AnimalType>(
        instance.type,
        const AnimalTypeConverter().toJson,
      ),
      'status': _$JsonConverterToJson<String, AnimalStatus>(
        instance.status,
        const AnimalStatusConverter().toJson,
      ),
      'dateFrom': instance.dateFrom?.toIso8601String(),
      'dateTo': instance.dateTo?.toIso8601String(),
      'batchId': instance.batchId,
      'corralId': instance.corralId,
      'minWeight': instance.minWeight,
      'maxWeight': instance.maxWeight,
      'isMale': instance.isMale,
      'searchQuery': instance.searchQuery,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
