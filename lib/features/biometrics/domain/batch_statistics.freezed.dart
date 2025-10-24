// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BatchStatistics _$BatchStatisticsFromJson(Map<String, dynamic> json) {
  return _BatchStatistics.fromJson(json);
}

/// @nodoc
mixin _$BatchStatistics {
  double get avgWeight => throw _privateConstructorUsedError;
  double get avgAdg => throw _privateConstructorUsedError;
  double get minWeight => throw _privateConstructorUsedError;
  double get maxWeight => throw _privateConstructorUsedError;
  double get weightStdDev => throw _privateConstructorUsedError;
  double get uniformityPercent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BatchStatisticsCopyWith<BatchStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchStatisticsCopyWith<$Res> {
  factory $BatchStatisticsCopyWith(
          BatchStatistics value, $Res Function(BatchStatistics) then) =
      _$BatchStatisticsCopyWithImpl<$Res, BatchStatistics>;
  @useResult
  $Res call(
      {double avgWeight,
      double avgAdg,
      double minWeight,
      double maxWeight,
      double weightStdDev,
      double uniformityPercent});
}

/// @nodoc
class _$BatchStatisticsCopyWithImpl<$Res, $Val extends BatchStatistics>
    implements $BatchStatisticsCopyWith<$Res> {
  _$BatchStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgWeight = null,
    Object? avgAdg = null,
    Object? minWeight = null,
    Object? maxWeight = null,
    Object? weightStdDev = null,
    Object? uniformityPercent = null,
  }) {
    return _then(_value.copyWith(
      avgWeight: null == avgWeight
          ? _value.avgWeight
          : avgWeight // ignore: cast_nullable_to_non_nullable
              as double,
      avgAdg: null == avgAdg
          ? _value.avgAdg
          : avgAdg // ignore: cast_nullable_to_non_nullable
              as double,
      minWeight: null == minWeight
          ? _value.minWeight
          : minWeight // ignore: cast_nullable_to_non_nullable
              as double,
      maxWeight: null == maxWeight
          ? _value.maxWeight
          : maxWeight // ignore: cast_nullable_to_non_nullable
              as double,
      weightStdDev: null == weightStdDev
          ? _value.weightStdDev
          : weightStdDev // ignore: cast_nullable_to_non_nullable
              as double,
      uniformityPercent: null == uniformityPercent
          ? _value.uniformityPercent
          : uniformityPercent // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchStatisticsImplCopyWith<$Res>
    implements $BatchStatisticsCopyWith<$Res> {
  factory _$$BatchStatisticsImplCopyWith(_$BatchStatisticsImpl value,
          $Res Function(_$BatchStatisticsImpl) then) =
      __$$BatchStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double avgWeight,
      double avgAdg,
      double minWeight,
      double maxWeight,
      double weightStdDev,
      double uniformityPercent});
}

/// @nodoc
class __$$BatchStatisticsImplCopyWithImpl<$Res>
    extends _$BatchStatisticsCopyWithImpl<$Res, _$BatchStatisticsImpl>
    implements _$$BatchStatisticsImplCopyWith<$Res> {
  __$$BatchStatisticsImplCopyWithImpl(
      _$BatchStatisticsImpl _value, $Res Function(_$BatchStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgWeight = null,
    Object? avgAdg = null,
    Object? minWeight = null,
    Object? maxWeight = null,
    Object? weightStdDev = null,
    Object? uniformityPercent = null,
  }) {
    return _then(_$BatchStatisticsImpl(
      avgWeight: null == avgWeight
          ? _value.avgWeight
          : avgWeight // ignore: cast_nullable_to_non_nullable
              as double,
      avgAdg: null == avgAdg
          ? _value.avgAdg
          : avgAdg // ignore: cast_nullable_to_non_nullable
              as double,
      minWeight: null == minWeight
          ? _value.minWeight
          : minWeight // ignore: cast_nullable_to_non_nullable
              as double,
      maxWeight: null == maxWeight
          ? _value.maxWeight
          : maxWeight // ignore: cast_nullable_to_non_nullable
              as double,
      weightStdDev: null == weightStdDev
          ? _value.weightStdDev
          : weightStdDev // ignore: cast_nullable_to_non_nullable
              as double,
      uniformityPercent: null == uniformityPercent
          ? _value.uniformityPercent
          : uniformityPercent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchStatisticsImpl implements _BatchStatistics {
  const _$BatchStatisticsImpl(
      {required this.avgWeight,
      required this.avgAdg,
      required this.minWeight,
      required this.maxWeight,
      required this.weightStdDev,
      required this.uniformityPercent});

  factory _$BatchStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchStatisticsImplFromJson(json);

  @override
  final double avgWeight;
  @override
  final double avgAdg;
  @override
  final double minWeight;
  @override
  final double maxWeight;
  @override
  final double weightStdDev;
  @override
  final double uniformityPercent;

  @override
  String toString() {
    return 'BatchStatistics(avgWeight: $avgWeight, avgAdg: $avgAdg, minWeight: $minWeight, maxWeight: $maxWeight, weightStdDev: $weightStdDev, uniformityPercent: $uniformityPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchStatisticsImpl &&
            (identical(other.avgWeight, avgWeight) ||
                other.avgWeight == avgWeight) &&
            (identical(other.avgAdg, avgAdg) || other.avgAdg == avgAdg) &&
            (identical(other.minWeight, minWeight) ||
                other.minWeight == minWeight) &&
            (identical(other.maxWeight, maxWeight) ||
                other.maxWeight == maxWeight) &&
            (identical(other.weightStdDev, weightStdDev) ||
                other.weightStdDev == weightStdDev) &&
            (identical(other.uniformityPercent, uniformityPercent) ||
                other.uniformityPercent == uniformityPercent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, avgWeight, avgAdg, minWeight,
      maxWeight, weightStdDev, uniformityPercent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchStatisticsImplCopyWith<_$BatchStatisticsImpl> get copyWith =>
      __$$BatchStatisticsImplCopyWithImpl<_$BatchStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchStatisticsImplToJson(
      this,
    );
  }
}

abstract class _BatchStatistics implements BatchStatistics {
  const factory _BatchStatistics(
      {required final double avgWeight,
      required final double avgAdg,
      required final double minWeight,
      required final double maxWeight,
      required final double weightStdDev,
      required final double uniformityPercent}) = _$BatchStatisticsImpl;

  factory _BatchStatistics.fromJson(Map<String, dynamic> json) =
      _$BatchStatisticsImpl.fromJson;

  @override
  double get avgWeight;
  @override
  double get avgAdg;
  @override
  double get minWeight;
  @override
  double get maxWeight;
  @override
  double get weightStdDev;
  @override
  double get uniformityPercent;
  @override
  @JsonKey(ignore: true)
  _$$BatchStatisticsImplCopyWith<_$BatchStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
