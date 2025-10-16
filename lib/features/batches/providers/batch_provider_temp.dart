import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/supabase/providers/supabase_provider.dart';

/// Provider para obtener un lote específico con sus animales
final batchProvider = FutureProvider.family<Batch, String>(
  (ref, batchId) async {
    try {
      // Obtener el lote con sus animales en una sola consulta
      final batchData =
          await ref.read(supabaseClientProvider).from('batches').select('''
            id,
            name,
            created_at,
            headcount_start,
            corral_id,
            initial_avg_weight,
            status,
            notes,
            animals(
              id,
              identifier,
              birth_date,
              breed,
              type,
              weight,
              status
            )
          ''').eq('id', batchId).single();

      // Mapear los animales
      final animals = (batchData['animals'] as List)
          .map((animal) => Animal.fromJson(animal))
          .toList()
          .cast<Animal>();

      // Crear el batch con sus animales
      final batch = Batch.fromJson(batchData);
      return batch.copyWith(animals: animals);
    } catch (e, stackTrace) {
      print('Error loading batch $batchId: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error al cargar el lote: $e');
    }
  },
);
