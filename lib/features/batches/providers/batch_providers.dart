import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/data/batch_data_source.dart';
import 'package:porkapp/features/batches/data/batch_repository.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/supabase/supabase.dart';

// Batch Repository Provider
final batchRepositoryProvider = Provider<BatchRepository>((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  final dataSource = SupabaseBatchDataSource(supabaseClient);
  return BatchRepositoryImpl(dataSource);
});

// Batch List Provider
final batchListProvider = FutureProvider<List<Batch>>((ref) async {
  final repository = ref.watch(batchRepositoryProvider);
  final result = await repository.getBatches();
  return result.fold((error) => throw error, (batches) => batches);
});

// Active Batches Provider
final activeBatchesProvider = FutureProvider<List<Batch>>((ref) async {
  final repository = ref.watch(batchRepositoryProvider);
  final result = await repository.getBatches();
  return result.fold(
    (error) => throw error,
    (batches) => batches.where((batch) => batch.status == 'active').toList(),
  );
});

// Single Batch Provider
final batchProvider = FutureProvider.family<Batch, String>((
  ref,
  batchId,
) async {
  final repository = ref.watch(batchRepositoryProvider);
  final result = await repository.getBatch(batchId);
  return result.fold((error) => throw error, (batch) => batch);
});
