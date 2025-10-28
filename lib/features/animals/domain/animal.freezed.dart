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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Animal _$AnimalFromJson(Map<String, dynamic> json) {
  return _Animal.fromJson(json);
}

/// @nodoc
mixin _$Animal {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_id')
  String get batchId => throw _privateConstructorUsedError;
  String get identifier =>
      throw _privateConstructorUsedError; // ID interno o número de arete
  @JsonKey(
      name: 'birth_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get sex => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_at_entry')
  double? get weight => throw _privateConstructorUsedError; // Peso inicial
  String get breed => throw _privateConstructorUsedError;
  @JsonKey(name: 'animal_type')
  String get type =>
      throw _privateConstructorUsedError; // Tipo de animal (ej: cerdo de engorde, reproductor, etc)
  @JsonKey(
      name: 'entry_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get entryDate =>
      throw _privateConstructorUsedError; // Fecha de ingreso al lote
  @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'updated_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // active, sold, deceased, removed
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_weight')
  double? get targetWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'parity_number')
  int? get parityNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_count')
  int? get serviceCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnimalCopyWith<Animal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalCopyWith<$Res> {
  factory $AnimalCopyWith(Animal value, $Res Function(Animal) then) =
      _$AnimalCopyWithImpl<$Res, Animal>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'batch_id') String batchId,
      String identifier,
      @JsonKey(
          name: 'birth_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? birthDate,
      String? sex,
      @JsonKey(name: 'weight_at_entry') double? weight,
      String breed,
      @JsonKey(name: 'animal_type') String type,
      @JsonKey(
          name: 'entry_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? entryDate,
      @JsonKey(
          name: 'created_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? updatedAt,
      String gender,
      String status,
      String? notes,
      @JsonKey(name: 'target_weight') double? targetWeight,
      @JsonKey(name: 'parity_number') int? parityNumber,
      @JsonKey(name: 'service_count') int? serviceCount});
}

/// @nodoc
class _$AnimalCopyWithImpl<$Res, $Val extends Animal>
    implements $AnimalCopyWith<$Res> {
  _$AnimalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchId = null,
    Object? identifier = null,
    Object? birthDate = freezed,
    Object? sex = freezed,
    Object? weight = freezed,
    Object? breed = null,
    Object? type = null,
    Object? entryDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? gender = null,
    Object? status = null,
    Object? notes = freezed,
    Object? targetWeight = freezed,
    Object? parityNumber = freezed,
    Object? serviceCount = freezed,
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
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sex: freezed == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      breed: null == breed
          ? _value.breed
          : breed // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: freezed == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      parityNumber: freezed == parityNumber
          ? _value.parityNumber
          : parityNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceCount: freezed == serviceCount
          ? _value.serviceCount
          : serviceCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnimalImplCopyWith<$Res> implements $AnimalCopyWith<$Res> {
  factory _$$AnimalImplCopyWith(
          _$AnimalImpl value, $Res Function(_$AnimalImpl) then) =
      __$$AnimalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'batch_id') String batchId,
      String identifier,
      @JsonKey(
          name: 'birth_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? birthDate,
      String? sex,
      @JsonKey(name: 'weight_at_entry') double? weight,
      String breed,
      @JsonKey(name: 'animal_type') String type,
      @JsonKey(
          name: 'entry_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? entryDate,
      @JsonKey(
          name: 'created_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      DateTime? updatedAt,
      String gender,
      String status,
      String? notes,
      @JsonKey(name: 'target_weight') double? targetWeight,
      @JsonKey(name: 'parity_number') int? parityNumber,
      @JsonKey(name: 'service_count') int? serviceCount});
}

/// @nodoc
class __$$AnimalImplCopyWithImpl<$Res>
    extends _$AnimalCopyWithImpl<$Res, _$AnimalImpl>
    implements _$$AnimalImplCopyWith<$Res> {
  __$$AnimalImplCopyWithImpl(
      _$AnimalImpl _value, $Res Function(_$AnimalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batchId = null,
    Object? identifier = null,
    Object? birthDate = freezed,
    Object? sex = freezed,
    Object? weight = freezed,
    Object? breed = null,
    Object? type = null,
    Object? entryDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? gender = null,
    Object? status = null,
    Object? notes = freezed,
    Object? targetWeight = freezed,
    Object? parityNumber = freezed,
    Object? serviceCount = freezed,
  }) {
    return _then(_$AnimalImpl(
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
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sex: freezed == sex
          ? _value.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      breed: null == breed
          ? _value.breed
          : breed // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: freezed == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      parityNumber: freezed == parityNumber
          ? _value.parityNumber
          : parityNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceCount: freezed == serviceCount
          ? _value.serviceCount
          : serviceCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimalImpl implements _Animal {
  const _$AnimalImpl(
      {required this.id,
      @JsonKey(name: 'batch_id') required this.batchId,
      required this.identifier,
      @JsonKey(
          name: 'birth_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      this.birthDate,
      this.sex,
      @JsonKey(name: 'weight_at_entry') this.weight,
      required this.breed,
      @JsonKey(name: 'animal_type') required this.type,
      @JsonKey(
          name: 'entry_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      this.entryDate,
      @JsonKey(
          name: 'created_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      this.createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      this.updatedAt,
      this.gender = 'unknown',
      this.status = 'active',
      this.notes,
      @JsonKey(name: 'target_weight') this.targetWeight,
      @JsonKey(name: 'parity_number') this.parityNumber,
      @JsonKey(name: 'service_count') this.serviceCount});

  factory _$AnimalImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimalImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'batch_id')
  final String batchId;
  @override
  final String identifier;
// ID interno o número de arete
  @override
  @JsonKey(
      name: 'birth_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  final DateTime? birthDate;
  @override
  final String? sex;
  @override
  @JsonKey(name: 'weight_at_entry')
  final double? weight;
// Peso inicial
  @override
  final String breed;
  @override
  @JsonKey(name: 'animal_type')
  final String type;
// Tipo de animal (ej: cerdo de engorde, reproductor, etc)
  @override
  @JsonKey(
      name: 'entry_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  final DateTime? entryDate;
// Fecha de ingreso al lote
  @override
  @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  final DateTime? createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final String gender;
  @override
  @JsonKey()
  final String status;
// active, sold, deceased, removed
  @override
  final String? notes;
  @override
  @JsonKey(name: 'target_weight')
  final double? targetWeight;
  @override
  @JsonKey(name: 'parity_number')
  final int? parityNumber;
  @override
  @JsonKey(name: 'service_count')
  final int? serviceCount;

  @override
  String toString() {
    return 'Animal(id: $id, batchId: $batchId, identifier: $identifier, birthDate: $birthDate, sex: $sex, weight: $weight, breed: $breed, type: $type, entryDate: $entryDate, createdAt: $createdAt, updatedAt: $updatedAt, gender: $gender, status: $status, notes: $notes, targetWeight: $targetWeight, parityNumber: $parityNumber, serviceCount: $serviceCount)';
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
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.parityNumber, parityNumber) ||
                other.parityNumber == parityNumber) &&
            (identical(other.serviceCount, serviceCount) ||
                other.serviceCount == serviceCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      batchId,
      identifier,
      birthDate,
      sex,
      weight,
      breed,
      type,
      entryDate,
      createdAt,
      updatedAt,
      gender,
      status,
      notes,
      targetWeight,
      parityNumber,
      serviceCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalImplCopyWith<_$AnimalImpl> get copyWith =>
      __$$AnimalImplCopyWithImpl<_$AnimalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimalImplToJson(
      this,
    );
  }
}

abstract class _Animal implements Animal {
  const factory _Animal(
      {required final String id,
      @JsonKey(name: 'batch_id') required final String batchId,
      required final String identifier,
      @JsonKey(
          name: 'birth_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      final DateTime? birthDate,
      final String? sex,
      @JsonKey(name: 'weight_at_entry') final double? weight,
      required final String breed,
      @JsonKey(name: 'animal_type') required final String type,
      @JsonKey(
          name: 'entry_date',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      final DateTime? entryDate,
      @JsonKey(
          name: 'created_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      final DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _nullableDateFromString,
          toJson: _nullableDateToString)
      final DateTime? updatedAt,
      final String gender,
      final String status,
      final String? notes,
      @JsonKey(name: 'target_weight') final double? targetWeight,
      @JsonKey(name: 'parity_number') final int? parityNumber,
      @JsonKey(name: 'service_count') final int? serviceCount}) = _$AnimalImpl;

  factory _Animal.fromJson(Map<String, dynamic> json) = _$AnimalImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'batch_id')
  String get batchId;
  @override
  String get identifier;
  @override // ID interno o número de arete
  @JsonKey(
      name: 'birth_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get birthDate;
  @override
  String? get sex;
  @override
  @JsonKey(name: 'weight_at_entry')
  double? get weight;
  @override // Peso inicial
  String get breed;
  @override
  @JsonKey(name: 'animal_type')
  String get type;
  @override // Tipo de animal (ej: cerdo de engorde, reproductor, etc)
  @JsonKey(
      name: 'entry_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get entryDate;
  @override // Fecha de ingreso al lote
  @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString)
  DateTime? get updatedAt;
  @override
  String get gender;
  @override
  String get status;
  @override // active, sold, deceased, removed
  String? get notes;
  @override
  @JsonKey(name: 'target_weight')
  double? get targetWeight;
  @override
  @JsonKey(name: 'parity_number')
  int? get parityNumber;
  @override
  @JsonKey(name: 'service_count')
  int? get serviceCount;
  @override
  @JsonKey(ignore: true)
  _$$AnimalImplCopyWith<_$AnimalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
