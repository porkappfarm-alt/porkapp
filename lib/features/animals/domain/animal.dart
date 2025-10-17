import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal.freezed.dart';
part 'animal.g.dart';

DateTime? _nullableDateFromString(String? date) =>
    date == null ? null : DateTime.parse(date);
String? _nullableDateToString(DateTime? date) => date?.toIso8601String();

@freezed
class Animal with _$Animal {
  const factory Animal({
    required String id,
    @JsonKey(name: 'batch_id') required String batchId,
    required String identifier, // ID interno o número de arete
    @JsonKey(
      name: 'birth_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? birthDate,
    String? sex,
    @JsonKey(name: 'weight_at_entry') double? weight, // Peso inicial
    required String breed,
    @JsonKey(name: 'animal_type')
    required String
        type, // Tipo de animal (ej: cerdo de engorde, reproductor, etc)
    @JsonKey(
      name: 'entry_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? entryDate, // Fecha de ingreso al lote
    @JsonKey(
      name: 'created_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? updatedAt,
    @Default('unknown') String gender,
    @Default('active') String status, // active, sold, deceased, removed
    String? notes,

    // Campos específicos por tipo
    @JsonKey(name: 'target_weight') double? targetWeight,
    @JsonKey(
      name: 'estimated_sale_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? estimatedSaleDate,
    @JsonKey(name: 'parity_number') int? parityNumber,
    @JsonKey(
      name: 'last_farrowing_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? lastFarrowingDate,
    @JsonKey(name: 'total_born_alive') int? totalBornAlive,
    @JsonKey(name: 'service_count') int? serviceCount,
    @JsonKey(
      name: 'last_service_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? lastServiceDate,
    @JsonKey(
      name: 'weaning_date',
      fromJson: _nullableDateFromString,
      toJson: _nullableDateToString,
    )
    DateTime? weaningDate,
    @JsonKey(name: 'birth_weight') double? birthWeight,
  }) = _Animal;

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);
}
