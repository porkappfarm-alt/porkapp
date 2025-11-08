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
      // Validar que batchId no esté vacío
      if (batchId.isEmpty) {
        throw ArgumentError('batchId no puede estar vacío');
      }

      print('🔍 BiometricsDataSource: Fetching data for batch: $batchId');

      // Usar inner join para asegurar que el batch existe y está activo
      // Obtener todas las biometrías excepto cancelled y archived (para mostrar historial completo)
      final response = await _client
          .from('batch_biometrics')
          .select('*, batches!inner(name, status)')
          .eq('batch_id', batchId) // SIEMPRE filtrar por batch_id
          .inFilter('status',
              ['active', 'inactive', 'pending']) // Incluir historial completo
          .order('measurement_date', ascending: false);

      print(
          '🔍 BiometricsDataSource: Response received: ${response.length} records');

      if (response.isNotEmpty) {
        print('🔍 BiometricsDataSource: First record: ${response.first}');
      }

      // Transform the response to match the expected format
      final transformed = List<Map<String, dynamic>>.from(response.map((row) {
        print('🔍 BiometricsDataSource: Processing row with id: ${row['id']}');
        print(
            '🔍 BiometricsDataSource: batches field type: ${row['batches']?.runtimeType}');
        print('🔍 BiometricsDataSource: batches value: ${row['batches']}');

        // Extraer el nombre del batch de forma segura
        String? batchName;
        if (row['batches'] != null) {
          if (row['batches'] is Map) {
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
          '✅ BiometricsDataSource: Successfully transformed ${transformed.length} records for batch $batchId');
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
