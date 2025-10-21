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
}
