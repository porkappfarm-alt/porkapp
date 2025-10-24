import 'dart:math' as math;
import '../batch_measurement.dart';
import '../animal_measurement.dart';

class BiometricStatistics {
  /// Calcula estadísticas básicas para un lote de mediciones
  static BiometricStats calculateBatchStats(BatchMeasurement measurement) {
    if (measurement.measurements.isEmpty) {
      return BiometricStats.empty();
    }

    final weights = measurement.measurements.map((m) => m.weight).toList();
    weights.sort();

    final mean = weights.reduce((a, b) => a + b) / weights.length;
    final median = _calculateMedian(weights);
    final stdDev = _calculateStdDev(weights, mean);
    final min = weights.first;
    final max = weights.last;

    final adgs = measurement.measurements
        .where((m) => m.adg != null)
        .map((m) => m.adg!)
        .toList();

    double? avgAdg;
    if (adgs.isNotEmpty) {
      avgAdg = adgs.reduce((a, b) => a + b) / adgs.length;
    }

    return BiometricStats(
      meanWeight: mean,
      medianWeight: median,
      standardDeviation: stdDev,
      minWeight: min,
      maxWeight: max,
      averageAdg: avgAdg,
      sampleSize: weights.length,
      coefficientOfVariation: (stdDev / mean) * 100,
    );
  }

  /// Calcula la mediana de una lista ordenada de pesos
  static double _calculateMedian(List<double> sortedWeights) {
    if (sortedWeights.isEmpty) return 0;
    if (sortedWeights.length % 2 == 0) {
      final mid = sortedWeights.length ~/ 2;
      return (sortedWeights[mid - 1] + sortedWeights[mid]) / 2;
    } else {
      return sortedWeights[sortedWeights.length ~/ 2];
    }
  }

  /// Calcula la desviación estándar
  static double _calculateStdDev(List<double> weights, double mean) {
    if (weights.length <= 1) return 0;
    final sumSquaredDiffs = weights.fold<double>(
      0,
      (sum, weight) => sum + math.pow(weight - mean, 2),
    );
    return math.sqrt(sumSquaredDiffs / (weights.length - 1));
  }

  /// Proyecta el peso futuro basado en el ADG actual
  static double projectFutureWeight(
    double currentWeight,
    double adg,
    int daysToProject,
  ) {
    return currentWeight + (adg * daysToProject);
  }

  /// Calcula los percentiles de peso para un conjunto de mediciones
  static Map<int, double> calculateWeightPercentiles(
    List<AnimalMeasurement> measurements,
    List<int> percentiles,
  ) {
    if (measurements.isEmpty) return {};

    final weights = measurements.map((m) => m.weight).toList()..sort();
    final result = <int, double>{};

    for (final percentile in percentiles) {
      if (percentile < 0 || percentile > 100) continue;
      final index = ((weights.length - 1) * percentile / 100).round();
      result[percentile] = weights[index];
    }

    return result;
  }
}

/// Clase para almacenar las estadísticas calculadas
class BiometricStats {
  final double meanWeight;
  final double medianWeight;
  final double standardDeviation;
  final double minWeight;
  final double maxWeight;
  final double? averageAdg;
  final int sampleSize;
  final double coefficientOfVariation;

  const BiometricStats({
    required this.meanWeight,
    required this.medianWeight,
    required this.standardDeviation,
    required this.minWeight,
    required this.maxWeight,
    required this.averageAdg,
    required this.sampleSize,
    required this.coefficientOfVariation,
  });

  factory BiometricStats.empty() {
    return const BiometricStats(
      meanWeight: 0,
      medianWeight: 0,
      standardDeviation: 0,
      minWeight: 0,
      maxWeight: 0,
      averageAdg: null,
      sampleSize: 0,
      coefficientOfVariation: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meanWeight': meanWeight,
      'medianWeight': medianWeight,
      'standardDeviation': standardDeviation,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'averageAdg': averageAdg,
      'sampleSize': sampleSize,
      'coefficientOfVariation': coefficientOfVariation,
    };
  }
}
