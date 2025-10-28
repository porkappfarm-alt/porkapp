import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BatchDataSource {
  Future<List<Batch>> getBatches();
  Future<Batch> getBatch(String id);
  Future<Batch> createBatch(Batch batch);
  Future<Batch> updateBatch(Batch batch);
  Future<void> deleteBatch(String id);
}

class SupabaseBatchDataSource implements BatchDataSource {
  final SupabaseClient _client;

  SupabaseBatchDataSource(this._client);

  @override
  Future<List<Batch>> getBatches() async {
    try {
      final response = await _client
          .from('batches')
          .select('*, animals(*)')
          .eq('status', 'active')
          .order('created_at', ascending: false);

      print('Batches response: $response'); // Debug log

      return response.map((json) => Batch.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print('Error getting batches: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<Batch> getBatch(String id) async {
    try {
      final response = await _client
          .from('batches')
          .select('*, animals(*)')
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        throw Exception('No se encontró el lote con ID: $id');
      }

      return Batch.fromJson(response);
    } catch (e) {
      print('Error al obtener el lote: $e'); // For debugging
      rethrow;
    }
  }

  @override
  Future<Batch> createBatch(Batch batch) async {
    try {
      // Preparar los datos básicos del lote
      final batchData = {
        'name': batch.name,
        'created_at': batch.createdAt.toIso8601String(),
        'headcount_start': batch.headcountStart,
        'corral_id': batch.corralId,
        'initial_avg_weight': batch.initialAvgWeight,
        'status': batch.status,
        'notes': batch.notes,
      };

      // Crear el lote
      final response =
          await _client.from('batches').insert(batchData).select().single();

      print('Lote creado: $response'); // Para debug

      // Devolver el lote creado
      return Batch.fromJson(response);
    } catch (e, stackTrace) {
      print('Error al crear el lote: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error al crear el lote: $e');
    }
  }

  @override
  Future<Batch> updateBatch(Batch batch) async {
    final response = await _client
        .from('batches')
        .update(batch.toJson())
        .eq('id', batch.id)
        .select()
        .single();

    return Batch.fromJson(response);
  }

  @override
  Future<void> deleteBatch(String id) async {
    await _client.from('batches').delete().eq('id', id);
  }
}
