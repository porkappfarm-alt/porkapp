import 'package:supabase_flutter/supabase_flutter.dart';

class BiometricsDataSource {
  final SupabaseClient _client;

  BiometricsDataSource(this._client);

  Future<List<Map<String, dynamic>>> getPesajesByBatch(String batchId) async {
    final response = await _client
        .from('animal_events')
        .select()
        .eq('batch_id', batchId)
        .eq('type', 'weighing')
        .order('created_at');

    return response;
  }

  Future<List<Map<String, dynamic>>> getAlimentacionByBatch(
    String batchId,
  ) async {
    final response = await _client
        .from('animal_events')
        .select()
        .eq('batch_id', batchId)
        .eq('type', 'feeding')
        .order('created_at');

    return response;
  }

  Future<List<Map<String, dynamic>>> getMortalidadByBatch(
    String batchId,
  ) async {
    final response = await _client
        .from('animal_events')
        .select()
        .eq('batch_id', batchId)
        .eq('type', 'mortality')
        .order('created_at');

    return response;
  }
}
