// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnimalEvent _$AnimalEventFromJson(Map<String, dynamic> json) {
  return _AnimalEvent.fromJson(json);
}

/// @nodoc
mixin _$AnimalEvent {
  String get id => throw _privateConstructorUsedError;
  String get animalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_date')
  DateTime get date => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // weighing, treatment, mortality, etc.
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_feed')
  double? get qtyFeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'death_cause')
  String? get deathCause => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_id')
  String? get batchId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnimalEventCopyWith<AnimalEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalEventCopyWith<$Res> {
  factory $AnimalEventCopyWith(
          AnimalEvent value, $Res Function(AnimalEvent) then) =
      _$AnimalEventCopyWithImpl<$Res, AnimalEvent>;
  @useResult
  $Res call(
      {String id,
      String animalId,
      @JsonKey(name: 'event_date') DateTime date,
      String type,
      Map<String, dynamic> data,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      double? weight,
      @JsonKey(name: 'qty_feed') double? qtyFeed,
      @JsonKey(name: 'death_cause') String? deathCause,
      @JsonKey(name: 'batch_id') String? batchId,
      String? description});
}

/// @nodoc
class _$AnimalEventCopyWithImpl<$Res, $Val extends AnimalEvent>
    implements $AnimalEventCopyWith<$Res> {
  _$AnimalEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? animalId = null,
    Object? date = null,
    Object? type = null,
    Object? data = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? weight = freezed,
    Object? qtyFeed = freezed,
    Object? deathCause = freezed,
    Object? batchId = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      animalId: null == animalId
          ? _value.animalId
          : animalId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      qtyFeed: freezed == qtyFeed
          ? _value.qtyFeed
          : qtyFeed // ignore: cast_nullable_to_non_nullable
              as double?,
      deathCause: freezed == deathCause
          ? _value.deathCause
          : deathCause // ignore: cast_nullable_to_non_nullable
              as String?,
      batchId: freezed == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnimalEventImplCopyWith<$Res>
    implements $AnimalEventCopyWith<$Res> {
  factory _$$AnimalEventImplCopyWith(
          _$AnimalEventImpl value, $Res Function(_$AnimalEventImpl) then) =
      __$$AnimalEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String animalId,
      @JsonKey(name: 'event_date') DateTime date,
      String type,
      Map<String, dynamic> data,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      double? weight,
      @JsonKey(name: 'qty_feed') double? qtyFeed,
      @JsonKey(name: 'death_cause') String? deathCause,
      @JsonKey(name: 'batch_id') String? batchId,
      String? description});
}

/// @nodoc
class __$$AnimalEventImplCopyWithImpl<$Res>
    extends _$AnimalEventCopyWithImpl<$Res, _$AnimalEventImpl>
    implements _$$AnimalEventImplCopyWith<$Res> {
  __$$AnimalEventImplCopyWithImpl(
      _$AnimalEventImpl _value, $Res Function(_$AnimalEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? animalId = null,
    Object? date = null,
    Object? type = null,
    Object? data = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? weight = freezed,
    Object? qtyFeed = freezed,
    Object? deathCause = freezed,
    Object? batchId = freezed,
    Object? description = freezed,
  }) {
    return _then(_$AnimalEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      animalId: null == animalId
          ? _value.animalId
          : animalId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      qtyFeed: freezed == qtyFeed
          ? _value.qtyFeed
          : qtyFeed // ignore: cast_nullable_to_non_nullable
              as double?,
      deathCause: freezed == deathCause
          ? _value.deathCause
          : deathCause // ignore: cast_nullable_to_non_nullable
              as String?,
      batchId: freezed == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimalEventImpl implements _AnimalEvent {
  const _$AnimalEventImpl(
      {required this.id,
      required this.animalId,
      @JsonKey(name: 'event_date') required this.date,
      required this.type,
      required final Map<String, dynamic> data,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.weight,
      @JsonKey(name: 'qty_feed') this.qtyFeed,
      @JsonKey(name: 'death_cause') this.deathCause,
      @JsonKey(name: 'batch_id') this.batchId,
      this.description})
      : _data = data;

  factory _$AnimalEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalEventImplFromJson(json);

  @override
  final String id;
  @override
  final String animalId;
  @override
  @JsonKey(name: 'event_date')
  final DateTime date;
  @override
  final String type;
// weighing, treatment, mortality, etc.
  final Map<String, dynamic> _data;
// weighing, treatment, mortality, etc.
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  final double? weight;
  @override
  @JsonKey(name: 'qty_feed')
  final double? qtyFeed;
  @override
  @JsonKey(name: 'death_cause')
  final String? deathCause;
  @override
  @JsonKey(name: 'batch_id')
  final String? batchId;
  @override
  final String? description;

  @override
  String toString() {
    return 'AnimalEvent(id: $id, animalId: $animalId, date: $date, type: $type, data: $data, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, weight: $weight, qtyFeed: $qtyFeed, deathCause: $deathCause, batchId: $batchId, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.animalId, animalId) ||
                other.animalId == animalId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.qtyFeed, qtyFeed) || other.qtyFeed == qtyFeed) &&
            (identical(other.deathCause, deathCause) ||
                other.deathCause == deathCause) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      animalId,
      date,
      type,
      const DeepCollectionEquality().hash(_data),
      notes,
      createdAt,
      updatedAt,
      weight,
      qtyFeed,
      deathCause,
      batchId,
      description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalEventImplCopyWith<_$AnimalEventImpl> get copyWith =>
      __$$AnimalEventImplCopyWithImpl<_$AnimalEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalEventImplToJson(
      this,
    );
  }
}

abstract class _AnimalEvent implements AnimalEvent {
  const factory _AnimalEvent(
      {required final String id,
      required final String animalId,
      @JsonKey(name: 'event_date') required final DateTime date,
      required final String type,
      required final Map<String, dynamic> data,
      final String? notes,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final double? weight,
      @JsonKey(name: 'qty_feed') final double? qtyFeed,
      @JsonKey(name: 'death_cause') final String? deathCause,
      @JsonKey(name: 'batch_id') final String? batchId,
      final String? description}) = _$AnimalEventImpl;

  factory _AnimalEvent.fromJson(Map<String, dynamic> json) =
      _$AnimalEventImpl.fromJson;

  @override
  String get id;
  @override
  String get animalId;
  @override
  @JsonKey(name: 'event_date')
  DateTime get date;
  @override
  String get type;
  @override // weighing, treatment, mortality, etc.
  Map<String, dynamic> get data;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  double? get weight;
  @override
  @JsonKey(name: 'qty_feed')
  double? get qtyFeed;
  @override
  @JsonKey(name: 'death_cause')
  String? get deathCause;
  @override
  @JsonKey(name: 'batch_id')
  String? get batchId;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$AnimalEventImplCopyWith<_$AnimalEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
