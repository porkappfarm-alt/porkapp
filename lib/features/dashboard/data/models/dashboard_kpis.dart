/// Modelo que contiene todos los KPIs principales del dashboard
class DashboardKPIs {
  /// Total de animales activos en la granja
  final int totalActiveAnimals;

  /// Distribución de animales por tipo (fattening, breeding, etc.)
  final Map<String, int> animalsByType;

  /// Información de ocupación de corrales
  final CorralOccupancy corralOccupancy;

  /// Peso promedio actual de todos los animales (kg)
  final double currentAvgWeight;

  /// Ganancia diaria promedio (Average Daily Gain) en kg/día
  final double avgADG;

  /// Tasa de mortalidad del mes actual (porcentaje)
  final double mortalityRate;

  /// Promedio de días que llevan los animales en la granja
  final int avgDaysInFarm;

  /// Fecha y hora de la última actualización
  final DateTime lastUpdated;

  const DashboardKPIs({
    required this.totalActiveAnimals,
    required this.animalsByType,
    required this.corralOccupancy,
    required this.currentAvgWeight,
    required this.avgADG,
    required this.mortalityRate,
    required this.avgDaysInFarm,
    required this.lastUpdated,
  });

  /// Factory para crear un KPI vacío (estado inicial)
  factory DashboardKPIs.empty() => DashboardKPIs(
        totalActiveAnimals: 0,
        animalsByType: const {},
        corralOccupancy: CorralOccupancy.empty(),
        currentAvgWeight: 0.0,
        avgADG: 0.0,
        mortalityRate: 0.0,
        avgDaysInFarm: 0,
        lastUpdated: DateTime.now(),
      );
}

/// Información sobre la ocupación de corrales
class CorralOccupancy {
  /// Total de corrales en la granja
  final int totalCorrals;

  /// Corrales actualmente ocupados
  final int occupiedCorrals;

  /// Corrales disponibles
  final int availableCorrals;

  /// Corrales en mantenimiento
  final int maintenanceCorrals;

  /// Capacidad total de todos los corrales
  final int totalCapacity;

  /// Animales actuales en todos los corrales
  final int currentAnimals;

  /// Porcentaje de ocupación (0-100)
  final double occupancyPercentage;

  const CorralOccupancy({
    required this.totalCorrals,
    required this.occupiedCorrals,
    required this.availableCorrals,
    required this.maintenanceCorrals,
    required this.totalCapacity,
    required this.currentAnimals,
    required this.occupancyPercentage,
  });

  factory CorralOccupancy.empty() => const CorralOccupancy(
        totalCorrals: 0,
        occupiedCorrals: 0,
        availableCorrals: 0,
        maintenanceCorrals: 0,
        totalCapacity: 0,
        currentAnimals: 0,
        occupancyPercentage: 0.0,
      );
}
