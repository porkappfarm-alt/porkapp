// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biometric_measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BiometricMeasurement _$BiometricMeasurementFromJson(Map<String, dynamic> json) {
  return _BiometricMeasurement.fromJson(json);
}

/// @nodoc
mixin _$BiometricMeasurement {
  /// Identificador único de la medición
  String get id => throw _privateConstructorUsedError;

  /// ID de la medición de lote a la que pertenece
  @JsonKey(name: 'biometric_id')
  String get batchMeasurementId => throw _privateConstructorUsedError;

  /// ID del animal medido
  @JsonKey(name: 'animal_id')
  String get animalId => throw _privateConstructorUsedError;

  /// Peso actual en kilogramos
  double get weight => throw _privateConstructorUsedError;

  /// Peso anterior en kilogramos
  @JsonKey(name: 'previous_weight')
  double? get previousWeight => throw _privateConstructorUsedError;

  /// Ganancia de peso desde la última medición
  @JsonKey(name: 'weight_gain')
  double? get weightGain => throw _privateConstructorUsedError;

  /// Días transcurridos desde la última medición
  @JsonKey(name: 'days_since_last')
  int? get daysSinceLast => throw _privateConstructorUsedError;

  /// Ganancia diaria promedio (kg/día)
  @JsonKey(name: 'adg')
  double? get averageDailyGain => throw _privateConstructorUsedError;

  /// Notas u observaciones sobre la medición
  String? get notes => throw _privateConstructorUsedError;

  /// Fecha y hora de la medición
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BiometricMeasurementCopyWith<BiometricMeasurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiometricMeasurementCopyWith<$Res> {
  factory $BiometricMeasurementCopyWith(BiometricMeasurement value,
          $Res Function(BiometricMeasurement) then) =
      _$BiometricMeasurementCopyWithImpl<$Res, BiometricMeasurement>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'biometric_id') String batchMeasurementId,
      @JsonKey(name: 'animal_id') String animalId,
      double weight,
      @JsonKey(name: 'previous_weight') double? previousWeight,
      @JsonKey(name: 'weight_gain') double? weightGain,
      @JsonKey(name: 'days_since_last') int? daysSinceLast,
      @JsonKey(name: 'adg') double? averageDailyGain,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$BiometricMeasurementCopyWithImpl<$Res,
        $Val extends BiometricMeasurement>
    implements $BiometricMeasurementCopyWith<$Res> {
  _$BiometricMeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    Object? averageDailyGain = freezed,
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
      averageDailyGain: freezed == averageDailyGain
          ? _value.averageDailyGain
          : averageDailyGain // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BiometricMeasurementImplCopyWith<$Res>
    implements $BiometricMeasurementCopyWith<$Res> {
  factory _$$BiometricMeasurementImplCopyWith(_$BiometricMeasurementImpl value,
          $Res Function(_$BiometricMeasurementImpl) then) =
      __$$BiometricMeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'biometric_id') String batchMeasurementId,
      @JsonKey(name: 'animal_id') String animalId,
      double weight,
      @JsonKey(name: 'previous_weight') double? previousWeight,
      @JsonKey(name: 'weight_gain') double? weightGain,
      @JsonKey(name: 'days_since_last') int? daysSinceLast,
      @JsonKey(name: 'adg') double? averageDailyGain,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$BiometricMeasurementImplCopyWithImpl<$Res>
    extends _$BiometricMeasurementCopyWithImpl<$Res, _$BiometricMeasurementImpl>
    implements _$$BiometricMeasurementImplCopyWith<$Res> {
  __$$BiometricMeasurementImplCopyWithImpl(_$BiometricMeasurementImpl _value,
      $Res Function(_$BiometricMeasurementImpl) _then)
      : super(_value, _then);

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
    Object? averageDailyGain = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BiometricMeasurementImpl(
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
      averageDailyGain: freezed == averageDailyGain
          ? _value.averageDailyGain
          : averageDailyGain // ignore: cast_nullable_to_non_nullable
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
class _$BiometricMeasurementImpl implements _BiometricMeasurement {
  const _$BiometricMeasurementImpl(
      {required this.id,
      @JsonKey(name: 'biometric_id') required this.batchMeasurementId,
      @JsonKey(name: 'animal_id') required this.animalId,
      required this.weight,
      @JsonKey(name: 'previous_weight') this.previousWeight,
      @JsonKey(name: 'weight_gain') this.weightGain,
      @JsonKey(name: 'days_since_last') this.daysSinceLast,
      @JsonKey(name: 'adg') this.averageDailyGain,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt})
      : assert(weight > 0, 'El peso debe ser mayor a 0'),
        assert(
            averageDailyGain == null ||
                (averageDailyGain >= 0 && averageDailyGain <= 2),
            'La ganancia diaria debe estar entre 0 y 2 kg/día');

  factory _$BiometricMeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$BiometricMeasurementImplFromJson(json);

  /// Identificador único de la medición
  @override
  final String id;

  /// ID de la medición de lote a la que pertenece
  @override
  @JsonKey(name: 'biometric_id')
  final String batchMeasurementId;

  /// ID del animal medido
  @override
  @JsonKey(name: 'animal_id')
  final String animalId;

  /// Peso actual en kilogramos
  @override
  final double weight;

  /// Peso anterior en kilogramos
  @override
  @JsonKey(name: 'previous_weight')
  final double? previousWeight;

  /// Ganancia de peso desde la última medición
  @override
  @JsonKey(name: 'weight_gain')
  final double? weightGain;

  /// Días transcurridos desde la última medición
  @override
  @JsonKey(name: 'days_since_last')
  final int? daysSinceLast;

  /// Ganancia diaria promedio (kg/día)
  @override
  @JsonKey(name: 'adg')
  final double? averageDailyGain;

  /// Notas u observaciones sobre la medición
  @override
  final String? notes;

  /// Fecha y hora de la medición
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'BiometricMeasurement(id: $id, batchMeasurementId: $batchMeasurementId, animalId: $animalId, weight: $weight, previousWeight: $previousWeight, weightGain: $weightGain, daysSinceLast: $daysSinceLast, averageDailyGain: $averageDailyGain, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiometricMeasurementImpl &&
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
            (identical(other.averageDailyGain, averageDailyGain) ||
                other.averageDailyGain == averageDailyGain) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      batchMeasurementId,
      animalId,
      weight,
      previousWeight,
      weightGain,
      daysSinceLast,
      averageDailyGain,
      notes,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BiometricMeasurementImplCopyWith<_$BiometricMeasurementImpl>
      get copyWith =>
          __$$BiometricMeasurementImplCopyWithImpl<_$BiometricMeasurementImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BiometricMeasurementImplToJson(
      this,
    );
  }
}

abstract class _BiometricMeasurement implements BiometricMeasurement {
  const factory _BiometricMeasurement(
      {required final String id,
      @JsonKey(name: 'biometric_id') required final String batchMeasurementId,
      @JsonKey(name: 'animal_id') required final String animalId,
      required final double weight,
      @JsonKey(name: 'previous_weight') final double? previousWeight,
      @JsonKey(name: 'weight_gain') final double? weightGain,
      @JsonKey(name: 'days_since_last') final int? daysSinceLast,
      @JsonKey(name: 'adg') final double? averageDailyGain,
      final String? notes,
      @JsonKey(name: 'created_at')
      required final DateTime createdAt}) = _$BiometricMeasurementImpl;

  factory _BiometricMeasurement.fromJson(Map<String, dynamic> json) =
      _$BiometricMeasurementImpl.fromJson;

  @override

  /// Identificador único de la medición
  String get id;
  @override

  /// ID de la medición de lote a la que pertenece
  @JsonKey(name: 'biometric_id')
  String get batchMeasurementId;
  @override

  /// ID del animal medido
  @JsonKey(name: 'animal_id')
  String get animalId;
  @override

  /// Peso actual en kilogramos
  double get weight;
  @override

  /// Peso anterior en kilogramos
  @JsonKey(name: 'previous_weight')
  double? get previousWeight;
  @override

  /// Ganancia de peso desde la última medición
  @JsonKey(name: 'weight_gain')
  double? get weightGain;
  @override

  /// Días transcurridos desde la última medición
  @JsonKey(name: 'days_since_last')
  int? get daysSinceLast;
  @override

  /// Ganancia diaria promedio (kg/día)
  @JsonKey(name: 'adg')
  double? get averageDailyGain;
  @override

  /// Notas u observaciones sobre la medición
  String? get notes;
  @override

  /// Fecha y hora de la medición
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BiometricMeasurementImplCopyWith<_$BiometricMeasurementImpl>
      get copyWith => throw _privateConstructorUsedError;
}
