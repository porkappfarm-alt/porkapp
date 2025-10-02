import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Estado para manejar los animales de un lote específico
final batchAnimalsProvider =
    StateNotifierProvider.family<
      AnimalsNotifier,
      AsyncValue<List<Animal>>,
      String
    >((ref, batchId) {
      final supabase = ref.watch(supabaseProvider);
      return AnimalsNotifier(supabase, batchId);
    });

class AnimalsNotifier extends StateNotifier<AsyncValue<List<Animal>>> {
  final SupabaseClient _supabase;
  final String _batchId;

  AnimalsNotifier(this._supabase, this._batchId)
    : super(const AsyncValue.loading()) {
    loadAnimals();
  }

  Future<void> loadAnimals() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('animals')
          .select()
          .eq('batch_id', _batchId)
          .order('created_at', ascending: false);

      final animals = response.map((data) => Animal.fromJson(data)).toList();
      state = AsyncValue.data(animals);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addAnimal({
    required String identifier,
    required DateTime birthDate,
    required double weight,
    required String breed,
  }) async {
    try {
      final currentTime = DateTime.now();
      final newAnimal = {
        'batch_id': _batchId,
        'identifier': identifier,
        'birth_date': birthDate.toIso8601String(),
        'weight': weight,
        'breed': breed,
        'created_at': currentTime.toIso8601String(),
        'status': 'active',
      };

      final response = await _supabase
          .from('animals')
          .insert(newAnimal)
          .select()
          .single();

      final animal = Animal.fromJson(response);
      final currentAnimals = state.value ?? [];
      state = AsyncValue.data([animal, ...currentAnimals]);

      // Actualizar el contador de animales en el lote
      await _supabase
          .from('batches')
          .update({'animal_count': currentAnimals.length + 1})
          .eq('id', _batchId);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteAnimal(String animalId) async {
    try {
      await _supabase.from('animals').delete().eq('id', animalId);

      final currentAnimals = state.value ?? [];
      state = AsyncValue.data(
        currentAnimals.where((animal) => animal.id != animalId).toList(),
      );

      // Actualizar el contador de animales en el lote
      await _supabase
          .from('batches')
          .update({'animal_count': currentAnimals.length - 1})
          .eq('id', _batchId);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateAnimal(Animal animal) async {
    try {
      final updatedAnimal = {
        'identifier': animal.identifier,
        'birth_date': animal.birthDate.toIso8601String(),
        'weight': animal.weight,
        'breed': animal.breed,
        'status': animal.status,
      };

      await _supabase.from('animals').update(updatedAnimal).eq('id', animal.id);

      final currentAnimals = state.value ?? [];
      state = AsyncValue.data(
        currentAnimals.map((a) => a.id == animal.id ? animal : a).toList(),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
