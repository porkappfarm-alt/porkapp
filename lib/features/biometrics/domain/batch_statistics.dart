/// Modelo de BatchStatistics - Convertido de freezed a clase plana
class BatchStatistics {
  final double avgWeight;
  final double avgAdg;
  final double minWeight;
  final double maxWeight;
  final double weightStdDev;
  final double uniformityPercent;

  const BatchStatistics({
    required this.avgWeight,
    required this.avgAdg,
    required this.minWeight,
    required this.maxWeight,
    required this.weightStdDev,
    required this.uniformityPercent,
  });

  factory BatchStatistics.fromJson(Map<String, dynamic> json) {
    return BatchStatistics(
      avgWeight: (json['avg_weight'] as num).toDouble(),
      avgAdg: (json['avg_adg'] as num).toDouble(),
      minWeight: (json['min_weight'] as num).toDouble(),
      maxWeight: (json['max_weight'] as num).toDouble(),
      weightStdDev: (json['weight_std_dev'] as num).toDouble(),
      uniformityPercent: (json['uniformity_percent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avg_weight': avgWeight,
      'avg_adg': avgAdg,
      'min_weight': minWeight,
      'max_weight': maxWeight,
      'weight_std_dev': weightStdDev,
      'uniformity_percent': uniformityPercent,
    };
  }

  BatchStatistics copyWith({
    double? avgWeight,
    double? avgAdg,
    double? minWeight,
    double? maxWeight,
    double? weightStdDev,
    double? uniformityPercent,
  }) {
    return BatchStatistics(
      avgWeight: avgWeight ?? this.avgWeight,
      avgAdg: avgAdg ?? this.avgAdg,
      minWeight: minWeight ?? this.minWeight,
      maxWeight: maxWeight ?? this.maxWeight,
      weightStdDev: weightStdDev ?? this.weightStdDev,
      uniformityPercent: uniformityPercent ?? this.uniformityPercent,
    );
  }
}
