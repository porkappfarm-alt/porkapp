import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/data/animal_repository.dart';
import 'package:porkapp/features/animals/providers/animal_repository_provider.dart';

// Provider para todas las operaciones con animales
final animalsProvider =
    StateNotifierProvider<AnimalsNotifier, AsyncValue<List<Animal>>>((ref) {
  final repository = ref.watch(animalRepositoryProvider);
  return AnimalsNotifier(repository);
});

// Estado para manejar los animales de un lote específico
final batchAnimalsProvider = StateNotifierProvider.family<BatchAnimalsNotifier,
    AsyncValue<List<Animal>>, String>((ref, batchId) {
  final repository = ref.watch(animalRepositoryProvider);
  return BatchAnimalsNotifier(repository, batchId);
});

class AnimalsNotifier extends StateNotifier<AsyncValue<List<Animal>>> {
  final AnimalRepository _repository;

  AnimalsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadAnimals();
  }

  Future<void> loadAnimals() async {
    try {
      state = const AsyncValue.loading();
      final result = await _repository.getAnimals();

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (animals) => state = AsyncValue.data(animals),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createAnimal(Animal animal) async {
    try {
      final result = await _repository.createAnimal(animal);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (newAnimal) {
          final currentAnimals = state.value ?? [];
          state = AsyncValue.data([newAnimal, ...currentAnimals]);
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
            currentAnimals.map((a) => a.id == animal.id ? updatedAnimal : a).toList(),
          );
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteAnimal(String id) async {
    try {
      final result = await _repository.deleteAnimal(id);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (_) {
          final currentAnimals = state.value ?? [];
          state = AsyncValue.data(
            currentAnimals.where((animal) => animal.id != id).toList(),
          );
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class BatchAnimalsNotifier extends StateNotifier<AsyncValue<List<Animal>>> {
  final AnimalRepository _repository;
  final String _batchId;

  BatchAnimalsNotifier(this._repository, this._batchId)
      : super(const AsyncValue.loading()) {
    loadAnimals();
  }

  Future<void> loadAnimals() async {
    try {
      state = const AsyncValue.loading();
      final result = await _repository.getAnimalsByBatch(_batchId);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (animals) => state = AsyncValue.data(animals),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addAnimal(Animal animal) async {
    try {
      final result = await _repository.createAnimal(animal);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (newAnimal) {
          final currentAnimals = state.value ?? [];
          state = AsyncValue.data([newAnimal, ...currentAnimals]);
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
            currentAnimals.map((a) => a.id == animal.id ? updatedAnimal : a).toList(),
          );
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteAnimal(String id) async {
    try {
      final result = await _repository.deleteAnimal(id);

      result.fold(
        (error) => state = AsyncValue.error(error, StackTrace.current),
        (_) {
          final currentAnimals = state.value ?? [];
          state = AsyncValue.data(
            currentAnimals.where((animal) => animal.id != id).toList(),
          );
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
