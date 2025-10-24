import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final biometricsDataSourceProvider = Provider<BiometricsDataSource>((ref) {
  final supabase = Supabase.instance.client;
  return BiometricsDataSource(supabase);
});

class BiometricsDataSource {
  final SupabaseClient _client;

  BiometricsDataSource(this._client);

  Future<List<Map<String, dynamic>>> getPesajesByBatch(String batchId) async {
    final query = _client
        .from('batch_biometrics')
        .select('*, batches(name)')
        .eq('status', 'active');

    if (batchId.isNotEmpty) {
      query.eq('batch_id', batchId);
    }

    final response = await query.order('measurement_date', ascending: false);

    // Transform the response to match the expected format
    return List<Map<String, dynamic>>.from(response.map((row) => {
          ...row,
          'batchName': row['batches']['name'],
        }));
  }

  Future<void> savePesaje(Map<String, dynamic> data) async {
    await _client.from('batch_biometrics').insert(data);
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
