// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnimalFilters _$AnimalFiltersFromJson(Map<String, dynamic> json) {
  return _AnimalFilters.fromJson(json);
}

/// @nodoc
mixin _$AnimalFilters {
// Tipo de animal
  @AnimalTypeConverter()
  AnimalType? get type =>
      throw _privateConstructorUsedError; // Estado del animal
  @AnimalStatusConverter()
  AnimalStatus? get status =>
      throw _privateConstructorUsedError; // Rango de fechas
  DateTime? get dateFrom => throw _privateConstructorUsedError;
  DateTime? get dateTo =>
      throw _privateConstructorUsedError; // Filtros adicionales
  String? get batchId => throw _privateConstructorUsedError;
  String? get corralId => throw _privateConstructorUsedError;
  double? get minWeight => throw _privateConstructorUsedError;
  double? get maxWeight => throw _privateConstructorUsedError;
  bool? get isMale => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Serializes this AnimalFilters to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnimalFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnimalFiltersCopyWith<AnimalFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalFiltersCopyWith<$Res> {
  factory $AnimalFiltersCopyWith(
          AnimalFilters value, $Res Function(AnimalFilters) then) =
      _$AnimalFiltersCopyWithImpl<$Res, AnimalFilters>;
  @useResult
  $Res call(
      {@AnimalTypeConverter() AnimalType? type,
      @AnimalStatusConverter() AnimalStatus? status,
      DateTime? dateFrom,
      DateTime? dateTo,
      String? batchId,
      String? corralId,
      double? minWeight,
      double? maxWeight,
      bool? isMale,
      String? searchQuery});

  $AnimalTypeCopyWith<$Res>? get type;
  $AnimalStatusCopyWith<$Res>? get status;
}

/// @nodoc
class _$AnimalFiltersCopyWithImpl<$Res, $Val extends AnimalFilters>
    implements $AnimalFiltersCopyWith<$Res> {
  _$AnimalFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimalFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? status = freezed,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? batchId = freezed,
    Object? corralId = freezed,
    Object? minWeight = freezed,
    Object? maxWeight = freezed,
    Object? isMale = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AnimalType?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AnimalStatus?,
      dateFrom: freezed == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      batchId: freezed == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String?,
      corralId: freezed == corralId
          ? _value.corralId
          : corralId // ignore: cast_nullable_to_non_nullable
              as String?,
      minWeight: freezed == minWeight
          ? _value.minWeight
          : minWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      maxWeight: freezed == maxWeight
          ? _value.maxWeight
          : maxWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      isMale: freezed == isMale
          ? _value.isMale
          : isMale // ignore: cast_nullable_to_non_nullable
              as bool?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AnimalFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnimalTypeCopyWith<$Res>? get type {
    if (_value.type == null) {
      return null;
    }

    return $AnimalTypeCopyWith<$Res>(_value.type!, (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }

  /// Create a copy of AnimalFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnimalStatusCopyWith<$Res>? get status {
    if (_value.status == null) {
      return null;
    }

    return $AnimalStatusCopyWith<$Res>(_value.status!, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnimalFiltersImplCopyWith<$Res>
    implements $AnimalFiltersCopyWith<$Res> {
  factory _$$AnimalFiltersImplCopyWith(
          _$AnimalFiltersImpl value, $Res Function(_$AnimalFiltersImpl) then) =
      __$$AnimalFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@AnimalTypeConverter() AnimalType? type,
      @AnimalStatusConverter() AnimalStatus? status,
      DateTime? dateFrom,
      DateTime? dateTo,
      String? batchId,
      String? corralId,
      double? minWeight,
      double? maxWeight,
      bool? isMale,
      String? searchQuery});

  @override
  $AnimalTypeCopyWith<$Res>? get type;
  @override
  $AnimalStatusCopyWith<$Res>? get status;
}

/// @nodoc
class __$$AnimalFiltersImplCopyWithImpl<$Res>
    extends _$AnimalFiltersCopyWithImpl<$Res, _$AnimalFiltersImpl>
    implements _$$AnimalFiltersImplCopyWith<$Res> {
  __$$AnimalFiltersImplCopyWithImpl(
      _$AnimalFiltersImpl _value, $Res Function(_$AnimalFiltersImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? status = freezed,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? batchId = freezed,
    Object? corralId = freezed,
    Object? minWeight = freezed,
    Object? maxWeight = freezed,
    Object? isMale = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_$AnimalFiltersImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AnimalType?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AnimalStatus?,
      dateFrom: freezed == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      batchId: freezed == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String?,
      corralId: freezed == corralId
          ? _value.corralId
          : corralId // ignore: cast_nullable_to_non_nullable
              as String?,
      minWeight: freezed == minWeight
          ? _value.minWeight
          : minWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      maxWeight: freezed == maxWeight
          ? _value.maxWeight
          : maxWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      isMale: freezed == isMale
          ? _value.isMale
          : isMale // ignore: cast_nullable_to_non_nullable
              as bool?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimalFiltersImpl implements _AnimalFilters {
  const _$AnimalFiltersImpl(
      {@AnimalTypeConverter() this.type,
      @AnimalStatusConverter() this.status,
      this.dateFrom,
      this.dateTo,
      this.batchId,
      this.corralId,
      this.minWeight,
      this.maxWeight,
      this.isMale,
      this.searchQuery});

  factory _$AnimalFiltersImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalFiltersImplFromJson(json);

// Tipo de animal
  @override
  @AnimalTypeConverter()
  final AnimalType? type;
// Estado del animal
  @override
  @AnimalStatusConverter()
  final AnimalStatus? status;
// Rango de fechas
  @override
  final DateTime? dateFrom;
  @override
  final DateTime? dateTo;
// Filtros adicionales
  @override
  final String? batchId;
  @override
  final String? corralId;
  @override
  final double? minWeight;
  @override
  final double? maxWeight;
  @override
  final bool? isMale;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'AnimalFilters(type: $type, status: $status, dateFrom: $dateFrom, dateTo: $dateTo, batchId: $batchId, corralId: $corralId, minWeight: $minWeight, maxWeight: $maxWeight, isMale: $isMale, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalFiltersImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateFrom, dateFrom) ||
                other.dateFrom == dateFrom) &&
            (identical(other.dateTo, dateTo) || other.dateTo == dateTo) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.corralId, corralId) ||
                other.corralId == corralId) &&
            (identical(other.minWeight, minWeight) ||
                other.minWeight == minWeight) &&
            (identical(other.maxWeight, maxWeight) ||
                other.maxWeight == maxWeight) &&
            (identical(other.isMale, isMale) || other.isMale == isMale) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, status, dateFrom, dateTo,
      batchId, corralId, minWeight, maxWeight, isMale, searchQuery);

  /// Create a copy of AnimalFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalFiltersImplCopyWith<_$AnimalFiltersImpl> get copyWith =>
      __$$AnimalFiltersImplCopyWithImpl<_$AnimalFiltersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalFiltersImplToJson(
      this,
    );
  }
}

abstract class _AnimalFilters implements AnimalFilters {
  const factory _AnimalFilters(
      {@AnimalTypeConverter() final AnimalType? type,
      @AnimalStatusConverter() final AnimalStatus? status,
      final DateTime? dateFrom,
      final DateTime? dateTo,
      final String? batchId,
      final String? corralId,
      final double? minWeight,
      final double? maxWeight,
      final bool? isMale,
      final String? searchQuery}) = _$AnimalFiltersImpl;

  factory _AnimalFilters.fromJson(Map<String, dynamic> json) =
      _$AnimalFiltersImpl.fromJson;

// Tipo de animal
  @override
  @AnimalTypeConverter()
  AnimalType? get type; // Estado del animal
  @override
  @AnimalStatusConverter()
  AnimalStatus? get status; // Rango de fechas
  @override
  DateTime? get dateFrom;
  @override
  DateTime? get dateTo; // Filtros adicionales
  @override
  String? get batchId;
  @override
  String? get corralId;
  @override
  double? get minWeight;
  @override
  double? get maxWeight;
  @override
  bool? get isMale;
  @override
  String? get searchQuery;

  /// Create a copy of AnimalFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnimalFiltersImplCopyWith<_$AnimalFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AnimalType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() piglet,
    required TResult Function() sow,
    required TResult Function() boar,
    required TResult Function() fattening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? piglet,
    TResult? Function()? sow,
    TResult? Function()? boar,
    TResult? Function()? fattening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? piglet,
    TResult Function()? sow,
    TResult Function()? boar,
    TResult Function()? fattening,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalTypePiglet value) piglet,
    required TResult Function(AnimalTypeSow value) sow,
    required TResult Function(AnimalTypeBoar value) boar,
    required TResult Function(AnimalTypeFattening value) fattening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalTypePiglet value)? piglet,
    TResult? Function(AnimalTypeSow value)? sow,
    TResult? Function(AnimalTypeBoar value)? boar,
    TResult? Function(AnimalTypeFattening value)? fattening,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalTypePiglet value)? piglet,
    TResult Function(AnimalTypeSow value)? sow,
    TResult Function(AnimalTypeBoar value)? boar,
    TResult Function(AnimalTypeFattening value)? fattening,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalTypeCopyWith<$Res> {
  factory $AnimalTypeCopyWith(
          AnimalType value, $Res Function(AnimalType) then) =
      _$AnimalTypeCopyWithImpl<$Res, AnimalType>;
}

/// @nodoc
class _$AnimalTypeCopyWithImpl<$Res, $Val extends AnimalType>
    implements $AnimalTypeCopyWith<$Res> {
  _$AnimalTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimalType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AnimalTypePigletImplCopyWith<$Res> {
  factory _$$AnimalTypePigletImplCopyWith(_$AnimalTypePigletImpl value,
          $Res Function(_$AnimalTypePigletImpl) then) =
      __$$AnimalTypePigletImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalTypePigletImplCopyWithImpl<$Res>
    extends _$AnimalTypeCopyWithImpl<$Res, _$AnimalTypePigletImpl>
    implements _$$AnimalTypePigletImplCopyWith<$Res> {
  __$$AnimalTypePigletImplCopyWithImpl(_$AnimalTypePigletImpl _value,
      $Res Function(_$AnimalTypePigletImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalTypePigletImpl implements AnimalTypePiglet {
  const _$AnimalTypePigletImpl();

  @override
  String toString() {
    return 'AnimalType.piglet()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AnimalTypePigletImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() piglet,
    required TResult Function() sow,
    required TResult Function() boar,
    required TResult Function() fattening,
  }) {
    return piglet();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? piglet,
    TResult? Function()? sow,
    TResult? Function()? boar,
    TResult? Function()? fattening,
  }) {
    return piglet?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? piglet,
    TResult Function()? sow,
    TResult Function()? boar,
    TResult Function()? fattening,
    required TResult orElse(),
  }) {
    if (piglet != null) {
      return piglet();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalTypePiglet value) piglet,
    required TResult Function(AnimalTypeSow value) sow,
    required TResult Function(AnimalTypeBoar value) boar,
    required TResult Function(AnimalTypeFattening value) fattening,
  }) {
    return piglet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalTypePiglet value)? piglet,
    TResult? Function(AnimalTypeSow value)? sow,
    TResult? Function(AnimalTypeBoar value)? boar,
    TResult? Function(AnimalTypeFattening value)? fattening,
  }) {
    return piglet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalTypePiglet value)? piglet,
    TResult Function(AnimalTypeSow value)? sow,
    TResult Function(AnimalTypeBoar value)? boar,
    TResult Function(AnimalTypeFattening value)? fattening,
    required TResult orElse(),
  }) {
    if (piglet != null) {
      return piglet(this);
    }
    return orElse();
  }
}

abstract class AnimalTypePiglet implements AnimalType {
  const factory AnimalTypePiglet() = _$AnimalTypePigletImpl;
}

/// @nodoc
abstract class _$$AnimalTypeSowImplCopyWith<$Res> {
  factory _$$AnimalTypeSowImplCopyWith(
          _$AnimalTypeSowImpl value, $Res Function(_$AnimalTypeSowImpl) then) =
      __$$AnimalTypeSowImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalTypeSowImplCopyWithImpl<$Res>
    extends _$AnimalTypeCopyWithImpl<$Res, _$AnimalTypeSowImpl>
    implements _$$AnimalTypeSowImplCopyWith<$Res> {
  __$$AnimalTypeSowImplCopyWithImpl(
      _$AnimalTypeSowImpl _value, $Res Function(_$AnimalTypeSowImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalTypeSowImpl implements AnimalTypeSow {
  const _$AnimalTypeSowImpl();

  @override
  String toString() {
    return 'AnimalType.sow()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AnimalTypeSowImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() piglet,
    required TResult Function() sow,
    required TResult Function() boar,
    required TResult Function() fattening,
  }) {
    return sow();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? piglet,
    TResult? Function()? sow,
    TResult? Function()? boar,
    TResult? Function()? fattening,
  }) {
    return sow?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? piglet,
    TResult Function()? sow,
    TResult Function()? boar,
    TResult Function()? fattening,
    required TResult orElse(),
  }) {
    if (sow != null) {
      return sow();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalTypePiglet value) piglet,
    required TResult Function(AnimalTypeSow value) sow,
    required TResult Function(AnimalTypeBoar value) boar,
    required TResult Function(AnimalTypeFattening value) fattening,
  }) {
    return sow(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalTypePiglet value)? piglet,
    TResult? Function(AnimalTypeSow value)? sow,
    TResult? Function(AnimalTypeBoar value)? boar,
    TResult? Function(AnimalTypeFattening value)? fattening,
  }) {
    return sow?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalTypePiglet value)? piglet,
    TResult Function(AnimalTypeSow value)? sow,
    TResult Function(AnimalTypeBoar value)? boar,
    TResult Function(AnimalTypeFattening value)? fattening,
    required TResult orElse(),
  }) {
    if (sow != null) {
      return sow(this);
    }
    return orElse();
  }
}

abstract class AnimalTypeSow implements AnimalType {
  const factory AnimalTypeSow() = _$AnimalTypeSowImpl;
}

/// @nodoc
abstract class _$$AnimalTypeBoarImplCopyWith<$Res> {
  factory _$$AnimalTypeBoarImplCopyWith(_$AnimalTypeBoarImpl value,
          $Res Function(_$AnimalTypeBoarImpl) then) =
      __$$AnimalTypeBoarImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalTypeBoarImplCopyWithImpl<$Res>
    extends _$AnimalTypeCopyWithImpl<$Res, _$AnimalTypeBoarImpl>
    implements _$$AnimalTypeBoarImplCopyWith<$Res> {
  __$$AnimalTypeBoarImplCopyWithImpl(
      _$AnimalTypeBoarImpl _value, $Res Function(_$AnimalTypeBoarImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalTypeBoarImpl implements AnimalTypeBoar {
  const _$AnimalTypeBoarImpl();

  @override
  String toString() {
    return 'AnimalType.boar()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AnimalTypeBoarImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() piglet,
    required TResult Function() sow,
    required TResult Function() boar,
    required TResult Function() fattening,
  }) {
    return boar();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? piglet,
    TResult? Function()? sow,
    TResult? Function()? boar,
    TResult? Function()? fattening,
  }) {
    return boar?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? piglet,
    TResult Function()? sow,
    TResult Function()? boar,
    TResult Function()? fattening,
    required TResult orElse(),
  }) {
    if (boar != null) {
      return boar();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalTypePiglet value) piglet,
    required TResult Function(AnimalTypeSow value) sow,
    required TResult Function(AnimalTypeBoar value) boar,
    required TResult Function(AnimalTypeFattening value) fattening,
  }) {
    return boar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalTypePiglet value)? piglet,
    TResult? Function(AnimalTypeSow value)? sow,
    TResult? Function(AnimalTypeBoar value)? boar,
    TResult? Function(AnimalTypeFattening value)? fattening,
  }) {
    return boar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalTypePiglet value)? piglet,
    TResult Function(AnimalTypeSow value)? sow,
    TResult Function(AnimalTypeBoar value)? boar,
    TResult Function(AnimalTypeFattening value)? fattening,
    required TResult orElse(),
  }) {
    if (boar != null) {
      return boar(this);
    }
    return orElse();
  }
}

abstract class AnimalTypeBoar implements AnimalType {
  const factory AnimalTypeBoar() = _$AnimalTypeBoarImpl;
}

/// @nodoc
abstract class _$$AnimalTypeFatteningImplCopyWith<$Res> {
  factory _$$AnimalTypeFatteningImplCopyWith(_$AnimalTypeFatteningImpl value,
          $Res Function(_$AnimalTypeFatteningImpl) then) =
      __$$AnimalTypeFatteningImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalTypeFatteningImplCopyWithImpl<$Res>
    extends _$AnimalTypeCopyWithImpl<$Res, _$AnimalTypeFatteningImpl>
    implements _$$AnimalTypeFatteningImplCopyWith<$Res> {
  __$$AnimalTypeFatteningImplCopyWithImpl(_$AnimalTypeFatteningImpl _value,
      $Res Function(_$AnimalTypeFatteningImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalTypeFatteningImpl implements AnimalTypeFattening {
  const _$AnimalTypeFatteningImpl();

  @override
  String toString() {
    return 'AnimalType.fattening()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalTypeFatteningImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() piglet,
    required TResult Function() sow,
    required TResult Function() boar,
    required TResult Function() fattening,
  }) {
    return fattening();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? piglet,
    TResult? Function()? sow,
    TResult? Function()? boar,
    TResult? Function()? fattening,
  }) {
    return fattening?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? piglet,
    TResult Function()? sow,
    TResult Function()? boar,
    TResult Function()? fattening,
    required TResult orElse(),
  }) {
    if (fattening != null) {
      return fattening();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalTypePiglet value) piglet,
    required TResult Function(AnimalTypeSow value) sow,
    required TResult Function(AnimalTypeBoar value) boar,
    required TResult Function(AnimalTypeFattening value) fattening,
  }) {
    return fattening(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalTypePiglet value)? piglet,
    TResult? Function(AnimalTypeSow value)? sow,
    TResult? Function(AnimalTypeBoar value)? boar,
    TResult? Function(AnimalTypeFattening value)? fattening,
  }) {
    return fattening?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalTypePiglet value)? piglet,
    TResult Function(AnimalTypeSow value)? sow,
    TResult Function(AnimalTypeBoar value)? boar,
    TResult Function(AnimalTypeFattening value)? fattening,
    required TResult orElse(),
  }) {
    if (fattening != null) {
      return fattening(this);
    }
    return orElse();
  }
}

abstract class AnimalTypeFattening implements AnimalType {
  const factory AnimalTypeFattening() = _$AnimalTypeFatteningImpl;
}

/// @nodoc
mixin _$AnimalStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() active,
    required TResult Function() sold,
    required TResult Function() dead,
    required TResult Function() transferred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? active,
    TResult? Function()? sold,
    TResult? Function()? dead,
    TResult? Function()? transferred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? active,
    TResult Function()? sold,
    TResult Function()? dead,
    TResult Function()? transferred,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalStatusActive value) active,
    required TResult Function(AnimalStatusSold value) sold,
    required TResult Function(AnimalStatusDead value) dead,
    required TResult Function(AnimalStatusTransferred value) transferred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalStatusActive value)? active,
    TResult? Function(AnimalStatusSold value)? sold,
    TResult? Function(AnimalStatusDead value)? dead,
    TResult? Function(AnimalStatusTransferred value)? transferred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalStatusActive value)? active,
    TResult Function(AnimalStatusSold value)? sold,
    TResult Function(AnimalStatusDead value)? dead,
    TResult Function(AnimalStatusTransferred value)? transferred,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalStatusCopyWith<$Res> {
  factory $AnimalStatusCopyWith(
          AnimalStatus value, $Res Function(AnimalStatus) then) =
      _$AnimalStatusCopyWithImpl<$Res, AnimalStatus>;
}

/// @nodoc
class _$AnimalStatusCopyWithImpl<$Res, $Val extends AnimalStatus>
    implements $AnimalStatusCopyWith<$Res> {
  _$AnimalStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimalStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AnimalStatusActiveImplCopyWith<$Res> {
  factory _$$AnimalStatusActiveImplCopyWith(_$AnimalStatusActiveImpl value,
          $Res Function(_$AnimalStatusActiveImpl) then) =
      __$$AnimalStatusActiveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalStatusActiveImplCopyWithImpl<$Res>
    extends _$AnimalStatusCopyWithImpl<$Res, _$AnimalStatusActiveImpl>
    implements _$$AnimalStatusActiveImplCopyWith<$Res> {
  __$$AnimalStatusActiveImplCopyWithImpl(_$AnimalStatusActiveImpl _value,
      $Res Function(_$AnimalStatusActiveImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalStatusActiveImpl implements AnimalStatusActive {
  const _$AnimalStatusActiveImpl();

  @override
  String toString() {
    return 'AnimalStatus.active()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AnimalStatusActiveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() active,
    required TResult Function() sold,
    required TResult Function() dead,
    required TResult Function() transferred,
  }) {
    return active();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? active,
    TResult? Function()? sold,
    TResult? Function()? dead,
    TResult? Function()? transferred,
  }) {
    return active?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? active,
    TResult Function()? sold,
    TResult Function()? dead,
    TResult Function()? transferred,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalStatusActive value) active,
    required TResult Function(AnimalStatusSold value) sold,
    required TResult Function(AnimalStatusDead value) dead,
    required TResult Function(AnimalStatusTransferred value) transferred,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalStatusActive value)? active,
    TResult? Function(AnimalStatusSold value)? sold,
    TResult? Function(AnimalStatusDead value)? dead,
    TResult? Function(AnimalStatusTransferred value)? transferred,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalStatusActive value)? active,
    TResult Function(AnimalStatusSold value)? sold,
    TResult Function(AnimalStatusDead value)? dead,
    TResult Function(AnimalStatusTransferred value)? transferred,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class AnimalStatusActive implements AnimalStatus {
  const factory AnimalStatusActive() = _$AnimalStatusActiveImpl;
}

/// @nodoc
abstract class _$$AnimalStatusSoldImplCopyWith<$Res> {
  factory _$$AnimalStatusSoldImplCopyWith(_$AnimalStatusSoldImpl value,
          $Res Function(_$AnimalStatusSoldImpl) then) =
      __$$AnimalStatusSoldImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalStatusSoldImplCopyWithImpl<$Res>
    extends _$AnimalStatusCopyWithImpl<$Res, _$AnimalStatusSoldImpl>
    implements _$$AnimalStatusSoldImplCopyWith<$Res> {
  __$$AnimalStatusSoldImplCopyWithImpl(_$AnimalStatusSoldImpl _value,
      $Res Function(_$AnimalStatusSoldImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalStatusSoldImpl implements AnimalStatusSold {
  const _$AnimalStatusSoldImpl();

  @override
  String toString() {
    return 'AnimalStatus.sold()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AnimalStatusSoldImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() active,
    required TResult Function() sold,
    required TResult Function() dead,
    required TResult Function() transferred,
  }) {
    return sold();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? active,
    TResult? Function()? sold,
    TResult? Function()? dead,
    TResult? Function()? transferred,
  }) {
    return sold?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? active,
    TResult Function()? sold,
    TResult Function()? dead,
    TResult Function()? transferred,
    required TResult orElse(),
  }) {
    if (sold != null) {
      return sold();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalStatusActive value) active,
    required TResult Function(AnimalStatusSold value) sold,
    required TResult Function(AnimalStatusDead value) dead,
    required TResult Function(AnimalStatusTransferred value) transferred,
  }) {
    return sold(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalStatusActive value)? active,
    TResult? Function(AnimalStatusSold value)? sold,
    TResult? Function(AnimalStatusDead value)? dead,
    TResult? Function(AnimalStatusTransferred value)? transferred,
  }) {
    return sold?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalStatusActive value)? active,
    TResult Function(AnimalStatusSold value)? sold,
    TResult Function(AnimalStatusDead value)? dead,
    TResult Function(AnimalStatusTransferred value)? transferred,
    required TResult orElse(),
  }) {
    if (sold != null) {
      return sold(this);
    }
    return orElse();
  }
}

abstract class AnimalStatusSold implements AnimalStatus {
  const factory AnimalStatusSold() = _$AnimalStatusSoldImpl;
}

/// @nodoc
abstract class _$$AnimalStatusDeadImplCopyWith<$Res> {
  factory _$$AnimalStatusDeadImplCopyWith(_$AnimalStatusDeadImpl value,
          $Res Function(_$AnimalStatusDeadImpl) then) =
      __$$AnimalStatusDeadImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalStatusDeadImplCopyWithImpl<$Res>
    extends _$AnimalStatusCopyWithImpl<$Res, _$AnimalStatusDeadImpl>
    implements _$$AnimalStatusDeadImplCopyWith<$Res> {
  __$$AnimalStatusDeadImplCopyWithImpl(_$AnimalStatusDeadImpl _value,
      $Res Function(_$AnimalStatusDeadImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalStatusDeadImpl implements AnimalStatusDead {
  const _$AnimalStatusDeadImpl();

  @override
  String toString() {
    return 'AnimalStatus.dead()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AnimalStatusDeadImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() active,
    required TResult Function() sold,
    required TResult Function() dead,
    required TResult Function() transferred,
  }) {
    return dead();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? active,
    TResult? Function()? sold,
    TResult? Function()? dead,
    TResult? Function()? transferred,
  }) {
    return dead?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? active,
    TResult Function()? sold,
    TResult Function()? dead,
    TResult Function()? transferred,
    required TResult orElse(),
  }) {
    if (dead != null) {
      return dead();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalStatusActive value) active,
    required TResult Function(AnimalStatusSold value) sold,
    required TResult Function(AnimalStatusDead value) dead,
    required TResult Function(AnimalStatusTransferred value) transferred,
  }) {
    return dead(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalStatusActive value)? active,
    TResult? Function(AnimalStatusSold value)? sold,
    TResult? Function(AnimalStatusDead value)? dead,
    TResult? Function(AnimalStatusTransferred value)? transferred,
  }) {
    return dead?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalStatusActive value)? active,
    TResult Function(AnimalStatusSold value)? sold,
    TResult Function(AnimalStatusDead value)? dead,
    TResult Function(AnimalStatusTransferred value)? transferred,
    required TResult orElse(),
  }) {
    if (dead != null) {
      return dead(this);
    }
    return orElse();
  }
}

abstract class AnimalStatusDead implements AnimalStatus {
  const factory AnimalStatusDead() = _$AnimalStatusDeadImpl;
}

/// @nodoc
abstract class _$$AnimalStatusTransferredImplCopyWith<$Res> {
  factory _$$AnimalStatusTransferredImplCopyWith(
          _$AnimalStatusTransferredImpl value,
          $Res Function(_$AnimalStatusTransferredImpl) then) =
      __$$AnimalStatusTransferredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalStatusTransferredImplCopyWithImpl<$Res>
    extends _$AnimalStatusCopyWithImpl<$Res, _$AnimalStatusTransferredImpl>
    implements _$$AnimalStatusTransferredImplCopyWith<$Res> {
  __$$AnimalStatusTransferredImplCopyWithImpl(
      _$AnimalStatusTransferredImpl _value,
      $Res Function(_$AnimalStatusTransferredImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalStatusTransferredImpl implements AnimalStatusTransferred {
  const _$AnimalStatusTransferredImpl();

  @override
  String toString() {
    return 'AnimalStatus.transferred()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalStatusTransferredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() active,
    required TResult Function() sold,
    required TResult Function() dead,
    required TResult Function() transferred,
  }) {
    return transferred();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? active,
    TResult? Function()? sold,
    TResult? Function()? dead,
    TResult? Function()? transferred,
  }) {
    return transferred?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? active,
    TResult Function()? sold,
    TResult Function()? dead,
    TResult Function()? transferred,
    required TResult orElse(),
  }) {
    if (transferred != null) {
      return transferred();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalStatusActive value) active,
    required TResult Function(AnimalStatusSold value) sold,
    required TResult Function(AnimalStatusDead value) dead,
    required TResult Function(AnimalStatusTransferred value) transferred,
  }) {
    return transferred(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalStatusActive value)? active,
    TResult? Function(AnimalStatusSold value)? sold,
    TResult? Function(AnimalStatusDead value)? dead,
    TResult? Function(AnimalStatusTransferred value)? transferred,
  }) {
    return transferred?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalStatusActive value)? active,
    TResult Function(AnimalStatusSold value)? sold,
    TResult Function(AnimalStatusDead value)? dead,
    TResult Function(AnimalStatusTransferred value)? transferred,
    required TResult orElse(),
  }) {
    if (transferred != null) {
      return transferred(this);
    }
    return orElse();
  }
}

abstract class AnimalStatusTransferred implements AnimalStatus {
  const factory AnimalStatusTransferred() = _$AnimalStatusTransferredImpl;
}

/// @nodoc
mixin _$AnimalEventType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() weighing,
    required TResult Function() treatment,
    required TResult Function() death,
    required TResult Function() sale,
    required TResult Function() transfer,
    required TResult Function() vaccination,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? weighing,
    TResult? Function()? treatment,
    TResult? Function()? death,
    TResult? Function()? sale,
    TResult? Function()? transfer,
    TResult? Function()? vaccination,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? weighing,
    TResult Function()? treatment,
    TResult Function()? death,
    TResult Function()? sale,
    TResult Function()? transfer,
    TResult Function()? vaccination,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalEventTypeWeighing value) weighing,
    required TResult Function(AnimalEventTypeTreatment value) treatment,
    required TResult Function(AnimalEventTypeDeath value) death,
    required TResult Function(AnimalEventTypeSale value) sale,
    required TResult Function(AnimalEventTypeTransfer value) transfer,
    required TResult Function(AnimalEventTypeVaccination value) vaccination,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalEventTypeWeighing value)? weighing,
    TResult? Function(AnimalEventTypeTreatment value)? treatment,
    TResult? Function(AnimalEventTypeDeath value)? death,
    TResult? Function(AnimalEventTypeSale value)? sale,
    TResult? Function(AnimalEventTypeTransfer value)? transfer,
    TResult? Function(AnimalEventTypeVaccination value)? vaccination,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalEventTypeWeighing value)? weighing,
    TResult Function(AnimalEventTypeTreatment value)? treatment,
    TResult Function(AnimalEventTypeDeath value)? death,
    TResult Function(AnimalEventTypeSale value)? sale,
    TResult Function(AnimalEventTypeTransfer value)? transfer,
    TResult Function(AnimalEventTypeVaccination value)? vaccination,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalEventTypeCopyWith<$Res> {
  factory $AnimalEventTypeCopyWith(
          AnimalEventType value, $Res Function(AnimalEventType) then) =
      _$AnimalEventTypeCopyWithImpl<$Res, AnimalEventType>;
}

/// @nodoc
class _$AnimalEventTypeCopyWithImpl<$Res, $Val extends AnimalEventType>
    implements $AnimalEventTypeCopyWith<$Res> {
  _$AnimalEventTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimalEventType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AnimalEventTypeWeighingImplCopyWith<$Res> {
  factory _$$AnimalEventTypeWeighingImplCopyWith(
          _$AnimalEventTypeWeighingImpl value,
          $Res Function(_$AnimalEventTypeWeighingImpl) then) =
      __$$AnimalEventTypeWeighingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalEventTypeWeighingImplCopyWithImpl<$Res>
    extends _$AnimalEventTypeCopyWithImpl<$Res, _$AnimalEventTypeWeighingImpl>
    implements _$$AnimalEventTypeWeighingImplCopyWith<$Res> {
  __$$AnimalEventTypeWeighingImplCopyWithImpl(
      _$AnimalEventTypeWeighingImpl _value,
      $Res Function(_$AnimalEventTypeWeighingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalEventType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalEventTypeWeighingImpl implements AnimalEventTypeWeighing {
  const _$AnimalEventTypeWeighingImpl();

  @override
  String toString() {
    return 'AnimalEventType.weighing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalEventTypeWeighingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() weighing,
    required TResult Function() treatment,
    required TResult Function() death,
    required TResult Function() sale,
    required TResult Function() transfer,
    required TResult Function() vaccination,
  }) {
    return weighing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? weighing,
    TResult? Function()? treatment,
    TResult? Function()? death,
    TResult? Function()? sale,
    TResult? Function()? transfer,
    TResult? Function()? vaccination,
  }) {
    return weighing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? weighing,
    TResult Function()? treatment,
    TResult Function()? death,
    TResult Function()? sale,
    TResult Function()? transfer,
    TResult Function()? vaccination,
    required TResult orElse(),
  }) {
    if (weighing != null) {
      return weighing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalEventTypeWeighing value) weighing,
    required TResult Function(AnimalEventTypeTreatment value) treatment,
    required TResult Function(AnimalEventTypeDeath value) death,
    required TResult Function(AnimalEventTypeSale value) sale,
    required TResult Function(AnimalEventTypeTransfer value) transfer,
    required TResult Function(AnimalEventTypeVaccination value) vaccination,
  }) {
    return weighing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalEventTypeWeighing value)? weighing,
    TResult? Function(AnimalEventTypeTreatment value)? treatment,
    TResult? Function(AnimalEventTypeDeath value)? death,
    TResult? Function(AnimalEventTypeSale value)? sale,
    TResult? Function(AnimalEventTypeTransfer value)? transfer,
    TResult? Function(AnimalEventTypeVaccination value)? vaccination,
  }) {
    return weighing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalEventTypeWeighing value)? weighing,
    TResult Function(AnimalEventTypeTreatment value)? treatment,
    TResult Function(AnimalEventTypeDeath value)? death,
    TResult Function(AnimalEventTypeSale value)? sale,
    TResult Function(AnimalEventTypeTransfer value)? transfer,
    TResult Function(AnimalEventTypeVaccination value)? vaccination,
    required TResult orElse(),
  }) {
    if (weighing != null) {
      return weighing(this);
    }
    return orElse();
  }
}

abstract class AnimalEventTypeWeighing implements AnimalEventType {
  const factory AnimalEventTypeWeighing() = _$AnimalEventTypeWeighingImpl;
}

/// @nodoc
abstract class _$$AnimalEventTypeTreatmentImplCopyWith<$Res> {
  factory _$$AnimalEventTypeTreatmentImplCopyWith(
          _$AnimalEventTypeTreatmentImpl value,
          $Res Function(_$AnimalEventTypeTreatmentImpl) then) =
      __$$AnimalEventTypeTreatmentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalEventTypeTreatmentImplCopyWithImpl<$Res>
    extends _$AnimalEventTypeCopyWithImpl<$Res, _$AnimalEventTypeTreatmentImpl>
    implements _$$AnimalEventTypeTreatmentImplCopyWith<$Res> {
  __$$AnimalEventTypeTreatmentImplCopyWithImpl(
      _$AnimalEventTypeTreatmentImpl _value,
      $Res Function(_$AnimalEventTypeTreatmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalEventType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalEventTypeTreatmentImpl implements AnimalEventTypeTreatment {
  const _$AnimalEventTypeTreatmentImpl();

  @override
  String toString() {
    return 'AnimalEventType.treatment()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalEventTypeTreatmentImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() weighing,
    required TResult Function() treatment,
    required TResult Function() death,
    required TResult Function() sale,
    required TResult Function() transfer,
    required TResult Function() vaccination,
  }) {
    return treatment();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? weighing,
    TResult? Function()? treatment,
    TResult? Function()? death,
    TResult? Function()? sale,
    TResult? Function()? transfer,
    TResult? Function()? vaccination,
  }) {
    return treatment?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? weighing,
    TResult Function()? treatment,
    TResult Function()? death,
    TResult Function()? sale,
    TResult Function()? transfer,
    TResult Function()? vaccination,
    required TResult orElse(),
  }) {
    if (treatment != null) {
      return treatment();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalEventTypeWeighing value) weighing,
    required TResult Function(AnimalEventTypeTreatment value) treatment,
    required TResult Function(AnimalEventTypeDeath value) death,
    required TResult Function(AnimalEventTypeSale value) sale,
    required TResult Function(AnimalEventTypeTransfer value) transfer,
    required TResult Function(AnimalEventTypeVaccination value) vaccination,
  }) {
    return treatment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalEventTypeWeighing value)? weighing,
    TResult? Function(AnimalEventTypeTreatment value)? treatment,
    TResult? Function(AnimalEventTypeDeath value)? death,
    TResult? Function(AnimalEventTypeSale value)? sale,
    TResult? Function(AnimalEventTypeTransfer value)? transfer,
    TResult? Function(AnimalEventTypeVaccination value)? vaccination,
  }) {
    return treatment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalEventTypeWeighing value)? weighing,
    TResult Function(AnimalEventTypeTreatment value)? treatment,
    TResult Function(AnimalEventTypeDeath value)? death,
    TResult Function(AnimalEventTypeSale value)? sale,
    TResult Function(AnimalEventTypeTransfer value)? transfer,
    TResult Function(AnimalEventTypeVaccination value)? vaccination,
    required TResult orElse(),
  }) {
    if (treatment != null) {
      return treatment(this);
    }
    return orElse();
  }
}

abstract class AnimalEventTypeTreatment implements AnimalEventType {
  const factory AnimalEventTypeTreatment() = _$AnimalEventTypeTreatmentImpl;
}

/// @nodoc
abstract class _$$AnimalEventTypeDeathImplCopyWith<$Res> {
  factory _$$AnimalEventTypeDeathImplCopyWith(_$AnimalEventTypeDeathImpl value,
          $Res Function(_$AnimalEventTypeDeathImpl) then) =
      __$$AnimalEventTypeDeathImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalEventTypeDeathImplCopyWithImpl<$Res>
    extends _$AnimalEventTypeCopyWithImpl<$Res, _$AnimalEventTypeDeathImpl>
    implements _$$AnimalEventTypeDeathImplCopyWith<$Res> {
  __$$AnimalEventTypeDeathImplCopyWithImpl(_$AnimalEventTypeDeathImpl _value,
      $Res Function(_$AnimalEventTypeDeathImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalEventType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalEventTypeDeathImpl implements AnimalEventTypeDeath {
  const _$AnimalEventTypeDeathImpl();

  @override
  String toString() {
    return 'AnimalEventType.death()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalEventTypeDeathImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() weighing,
    required TResult Function() treatment,
    required TResult Function() death,
    required TResult Function() sale,
    required TResult Function() transfer,
    required TResult Function() vaccination,
  }) {
    return death();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? weighing,
    TResult? Function()? treatment,
    TResult? Function()? death,
    TResult? Function()? sale,
    TResult? Function()? transfer,
    TResult? Function()? vaccination,
  }) {
    return death?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? weighing,
    TResult Function()? treatment,
    TResult Function()? death,
    TResult Function()? sale,
    TResult Function()? transfer,
    TResult Function()? vaccination,
    required TResult orElse(),
  }) {
    if (death != null) {
      return death();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalEventTypeWeighing value) weighing,
    required TResult Function(AnimalEventTypeTreatment value) treatment,
    required TResult Function(AnimalEventTypeDeath value) death,
    required TResult Function(AnimalEventTypeSale value) sale,
    required TResult Function(AnimalEventTypeTransfer value) transfer,
    required TResult Function(AnimalEventTypeVaccination value) vaccination,
  }) {
    return death(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalEventTypeWeighing value)? weighing,
    TResult? Function(AnimalEventTypeTreatment value)? treatment,
    TResult? Function(AnimalEventTypeDeath value)? death,
    TResult? Function(AnimalEventTypeSale value)? sale,
    TResult? Function(AnimalEventTypeTransfer value)? transfer,
    TResult? Function(AnimalEventTypeVaccination value)? vaccination,
  }) {
    return death?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalEventTypeWeighing value)? weighing,
    TResult Function(AnimalEventTypeTreatment value)? treatment,
    TResult Function(AnimalEventTypeDeath value)? death,
    TResult Function(AnimalEventTypeSale value)? sale,
    TResult Function(AnimalEventTypeTransfer value)? transfer,
    TResult Function(AnimalEventTypeVaccination value)? vaccination,
    required TResult orElse(),
  }) {
    if (death != null) {
      return death(this);
    }
    return orElse();
  }
}

abstract class AnimalEventTypeDeath implements AnimalEventType {
  const factory AnimalEventTypeDeath() = _$AnimalEventTypeDeathImpl;
}

/// @nodoc
abstract class _$$AnimalEventTypeSaleImplCopyWith<$Res> {
  factory _$$AnimalEventTypeSaleImplCopyWith(_$AnimalEventTypeSaleImpl value,
          $Res Function(_$AnimalEventTypeSaleImpl) then) =
      __$$AnimalEventTypeSaleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalEventTypeSaleImplCopyWithImpl<$Res>
    extends _$AnimalEventTypeCopyWithImpl<$Res, _$AnimalEventTypeSaleImpl>
    implements _$$AnimalEventTypeSaleImplCopyWith<$Res> {
  __$$AnimalEventTypeSaleImplCopyWithImpl(_$AnimalEventTypeSaleImpl _value,
      $Res Function(_$AnimalEventTypeSaleImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalEventType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalEventTypeSaleImpl implements AnimalEventTypeSale {
  const _$AnimalEventTypeSaleImpl();

  @override
  String toString() {
    return 'AnimalEventType.sale()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalEventTypeSaleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() weighing,
    required TResult Function() treatment,
    required TResult Function() death,
    required TResult Function() sale,
    required TResult Function() transfer,
    required TResult Function() vaccination,
  }) {
    return sale();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? weighing,
    TResult? Function()? treatment,
    TResult? Function()? death,
    TResult? Function()? sale,
    TResult? Function()? transfer,
    TResult? Function()? vaccination,
  }) {
    return sale?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? weighing,
    TResult Function()? treatment,
    TResult Function()? death,
    TResult Function()? sale,
    TResult Function()? transfer,
    TResult Function()? vaccination,
    required TResult orElse(),
  }) {
    if (sale != null) {
      return sale();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalEventTypeWeighing value) weighing,
    required TResult Function(AnimalEventTypeTreatment value) treatment,
    required TResult Function(AnimalEventTypeDeath value) death,
    required TResult Function(AnimalEventTypeSale value) sale,
    required TResult Function(AnimalEventTypeTransfer value) transfer,
    required TResult Function(AnimalEventTypeVaccination value) vaccination,
  }) {
    return sale(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalEventTypeWeighing value)? weighing,
    TResult? Function(AnimalEventTypeTreatment value)? treatment,
    TResult? Function(AnimalEventTypeDeath value)? death,
    TResult? Function(AnimalEventTypeSale value)? sale,
    TResult? Function(AnimalEventTypeTransfer value)? transfer,
    TResult? Function(AnimalEventTypeVaccination value)? vaccination,
  }) {
    return sale?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalEventTypeWeighing value)? weighing,
    TResult Function(AnimalEventTypeTreatment value)? treatment,
    TResult Function(AnimalEventTypeDeath value)? death,
    TResult Function(AnimalEventTypeSale value)? sale,
    TResult Function(AnimalEventTypeTransfer value)? transfer,
    TResult Function(AnimalEventTypeVaccination value)? vaccination,
    required TResult orElse(),
  }) {
    if (sale != null) {
      return sale(this);
    }
    return orElse();
  }
}

abstract class AnimalEventTypeSale implements AnimalEventType {
  const factory AnimalEventTypeSale() = _$AnimalEventTypeSaleImpl;
}

/// @nodoc
abstract class _$$AnimalEventTypeTransferImplCopyWith<$Res> {
  factory _$$AnimalEventTypeTransferImplCopyWith(
          _$AnimalEventTypeTransferImpl value,
          $Res Function(_$AnimalEventTypeTransferImpl) then) =
      __$$AnimalEventTypeTransferImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalEventTypeTransferImplCopyWithImpl<$Res>
    extends _$AnimalEventTypeCopyWithImpl<$Res, _$AnimalEventTypeTransferImpl>
    implements _$$AnimalEventTypeTransferImplCopyWith<$Res> {
  __$$AnimalEventTypeTransferImplCopyWithImpl(
      _$AnimalEventTypeTransferImpl _value,
      $Res Function(_$AnimalEventTypeTransferImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalEventType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalEventTypeTransferImpl implements AnimalEventTypeTransfer {
  const _$AnimalEventTypeTransferImpl();

  @override
  String toString() {
    return 'AnimalEventType.transfer()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalEventTypeTransferImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() weighing,
    required TResult Function() treatment,
    required TResult Function() death,
    required TResult Function() sale,
    required TResult Function() transfer,
    required TResult Function() vaccination,
  }) {
    return transfer();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? weighing,
    TResult? Function()? treatment,
    TResult? Function()? death,
    TResult? Function()? sale,
    TResult? Function()? transfer,
    TResult? Function()? vaccination,
  }) {
    return transfer?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? weighing,
    TResult Function()? treatment,
    TResult Function()? death,
    TResult Function()? sale,
    TResult Function()? transfer,
    TResult Function()? vaccination,
    required TResult orElse(),
  }) {
    if (transfer != null) {
      return transfer();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalEventTypeWeighing value) weighing,
    required TResult Function(AnimalEventTypeTreatment value) treatment,
    required TResult Function(AnimalEventTypeDeath value) death,
    required TResult Function(AnimalEventTypeSale value) sale,
    required TResult Function(AnimalEventTypeTransfer value) transfer,
    required TResult Function(AnimalEventTypeVaccination value) vaccination,
  }) {
    return transfer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalEventTypeWeighing value)? weighing,
    TResult? Function(AnimalEventTypeTreatment value)? treatment,
    TResult? Function(AnimalEventTypeDeath value)? death,
    TResult? Function(AnimalEventTypeSale value)? sale,
    TResult? Function(AnimalEventTypeTransfer value)? transfer,
    TResult? Function(AnimalEventTypeVaccination value)? vaccination,
  }) {
    return transfer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalEventTypeWeighing value)? weighing,
    TResult Function(AnimalEventTypeTreatment value)? treatment,
    TResult Function(AnimalEventTypeDeath value)? death,
    TResult Function(AnimalEventTypeSale value)? sale,
    TResult Function(AnimalEventTypeTransfer value)? transfer,
    TResult Function(AnimalEventTypeVaccination value)? vaccination,
    required TResult orElse(),
  }) {
    if (transfer != null) {
      return transfer(this);
    }
    return orElse();
  }
}

abstract class AnimalEventTypeTransfer implements AnimalEventType {
  const factory AnimalEventTypeTransfer() = _$AnimalEventTypeTransferImpl;
}

/// @nodoc
abstract class _$$AnimalEventTypeVaccinationImplCopyWith<$Res> {
  factory _$$AnimalEventTypeVaccinationImplCopyWith(
          _$AnimalEventTypeVaccinationImpl value,
          $Res Function(_$AnimalEventTypeVaccinationImpl) then) =
      __$$AnimalEventTypeVaccinationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AnimalEventTypeVaccinationImplCopyWithImpl<$Res>
    extends _$AnimalEventTypeCopyWithImpl<$Res,
        _$AnimalEventTypeVaccinationImpl>
    implements _$$AnimalEventTypeVaccinationImplCopyWith<$Res> {
  __$$AnimalEventTypeVaccinationImplCopyWithImpl(
      _$AnimalEventTypeVaccinationImpl _value,
      $Res Function(_$AnimalEventTypeVaccinationImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnimalEventType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AnimalEventTypeVaccinationImpl implements AnimalEventTypeVaccination {
  const _$AnimalEventTypeVaccinationImpl();

  @override
  String toString() {
    return 'AnimalEventType.vaccination()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalEventTypeVaccinationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() weighing,
    required TResult Function() treatment,
    required TResult Function() death,
    required TResult Function() sale,
    required TResult Function() transfer,
    required TResult Function() vaccination,
  }) {
    return vaccination();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? weighing,
    TResult? Function()? treatment,
    TResult? Function()? death,
    TResult? Function()? sale,
    TResult? Function()? transfer,
    TResult? Function()? vaccination,
  }) {
    return vaccination?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? weighing,
    TResult Function()? treatment,
    TResult Function()? death,
    TResult Function()? sale,
    TResult Function()? transfer,
    TResult Function()? vaccination,
    required TResult orElse(),
  }) {
    if (vaccination != null) {
      return vaccination();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AnimalEventTypeWeighing value) weighing,
    required TResult Function(AnimalEventTypeTreatment value) treatment,
    required TResult Function(AnimalEventTypeDeath value) death,
    required TResult Function(AnimalEventTypeSale value) sale,
    required TResult Function(AnimalEventTypeTransfer value) transfer,
    required TResult Function(AnimalEventTypeVaccination value) vaccination,
  }) {
    return vaccination(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AnimalEventTypeWeighing value)? weighing,
    TResult? Function(AnimalEventTypeTreatment value)? treatment,
    TResult? Function(AnimalEventTypeDeath value)? death,
    TResult? Function(AnimalEventTypeSale value)? sale,
    TResult? Function(AnimalEventTypeTransfer value)? transfer,
    TResult? Function(AnimalEventTypeVaccination value)? vaccination,
  }) {
    return vaccination?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AnimalEventTypeWeighing value)? weighing,
    TResult Function(AnimalEventTypeTreatment value)? treatment,
    TResult Function(AnimalEventTypeDeath value)? death,
    TResult Function(AnimalEventTypeSale value)? sale,
    TResult Function(AnimalEventTypeTransfer value)? transfer,
    TResult Function(AnimalEventTypeVaccination value)? vaccination,
    required TResult orElse(),
  }) {
    if (vaccination != null) {
      return vaccination(this);
    }
    return orElse();
  }
}

abstract class AnimalEventTypeVaccination implements AnimalEventType {
  const factory AnimalEventTypeVaccination() = _$AnimalEventTypeVaccinationImpl;
}
