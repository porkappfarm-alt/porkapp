import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/domain/batch_progress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio para calcular el progreso de los lotes
class BatchProgressService {
  final SupabaseClient _supabase;

  BatchProgressService(this._supabase);

  /// Calcula el progreso de un lote específico
  Future<BatchProgress?> calculateProgress(Batch batch) async {
    try {
      // Validar que el lote tenga fecha de nacimiento
      if (batch.birthDate == null) {
        return null;
      }

      final daysOld = batch.daysOld;
      final weeksOld = batch.weeksOld;

      // Obtener la última biometría del lote
      final biometricsData = await _supabase
          .from('batch_biometrics')
          .select('avg_weight, measurement_date')
          .eq('batch_id', batch.id)
          .not('avg_weight', 'is', null)
          .order('measurement_date', ascending: false)
          .limit(1);

      if (biometricsData.isEmpty) {
        return null;
      }

      final currentWeight =
          (biometricsData.first['avg_weight'] as num).toDouble();
      final lastBiometryDate =
          DateTime.parse(biometricsData.first['measurement_date'] as String);

      // Buscar el peso de referencia en feeding_schedule
      final feedingData = await _findClosestFeedingSchedule(daysOld);

      if (feedingData == null) {
        return null;
      }

      final referenceWeight =
          (feedingData['average_weight_kg'] as num).toDouble();
      final currentFeedType = feedingData['feed_type'] as String?;

      // Calcular porcentaje de progreso
      final progressPercentage = (currentWeight / referenceWeight) * 100;

      // Determinar el estado
      final status = _determineStatus(progressPercentage);

      // Verificar tareas pendientes (tareas no ejecutadas)
      final pendingTasks = await _getPendingTasks(batch.id, daysOld);

      // Obtener consumo diario estimado del feeding schedule
      double? dailyFeedKg;
      final rawDailyFeed = feedingData['daily_feed_kg'];

      if (rawDailyFeed != null) {
        if (rawDailyFeed is num) {
          dailyFeedKg = rawDailyFeed.toDouble();
        } else if (rawDailyFeed is String) {
          dailyFeedKg = double.tryParse(rawDailyFeed);
        }
      }

      return BatchProgress(
        batchId: batch.id,
        daysOld: daysOld,
        weeksOld: weeksOld,
        currentWeight: currentWeight,
        referenceWeight: referenceWeight,
        progressPercentage: progressPercentage,
        status: status,
        lastBiometryDate: lastBiometryDate,
        currentFeedType: currentFeedType,
        dailyFeedKg: dailyFeedKg,
        pendingTasks: pendingTasks,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error calculando progreso del lote ${batch.id}: $e');
      return null;
    }
  }

  /// Busca el registro más cercano en feeding_schedule para los días dados
  Future<Map<String, dynamic>?> _findClosestFeedingSchedule(int daysOld) async {
    try {
      // Buscar el registro con days_old más cercano (puede ser exacto o el más próximo)
      final feedingData = await _supabase
          .from('feeding_schedule')
          .select(
              'days_old, average_weight_kg, daily_feed_kg, feed_type, tasks')
          .order('days_old', ascending: true);

      if (feedingData.isEmpty) {
        return null;
      }

      // Buscar el registro más cercano
      Map<String, dynamic>? closestRecord;
      int minDifference = 999999;

      for (final record in feedingData) {
        final recordDays = record['days_old'] as int;
        final difference = (recordDays - daysOld).abs();

        if (difference < minDifference) {
          minDifference = difference;
          closestRecord = record;
        }

        // Si encontramos un registro exacto o muy cercano, lo usamos
        if (difference == 0 || (recordDays > daysOld && minDifference <= 7)) {
          break;
        }
      }

      return closestRecord;
    } catch (e) {
      print('Error buscando feeding schedule: $e');
      return null;
    }
  }

  /// Determina el estado del progreso según el porcentaje
  ProgressStatus _determineStatus(double percentage) {
    if (percentage >= 90 && percentage <= 110) {
      return ProgressStatus.onTrack;
    } else if (percentage < 90) {
      return ProgressStatus.belowTarget;
    } else {
      return ProgressStatus.aboveTarget;
    }
  }

  /// Obtiene las tareas pendientes del lote según feeding_schedule
  Future<List<String>> _getPendingTasks(String batchId, int daysOld) async {
    try {
      // Buscar tareas en feeding_schedule en un rango de ±3 días
      final feedingData = await _supabase
          .from('feeding_schedule')
          .select('days_old, tasks')
          .gte('days_old', daysOld - 3)
          .lte('days_old', daysOld + 3)
          .not('tasks', 'eq', '{}');

      if (feedingData.isEmpty) {
        return [];
      }

      final allTasks = <String>{};
      for (final record in feedingData) {
        final tasks = (record['tasks'] as List<dynamic>?)?.cast<String>() ?? [];
        allTasks.addAll(tasks);
      }

      // TODO: En el futuro, verificar si las tareas ya se ejecutaron
      // consultando la tabla animal_events

      return allTasks.toList();
    } catch (e) {
      print('Error obteniendo tareas pendientes: $e');
      return [];
    }
  }

  /// Calcula el progreso de múltiples lotes
  Future<Map<String, BatchProgress>> calculateProgressForBatches(
    List<Batch> batches,
  ) async {
    final progressMap = <String, BatchProgress>{};

    for (final batch in batches) {
      final progress = await calculateProgress(batch);
      if (progress != null) {
        progressMap[batch.id] = progress;
      }
    }

    return progressMap;
  }
}
