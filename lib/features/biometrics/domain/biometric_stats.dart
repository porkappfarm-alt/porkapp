import 'package:freezed_annotation/freezed_annotation.dart';

part 'biometric_stats.freezed.dart';
part 'biometric_stats.g.dart';

@freezed
class BiometricStats with _$BiometricStats {
  const factory BiometricStats({
    required double adg,
    required double fcr,
    required double mortalityRate,
    required List<MortalityByCause> mortalityByCause,
    required List<WeightPoint> weightTimeline,
  }) = _BiometricStats;

  factory BiometricStats.fromJson(Map<String, dynamic> json) =>
      _$BiometricStatsFromJson(json);
}

@freezed
class MortalityByCause with _$MortalityByCause {
  const factory MortalityByCause({required String cause, required int count}) =
      _MortalityByCause;

  factory MortalityByCause.fromJson(Map<String, dynamic> json) =>
      _$MortalityByCauseFromJson(json);
}

@freezed
class WeightPoint with _$WeightPoint {
  const factory WeightPoint({
    required DateTime date,
    required double avgWeight,
  }) = _WeightPoint;

  factory WeightPoint.fromJson(Map<String, dynamic> json) =>
      _$WeightPointFromJson(json);
}
