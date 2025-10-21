import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch_statistics.freezed.dart';
part 'batch_statistics.g.dart';

@freezed
class BatchStatistics with _$BatchStatistics {
  const factory BatchStatistics({
    required double avgWeight,
    required double avgAdg,
    required double minWeight,
    required double maxWeight,
    required double weightStdDev,
    required double uniformityPercent,
  }) = _BatchStatistics;

  factory BatchStatistics.fromJson(Map<String, dynamic> json) =>
      _$BatchStatisticsFromJson(json);
}
