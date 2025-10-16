// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'corral.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Corral _$CorralFromJson(Map<String, dynamic> json) {
  return _Corral.fromJson(json);
}

/// @nodoc
mixin _$Corral {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get activeBatchCount => throw _privateConstructorUsedError;
  CorralStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CorralCopyWith<Corral> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CorralCopyWith<$Res> {
  factory $CorralCopyWith(Corral value, $Res Function(Corral) then) =
      _$CorralCopyWithImpl<$Res, Corral>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? location,
      int? capacity,
      String? notes,
      String? imageUrl,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      int activeBatchCount,
      CorralStatus status});
}

/// @nodoc
class _$CorralCopyWithImpl<$Res, $Val extends Corral>
    implements $CorralCopyWith<$Res> {
  _$CorralCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = freezed,
    Object? capacity = freezed,
    Object? notes = freezed,
    Object? imageUrl = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
    Object? activeBatchCount = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      activeBatchCount: null == activeBatchCount
          ? _value.activeBatchCount
          : activeBatchCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CorralStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CorralImplCopyWith<$Res> implements $CorralCopyWith<$Res> {
  factory _$$CorralImplCopyWith(
          _$CorralImpl value, $Res Function(_$CorralImpl) then) =
      __$$CorralImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? location,
      int? capacity,
      String? notes,
      String? imageUrl,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      int activeBatchCount,
      CorralStatus status});
}

/// @nodoc
class __$$CorralImplCopyWithImpl<$Res>
    extends _$CorralCopyWithImpl<$Res, _$CorralImpl>
    implements _$$CorralImplCopyWith<$Res> {
  __$$CorralImplCopyWithImpl(
      _$CorralImpl _value, $Res Function(_$CorralImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = freezed,
    Object? capacity = freezed,
    Object? notes = freezed,
    Object? imageUrl = freezed,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? updatedAt = null,
    Object? activeBatchCount = null,
    Object? status = null,
  }) {
    return _then(_$CorralImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      activeBatchCount: null == activeBatchCount
          ? _value.activeBatchCount
          : activeBatchCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CorralStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CorralImpl implements _Corral {
  _$CorralImpl(
      {required this.id,
      required this.name,
      this.location,
      this.capacity,
      this.notes,
      this.imageUrl,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'created_by') required this.createdBy,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.activeBatchCount = 0,
      this.status = CorralStatus.disponible});

  factory _$CorralImpl.fromJson(Map<String, dynamic> json) =>
      _$$CorralImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? location;
  @override
  final int? capacity;
  @override
  final String? notes;
  @override
  final String? imageUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int activeBatchCount;
  @override
  @JsonKey()
  final CorralStatus status;

  @override
  String toString() {
    return 'Corral(id: $id, name: $name, location: $location, capacity: $capacity, notes: $notes, imageUrl: $imageUrl, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, activeBatchCount: $activeBatchCount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CorralImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.activeBatchCount, activeBatchCount) ||
                other.activeBatchCount == activeBatchCount) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      location,
      capacity,
      notes,
      imageUrl,
      createdAt,
      createdBy,
      updatedAt,
      activeBatchCount,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CorralImplCopyWith<_$CorralImpl> get copyWith =>
      __$$CorralImplCopyWithImpl<_$CorralImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CorralImplToJson(
      this,
    );
  }
}

abstract class _Corral implements Corral {
  factory _Corral(
      {required final String id,
      required final String name,
      final String? location,
      final int? capacity,
      final String? notes,
      final String? imageUrl,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'created_by') required final String createdBy,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final int activeBatchCount,
      final CorralStatus status}) = _$CorralImpl;

  factory _Corral.fromJson(Map<String, dynamic> json) = _$CorralImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get location;
  @override
  int? get capacity;
  @override
  String? get notes;
  @override
  String? get imageUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'created_by')
  String get createdBy;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  int get activeBatchCount;
  @override
  CorralStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$CorralImplCopyWith<_$CorralImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
