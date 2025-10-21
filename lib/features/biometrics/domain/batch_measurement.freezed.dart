// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BatchMeasurement _$BatchMeasurementFromJson(Map<String, dynamic> json) {
  return _BatchMeasurement.fromJson(json);
}

/// @nodoc
mixin _$BatchMeasurement {
  String get id => throw _privateConstructorUsedError;
  String get batchId => throw _privateConstructorUsedError;
  DateTime get measurementDate => throw _privateConstructorUsedError;
  double get averageWeight => throw _privateConstructorUsedError;
  int get animalCount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get batchName => throw _privateConstructorUsedError;

  /// Serializes this BatchMeasurement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchMeasurementCopyWith<BatchMeasurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchMeasurementCopyWith<$Res> {
  factory $BatchMeasurementCopyWith(
          BatchMeasurement value, $Res Function(BatchMeasurement) then) =
      _$BatchMeasurementCopyWithImpl<$Res, BatchMeasurement>;
  @useResult
  $Res call(
      {String id,
      String batchId,
      DateTime measurementDate,
      double averageWeight,
      int animalCount,
      String? notes,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      String status,
      String? batchName});
}

/// @nodoc
class _$BatchMeasurementCopyWithImpl<$Res, $Val extends BatchMeasurement>
    implements $BatchMeasurementCopyWith<$Res> {
  _$BatchMeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchId = null,
    Object? measurementDate = null,
    Object? averageWeight = null,
    Object? animalCount = null,
    Object? notes = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? batchName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      averageWeight: null == averageWeight
          ? _value.averageWeight
          : averageWeight // ignore: cast_nullable_to_non_nullable
              as double,
      animalCount: null == animalCount
          ? _value.animalCount
          : animalCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      batchName: freezed == batchName
          ? _value.batchName
          : batchName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchMeasurementImplCopyWith<$Res>
    implements $BatchMeasurementCopyWith<$Res> {
  factory _$$BatchMeasurementImplCopyWith(_$BatchMeasurementImpl value,
          $Res Function(_$BatchMeasurementImpl) then) =
      __$$BatchMeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String batchId,
      DateTime measurementDate,
      double averageWeight,
      int animalCount,
      String? notes,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      String status,
      String? batchName});
}

/// @nodoc
class __$$BatchMeasurementImplCopyWithImpl<$Res>
    extends _$BatchMeasurementCopyWithImpl<$Res, _$BatchMeasurementImpl>
    implements _$$BatchMeasurementImplCopyWith<$Res> {
  __$$BatchMeasurementImplCopyWithImpl(_$BatchMeasurementImpl _value,
      $Res Function(_$BatchMeasurementImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchId = null,
    Object? measurementDate = null,
    Object? averageWeight = null,
    Object? animalCount = null,
    Object? notes = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? batchName = freezed,
  }) {
    return _then(_$BatchMeasurementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      averageWeight: null == averageWeight
          ? _value.averageWeight
          : averageWeight // ignore: cast_nullable_to_non_nullable
              as double,
      animalCount: null == animalCount
          ? _value.animalCount
          : animalCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      batchName: freezed == batchName
          ? _value.batchName
          : batchName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchMeasurementImpl implements _BatchMeasurement {
  const _$BatchMeasurementImpl(
      {required this.id,
      required this.batchId,
      required this.measurementDate,
      required this.averageWeight,
      required this.animalCount,
      this.notes,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      this.status = 'active',
      this.batchName});

  factory _$BatchMeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchMeasurementImplFromJson(json);

  @override
  final String id;
  @override
  final String batchId;
  @override
  final DateTime measurementDate;
  @override
  final double averageWeight;
  @override
  final int animalCount;
  @override
  final String? notes;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final String status;
  @override
  final String? batchName;

  @override
  String toString() {
    return 'BatchMeasurement(id: $id, batchId: $batchId, measurementDate: $measurementDate, averageWeight: $averageWeight, animalCount: $animalCount, notes: $notes, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, batchName: $batchName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchMeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.measurementDate, measurementDate) ||
                other.measurementDate == measurementDate) &&
            (identical(other.averageWeight, averageWeight) ||
                other.averageWeight == averageWeight) &&
            (identical(other.animalCount, animalCount) ||
                other.animalCount == animalCount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.batchName, batchName) ||
                other.batchName == batchName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      batchId,
      measurementDate,
      averageWeight,
      animalCount,
      notes,
      createdBy,
      createdAt,
      updatedAt,
      status,
      batchName);

  /// Create a copy of BatchMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchMeasurementImplCopyWith<_$BatchMeasurementImpl> get copyWith =>
      __$$BatchMeasurementImplCopyWithImpl<_$BatchMeasurementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchMeasurementImplToJson(
      this,
    );
  }
}

abstract class _BatchMeasurement implements BatchMeasurement {
  const factory _BatchMeasurement(
      {required final String id,
      required final String batchId,
      required final DateTime measurementDate,
      required final double averageWeight,
      required final int animalCount,
      final String? notes,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String status,
      final String? batchName}) = _$BatchMeasurementImpl;

  factory _BatchMeasurement.fromJson(Map<String, dynamic> json) =
      _$BatchMeasurementImpl.fromJson;

  @override
  String get id;
  @override
  String get batchId;
  @override
  DateTime get measurementDate;
  @override
  double get averageWeight;
  @override
  int get animalCount;
  @override
  String? get notes;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get status;
  @override
  String? get batchName;

  /// Create a copy of BatchMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchMeasurementImplCopyWith<_$BatchMeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
