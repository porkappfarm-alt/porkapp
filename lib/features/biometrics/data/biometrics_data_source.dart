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
    try {
      print('🔍 BiometricsDataSource: Fetching data for batch: $batchId');

      final query = _client
          .from('batch_biometrics')
          .select('*, batches(name)')
          .inFilter(
              'status', ['active', 'pending']); // Incluir pending y active

      if (batchId.isNotEmpty) {
        query.eq('batch_id', batchId);
      }

      print('🔍 BiometricsDataSource: Executing query...');
      final response = await query.order('measurement_date', ascending: false);

      print(
          '🔍 BiometricsDataSource: Response received: ${response.length} records');
      print(
          '🔍 BiometricsDataSource: First record: ${response.isNotEmpty ? response.first : "empty"}');

      // Transform the response to match the expected format
      final transformed = List<Map<String, dynamic>>.from(response.map((row) {
        print('🔍 BiometricsDataSource: Processing row with id: ${row['id']}');
        print(
            '🔍 BiometricsDataSource: batches field type: ${row['batches']?.runtimeType}');
        print('🔍 BiometricsDataSource: batches value: ${row['batches']}');

        // Extraer el nombre del batch de forma segura
        String? batchName;
        if (row['batches'] != null) {
          if (row['batches'] is List && (row['batches'] as List).isNotEmpty) {
            batchName = (row['batches'] as List).first['name'];
            print(
                '🔍 BiometricsDataSource: Extracted batchName from List: $batchName');
          } else if (row['batches'] is Map) {
            batchName = row['batches']['name'];
            print(
                '🔍 BiometricsDataSource: Extracted batchName from Map: $batchName');
          }
        }

        final result = {
          ...row,
          'batchName': batchName ?? 'Sin nombre',
        };

        print('🔍 BiometricsDataSource: Transformed row: $result');
        return result;
      }));

      print(
          '✅ BiometricsDataSource: Successfully transformed ${transformed.length} records');
      return transformed;
    } catch (e, stackTrace) {
      print('❌ BiometricsDataSource ERROR: $e');
      print('❌ StackTrace: $stackTrace');
      rethrow;
    }
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
