import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/batch_measurement.dart';
import '../domain/animal_measurement.dart';
import '../domain/batch_statistics.dart';

final biometricsRepositoryProvider = Provider<BiometricsRepository>((ref) {
  final supabase = Supabase.instance.client;
  return BiometricsRepository(supabase);
});

class BiometricsRepository {
  final SupabaseClient _supabase;
  static const String _batchMeasurementsTable = 'biometrics.batch_measurements';
  static const String _animalMeasurementsTable =
      'biometrics.animal_measurements';
  static const String _measurementsView = 'biometrics.measurements_view';

  BiometricsRepository(this._supabase);

  /// Obtiene estadísticas por rango de fechas
  Future<Map<String, dynamic>> getStatsByDateRange(
    String batchId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await _supabase.rpc(
      'get_stats_by_date_range',
      params: {
        'p_batch_id': batchId,
        'p_start_date': startDate.toIso8601String(),
        'p_end_date': endDate.toIso8601String(),
      },
    ).single();
    return response;
  }

  /// Compara estadísticas entre lotes
  Future<List<Map<String, dynamic>>> compareBatchStats(
    List<String> batchIds,
  ) async {
    final response = await _supabase.rpc(
      'compare_batch_stats',
      params: {
        'p_batch_ids': batchIds,
      },
    );
    return List<Map<String, dynamic>>.from(response);
  }

  /// Obtiene métricas de rendimiento del lote
  Future<Map<String, dynamic>> getPerformanceMetrics(
    String batchId,
  ) async {
    final response = await _supabase.rpc(
      'get_performance_metrics',
      params: {
        'p_batch_id': batchId,
      },
    ).single();
    return response;
  }

  Future<BatchMeasurement> createBatchMeasurement(
      BatchMeasurement measurement) async {
    final response = await _supabase
        .from(_batchMeasurementsTable)
        .insert(measurement.toJson())
        .select()
        .single();
    return BatchMeasurement.fromJson(response);
  }

  Future<List<BatchMeasurement>> getBatchMeasurements(String batchId) async {
    final response = await _supabase
        .from(_measurementsView)
        .select()
        .eq('batch_id', batchId)
        .order('measurement_date', ascending: false);
    return response.map((json) => BatchMeasurement.fromJson(json)).toList();
  }

  Future<AnimalMeasurement> createAnimalMeasurement(
      AnimalMeasurement measurement) async {
    final response = await _supabase
        .from(_animalMeasurementsTable)
        .insert(measurement.toJson())
        .select()
        .single();
    return AnimalMeasurement.fromJson(response);
  }

  Future<List<AnimalMeasurement>> getAnimalMeasurements(
      String batchMeasurementId) async {
    final response = await _supabase
        .from(_animalMeasurementsTable)
        .select()
        .eq('batch_measurement_id', batchMeasurementId)
        .order('created_at', ascending: false);
    return response.map((json) => AnimalMeasurement.fromJson(json)).toList();
  }

  Future<List<AnimalMeasurement>> getAnimalHistory(String animalId) async {
    final response = await _supabase
        .from(_animalMeasurementsTable)
        .select()
        .eq('animal_id', animalId)
        .order('created_at', ascending: false);
    return response.map((json) => AnimalMeasurement.fromJson(json)).toList();
  }

  Future<BatchStatistics> getBatchStatistics(String batchId) async {
    final response = await _supabase
        .rpc('calculate_batch_stats', params: {'batch_id': batchId}).single();
    return BatchStatistics.fromJson(response);
  }

  Future<void> updateBatchMeasurementStatus(String id, String status) async {
    await _supabase
        .from(_batchMeasurementsTable)
        .update({'status': status}).eq('id', id);
  }

  Future<void> deleteBatchMeasurement(String id) async {
    await _supabase.from(_batchMeasurementsTable).delete().eq('id', id);
  }

  Future<void> deleteAnimalMeasurement(String id) async {
    await _supabase.from(_animalMeasurementsTable).delete().eq('id', id);
  }

  Future<List<BatchMeasurement>> getAllBatchMeasurements() async {
    final response = await _supabase
        .from(_measurementsView)
        .select()
        .order('measurement_date', ascending: false);
    return response.map((json) => BatchMeasurement.fromJson(json)).toList();
  }

  Future<BatchMeasurement?> getBatchMeasurement(String id) async {
    try {
      final response = await _supabase
          .from(_measurementsView)
          .select()
          .eq('id', id)
          .single();

      final measurements = await getAnimalMeasurements(id);
      return BatchMeasurement.fromJson(response)
          .copyWith(measurements: measurements);
    } catch (e) {
      return null;
    }
  }
}
