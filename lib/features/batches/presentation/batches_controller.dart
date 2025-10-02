import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/data/batches_repository.dart';
import 'package:porkapp/features/batches/domain/batch.dart';

class BatchesController extends StateNotifier<AsyncValue<List<Batch>>> {
  BatchesController(this.ref) : super(const AsyncValue.loading()) {
    loadBatches();
  }

  final Ref ref;

  Future<void> loadBatches() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(batchesRepositoryProvider).getBatches(),
    );
  }

  Future<void> createBatch({
    required String name,
    required String corralId,
    required DateTime createdAt,
    required int headcountStart,
    double? initialAvgWeight,
    String? notes,
  }) async {
    await ref
        .read(batchesRepositoryProvider)
        .createBatch(
          name: name,
          corralId: corralId,
          createdAt: createdAt,
          headcountStart: headcountStart,
          initialAvgWeight: initialAvgWeight,
          notes: notes,
        );
    loadBatches();
  }

  Future<void> updateBatch({
    required String id,
    required String name,
    required String corralId,
    required DateTime createdAt,
    required int headcountStart,
    double? initialAvgWeight,
    String? notes,
  }) async {
    await ref
        .read(batchesRepositoryProvider)
        .updateBatch(
          id: id,
          name: name,
          corralId: corralId,
          createdAt: createdAt,
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
    StateNotifierProvider<BatchesController, AsyncValue<List<Batch>>>((ref) {
      return BatchesController(ref);
    });
