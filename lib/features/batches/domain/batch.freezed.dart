// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Batch _$BatchFromJson(Map<String, dynamic> json) {
  return _Batch.fromJson(json);
}

/// @nodoc
mixin _$Batch {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'headcount_start')
  int get headcountStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'corral_id')
  String? get corralId => throw _privateConstructorUsedError;
  @JsonKey(name: 'initial_avg_weight')
  double? get initialAvgWeight => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'animals', fromJson: _animalsFromJson, toJson: _animalsToJson)
  List<Animal> get animals => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BatchCopyWith<Batch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchCopyWith<$Res> {
  factory $BatchCopyWith(Batch value, $Res Function(Batch) then) =
      _$BatchCopyWithImpl<$Res, Batch>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'headcount_start') int headcountStart,
      @JsonKey(name: 'corral_id') String? corralId,
      @JsonKey(name: 'initial_avg_weight') double? initialAvgWeight,
      String status,
      String? notes,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(
          name: 'animals', fromJson: _animalsFromJson, toJson: _animalsToJson)
      List<Animal> animals});
}

/// @nodoc
class _$BatchCopyWithImpl<$Res, $Val extends Batch>
    implements $BatchCopyWith<$Res> {
  _$BatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? headcountStart = null,
    Object? corralId = freezed,
    Object? initialAvgWeight = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? imageUrl = freezed,
    Object? animals = null,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      headcountStart: null == headcountStart
          ? _value.headcountStart
          : headcountStart // ignore: cast_nullable_to_non_nullable
              as int,
      corralId: freezed == corralId
          ? _value.corralId
          : corralId // ignore: cast_nullable_to_non_nullable
              as String?,
      initialAvgWeight: freezed == initialAvgWeight
          ? _value.initialAvgWeight
          : initialAvgWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      animals: null == animals
          ? _value.animals
          : animals // ignore: cast_nullable_to_non_nullable
              as List<Animal>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchImplCopyWith<$Res> implements $BatchCopyWith<$Res> {
  factory _$$BatchImplCopyWith(
          _$BatchImpl value, $Res Function(_$BatchImpl) then) =
      __$$BatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'headcount_start') int headcountStart,
      @JsonKey(name: 'corral_id') String? corralId,
      @JsonKey(name: 'initial_avg_weight') double? initialAvgWeight,
      String status,
      String? notes,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(
          name: 'animals', fromJson: _animalsFromJson, toJson: _animalsToJson)
      List<Animal> animals});
}

/// @nodoc
class __$$BatchImplCopyWithImpl<$Res>
    extends _$BatchCopyWithImpl<$Res, _$BatchImpl>
    implements _$$BatchImplCopyWith<$Res> {
  __$$BatchImplCopyWithImpl(
      _$BatchImpl _value, $Res Function(_$BatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? headcountStart = null,
    Object? corralId = freezed,
    Object? initialAvgWeight = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? imageUrl = freezed,
    Object? animals = null,
  }) {
    return _then(_$BatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      headcountStart: null == headcountStart
          ? _value.headcountStart
          : headcountStart // ignore: cast_nullable_to_non_nullable
              as int,
      corralId: freezed == corralId
          ? _value.corralId
          : corralId // ignore: cast_nullable_to_non_nullable
              as String?,
      initialAvgWeight: freezed == initialAvgWeight
          ? _value.initialAvgWeight
          : initialAvgWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      animals: null == animals
          ? _value._animals
          : animals // ignore: cast_nullable_to_non_nullable
              as List<Animal>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchImpl implements _Batch {
  const _$BatchImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'headcount_start') this.headcountStart = 0,
      @JsonKey(name: 'corral_id') this.corralId,
      @JsonKey(name: 'initial_avg_weight') this.initialAvgWeight,
      this.status = 'active',
      this.notes,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(
          name: 'animals', fromJson: _animalsFromJson, toJson: _animalsToJson)
      final List<Animal> animals = const []})
      : _animals = animals;

  factory _$BatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'headcount_start')
  final int headcountStart;
  @override
  @JsonKey(name: 'corral_id')
  final String? corralId;
  @override
  @JsonKey(name: 'initial_avg_weight')
  final double? initialAvgWeight;
  @override
  @JsonKey()
  final String status;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final List<Animal> _animals;
  @override
  @JsonKey(name: 'animals', fromJson: _animalsFromJson, toJson: _animalsToJson)
  List<Animal> get animals {
    if (_animals is EqualUnmodifiableListView) return _animals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_animals);
  }

  @override
  String toString() {
    return 'Batch(id: $id, name: $name, createdAt: $createdAt, headcountStart: $headcountStart, corralId: $corralId, initialAvgWeight: $initialAvgWeight, status: $status, notes: $notes, imageUrl: $imageUrl, animals: $animals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.headcountStart, headcountStart) ||
                other.headcountStart == headcountStart) &&
            (identical(other.corralId, corralId) ||
                other.corralId == corralId) &&
            (identical(other.initialAvgWeight, initialAvgWeight) ||
                other.initialAvgWeight == initialAvgWeight) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._animals, _animals));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      createdAt,
      headcountStart,
      corralId,
      initialAvgWeight,
      status,
      notes,
      imageUrl,
      const DeepCollectionEquality().hash(_animals));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchImplCopyWith<_$BatchImpl> get copyWith =>
      __$$BatchImplCopyWithImpl<_$BatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchImplToJson(
      this,
    );
  }
}

abstract class _Batch implements Batch {
  const factory _Batch(
      {required final String id,
      required final String name,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'headcount_start') final int headcountStart,
      @JsonKey(name: 'corral_id') final String? corralId,
      @JsonKey(name: 'initial_avg_weight') final double? initialAvgWeight,
      final String status,
      final String? notes,
      @JsonKey(name: 'image_url') final String? imageUrl,
      @JsonKey(
          name: 'animals', fromJson: _animalsFromJson, toJson: _animalsToJson)
      final List<Animal> animals}) = _$BatchImpl;

  factory _Batch.fromJson(Map<String, dynamic> json) = _$BatchImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'headcount_start')
  int get headcountStart;
  @override
  @JsonKey(name: 'corral_id')
  String? get corralId;
  @override
  @JsonKey(name: 'initial_avg_weight')
  double? get initialAvgWeight;
  @override
  String get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'animals', fromJson: _animalsFromJson, toJson: _animalsToJson)
  List<Animal> get animals;
  @override
  @JsonKey(ignore: true)
  _$$BatchImplCopyWith<_$BatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
