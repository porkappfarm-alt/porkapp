import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/supabase/supabase.dart';

class AnimalsRepository {
  Future<List<Animal>> getAnimalsByBatch(String batchId) async {
    final response = await supabase
        .from('animals')
        .select()
        .eq('batch_id', batchId)
        .order('created_at', ascending: false);

    return response.map((json) => Animal.fromJson(json)).toList();
  }

  Future<Animal> getAnimal(String id) async {
    final response = await supabase
        .from('animals')
        .select()
        .eq('id', id)
        .single();

    return Animal.fromJson(response);
  }

  Future<Animal> createAnimal({
    required String batchId,
    required String identifier,
    required DateTime birthDate,
    required String breed,
    required double weight,
    String status = 'active',
  }) async {
    final currentTime = DateTime.now();
    final response = await supabase
        .from('animals')
        .insert({
          'batch_id': batchId,
          'identifier': identifier,
          'birth_date': birthDate.toIso8601String(),
          'breed': breed,
          'weight': weight,
          'status': status,
          'created_at': currentTime.toIso8601String(),
        })
        .select()
        .single();

    return Animal.fromJson(response);
  }

  Future<Animal> updateAnimal({
    required String id,
    required String identifier,
    required DateTime birthDate,
    required String breed,
    required double weight,
    required String status,
  }) async {
    final response = await supabase
        .from('animals')
        .update({
          'identifier': identifier,
          'birth_date': birthDate.toIso8601String(),
          'breed': breed,
          'weight': weight,
          'status': status,
        })
        .eq('id', id)
        .select()
        .single();

    return Animal.fromJson(response);
  }

  Future<void> deleteAnimal(String id) async {
    await supabase.from('animals').delete().eq('id', id);
  }
}

final animalsRepositoryProvider = Provider((ref) => AnimalsRepository());
