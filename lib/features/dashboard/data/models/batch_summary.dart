/// Resumen de un lote para mostrar en el dashboard
class BatchSummary {
  /// ID del lote
  final String id;

  /// Nombre del lote
  final String name;

  /// Nombre del corral asociado
  final String corralName;

  /// Cantidad de animales en el lote
  final int animalCount;

  /// Cantidad de días que el lote lleva en la granja
  final int daysInFarm;

  /// Peso promedio inicial del lote (kg)
  final double? initialAvgWeight;

  /// Peso promedio actual del lote (kg)
  final double? currentAvgWeight;

  /// Ganancia diaria promedio del lote (kg/día)
  final double? avgADG;

  /// Progreso hacia el peso objetivo (0-100%)
  final double progressToTarget;

  /// Peso objetivo estimado (kg)
  final double targetWeight;

  /// Fecha de entrada del lote
  final DateTime entryDate;

  /// Fecha estimada de venta (opcional)
  final DateTime? estimatedSaleDate;

  /// Estado del lote
  final String status;

  const BatchSummary({
    required this.id,
    required this.name,
    required this.corralName,
    required this.animalCount,
    required this.daysInFarm,
    this.initialAvgWeight,
    this.currentAvgWeight,
    this.avgADG,
    this.progressToTarget = 0.0,
    this.targetWeight = 120.0,
    required this.entryDate,
    this.estimatedSaleDate,
    this.status = 'active',
  });

  /// Calcula si el lote está próximo a la venta (< 14 días)
  bool get isNearSale {
    if (estimatedSaleDate == null) return false;
    final daysUntilSale = estimatedSaleDate!.difference(DateTime.now()).inDays;
    return daysUntilSale <= 14 && daysUntilSale > 0;
  }

  /// Calcula el color del progreso basado en el porcentaje
  String get progressColor {
    if (progressToTarget < 30) return '#EF4444'; // Rojo
    if (progressToTarget < 60) return '#F59E0B'; // Amarillo
    if (progressToTarget < 90) return '#3B82F6'; // Azul
    return '#10B981'; // Verde
  }

  /// Calcula si el ADG es bajo (< 0.5 kg/día)
  bool get hasLowADG {
    if (avgADG == null) return false;
    return avgADG! < 0.5;
  }

  /// Calcula si necesita una biometría pronto
  bool get needsBiometry {
    // Si han pasado más de 14 días sin actualizar el peso
    return currentAvgWeight == null || daysInFarm > 14;
  }
}
