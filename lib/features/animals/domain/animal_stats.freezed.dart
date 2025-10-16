// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnimalStats _$AnimalStatsFromJson(Map<String, dynamic> json) {
  return _AnimalStats.fromJson(json);
}

/// @nodoc
mixin _$AnimalStats {
// Ganancia de peso
  double get currentWeight => throw _privateConstructorUsedError;
  double get initialWeight => throw _privateConstructorUsedError;
  double? get lastWeightGain =>
      throw _privateConstructorUsedError; // kg/día desde última medición
  double get avgWeightGain =>
      throw _privateConstructorUsedError; // kg/día promedio total
// Edad
  DateTime get birthDate => throw _privateConstructorUsedError;
  int get ageInDays =>
      throw _privateConstructorUsedError; // Mortalidad (si aplica al lote)
  int? get initialCount => throw _privateConstructorUsedError;
  int? get currentCount => throw _privateConstructorUsedError;
  double? get mortalityRate => throw _privateConstructorUsedError; // Porcentaje
// Métricas adicionales
  double? get feedConversionRatio =>
      throw _privateConstructorUsedError; // kg alimento / kg ganancia
  double? get dailyFeedIntake => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnimalStatsCopyWith<AnimalStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalStatsCopyWith<$Res> {
  factory $AnimalStatsCopyWith(
          AnimalStats value, $Res Function(AnimalStats) then) =
      _$AnimalStatsCopyWithImpl<$Res, AnimalStats>;
  @useResult
  $Res call(
      {double currentWeight,
      double initialWeight,
      double? lastWeightGain,
      double avgWeightGain,
      DateTime birthDate,
      int ageInDays,
      int? initialCount,
      int? currentCount,
      double? mortalityRate,
      double? feedConversionRatio,
      double? dailyFeedIntake});
}

/// @nodoc
class _$AnimalStatsCopyWithImpl<$Res, $Val extends AnimalStats>
    implements $AnimalStatsCopyWith<$Res> {
  _$AnimalStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeight = null,
    Object? initialWeight = null,
    Object? lastWeightGain = freezed,
    Object? avgWeightGain = null,
    Object? birthDate = null,
    Object? ageInDays = null,
    Object? initialCount = freezed,
    Object? currentCount = freezed,
    Object? mortalityRate = freezed,
    Object? feedConversionRatio = freezed,
    Object? dailyFeedIntake = freezed,
  }) {
    return _then(_value.copyWith(
      currentWeight: null == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double,
      initialWeight: null == initialWeight
          ? _value.initialWeight
          : initialWeight // ignore: cast_nullable_to_non_nullable
              as double,
      lastWeightGain: freezed == lastWeightGain
          ? _value.lastWeightGain
          : lastWeightGain // ignore: cast_nullable_to_non_nullable
              as double?,
      avgWeightGain: null == avgWeightGain
          ? _value.avgWeightGain
          : avgWeightGain // ignore: cast_nullable_to_non_nullable
              as double,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInDays: null == ageInDays
          ? _value.ageInDays
          : ageInDays // ignore: cast_nullable_to_non_nullable
              as int,
      initialCount: freezed == initialCount
          ? _value.initialCount
          : initialCount // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCount: freezed == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int?,
      mortalityRate: freezed == mortalityRate
          ? _value.mortalityRate
          : mortalityRate // ignore: cast_nullable_to_non_nullable
              as double?,
      feedConversionRatio: freezed == feedConversionRatio
          ? _value.feedConversionRatio
          : feedConversionRatio // ignore: cast_nullable_to_non_nullable
              as double?,
      dailyFeedIntake: freezed == dailyFeedIntake
          ? _value.dailyFeedIntake
          : dailyFeedIntake // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnimalStatsImplCopyWith<$Res>
    implements $AnimalStatsCopyWith<$Res> {
  factory _$$AnimalStatsImplCopyWith(
          _$AnimalStatsImpl value, $Res Function(_$AnimalStatsImpl) then) =
      __$$AnimalStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentWeight,
      double initialWeight,
      double? lastWeightGain,
      double avgWeightGain,
      DateTime birthDate,
      int ageInDays,
      int? initialCount,
      int? currentCount,
      double? mortalityRate,
      double? feedConversionRatio,
      double? dailyFeedIntake});
}

/// @nodoc
class __$$AnimalStatsImplCopyWithImpl<$Res>
    extends _$AnimalStatsCopyWithImpl<$Res, _$AnimalStatsImpl>
    implements _$$AnimalStatsImplCopyWith<$Res> {
  __$$AnimalStatsImplCopyWithImpl(
      _$AnimalStatsImpl _value, $Res Function(_$AnimalStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeight = null,
    Object? initialWeight = null,
    Object? lastWeightGain = freezed,
    Object? avgWeightGain = null,
    Object? birthDate = null,
    Object? ageInDays = null,
    Object? initialCount = freezed,
    Object? currentCount = freezed,
    Object? mortalityRate = freezed,
    Object? feedConversionRatio = freezed,
    Object? dailyFeedIntake = freezed,
  }) {
    return _then(_$AnimalStatsImpl(
      currentWeight: null == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double,
      initialWeight: null == initialWeight
          ? _value.initialWeight
          : initialWeight // ignore: cast_nullable_to_non_nullable
              as double,
      lastWeightGain: freezed == lastWeightGain
          ? _value.lastWeightGain
          : lastWeightGain // ignore: cast_nullable_to_non_nullable
              as double?,
      avgWeightGain: null == avgWeightGain
          ? _value.avgWeightGain
          : avgWeightGain // ignore: cast_nullable_to_non_nullable
              as double,
      birthDate: null == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ageInDays: null == ageInDays
          ? _value.ageInDays
          : ageInDays // ignore: cast_nullable_to_non_nullable
              as int,
      initialCount: freezed == initialCount
          ? _value.initialCount
          : initialCount // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCount: freezed == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int?,
      mortalityRate: freezed == mortalityRate
          ? _value.mortalityRate
          : mortalityRate // ignore: cast_nullable_to_non_nullable
              as double?,
      feedConversionRatio: freezed == feedConversionRatio
          ? _value.feedConversionRatio
          : feedConversionRatio // ignore: cast_nullable_to_non_nullable
              as double?,
      dailyFeedIntake: freezed == dailyFeedIntake
          ? _value.dailyFeedIntake
          : dailyFeedIntake // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimalStatsImpl implements _AnimalStats {
  const _$AnimalStatsImpl(
      {required this.currentWeight,
      required this.initialWeight,
      this.lastWeightGain,
      required this.avgWeightGain,
      required this.birthDate,
      required this.ageInDays,
      this.initialCount,
      this.currentCount,
      this.mortalityRate,
      this.feedConversionRatio,
      this.dailyFeedIntake});

  factory _$AnimalStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalStatsImplFromJson(json);

// Ganancia de peso
  @override
  final double currentWeight;
  @override
  final double initialWeight;
  @override
  final double? lastWeightGain;
// kg/día desde última medición
  @override
  final double avgWeightGain;
// kg/día promedio total
// Edad
  @override
  final DateTime birthDate;
  @override
  final int ageInDays;
// Mortalidad (si aplica al lote)
  @override
  final int? initialCount;
  @override
  final int? currentCount;
  @override
  final double? mortalityRate;
// Porcentaje
// Métricas adicionales
  @override
  final double? feedConversionRatio;
// kg alimento / kg ganancia
  @override
  final double? dailyFeedIntake;

  @override
  String toString() {
    return 'AnimalStats(currentWeight: $currentWeight, initialWeight: $initialWeight, lastWeightGain: $lastWeightGain, avgWeightGain: $avgWeightGain, birthDate: $birthDate, ageInDays: $ageInDays, initialCount: $initialCount, currentCount: $currentCount, mortalityRate: $mortalityRate, feedConversionRatio: $feedConversionRatio, dailyFeedIntake: $dailyFeedIntake)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalStatsImpl &&
            (identical(other.currentWeight, currentWeight) ||
                other.currentWeight == currentWeight) &&
            (identical(other.initialWeight, initialWeight) ||
                other.initialWeight == initialWeight) &&
            (identical(other.lastWeightGain, lastWeightGain) ||
                other.lastWeightGain == lastWeightGain) &&
            (identical(other.avgWeightGain, avgWeightGain) ||
                other.avgWeightGain == avgWeightGain) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.ageInDays, ageInDays) ||
                other.ageInDays == ageInDays) &&
            (identical(other.initialCount, initialCount) ||
                other.initialCount == initialCount) &&
            (identical(other.currentCount, currentCount) ||
                other.currentCount == currentCount) &&
            (identical(other.mortalityRate, mortalityRate) ||
                other.mortalityRate == mortalityRate) &&
            (identical(other.feedConversionRatio, feedConversionRatio) ||
                other.feedConversionRatio == feedConversionRatio) &&
            (identical(other.dailyFeedIntake, dailyFeedIntake) ||
                other.dailyFeedIntake == dailyFeedIntake));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentWeight,
      initialWeight,
      lastWeightGain,
      avgWeightGain,
      birthDate,
      ageInDays,
      initialCount,
      currentCount,
      mortalityRate,
      feedConversionRatio,
      dailyFeedIntake);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalStatsImplCopyWith<_$AnimalStatsImpl> get copyWith =>
      __$$AnimalStatsImplCopyWithImpl<_$AnimalStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalStatsImplToJson(
      this,
    );
  }
}

abstract class _AnimalStats implements AnimalStats {
  const factory _AnimalStats(
      {required final double currentWeight,
      required final double initialWeight,
      final double? lastWeightGain,
      required final double avgWeightGain,
      required final DateTime birthDate,
      required final int ageInDays,
      final int? initialCount,
      final int? currentCount,
      final double? mortalityRate,
      final double? feedConversionRatio,
      final double? dailyFeedIntake}) = _$AnimalStatsImpl;

  factory _AnimalStats.fromJson(Map<String, dynamic> json) =
      _$AnimalStatsImpl.fromJson;

  @override // Ganancia de peso
  double get currentWeight;
  @override
  double get initialWeight;
  @override
  double? get lastWeightGain;
  @override // kg/día desde última medición
  double get avgWeightGain;
  @override // kg/día promedio total
// Edad
  DateTime get birthDate;
  @override
  int get ageInDays;
  @override // Mortalidad (si aplica al lote)
  int? get initialCount;
  @override
  int? get currentCount;
  @override
  double? get mortalityRate;
  @override // Porcentaje
// Métricas adicionales
  double? get feedConversionRatio;
  @override // kg alimento / kg ganancia
  double? get dailyFeedIntake;
  @override
  @JsonKey(ignore: true)
  _$$AnimalStatsImplCopyWith<_$AnimalStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
