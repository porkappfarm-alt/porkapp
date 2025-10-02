// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Animal _$AnimalFromJson(Map<String, dynamic> json) {
  return _Animal.fromJson(json);
}

/// @nodoc
mixin _$Animal {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_id')
  String get batchId => throw _privateConstructorUsedError;
  String get identifier => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime get birthDate => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  String get breed => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this Animal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnimalCopyWith<Animal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalCopyWith<$Res> {
  factory $AnimalCopyWith(Animal value, $Res Function(Animal) then) =
      _$AnimalCopyWithImpl<$Res, Animal>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'batch_id') String batchId,
    String identifier,
    @JsonKey(name: 'birth_date') DateTime birthDate,
    double weight,
    String breed,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String status,
  });
}

/// @nodoc
class _$AnimalCopyWithImpl<$Res, $Val extends Animal>
    implements $AnimalCopyWith<$Res> {
  _$AnimalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchId = null,
    Object? identifier = null,
    Object? birthDate = null,
    Object? weight = null,
    Object? breed = null,
    Object? createdAt = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            batchId: null == batchId
                ? _value.batchId
                : batchId // ignore: cast_nullable_to_non_nullable
                      as String,
            identifier: null == identifier
                ? _value.identifier
                : identifier // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: null == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            breed: null == breed
                ? _value.breed
                : breed // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnimalImplCopyWith<$Res> implements $AnimalCopyWith<$Res> {
  factory _$$AnimalImplCopyWith(
    _$AnimalImpl value,
    $Res Function(_$AnimalImpl) then,
  ) = __$$AnimalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'batch_id') String batchId,
    String identifier,
    @JsonKey(name: 'birth_date') DateTime birthDate,
    double weight,
    String breed,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String status,
  });
}

/// @nodoc
class __$$AnimalImplCopyWithImpl<$Res>
    extends _$AnimalCopyWithImpl<$Res, _$AnimalImpl>
    implements _$$AnimalImplCopyWith<$Res> {
  __$$AnimalImplCopyWithImpl(
    _$AnimalImpl _value,
    $Res Function(_$AnimalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchId = null,
    Object? identifier = null,
    Object? birthDate = null,
    Object? weight = null,
    Object? breed = null,
    Object? createdAt = null,
    Object? status = null,
  }) {
    return _then(
      _$AnimalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        batchId: null == batchId
            ? _value.batchId
            : batchId // ignore: cast_nullable_to_non_nullable
                  as String,
        identifier: null == identifier
            ? _value.identifier
            : identifier // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: null == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        breed: null == breed
            ? _value.breed
            : breed // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimalImpl implements _Animal {
  _$AnimalImpl({
    required this.id,
    @JsonKey(name: 'batch_id') required this.batchId,
    required this.identifier,
    @JsonKey(name: 'birth_date') required this.birthDate,
    required this.weight,
    required this.breed,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.status = 'active',
  });

  factory _$AnimalImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'batch_id')
  final String batchId;
  @override
  final String identifier;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime birthDate;
  @override
  final double weight;
  @override
  final String breed;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'Animal(id: $id, batchId: $batchId, identifier: $identifier, birthDate: $birthDate, weight: $weight, breed: $breed, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    batchId,
    identifier,
    birthDate,
    weight,
    breed,
    createdAt,
    status,
  );

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalImplCopyWith<_$AnimalImpl> get copyWith =>
      __$$AnimalImplCopyWithImpl<_$AnimalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalImplToJson(this);
  }
}

abstract class _Animal implements Animal {
  factory _Animal({
    required final String id,
    @JsonKey(name: 'batch_id') required final String batchId,
    required final String identifier,
    @JsonKey(name: 'birth_date') required final DateTime birthDate,
    required final double weight,
    required final String breed,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    final String status,
  }) = _$AnimalImpl;

  factory _Animal.fromJson(Map<String, dynamic> json) = _$AnimalImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'batch_id')
  String get batchId;
  @override
  String get identifier;
  @override
  @JsonKey(name: 'birth_date')
  DateTime get birthDate;
  @override
  double get weight;
  @override
  String get breed;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  String get status;

  /// Create a copy of Animal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnimalImplCopyWith<_$AnimalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
