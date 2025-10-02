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
    final response = await _client
        .from('batches')
        .select()
        .order('created_at', ascending: false);

    return response.map((json) => Batch.fromJson(json)).toList();
  }

  @override
  Future<Batch> getBatch(String id) async {
    final response = await _client
        .from('batches')
        .select()
        .eq('id', id)
        .single();

    return Batch.fromJson(response);
  }

  @override
  Future<Batch> createBatch(Batch batch) async {
    final response = await _client
        .from('batches')
        .insert(batch.toJson())
        .select()
        .single();

    return Batch.fromJson(response);
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
