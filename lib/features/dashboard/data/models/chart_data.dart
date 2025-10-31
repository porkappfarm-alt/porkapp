/// Punto de datos para el gráfico de tendencia de peso
class WeightDataPoint {
  /// Fecha de la medición
  final DateTime date;

  /// Peso promedio en ese día (kg)
  final double avgWeight;

  /// Cantidad de animales medidos ese día
  final int? animalsMeasured;

  const WeightDataPoint({
    required this.date,
    required this.avgWeight,
    this.animalsMeasured,
  });
}

/// Datos para el gráfico comparativo de ADG por lote
class ADGComparisonData {
  /// Nombre del lote
  final String batchName;

  /// ADG del lote (kg/día)
  final double adg;

  /// Color para el gráfico (hex string)
  final String color;

  /// Cantidad de animales en el lote
  final int animalCount;

  const ADGComparisonData({
    required this.batchName,
    required this.adg,
    required this.color,
    required this.animalCount,
  });
}

/// Distribución de pesos para histograma
class WeightDistribution {
  /// Rango mínimo del bucket (kg)
  final double minWeight;

  /// Rango máximo del bucket (kg)
  final double maxWeight;

  /// Cantidad de animales en este rango
  final int count;

  /// Porcentaje del total
  final double percentage;

  const WeightDistribution({
    required this.minWeight,
    required this.maxWeight,
    required this.count,
    required this.percentage,
  });
}

/// Estadísticas generales de peso para complementar los gráficos
class WeightStatistics {
  /// Peso mínimo registrado (kg)
  final double minWeight;

  /// Peso máximo registrado (kg)
  final double maxWeight;

  /// Peso promedio (kg)
  final double avgWeight;

  /// Desviación estándar
  final double stdDev;

  /// Mediana
  final double median;

  /// Total de animales medidos
  final int totalAnimals;

  const WeightStatistics({
    required this.minWeight,
    required this.maxWeight,
    required this.avgWeight,
    required this.stdDev,
    required this.median,
    required this.totalAnimals,
  });
}
