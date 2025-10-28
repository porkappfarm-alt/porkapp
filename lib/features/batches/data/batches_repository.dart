import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/supabase/supabase.dart';

class BatchesRepository {
  Future<List<Batch>> getBatches() async {
    final response = await supabase
        .from('batches')
        .select()
        .order('created_at', ascending: false);

    return response.map((json) => Batch.fromJson(json)).toList();
  }

  Future<Batch> getBatch(String id) async {
    final response =
        await supabase.from('batches').select().eq('id', id).single();

    return Batch.fromJson(response);
  }

  Future<Batch> createBatch({
    required String corralId,
    required DateTime createdAt,
    required int headcountStart,
    double? initialAvgWeight,
    String? notes,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await supabase
        .from('batches')
        .insert({
          // 'name' se genera automáticamente en la base de datos
          'corral_id': corralId,
          'created_at': createdAt.toIso8601String(),
          'headcount_start': headcountStart,
          'initial_avg_weight': initialAvgWeight,
          'notes': notes,
          'status': 'active',
        })
        .select()
        .single();

    return Batch.fromJson(response);
  }

  Future<Batch> updateBatch({
    required String id,
    required String name,
    required String corralId,
    required DateTime createdAt,
    required int headcountStart,
    double? initialAvgWeight,
    String? notes,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await supabase
        .from('batches')
        .update({
          'name': name,
          'corral_id': corralId,
          'created_at': createdAt.toIso8601String(),
          'headcount_start': headcountStart,
          'initial_avg_weight': initialAvgWeight,
          'notes': notes,
          'status': 'active',
        })
        .eq('id', id)
        .select()
        .single();

    return Batch.fromJson(response);
  }

  Future<void> deleteBatch(String id) async {
    await supabase.from('batches').delete().eq('id', id);
  }

  Future<Batch> finishBatch(String id) async {
    final response = await supabase
        .from('batches')
        .update({'status': 'finished'})
        .eq('id', id)
        .select()
        .single();

    return Batch.fromJson(response);
  }
}

final batchesRepositoryProvider = Provider((ref) => BatchesRepository());
