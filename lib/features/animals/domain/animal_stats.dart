import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_stats.freezed.dart';
part 'animal_stats.g.dart';

@freezed
class AnimalStats with _$AnimalStats {
  const factory AnimalStats({
    // Ganancia de peso
    required double currentWeight,
    required double initialWeight,
    double? lastWeightGain, // kg/día desde última medición
    required double avgWeightGain, // kg/día promedio total
    // Edad
    required DateTime birthDate,
    required int ageInDays,

    // Mortalidad (si aplica al lote)
    int? initialCount,
    int? currentCount,
    double? mortalityRate, // Porcentaje
    // Métricas adicionales
    double? feedConversionRatio, // kg alimento / kg ganancia
    double? dailyFeedIntake, // kg/día
  }) = _AnimalStats;

  factory AnimalStats.fromJson(Map<String, dynamic> json) =>
      _$AnimalStatsFromJson(json);
}
