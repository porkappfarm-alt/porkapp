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
  static const String _batchMeasurementsTable = 'batch_biometrics';
  static const String _animalMeasurementsTable = 'biometric_measurements';
  static const String _measurementsView = 'measurements_view';

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
    try {
      // Intentar crear la medición directamente
      // Si el lote no existe, la foreign key constraint lanzará un error
      final response = await _supabase
          .from(_batchMeasurementsTable)
          .insert(measurement.toJson())
          .select()
          .single();

      return BatchMeasurement.fromJson(response);
    } catch (e) {
      if (e.toString().contains('duplicate key')) {
        throw Exception('Ya existe una medición para este lote en esta fecha');
      } else if (e.toString().contains('foreign key')) {
        throw Exception('El lote especificado no existe');
      } else {
        throw Exception('Error al crear la medición: ${e.toString()}');
      }
    }
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
    try {
      final measurementData = measurement.toJson();
      measurementData['measurement_date'] = DateTime(
        measurement.createdAt.year,
        measurement.createdAt.month,
        measurement.createdAt.day,
      ).toIso8601String();

      final response = await _supabase
          .from(_animalMeasurementsTable)
          .insert(measurementData)
          .select()
          .single();
      return AnimalMeasurement.fromJson(response);
    } catch (e) {
      if (e.toString().contains('animal_measurements_unique_per_day')) {
        throw Exception(
            'Ya existe una medición para este animal en esta fecha');
      }
      throw Exception('Error al guardar la medición: ${e.toString()}');
    }
  }

  Future<List<AnimalMeasurement>> getAnimalMeasurements(
      String batchMeasurementId) async {
    final response = await _supabase
        .from(_animalMeasurementsTable)
        .select()
        .eq('biometric_id', batchMeasurementId)
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

  Future<BatchMeasurement> updateBatchMeasurement({
    required String id,
    double? averageWeight,
    int? animalCount,
    String? notes,
    String? status,
  }) async {
    final updateData = <String, dynamic>{};
    if (averageWeight != null) updateData['average_weight'] = averageWeight;
    if (animalCount != null) updateData['animal_count'] = animalCount;
    if (notes != null) updateData['notes'] = notes;
    if (status != null) updateData['status'] = status;
    updateData['updated_at'] = DateTime.now().toIso8601String();

    final response = await _supabase
        .from(_batchMeasurementsTable)
        .update(updateData)
        .eq('id', id)
        .select()
        .single();

    return BatchMeasurement.fromJson(response);
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
