import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/data/animal_repository.dart';
import 'package:porkapp/features/animals/providers/animal_repository_provider.dart';

// Estado para manejar los animales de un lote específico
final batchAnimalsProvider = StateNotifierProvider.family<AnimalsNotifier,
    AsyncValue<List<Animal>>, String>((ref, batchId) {
  final repository = ref.watch(animalRepositoryProvider);
  return AnimalsNotifier(repository, batchId);
});

class AnimalsNotifier extends StateNotifier<AsyncValue<List<Animal>>> {
  final AnimalRepository _repository;
  final String _batchId;

  AnimalsNotifier(this._repository, this._batchId)
      : super(const AsyncValue.loading()) {
    loadAnimals();
  }

  Future<void> loadAnimals() async {
    try {
      print('Cargando animales para el lote: $_batchId'); // Debug log
      state = const AsyncValue.loading();
      final result = await _repository.getAnimalsByBatch(_batchId);

      result.fold(
        (error) {
          print('Error al cargar animales: $error'); // Debug log
          state = AsyncValue.error(error, StackTrace.current);
        },
        (animals) {
          print(
              'Animales cargados exitosamente: ${animals.length}'); // Debug log
          state = AsyncValue.data(animals);
        },
      );
    } catch (e, stackTrace) {
      print('Excepción al cargar animales: $e'); // Debug log
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
      final newAnimal = Animal(
        id: '', // Se generará en la base de datos
        batchId: _batchId,
        identifier: identifier,
        birthDate: birthDate,
        weight: weight,
        breed: breed,
        type: 'fattening',
        entryDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        gender: 'unknown',
        status: 'active',
      );

      final result = await _repository.createAnimal(newAnimal);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (animal) {
          final currentAnimals = state.value ?? [];
          state = AsyncValue.data([animal, ...currentAnimals]);
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteAnimal(String animalId) async {
    try {
      final result = await _repository.deleteAnimal(animalId);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (_) {
          final currentAnimals = state.value ?? [];
          state = AsyncValue.data(
            currentAnimals.where((animal) => animal.id != animalId).toList(),
          );
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateAnimal(Animal animal) async {
    try {
      final result = await _repository.updateAnimal(animal);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (updatedAnimal) {
          final currentAnimals = state.value ?? [];
          state = AsyncValue.data(
            currentAnimals
                .map((a) => a.id == animal.id ? updatedAnimal : a)
                .toList(),
          );
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
