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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnimalEvent _$AnimalEventFromJson(Map<String, dynamic> json) {
  return _AnimalEvent.fromJson(json);
}

/// @nodoc
mixin _$AnimalEvent {
  String get id => throw _privateConstructorUsedError;
  String get animalId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // weighing, treatment, mortality
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AnimalEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnimalEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnimalEventCopyWith<AnimalEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalEventCopyWith<$Res> {
  factory $AnimalEventCopyWith(
    AnimalEvent value,
    $Res Function(AnimalEvent) then,
  ) = _$AnimalEventCopyWithImpl<$Res, AnimalEvent>;
  @useResult
  $Res call({
    String id,
    String animalId,
    DateTime date,
    String type,
    Map<String, dynamic> data,
    String? notes,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$AnimalEventCopyWithImpl<$Res, $Val extends AnimalEvent>
    implements $AnimalEventCopyWith<$Res> {
  _$AnimalEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimalEvent
  /// with the given fields replaced by the non-null parameter values.
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
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnimalEventImplCopyWith<$Res>
    implements $AnimalEventCopyWith<$Res> {
  factory _$$AnimalEventImplCopyWith(
    _$AnimalEventImpl value,
    $Res Function(_$AnimalEventImpl) then,
  ) = __$$AnimalEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String animalId,
    DateTime date,
    String type,
    Map<String, dynamic> data,
    String? notes,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$AnimalEventImplCopyWithImpl<$Res>
    extends _$AnimalEventCopyWithImpl<$Res, _$AnimalEventImpl>
    implements _$$AnimalEventImplCopyWith<$Res> {
  __$$AnimalEventImplCopyWithImpl(
    _$AnimalEventImpl _value,
    $Res Function(_$AnimalEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnimalEvent
  /// with the given fields replaced by the non-null parameter values.
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
  }) {
    return _then(
      _$AnimalEventImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimalEventImpl implements _AnimalEvent {
  const _$AnimalEventImpl({
    required this.id,
    required this.animalId,
    required this.date,
    required this.type,
    required final Map<String, dynamic> data,
    this.notes,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _data = data;

  factory _$AnimalEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalEventImplFromJson(json);

  @override
  final String id;
  @override
  final String animalId;
  @override
  final DateTime date;
  @override
  final String type;
  // weighing, treatment, mortality
  final Map<String, dynamic> _data;
  // weighing, treatment, mortality
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
  String toString() {
    return 'AnimalEvent(id: $id, animalId: $animalId, date: $date, type: $type, data: $data, notes: $notes, createdAt: $createdAt)';
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
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
  );

  /// Create a copy of AnimalEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalEventImplCopyWith<_$AnimalEventImpl> get copyWith =>
      __$$AnimalEventImplCopyWithImpl<_$AnimalEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalEventImplToJson(this);
  }
}

abstract class _AnimalEvent implements AnimalEvent {
  const factory _AnimalEvent({
    required final String id,
    required final String animalId,
    required final DateTime date,
    required final String type,
    required final Map<String, dynamic> data,
    final String? notes,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$AnimalEventImpl;

  factory _AnimalEvent.fromJson(Map<String, dynamic> json) =
      _$AnimalEventImpl.fromJson;

  @override
  String get id;
  @override
  String get animalId;
  @override
  DateTime get date;
  @override
  String get type; // weighing, treatment, mortality
  @override
  Map<String, dynamic> get data;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of AnimalEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnimalEventImplCopyWith<_$AnimalEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
