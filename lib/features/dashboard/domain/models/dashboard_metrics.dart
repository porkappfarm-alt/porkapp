// Modelo para las métricas de corrales
class CorralMetrics {
  final int activeCount;
  final double occupancyRate;
  final double monthlyChange;
  final DateTime lastUpdated;

  const CorralMetrics({
    required this.activeCount,
    required this.occupancyRate,
    required this.monthlyChange,
    required this.lastUpdated,
  });

  factory CorralMetrics.empty() => CorralMetrics(
    activeCount: 0,
    occupancyRate: 0,
    monthlyChange: 0,
    lastUpdated: DateTime.now(),
  );
}

// Modelo para las métricas de lotes
class BatchMetrics {
  final int activeCount;
  final String generalStatus;
  final int endingSoon;
  final DateTime lastUpdated;

  const BatchMetrics({
    required this.activeCount,
    required this.generalStatus,
    required this.endingSoon,
    required this.lastUpdated,
  });

  factory BatchMetrics.empty() => BatchMetrics(
    activeCount: 0,
    generalStatus: 'Sin datos',
    endingSoon: 0,
    lastUpdated: DateTime.now(),
  );
}

// Modelo para las métricas de población
class PopulationMetrics {
  final int totalCount;
  final Map<String, int> statusDistribution;
  final int dailyEntries;
  final int dailyExits;
  final DateTime lastUpdated;

  const PopulationMetrics({
    required this.totalCount,
    required this.statusDistribution,
    required this.dailyEntries,
    required this.dailyExits,
    required this.lastUpdated,
  });

  factory PopulationMetrics.empty() => PopulationMetrics(
    totalCount: 0,
    statusDistribution: const {},
    dailyEntries: 0,
    dailyExits: 0,
    lastUpdated: DateTime.now(),
  );
}

// Modelo para las métricas de peso
class WeightMetrics {
  final double averageWeight;
  final double dailyGain;
  final String weeklyTrend;
  final DateTime lastUpdated;

  const WeightMetrics({
    required this.averageWeight,
    required this.dailyGain,
    required this.weeklyTrend,
    required this.lastUpdated,
  });

  factory WeightMetrics.empty() => WeightMetrics(
    averageWeight: 0,
    dailyGain: 0,
    weeklyTrend: 'Sin datos',
    lastUpdated: DateTime.now(),
  );
}
