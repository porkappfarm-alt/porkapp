import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/data/batch_progress_service.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/domain/batch_progress.dart';
import 'package:porkapp/supabase/providers/supabase_provider.dart';

/// Provider del servicio de progreso de lotes
final batchProgressServiceProvider = Provider<BatchProgressService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return BatchProgressService(supabase);
});

/// Provider para calcular el progreso de un lote específico
final batchProgressProvider =
    FutureProvider.family<BatchProgress?, Batch>((ref, batch) async {
  final service = ref.watch(batchProgressServiceProvider);
  return await service.calculateProgress(batch);
});

/// Provider para calcular el progreso de múltiples lotes
final batchesProgressProvider =
    FutureProvider.family<Map<String, BatchProgress>, List<Batch>>(
        (ref, batches) async {
  final service = ref.watch(batchProgressServiceProvider);
  return await service.calculateProgressForBatches(batches);
});
