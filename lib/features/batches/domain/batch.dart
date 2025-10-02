import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch.freezed.dart';
part 'batch.g.dart';

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
  }) = _Batch;

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);
}
