import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/supabase/supabase.dart';

// Estado para manejar los lotes
final batchesProvider =
    StateNotifierProvider<BatchesNotifier, AsyncValue<List<Batch>>>((ref) {
      final supabase = ref.watch(supabaseProvider);
      return BatchesNotifier(supabase);
    });

class BatchesNotifier extends StateNotifier<AsyncValue<List<Batch>>> {
  final SupabaseClient _supabase;

  BatchesNotifier(this._supabase) : super(const AsyncValue.loading()) {
    loadBatches();
  }

  Future<void> loadBatches() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('batches')
          .select()
          .order('created_at', ascending: false);

      final batches = response.map((data) => Batch.fromJson(data)).toList();
      state = AsyncValue.data(batches);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addBatch(String name, {String? corralId}) async {
    try {
      final newBatch = {
        'name': name,
        'created_at': DateTime.now().toIso8601String(),
        'headcount_start': 0,
        'status': 'active',
        if (corralId != null) 'corral_id': corralId,
      };

      final response = await _supabase
          .from('batches')
          .insert(newBatch)
          .select()
          .single();

      final batch = Batch.fromJson(response);
      final currentBatches = state.value ?? [];
      state = AsyncValue.data([batch, ...currentBatches]);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateBatch(Batch batch) async {
    try {
      final updateData = {
        'name': batch.name,
        'status': batch.status,
        'headcount_start': batch.headcountStart,
        'corral_id': batch.corralId,
        'initial_avg_weight': batch.initialAvgWeight,
        'notes': batch.notes,
      };

      await _supabase.from('batches').update(updateData).eq('id', batch.id);

      final currentBatches = state.value ?? [];
      state = AsyncValue.data(
        currentBatches.map((b) => b.id == batch.id ? batch : b).toList(),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteBatch(String id) async {
    try {
      await _supabase.from('batches').delete().eq('id', id);

      final currentBatches = state.value ?? [];
      state = AsyncValue.data(
        currentBatches.where((batch) => batch.id != id).toList(),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateBatchHeadcount(String batchId, int count) async {
    try {
      await _supabase
          .from('batches')
          .update({'headcount_start': count})
          .eq('id', batchId);

      final currentBatches = state.value ?? [];
      state = AsyncValue.data(
        currentBatches.map((batch) {
          if (batch.id == batchId) {
            return batch.copyWith(headcountStart: count);
          }
          return batch;
        }).toList(),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> finishBatch(String id) async {
    try {
      await _supabase
          .from('batches')
          .update({'status': 'finished'})
          .eq('id', id);

      final currentBatches = state.value ?? [];
      state = AsyncValue.data(
        currentBatches.map((batch) {
          if (batch.id == id) {
            return batch.copyWith(status: 'finished');
          }
          return batch;
        }).toList(),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
