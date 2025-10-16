import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal.freezed.dart';
part 'animal.g.dart';

DateTime? _nullableDateFromString(String? date) =>
    date == null ? null : DateTime.parse(date);
String? _nullableDateToString(DateTime? date) => date?.toIso8601String();

DateTime _dateFromString(String date) => DateTime.parse(date);
String _dateToString(DateTime date) => date.toIso8601String();

@freezed
class Animal with _$Animal {
  factory Animal({
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
  }) = _Animal;

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);
}
