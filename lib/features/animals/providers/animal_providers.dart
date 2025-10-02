import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/data/animal_data_source.dart';
import 'package:porkapp/features/animals/data/animal_repository.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/supabase/supabase.dart';

// Animal Repository Provider
final animalRepositoryProvider = Provider<AnimalRepository>((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  final dataSource = SupabaseAnimalDataSource(supabaseClient);
  return AnimalRepositoryImpl(dataSource);
});

// Animal List Provider por Batch
final animalListProvider = FutureProvider.family<List<Animal>, String>((ref, batchId) async {
  final repository = ref.watch(animalRepositoryProvider);
  final result = await repository.getAnimalsByBatch(batchId);
  return result.fold(
    (error) => throw error,
    (animals) => animals,
  );
});

// Single Animal Provider
final animalProvider = FutureProvider.family<Animal, String>((ref, animalId) async {
  final repository = ref.watch(animalRepositoryProvider);
  final result = await repository.getAnimal(animalId);
  return result.fold(
    (error) => throw error,
    (animal) => animal,
  );
});