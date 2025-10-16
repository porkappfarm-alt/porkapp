// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biometric_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BiometricStats _$BiometricStatsFromJson(Map<String, dynamic> json) {
  return _BiometricStats.fromJson(json);
}

/// @nodoc
mixin _$BiometricStats {
  double get adg => throw _privateConstructorUsedError;
  double get fcr => throw _privateConstructorUsedError;
  double get mortalityRate => throw _privateConstructorUsedError;
  List<MortalityByCause> get mortalityByCause =>
      throw _privateConstructorUsedError;
  List<WeightPoint> get weightTimeline => throw _privateConstructorUsedError;

  /// Serializes this BiometricStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BiometricStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BiometricStatsCopyWith<BiometricStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiometricStatsCopyWith<$Res> {
  factory $BiometricStatsCopyWith(
          BiometricStats value, $Res Function(BiometricStats) then) =
      _$BiometricStatsCopyWithImpl<$Res, BiometricStats>;
  @useResult
  $Res call(
      {double adg,
      double fcr,
      double mortalityRate,
      List<MortalityByCause> mortalityByCause,
      List<WeightPoint> weightTimeline});
}

/// @nodoc
class _$BiometricStatsCopyWithImpl<$Res, $Val extends BiometricStats>
    implements $BiometricStatsCopyWith<$Res> {
  _$BiometricStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BiometricStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adg = null,
    Object? fcr = null,
    Object? mortalityRate = null,
    Object? mortalityByCause = null,
    Object? weightTimeline = null,
  }) {
    return _then(_value.copyWith(
      adg: null == adg
          ? _value.adg
          : adg // ignore: cast_nullable_to_non_nullable
              as double,
      fcr: null == fcr
          ? _value.fcr
          : fcr // ignore: cast_nullable_to_non_nullable
              as double,
      mortalityRate: null == mortalityRate
          ? _value.mortalityRate
          : mortalityRate // ignore: cast_nullable_to_non_nullable
              as double,
      mortalityByCause: null == mortalityByCause
          ? _value.mortalityByCause
          : mortalityByCause // ignore: cast_nullable_to_non_nullable
              as List<MortalityByCause>,
      weightTimeline: null == weightTimeline
          ? _value.weightTimeline
          : weightTimeline // ignore: cast_nullable_to_non_nullable
              as List<WeightPoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BiometricStatsImplCopyWith<$Res>
    implements $BiometricStatsCopyWith<$Res> {
  factory _$$BiometricStatsImplCopyWith(_$BiometricStatsImpl value,
          $Res Function(_$BiometricStatsImpl) then) =
      __$$BiometricStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double adg,
      double fcr,
      double mortalityRate,
      List<MortalityByCause> mortalityByCause,
      List<WeightPoint> weightTimeline});
}

/// @nodoc
class __$$BiometricStatsImplCopyWithImpl<$Res>
    extends _$BiometricStatsCopyWithImpl<$Res, _$BiometricStatsImpl>
    implements _$$BiometricStatsImplCopyWith<$Res> {
  __$$BiometricStatsImplCopyWithImpl(
      _$BiometricStatsImpl _value, $Res Function(_$BiometricStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BiometricStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adg = null,
    Object? fcr = null,
    Object? mortalityRate = null,
    Object? mortalityByCause = null,
    Object? weightTimeline = null,
  }) {
    return _then(_$BiometricStatsImpl(
      adg: null == adg
          ? _value.adg
          : adg // ignore: cast_nullable_to_non_nullable
              as double,
      fcr: null == fcr
          ? _value.fcr
          : fcr // ignore: cast_nullable_to_non_nullable
              as double,
      mortalityRate: null == mortalityRate
          ? _value.mortalityRate
          : mortalityRate // ignore: cast_nullable_to_non_nullable
              as double,
      mortalityByCause: null == mortalityByCause
          ? _value._mortalityByCause
          : mortalityByCause // ignore: cast_nullable_to_non_nullable
              as List<MortalityByCause>,
      weightTimeline: null == weightTimeline
          ? _value._weightTimeline
          : weightTimeline // ignore: cast_nullable_to_non_nullable
              as List<WeightPoint>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BiometricStatsImpl implements _BiometricStats {
  const _$BiometricStatsImpl(
      {required this.adg,
      required this.fcr,
      required this.mortalityRate,
      required final List<MortalityByCause> mortalityByCause,
      required final List<WeightPoint> weightTimeline})
      : _mortalityByCause = mortalityByCause,
        _weightTimeline = weightTimeline;

  factory _$BiometricStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BiometricStatsImplFromJson(json);

  @override
  final double adg;
  @override
  final double fcr;
  @override
  final double mortalityRate;
  final List<MortalityByCause> _mortalityByCause;
  @override
  List<MortalityByCause> get mortalityByCause {
    if (_mortalityByCause is EqualUnmodifiableListView)
      return _mortalityByCause;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mortalityByCause);
  }

  final List<WeightPoint> _weightTimeline;
  @override
  List<WeightPoint> get weightTimeline {
    if (_weightTimeline is EqualUnmodifiableListView) return _weightTimeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weightTimeline);
  }

  @override
  String toString() {
    return 'BiometricStats(adg: $adg, fcr: $fcr, mortalityRate: $mortalityRate, mortalityByCause: $mortalityByCause, weightTimeline: $weightTimeline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiometricStatsImpl &&
            (identical(other.adg, adg) || other.adg == adg) &&
            (identical(other.fcr, fcr) || other.fcr == fcr) &&
            (identical(other.mortalityRate, mortalityRate) ||
                other.mortalityRate == mortalityRate) &&
            const DeepCollectionEquality()
                .equals(other._mortalityByCause, _mortalityByCause) &&
            const DeepCollectionEquality()
                .equals(other._weightTimeline, _weightTimeline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      adg,
      fcr,
      mortalityRate,
      const DeepCollectionEquality().hash(_mortalityByCause),
      const DeepCollectionEquality().hash(_weightTimeline));

  /// Create a copy of BiometricStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BiometricStatsImplCopyWith<_$BiometricStatsImpl> get copyWith =>
      __$$BiometricStatsImplCopyWithImpl<_$BiometricStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BiometricStatsImplToJson(
      this,
    );
  }
}

abstract class _BiometricStats implements BiometricStats {
  const factory _BiometricStats(
      {required final double adg,
      required final double fcr,
      required final double mortalityRate,
      required final List<MortalityByCause> mortalityByCause,
      required final List<WeightPoint> weightTimeline}) = _$BiometricStatsImpl;

  factory _BiometricStats.fromJson(Map<String, dynamic> json) =
      _$BiometricStatsImpl.fromJson;

  @override
  double get adg;
  @override
  double get fcr;
  @override
  double get mortalityRate;
  @override
  List<MortalityByCause> get mortalityByCause;
  @override
  List<WeightPoint> get weightTimeline;

  /// Create a copy of BiometricStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BiometricStatsImplCopyWith<_$BiometricStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MortalityByCause _$MortalityByCauseFromJson(Map<String, dynamic> json) {
  return _MortalityByCause.fromJson(json);
}

/// @nodoc
mixin _$MortalityByCause {
  String get cause => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this MortalityByCause to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MortalityByCause
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MortalityByCauseCopyWith<MortalityByCause> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MortalityByCauseCopyWith<$Res> {
  factory $MortalityByCauseCopyWith(
          MortalityByCause value, $Res Function(MortalityByCause) then) =
      _$MortalityByCauseCopyWithImpl<$Res, MortalityByCause>;
  @useResult
  $Res call({String cause, int count});
}

/// @nodoc
class _$MortalityByCauseCopyWithImpl<$Res, $Val extends MortalityByCause>
    implements $MortalityByCauseCopyWith<$Res> {
  _$MortalityByCauseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MortalityByCause
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cause = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      cause: null == cause
          ? _value.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MortalityByCauseImplCopyWith<$Res>
    implements $MortalityByCauseCopyWith<$Res> {
  factory _$$MortalityByCauseImplCopyWith(_$MortalityByCauseImpl value,
          $Res Function(_$MortalityByCauseImpl) then) =
      __$$MortalityByCauseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cause, int count});
}

/// @nodoc
class __$$MortalityByCauseImplCopyWithImpl<$Res>
    extends _$MortalityByCauseCopyWithImpl<$Res, _$MortalityByCauseImpl>
    implements _$$MortalityByCauseImplCopyWith<$Res> {
  __$$MortalityByCauseImplCopyWithImpl(_$MortalityByCauseImpl _value,
      $Res Function(_$MortalityByCauseImpl) _then)
      : super(_value, _then);

  /// Create a copy of MortalityByCause
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cause = null,
    Object? count = null,
  }) {
    return _then(_$MortalityByCauseImpl(
      cause: null == cause
          ? _value.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MortalityByCauseImpl implements _MortalityByCause {
  const _$MortalityByCauseImpl({required this.cause, required this.count});

  factory _$MortalityByCauseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MortalityByCauseImplFromJson(json);

  @override
  final String cause;
  @override
  final int count;

  @override
  String toString() {
    return 'MortalityByCause(cause: $cause, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MortalityByCauseImpl &&
            (identical(other.cause, cause) || other.cause == cause) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cause, count);

  /// Create a copy of MortalityByCause
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MortalityByCauseImplCopyWith<_$MortalityByCauseImpl> get copyWith =>
      __$$MortalityByCauseImplCopyWithImpl<_$MortalityByCauseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MortalityByCauseImplToJson(
      this,
    );
  }
}

abstract class _MortalityByCause implements MortalityByCause {
  const factory _MortalityByCause(
      {required final String cause,
      required final int count}) = _$MortalityByCauseImpl;

  factory _MortalityByCause.fromJson(Map<String, dynamic> json) =
      _$MortalityByCauseImpl.fromJson;

  @override
  String get cause;
  @override
  int get count;

  /// Create a copy of MortalityByCause
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MortalityByCauseImplCopyWith<_$MortalityByCauseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeightPoint _$WeightPointFromJson(Map<String, dynamic> json) {
  return _WeightPoint.fromJson(json);
}

/// @nodoc
mixin _$WeightPoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get avgWeight => throw _privateConstructorUsedError;

  /// Serializes this WeightPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightPointCopyWith<WeightPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightPointCopyWith<$Res> {
  factory $WeightPointCopyWith(
          WeightPoint value, $Res Function(WeightPoint) then) =
      _$WeightPointCopyWithImpl<$Res, WeightPoint>;
  @useResult
  $Res call({DateTime date, double avgWeight});
}

/// @nodoc
class _$WeightPointCopyWithImpl<$Res, $Val extends WeightPoint>
    implements $WeightPointCopyWith<$Res> {
  _$WeightPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? avgWeight = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avgWeight: null == avgWeight
          ? _value.avgWeight
          : avgWeight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeightPointImplCopyWith<$Res>
    implements $WeightPointCopyWith<$Res> {
  factory _$$WeightPointImplCopyWith(
          _$WeightPointImpl value, $Res Function(_$WeightPointImpl) then) =
      __$$WeightPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double avgWeight});
}

/// @nodoc
class __$$WeightPointImplCopyWithImpl<$Res>
    extends _$WeightPointCopyWithImpl<$Res, _$WeightPointImpl>
    implements _$$WeightPointImplCopyWith<$Res> {
  __$$WeightPointImplCopyWithImpl(
      _$WeightPointImpl _value, $Res Function(_$WeightPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeightPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? avgWeight = null,
  }) {
    return _then(_$WeightPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avgWeight: null == avgWeight
          ? _value.avgWeight
          : avgWeight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightPointImpl implements _WeightPoint {
  const _$WeightPointImpl({required this.date, required this.avgWeight});

  factory _$WeightPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightPointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double avgWeight;

  @override
  String toString() {
    return 'WeightPoint(date: $date, avgWeight: $avgWeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.avgWeight, avgWeight) ||
                other.avgWeight == avgWeight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, avgWeight);

  /// Create a copy of WeightPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightPointImplCopyWith<_$WeightPointImpl> get copyWith =>
      __$$WeightPointImplCopyWithImpl<_$WeightPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightPointImplToJson(
      this,
    );
  }
}

abstract class _WeightPoint implements WeightPoint {
  const factory _WeightPoint(
      {required final DateTime date,
      required final double avgWeight}) = _$WeightPointImpl;

  factory _WeightPoint.fromJson(Map<String, dynamic> json) =
      _$WeightPointImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get avgWeight;

  /// Create a copy of WeightPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightPointImplCopyWith<_$WeightPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
