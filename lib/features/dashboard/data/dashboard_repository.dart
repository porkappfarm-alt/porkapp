import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/dashboard/data/models/batch_summary.dart';
import 'package:porkapp/features/dashboard/data/models/chart_data.dart';
import 'package:porkapp/features/dashboard/data/models/dashboard_alert.dart';
import 'package:porkapp/features/dashboard/data/models/dashboard_kpis.dart';
import 'package:porkapp/supabase/providers/supabase_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository para obtener datos del dashboard desde Supabase
class DashboardRepository {
  final SupabaseClient _supabase;

  DashboardRepository(this._supabase);

  /// Obtiene todos los KPIs principales del dashboard
  Future<DashboardKPIs> getKPIs() async {
    try {
      // Query 1: Total de animales activos por tipo
      final animalsData = await _supabase
          .from('animals')
          .select('id, animal_type, status, entry_date')
          .eq('status', 'active');

      // Calcular totales y distribución por tipo
      final totalActiveAnimals = animalsData.length;
      final animalsByType = <String, int>{};

      for (final animal in animalsData) {
        final type = animal['animal_type'] as String? ?? 'unknown';
        animalsByType[type] = (animalsByType[type] ?? 0) + 1;
      }

      // Query 2: Información de corrales
      final corralsData =
          await _supabase.from('corrals').select('status, capacity');

      final corralOccupancy = _calculateCorralOccupancy(corralsData);

      // Query 3: Peso promedio actual (última biometría de cada animal activo)
      // Primero obtenemos los IDs de animales activos
      final activeAnimalIds = animalsData
          .map((a) => a['id'] as String?)
          .where((id) => id != null)
          .toList();

      double currentAvgWeight = 0.0;
      if (activeAnimalIds.isNotEmpty) {
        final biometricsData = await _supabase
            .from('biometric_measurements')
            .select('animal_id, weight, created_at')
            .inFilter('animal_id', activeAnimalIds)
            .order('created_at', ascending: false);

        if (biometricsData.isNotEmpty) {
          // Obtener el peso más reciente por animal
          final latestWeights = <String, double>{};
          for (final record in biometricsData) {
            final animalId = record['animal_id'] as String?;
            final weight = (record['weight'] as num?)?.toDouble();
            if (animalId != null &&
                weight != null &&
                !latestWeights.containsKey(animalId)) {
              latestWeights[animalId] = weight;
            }
          }
          if (latestWeights.isNotEmpty) {
            currentAvgWeight = latestWeights.values.reduce((a, b) => a + b) /
                latestWeights.length;
          }
        }
      }

      // Query 4: ADG promedio de lotes activos
      final batchesData = await _supabase
          .from('batches')
          .select('id, entry_date, status')
          .eq('status', 'active');

      double avgADG = 0.0;
      if (batchesData.isNotEmpty) {
        final adgValues = <double>[];
        for (final batch in batchesData) {
          final batchId = batch['id'] as String?;
          if (batchId != null) {
            final batchBiometrics = await _supabase
                .from('batch_biometrics')
                .select('avg_adg')
                .eq('batch_id', batchId)
                .order('measurement_date', ascending: false)
                .limit(1);

            if (batchBiometrics.isNotEmpty) {
              final adg =
                  (batchBiometrics.first['avg_adg'] as num?)?.toDouble();
              if (adg != null && adg > 0) {
                adgValues.add(adg);
              }
            }
          }
        }
        if (adgValues.isNotEmpty) {
          avgADG = adgValues.reduce((a, b) => a + b) / adgValues.length;
        }
      }

      // Query 5: Tasa de mortalidad del mes actual
      final mortalityRate = await _calculateMortalityRate();

      // Query 6: Días promedio en granja (calculado desde entry_date)
      int avgDaysInFarm = 0;
      if (animalsData.isNotEmpty) {
        final now = DateTime.now();
        final daysValues = <int>[];
        for (final animal in animalsData) {
          final entryDate = animal['entry_date'] as String?;
          if (entryDate != null) {
            final entry = DateTime.parse(entryDate);
            final days = now.difference(entry).inDays;
            if (days >= 0) {
              daysValues.add(days);
            }
          }
        }
        if (daysValues.isNotEmpty) {
          avgDaysInFarm =
              (daysValues.reduce((a, b) => a + b) / daysValues.length).round();
        }
      }

      return DashboardKPIs(
        totalActiveAnimals: totalActiveAnimals,
        animalsByType: animalsByType,
        corralOccupancy: corralOccupancy,
        currentAvgWeight: currentAvgWeight,
        avgADG: avgADG,
        mortalityRate: mortalityRate,
        avgDaysInFarm: avgDaysInFarm,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error al obtener KPIs del dashboard: $e');
    }
  }

  /// Calcula la ocupación de corrales
  CorralOccupancy _calculateCorralOccupancy(List<dynamic> corralsData) {
    int totalCorrals = corralsData.length;
    int occupiedCorrals = 0;
    int availableCorrals = 0;
    int maintenanceCorrals = 0;
    int totalCapacity = 0;

    for (final corral in corralsData) {
      final status = corral['status'] as String?;
      final capacity = (corral['capacity'] as num?)?.toInt() ?? 0;

      totalCapacity += capacity;

      switch (status) {
        case 'ocupado':
          occupiedCorrals++;
          break;
        case 'disponible':
          availableCorrals++;
          break;
        case 'mantenimiento':
          maintenanceCorrals++;
          break;
      }
    }

    // Calcular animales actuales
    int currentAnimals = 0;
    // Nota: Esto se puede optimizar con una query más eficiente
    // Por ahora, usamos la suma de animal_count de los batches activos

    double occupancyPercentage =
        totalCapacity > 0 ? (currentAnimals / totalCapacity * 100) : 0.0;

    return CorralOccupancy(
      totalCorrals: totalCorrals,
      occupiedCorrals: occupiedCorrals,
      availableCorrals: availableCorrals,
      maintenanceCorrals: maintenanceCorrals,
      totalCapacity: totalCapacity,
      currentAnimals: currentAnimals,
      occupancyPercentage: occupancyPercentage,
    );
  }

  /// Calcula la tasa de mortalidad del mes actual
  Future<double> _calculateMortalityRate() async {
    try {
      final firstDayOfMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );

      // Eventos de mortalidad del mes
      final mortalityEvents = await _supabase
          .from('animal_events')
          .select('id')
          .eq('type', 'mortality')
          .gte('event_date', firstDayOfMonth.toIso8601String());

      // Total de animales activos al inicio del mes
      final totalAnimals =
          await _supabase.from('animals').select('id').eq('status', 'active');

      if (totalAnimals.isEmpty) return 0.0;

      return (mortalityEvents.length / totalAnimals.length) * 100;
    } catch (e) {
      return 0.0;
    }
  }

  /// Obtiene las alertas del dashboard
  Future<List<DashboardAlert>> getAlerts() async {
    try {
      final alerts = <DashboardAlert>[];

      // Alerta 1: Lotes sin biometría reciente (>14 días)
      final batchesWithoutBiometry = await _getBatchesWithoutRecentBiometry();
      if (batchesWithoutBiometry.isNotEmpty) {
        alerts.add(DashboardAlert(
          id: 'missing_biometry_${DateTime.now().millisecondsSinceEpoch}',
          severity: AlertSeverity.critical,
          type: AlertType.missingBiometry,
          title: 'Lotes sin biometría reciente',
          description:
              '${batchesWithoutBiometry.length} lote(s) no tienen biometría en más de 14 días',
          affectedCount: batchesWithoutBiometry.length,
          actionRoute: '/batches',
          createdAt: DateTime.now(),
        ));
      }

      // Alerta 2: Corrales cerca de capacidad máxima (>90%)
      final corralsNearCapacity = await _getCorralsNearCapacity();
      if (corralsNearCapacity.isNotEmpty) {
        alerts.add(DashboardAlert(
          id: 'corral_capacity_${DateTime.now().millisecondsSinceEpoch}',
          severity: AlertSeverity.warning,
          type: AlertType.corralNearCapacity,
          title: 'Corrales cerca de capacidad',
          description:
              '${corralsNearCapacity.length} corral(es) están sobre el 90% de ocupación',
          affectedCount: corralsNearCapacity.length,
          actionRoute: '/corrals',
          createdAt: DateTime.now(),
        ));
      }

      // Alerta 3: Animales con bajo ADG (<0.5 kg/día)
      final lowPerformanceAnimals = await _getAnimalsWithLowADG();
      if (lowPerformanceAnimals.isNotEmpty) {
        alerts.add(DashboardAlert(
          id: 'low_adg_${DateTime.now().millisecondsSinceEpoch}',
          severity: AlertSeverity.warning,
          type: AlertType.lowPerformance,
          title: 'Animales con bajo rendimiento',
          description:
              '${lowPerformanceAnimals.length} animal(es) tienen ADG menor a 0.5 kg/día',
          affectedCount: lowPerformanceAnimals.length,
          actionRoute: '/batches',
          createdAt: DateTime.now(),
        ));
      }

      return alerts;
    } catch (e) {
      throw Exception('Error al obtener alertas: $e');
    }
  }

  /// Obtiene lotes sin biometría reciente
  Future<List<Map<String, dynamic>>> _getBatchesWithoutRecentBiometry() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 14));

      final result = await _supabase
          .from('batches')
          .select('id, name, animal_count')
          .eq('status', 'active');

      final batchesWithoutRecent = <Map<String, dynamic>>[];

      for (final batch in result) {
        final batchId = batch['id'] as String;

        final latestBiometry = await _supabase
            .from('batch_biometrics')
            .select('measurement_date')
            .eq('batch_id', batchId)
            .order('measurement_date', ascending: false)
            .limit(1);

        if (latestBiometry.isEmpty) {
          batchesWithoutRecent.add(batch);
        } else {
          final lastMeasurement = DateTime.parse(
            latestBiometry.first['measurement_date'] as String,
          );
          if (lastMeasurement.isBefore(cutoffDate)) {
            batchesWithoutRecent.add(batch);
          }
        }
      }

      return batchesWithoutRecent;
    } catch (e) {
      return [];
    }
  }

  /// Obtiene corrales cerca de capacidad
  Future<List<Map<String, dynamic>>> _getCorralsNearCapacity() async {
    try {
      // Esta query necesita ser optimizada con una vista o función en la BD
      final corrals = await _supabase
          .from('corrals')
          .select('id, name, capacity, status')
          .eq('status', 'ocupado');

      final corralsNear = <Map<String, dynamic>>[];

      for (final corral in corrals) {
        final capacity = (corral['capacity'] as num?)?.toInt() ?? 0;
        if (capacity == 0) continue;

        // Contar animales en el corral
        final corralId = corral['id'] as String;
        final batches = await _supabase
            .from('batches')
            .select('animal_count')
            .eq('corral_id', corralId)
            .eq('status', 'active');

        int totalAnimals = 0;
        for (final batch in batches) {
          totalAnimals += (batch['animal_count'] as num?)?.toInt() ?? 0;
        }

        final occupancyPct = (totalAnimals / capacity) * 100;
        if (occupancyPct > 90) {
          corralsNear.add({
            ...corral,
            'current_animals': totalAnimals,
            'occupancy_pct': occupancyPct,
          });
        }
      }

      return corralsNear;
    } catch (e) {
      return [];
    }
  }

  /// Obtiene animales con bajo ADG
  Future<List<Map<String, dynamic>>> _getAnimalsWithLowADG() async {
    try {
      final result = await _supabase
          .from('biometric_measurements')
          .select('animal_id, adg, animals(identifier, batch_id)')
          .lt('adg', 0.5)
          .order('created_at', ascending: false);

      // Filtrar para obtener solo la última medición de cada animal
      final seenAnimals = <String>{};
      final lowADGAnimals = <Map<String, dynamic>>[];

      for (final measurement in result) {
        final animalId = measurement['animal_id'] as String;
        if (!seenAnimals.contains(animalId)) {
          seenAnimals.add(animalId);
          lowADGAnimals.add(measurement);
        }
      }

      return lowADGAnimals;
    } catch (e) {
      return [];
    }
  }

  /// Obtiene resumen de los últimos 3 lotes activos
  Future<List<BatchSummary>> getBatchSummaries({int limit = 3}) async {
    try {
      final batches = await _supabase
          .from('batches')
          .select('''
            id,
            name,
            entry_date,
            animal_count,
            initial_avg_weight,
            status,
            corrals(name)
          ''')
          .eq('status', 'active')
          .order('entry_date', ascending: false)
          .limit(limit);

      final summaries = <BatchSummary>[];

      for (final batch in batches) {
        final batchId = batch['id'] as String;
        final entryDate = DateTime.parse(batch['entry_date'] as String);
        final daysInFarm = DateTime.now().difference(entryDate).inDays;

        // Obtener última biometría del lote
        final latestBiometry = await _supabase
            .from('batch_biometrics')
            .select('avg_weight, avg_adg')
            .eq('batch_id', batchId)
            .order('measurement_date', ascending: false)
            .limit(1);

        double? currentAvgWeight;
        double? avgADG;

        if (latestBiometry.isNotEmpty) {
          currentAvgWeight =
              (latestBiometry.first['avg_weight'] as num?)?.toDouble();
          avgADG = (latestBiometry.first['avg_adg'] as num?)?.toDouble();
        }

        final initialWeight =
            (batch['initial_avg_weight'] as num?)?.toDouble() ?? 0.0;
        const targetWeight = 120.0;

        double progressToTarget = 0.0;
        if (currentAvgWeight != null && initialWeight > 0) {
          progressToTarget = ((currentAvgWeight - initialWeight) /
                  (targetWeight - initialWeight)) *
              100;
          progressToTarget = progressToTarget.clamp(0.0, 100.0);
        }

        final corralData = batch['corrals'];
        final corralName = corralData != null && corralData is Map
            ? (corralData['name'] as String? ?? 'Sin corral')
            : 'Sin corral';

        summaries.add(BatchSummary(
          id: batchId,
          name: batch['name'] as String,
          corralName: corralName,
          animalCount: (batch['animal_count'] as num?)?.toInt() ?? 0,
          daysInFarm: daysInFarm,
          initialAvgWeight: initialWeight,
          currentAvgWeight: currentAvgWeight,
          avgADG: avgADG,
          progressToTarget: progressToTarget,
          targetWeight: targetWeight,
          entryDate: entryDate,
          status: batch['status'] as String? ?? 'active',
        ));
      }

      return summaries;
    } catch (e) {
      throw Exception('Error al obtener resúmenes de lotes: $e');
    }
  }

  /// Obtiene datos de tendencia de peso para los últimos N días
  Future<List<WeightDataPoint>> getWeightTrendData({int days = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final result = await _supabase
          .from('batch_biometrics')
          .select('measurement_date, avg_weight, animals_measured')
          .gte('measurement_date', cutoffDate.toIso8601String())
          .eq('status', 'active')
          .order('measurement_date');

      // Agrupar por día y calcular promedio
      final dataByDay = <DateTime, List<double>>{};
      final countByDay = <DateTime, int>{};

      for (final record in result) {
        final date = DateTime.parse(record['measurement_date'] as String);
        final dateOnly = DateTime(date.year, date.month, date.day);
        final weight = (record['avg_weight'] as num?)?.toDouble() ?? 0.0;
        final count = (record['animals_measured'] as num?)?.toInt() ?? 0;

        dataByDay.putIfAbsent(dateOnly, () => []).add(weight);
        countByDay[dateOnly] = (countByDay[dateOnly] ?? 0) + count;
      }

      final dataPoints = <WeightDataPoint>[];
      for (final entry in dataByDay.entries) {
        final avgWeight =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
        dataPoints.add(WeightDataPoint(
          date: entry.key,
          avgWeight: avgWeight,
          animalsMeasured: countByDay[entry.key],
        ));
      }

      dataPoints.sort((a, b) => a.date.compareTo(b.date));
      return dataPoints;
    } catch (e) {
      throw Exception('Error al obtener datos de tendencia: $e');
    }
  }

  /// Obtiene datos de comparación de ADG entre lotes
  Future<List<ADGComparisonData>> getADGComparisonData() async {
    try {
      final batches = await _supabase
          .from('batches')
          .select('id, name, animal_count')
          .eq('status', 'active')
          .order('entry_date', ascending: false)
          .limit(5);

      final comparisonData = <ADGComparisonData>[];
      final colors = [
        '#6B0338',
        '#8B1548',
        '#AB2758',
        '#CB3968',
        '#EB4B78',
      ];

      for (var i = 0; i < batches.length; i++) {
        final batch = batches[i];
        final batchId = batch['id'] as String;

        final latestBiometry = await _supabase
            .from('batch_biometrics')
            .select('avg_adg')
            .eq('batch_id', batchId)
            .order('measurement_date', ascending: false)
            .limit(1);

        if (latestBiometry.isNotEmpty) {
          final adg =
              (latestBiometry.first['avg_adg'] as num?)?.toDouble() ?? 0.0;

          comparisonData.add(ADGComparisonData(
            batchName: batch['name'] as String,
            adg: adg,
            color: colors[i % colors.length],
            animalCount: (batch['animal_count'] as num?)?.toInt() ?? 0,
          ));
        }
      }

      return comparisonData;
    } catch (e) {
      throw Exception('Error al obtener comparación de ADG: $e');
    }
  }
}

/// Provider del repository
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return DashboardRepository(supabase);
});
