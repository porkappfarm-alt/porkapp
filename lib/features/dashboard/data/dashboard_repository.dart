import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/data/batch_progress_service.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/domain/batch_progress.dart';
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
      for (final batch in batchesWithoutBiometry) {
        alerts.add(DashboardAlert(
          id: 'missing_biometry_${batch['id']}_${DateTime.now().millisecondsSinceEpoch}',
          severity: AlertSeverity.critical,
          type: AlertType.missingBiometry,
          title: 'Lote ${batch['name']}: Sin biometría reciente',
          description: 'No tiene registro de biometría en más de 14 días',
          affectedCount: 1,
          actionRoute: '/batches/${batch['id']}',
          createdAt: DateTime.now(),
        ));
      }

      // Alerta 2: Corrales cerca de capacidad máxima (>90%)
      final corralsNearCapacity = await _getCorralsNearCapacity();
      for (final corral in corralsNearCapacity) {
        final corralName = corral['name'] as String? ?? 'Desconocido';
        final occupancy = (corral['occupancy_pct'] as num?)?.toDouble() ?? 0.0;

        alerts.add(DashboardAlert(
          id: 'corral_capacity_${corral['id']}_${DateTime.now().millisecondsSinceEpoch}',
          severity: AlertSeverity.warning,
          type: AlertType.corralNearCapacity,
          title: 'Corral $corralName: Cerca de capacidad',
          description: 'Ocupación del ${occupancy.toStringAsFixed(0)}%',
          affectedCount: 1,
          actionRoute: '/corrals',
          createdAt: DateTime.now(),
        ));
      }

      // Alerta 3: Animales con bajo ADG (<0.5 kg/día)
      final lowPerformanceAnimals = await _getAnimalsWithLowADG();
      for (final animal in lowPerformanceAnimals) {
        final animalData = animal['animals'] as Map<String, dynamic>?;
        final batchId = animalData?['batch_id'] as String?;
        final identifier =
            animalData?['identifier'] as String? ?? 'Desconocido';
        final adg = (animal['adg'] as num?)?.toDouble() ?? 0.0;

        if (batchId != null) {
          alerts.add(DashboardAlert(
            id: 'low_adg_${animal['animal_id']}_${DateTime.now().millisecondsSinceEpoch}',
            severity: AlertSeverity.warning,
            type: AlertType.lowPerformance,
            title: 'Animal $identifier: Bajo rendimiento',
            description:
                'ADG de ${adg.toStringAsFixed(2)} kg/día (menor a 0.5 kg/día)',
            affectedCount: 1,
            actionRoute: '/batches/$batchId',
            createdAt: DateTime.now(),
          ));
        }
      }

      // Alerta 4: Lotes por debajo del peso objetivo
      final batchesBelowTarget = await _getBatchesBelowTargetWeight();
      for (final batch in batchesBelowTarget) {
        alerts.add(DashboardAlert(
          id: 'below_target_${batch['id']}_${DateTime.now().millisecondsSinceEpoch}',
          severity: AlertSeverity.warning,
          type: AlertType.belowTargetWeight,
          title: 'Lote ${batch['name']}: Por debajo del peso objetivo',
          description:
              'Peso actual: ${batch['current_weight']}kg vs ${batch['reference_weight']}kg esperado (${batch['progress_percentage']}%)',
          affectedCount: 1,
          actionRoute: '/batches/${batch['id']}',
          createdAt: DateTime.now(),
        ));
      }

      // Alerta 4b: Lotes por encima del peso objetivo
      final batchesAboveTarget = await _getBatchesAboveTargetWeight();
      for (final batch in batchesAboveTarget) {
        alerts.add(DashboardAlert(
          id: 'above_target_${batch['id']}_${DateTime.now().millisecondsSinceEpoch}',
          severity: AlertSeverity.info,
          type: AlertType.aboveTargetWeight,
          title: 'Lote ${batch['name']}: Por encima del peso objetivo',
          description:
              'Peso actual: ${batch['current_weight']}kg vs ${batch['reference_weight']}kg esperado (${batch['progress_percentage']}%)',
          affectedCount: 1,
          actionRoute: '/batches/${batch['id']}',
          createdAt: DateTime.now(),
        ));
      }

      // Alerta 5: Tareas programadas pendientes
      final scheduledTasks = await _getScheduledTaskAlerts();
      alerts.addAll(scheduledTasks);

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

  /// Obtiene lotes por debajo del peso objetivo según feeding_schedule
  Future<List<Map<String, dynamic>>> _getBatchesBelowTargetWeight() async {
    try {
      final batchProgressService = BatchProgressService(_supabase);

      // Obtener todos los lotes activos con birth_date
      final batchesData = await _supabase
          .from('batches')
          .select(
              'id, name, birth_date, created_at, entry_date, headcount_start, corral_id, initial_avg_weight, status, notes')
          .eq('status', 'active')
          .not('birth_date', 'is', null);

      final batchesBelowTarget = <Map<String, dynamic>>[];

      for (final batchData in batchesData) {
        try {
          // Convertir a modelo Batch
          final batch = Batch.fromJson(batchData);

          // Calcular progreso
          final progress = await batchProgressService.calculateProgress(batch);

          if (progress != null &&
              progress.status == ProgressStatus.belowTarget) {
            batchesBelowTarget.add({
              'id': batch.id,
              'name': batch.name,
              'days_old': progress.daysOld,
              'current_weight': progress.currentWeight,
              'reference_weight': progress.referenceWeight,
              'progress_percentage': progress.progressPercentage,
            });
          }
        } catch (e) {
          print('Error procesando lote ${batchData['id']}: $e');
        }
      }

      return batchesBelowTarget;
    } catch (e) {
      print('Error obteniendo lotes por debajo del objetivo: $e');
      return [];
    }
  }

  /// Obtiene lotes por encima del peso objetivo según feeding_schedule
  Future<List<Map<String, dynamic>>> _getBatchesAboveTargetWeight() async {
    try {
      final batchProgressService = BatchProgressService(_supabase);

      // Obtener todos los lotes activos con birth_date
      final batchesData = await _supabase
          .from('batches')
          .select(
              'id, name, birth_date, created_at, entry_date, headcount_start, corral_id, initial_avg_weight, status, notes')
          .eq('status', 'active')
          .not('birth_date', 'is', null);

      final batchesAboveTarget = <Map<String, dynamic>>[];

      for (final batchData in batchesData) {
        try {
          // Convertir a modelo Batch
          final batch = Batch.fromJson(batchData);

          // Calcular progreso
          final progress = await batchProgressService.calculateProgress(batch);

          if (progress != null &&
              progress.status == ProgressStatus.aboveTarget) {
            batchesAboveTarget.add({
              'id': batch.id,
              'name': batch.name,
              'days_old': progress.daysOld,
              'current_weight': progress.currentWeight,
              'reference_weight': progress.referenceWeight,
              'progress_percentage': progress.progressPercentage,
            });
          }
        } catch (e) {
          print('Error procesando lote ${batchData['id']}: $e');
        }
      }

      return batchesAboveTarget;
    } catch (e) {
      print('Error obteniendo lotes por encima del objetivo: $e');
      return [];
    }
  }

  /// Obtiene alertas de tareas programadas según feeding_schedule
  Future<List<DashboardAlert>> _getScheduledTaskAlerts() async {
    try {
      final alerts = <DashboardAlert>[];

      // Obtener todos los lotes activos con birth_date
      final batchesData = await _supabase
          .from('batches')
          .select('id, name, birth_date')
          .eq('status', 'active')
          .not('birth_date', 'is', null);

      for (final batchData in batchesData) {
        try {
          final birthDate = DateTime.parse(batchData['birth_date'] as String);
          final daysOld = DateTime.now().difference(birthDate).inDays;

          // Buscar tareas programadas para la edad actual (±3 días)
          final feedingData = await _supabase
              .from('feeding_schedule')
              .select('days_old, tasks')
              .gte('days_old', daysOld - 3)
              .lte('days_old', daysOld + 3)
              .not('tasks', 'eq', '{}');

          for (final schedule in feedingData) {
            final tasks =
                (schedule['tasks'] as List<dynamic>?)?.cast<String>() ?? [];
            final scheduledDays = schedule['days_old'] as int;

            for (final task in tasks) {
              // Crear una alerta individual por cada lote y tarea
              alerts.add(DashboardAlert(
                id: 'scheduled_task_${task}_${batchData['id']}_${DateTime.now().millisecondsSinceEpoch}',
                severity: AlertSeverity.info,
                type: AlertType.scheduledTask,
                title: '${_getTaskTitle(task)} - ${batchData['name']}',
                description:
                    'Lote con $daysOld días de edad. Tarea programada para los $scheduledDays días',
                affectedCount: 1,
                actionRoute: '/batches/${batchData['id']}',
                createdAt: DateTime.now(),
              ));
            }
          }
        } catch (e) {
          print('Error procesando tareas del lote ${batchData['id']}: $e');
        }
      }

      return alerts;
    } catch (e) {
      print('Error obteniendo alertas de tareas programadas: $e');
      return [];
    }
  }

  /// Obtiene el título amigable para un tipo de tarea
  String _getTaskTitle(String taskType) {
    final taskTitles = {
      'vacunacion': 'Vacunación Programada',
      'desparasitacion': 'Desparasitación Programada',
      'vitaminas': 'Suplemento Vitamínico',
      'cambio_alimentacion': 'Cambio de Alimentación',
      'pesaje': 'Pesaje Programado',
    };
    return taskTitles[taskType.toLowerCase()] ?? 'Tarea Programada: $taskType';
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
