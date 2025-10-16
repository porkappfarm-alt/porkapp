import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:porkapp/features/animals/domain/animal.dart';

part 'batch.freezed.dart';
part 'batch.g.dart';

List<Animal> _animalsFromJson(List<dynamic>? json) {
  if (json == null) return [];
  return json.map((x) => Animal.fromJson(x as Map<String, dynamic>)).toList();
}

List<Map<String, dynamic>> _animalsToJson(List<Animal> animals) {
  return animals.map((x) => x.toJson()).toList();
}

@freezed
class Batch with _$Batch {
  factory Batch({
    required String id,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'headcount_start') @Default(0) int headcountStart,
    @JsonKey(name: 'corral_id') String? corralId,
    @JsonKey(name: 'initial_avg_weight') double? initialAvgWeight,
    @Default('active') String status,
    String? notes,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(
      fromJson: _animalsFromJson,
      toJson: _animalsToJson,
    )
    @Default([])
    List<Animal> animals,
  }) = _Batch;

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);
}
