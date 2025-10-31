import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/data/batches_repository.dart';
import 'package:porkapp/features/batches/domain/batch.dart';

class BatchesController extends StateNotifier<AsyncValue<List<Batch>>> {
  BatchesController(this.ref) : super(const AsyncValue.loading()) {
    loadBatches();
  }

  final Ref ref;

  Future<void> loadBatches() async {
    try {
      state = const AsyncValue.loading();
      final batches = await ref.read(batchesRepositoryProvider).getBatches();
      if (!mounted) return;
      state = AsyncValue.data(batches);
    } catch (error, stackTrace) {
      if (!mounted) return;
      state = AsyncValue.error(error, stackTrace);
      // Retry after 3 seconds on error
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) loadBatches();
    }
  }

  Future<Batch> createBatch({
    required String corralId,
    required DateTime entryDate,
    required int animalCount,
  }) async {
    final batch = await ref.read(batchesRepositoryProvider).createBatch(
          corralId: corralId,
          entryDate: entryDate,
          animalCount: animalCount,
        );
    await loadBatches();
    return batch;
  }

  Future<void> updateBatch({
    required String id,
    required String name,
    required String corralId,
    required DateTime entryDate,
    required int headcountStart,
    double? initialAvgWeight,
    String? notes,
  }) async {
    await ref.read(batchesRepositoryProvider).updateBatch(
          id: id,
          name: name,
          corralId: corralId,
          entryDate: entryDate,
          headcountStart: headcountStart,
          initialAvgWeight: initialAvgWeight,
          notes: notes,
        );
    loadBatches();
  }

  Future<void> deleteBatch(String id) async {
    await ref.read(batchesRepositoryProvider).deleteBatch(id);
    loadBatches();
  }

  Future<void> finishBatch(String id) async {
    await ref.read(batchesRepositoryProvider).finishBatch(id);
    loadBatches();
  }
}

final batchesControllerProvider =
    StateNotifierProvider<BatchesController, AsyncValue<List<Batch>>>(
  (ref) => BatchesController(ref),
  dependencies: [batchesRepositoryProvider],
);
