import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal.freezed.dart';
part 'animal.g.dart';

@freezed
class Animal with _$Animal {
  factory Animal({
    required String id,
    @JsonKey(name: 'batch_id') required String batchId,
    required String identifier,
    @JsonKey(name: 'birth_date') required DateTime birthDate,
    required double weight,
    required String breed,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default('active') String status,
  }) = _Animal;

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);
}
