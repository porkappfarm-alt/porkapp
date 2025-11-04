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

  /// Verifica si un corral tiene un lote activo
  Future<bool> corralHasActiveBatch(String corralId) async {
    final response = await supabase.rpc('check_corral_has_active_batch',
        params: {'p_corral_id': corralId});
    return response as bool;
  }

  /// Crea un nuevo lote con solo 3 campos requeridos
  Future<Batch> createBatch({
    required String corralId,
    required DateTime entryDate,
    required int animalCount,
    required DateTime birthDate, // Ahora es obligatorio
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    // Verificar que el corral no tenga un lote activo
    final hasActiveBatch = await corralHasActiveBatch(corralId);
    if (hasActiveBatch) {
      throw Exception('El corral seleccionado ya tiene un lote activo');
    }

    // Crear el lote (name se genera automáticamente)
    final insertData = {
      'corral_id': corralId,
      'entry_date': entryDate.toIso8601String().split('T')[0],
      'birth_date': birthDate.toIso8601String().split('T')[0],
      'animal_count': animalCount,
      'headcount_start': animalCount, // Inicializar con el mismo valor
      'status': 'active',
    };

    final response =
        await supabase.from('batches').insert(insertData).select().single();

    final batch = Batch.fromJson(response);

    // Crear los animales automáticamente
    await supabase.rpc('create_batch_animals', params: {
      'p_batch_id': batch.id,
      'p_animal_count': animalCount,
      'p_entry_date': entryDate.toIso8601String().split('T')[0],
    });

    return batch;
  }

  Future<Batch> updateBatch({
    required String id,
    required String name,
    required String corralId,
    required DateTime entryDate,
    required int headcountStart,
    double? initialAvgWeight,
    String? notes,
    DateTime? birthDate,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final updateData = {
      'name': name,
      'corral_id': corralId,
      'entry_date': entryDate.toIso8601String().split('T')[0],
      'headcount_start': headcountStart,
      'initial_avg_weight': initialAvgWeight,
      'notes': notes,
      'status': 'active',
    };

    // Agregar birth_date solo si se proporciona
    if (birthDate != null) {
      updateData['birth_date'] = birthDate.toIso8601String().split('T')[0];
    }

    final response = await supabase
        .from('batches')
        .update(updateData)
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
