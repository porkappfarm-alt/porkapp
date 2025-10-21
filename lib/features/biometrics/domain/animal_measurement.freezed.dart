// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal_measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnimalMeasurement _$AnimalMeasurementFromJson(Map<String, dynamic> json) {
  return _AnimalMeasurement.fromJson(json);
}

/// @nodoc
mixin _$AnimalMeasurement {
  String get id => throw _privateConstructorUsedError;
  String get batchMeasurementId => throw _privateConstructorUsedError;
  String get animalId => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double? get previousWeight => throw _privateConstructorUsedError;
  double? get weightGain => throw _privateConstructorUsedError;
  int? get daysSinceLast => throw _privateConstructorUsedError;
  double? get adg => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AnimalMeasurement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnimalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnimalMeasurementCopyWith<AnimalMeasurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalMeasurementCopyWith<$Res> {
  factory $AnimalMeasurementCopyWith(
          AnimalMeasurement value, $Res Function(AnimalMeasurement) then) =
      _$AnimalMeasurementCopyWithImpl<$Res, AnimalMeasurement>;
  @useResult
  $Res call(
      {String id,
      String batchMeasurementId,
      String animalId,
      double weight,
      double? previousWeight,
      double? weightGain,
      int? daysSinceLast,
      double? adg,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class _$AnimalMeasurementCopyWithImpl<$Res, $Val extends AnimalMeasurement>
    implements $AnimalMeasurementCopyWith<$Res> {
  _$AnimalMeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchMeasurementId = null,
    Object? animalId = null,
    Object? weight = null,
    Object? previousWeight = freezed,
    Object? weightGain = freezed,
    Object? daysSinceLast = freezed,
    Object? adg = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      batchMeasurementId: null == batchMeasurementId
          ? _value.batchMeasurementId
          : batchMeasurementId // ignore: cast_nullable_to_non_nullable
              as String,
      animalId: null == animalId
          ? _value.animalId
          : animalId // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      previousWeight: freezed == previousWeight
          ? _value.previousWeight
          : previousWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      weightGain: freezed == weightGain
          ? _value.weightGain
          : weightGain // ignore: cast_nullable_to_non_nullable
              as double?,
      daysSinceLast: freezed == daysSinceLast
          ? _value.daysSinceLast
          : daysSinceLast // ignore: cast_nullable_to_non_nullable
              as int?,
      adg: freezed == adg
          ? _value.adg
          : adg // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnimalMeasurementImplCopyWith<$Res>
    implements $AnimalMeasurementCopyWith<$Res> {
  factory _$$AnimalMeasurementImplCopyWith(_$AnimalMeasurementImpl value,
          $Res Function(_$AnimalMeasurementImpl) then) =
      __$$AnimalMeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String batchMeasurementId,
      String animalId,
      double weight,
      double? previousWeight,
      double? weightGain,
      int? daysSinceLast,
      double? adg,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class __$$AnimalMeasurementImplCopyWithImpl<$Res>
    extends _$AnimalMeasurementCopyWithImpl<$Res, _$AnimalMeasurementImpl>
    implements _$$AnimalMeasurementImplCopyWith<$Res> {
  __$$AnimalMeasurementImplCopyWithImpl(_$AnimalMeasurementImpl _value,
      $Res Function(_$AnimalMeasurementImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchMeasurementId = null,
    Object? animalId = null,
    Object? weight = null,
    Object? previousWeight = freezed,
    Object? weightGain = freezed,
    Object? daysSinceLast = freezed,
    Object? adg = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$AnimalMeasurementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      batchMeasurementId: null == batchMeasurementId
          ? _value.batchMeasurementId
          : batchMeasurementId // ignore: cast_nullable_to_non_nullable
              as String,
      animalId: null == animalId
          ? _value.animalId
          : animalId // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      previousWeight: freezed == previousWeight
          ? _value.previousWeight
          : previousWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      weightGain: freezed == weightGain
          ? _value.weightGain
          : weightGain // ignore: cast_nullable_to_non_nullable
              as double?,
      daysSinceLast: freezed == daysSinceLast
          ? _value.daysSinceLast
          : daysSinceLast // ignore: cast_nullable_to_non_nullable
              as int?,
      adg: freezed == adg
          ? _value.adg
          : adg // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimalMeasurementImpl implements _AnimalMeasurement {
  const _$AnimalMeasurementImpl(
      {required this.id,
      required this.batchMeasurementId,
      required this.animalId,
      required this.weight,
      this.previousWeight,
      this.weightGain,
      this.daysSinceLast,
      this.adg,
      this.notes,
      required this.createdAt});

  factory _$AnimalMeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalMeasurementImplFromJson(json);

  @override
  final String id;
  @override
  final String batchMeasurementId;
  @override
  final String animalId;
  @override
  final double weight;
  @override
  final double? previousWeight;
  @override
  final double? weightGain;
  @override
  final int? daysSinceLast;
  @override
  final double? adg;
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AnimalMeasurement(id: $id, batchMeasurementId: $batchMeasurementId, animalId: $animalId, weight: $weight, previousWeight: $previousWeight, weightGain: $weightGain, daysSinceLast: $daysSinceLast, adg: $adg, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalMeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.batchMeasurementId, batchMeasurementId) ||
                other.batchMeasurementId == batchMeasurementId) &&
            (identical(other.animalId, animalId) ||
                other.animalId == animalId) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.previousWeight, previousWeight) ||
                other.previousWeight == previousWeight) &&
            (identical(other.weightGain, weightGain) ||
                other.weightGain == weightGain) &&
            (identical(other.daysSinceLast, daysSinceLast) ||
                other.daysSinceLast == daysSinceLast) &&
            (identical(other.adg, adg) || other.adg == adg) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, batchMeasurementId, animalId,
      weight, previousWeight, weightGain, daysSinceLast, adg, notes, createdAt);

  /// Create a copy of AnimalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalMeasurementImplCopyWith<_$AnimalMeasurementImpl> get copyWith =>
      __$$AnimalMeasurementImplCopyWithImpl<_$AnimalMeasurementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalMeasurementImplToJson(
      this,
    );
  }
}

abstract class _AnimalMeasurement implements AnimalMeasurement {
  const factory _AnimalMeasurement(
      {required final String id,
      required final String batchMeasurementId,
      required final String animalId,
      required final double weight,
      final double? previousWeight,
      final double? weightGain,
      final int? daysSinceLast,
      final double? adg,
      final String? notes,
      required final DateTime createdAt}) = _$AnimalMeasurementImpl;

  factory _AnimalMeasurement.fromJson(Map<String, dynamic> json) =
      _$AnimalMeasurementImpl.fromJson;

  @override
  String get id;
  @override
  String get batchMeasurementId;
  @override
  String get animalId;
  @override
  double get weight;
  @override
  double? get previousWeight;
  @override
  double? get weightGain;
  @override
  int? get daysSinceLast;
  @override
  double? get adg;
  @override
  String? get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of AnimalMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnimalMeasurementImplCopyWith<_$AnimalMeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
