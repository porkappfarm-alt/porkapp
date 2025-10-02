import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AnimalDataSource {
  Future<List<Animal>> getAnimalsByBatch(String batchId);
  Future<Animal> getAnimal(String id);
  Future<Animal> createAnimal(Animal animal);
  Future<Animal> updateAnimal(Animal animal);
  Future<void> deleteAnimal(String id);
}

class SupabaseAnimalDataSource implements AnimalDataSource {
  final SupabaseClient _client;

  SupabaseAnimalDataSource(this._client);

  @override
  Future<List<Animal>> getAnimalsByBatch(String batchId) async {
    final response = await _client
        .from('animals')
        .select()
        .eq('batch_id', batchId)
        .order('created_at');

    return response.map((json) => Animal.fromJson(json)).toList();
  }

  @override
  Future<Animal> getAnimal(String id) async {
    final response = await _client
        .from('animals')
        .select()
        .eq('id', id)
        .single();

    return Animal.fromJson(response);
  }

  @override
  Future<Animal> createAnimal(Animal animal) async {
    final response = await _client
        .from('animals')
        .insert(animal.toJson())
        .select()
        .single();

    return Animal.fromJson(response);
  }

  @override
  Future<Animal> updateAnimal(Animal animal) async {
    final response = await _client
        .from('animals')
        .update(animal.toJson())
        .eq('id', animal.id)
        .select()
        .single();

    return Animal.fromJson(response);
  }

  @override
  Future<void> deleteAnimal(String id) async {
    await _client.from('animals').delete().eq('id', id);
  }
}
