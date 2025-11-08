import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/data/animals_repository.dart';
import 'package:porkapp/features/animals/domain/animal.dart';

/// Provider para manejar la caché y estado de un animal individual
final animalDetailProvider =
    AsyncNotifierProvider.family<AnimalDetailNotifier, Animal, String>(
  () => AnimalDetailNotifier(),
);

class AnimalDetailNotifier extends FamilyAsyncNotifier<Animal, String> {
  late final AnimalsRepository _repository;

  @override
  Future<Animal> build(String animalId) async {
    print('AnimalDetailProvider: Iniciando build para animalId: $animalId');
    state = const AsyncValue.loading();
    _repository = ref.read(animalsRepositoryProvider);

    try {
      print('AnimalDetailProvider: Intentando obtener datos del animal...');
      final animal = await _repository.getAnimal(animalId);
      print(
          'AnimalDetailProvider: Animal obtenido exitosamente: ${animal.toString()}');
      return animal;
    } catch (e, stack) {
      // Log del error para debugging
      print('Error cargando animal $animalId: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  Future<void> updateAnimal({
    required String identifier,
    required DateTime birthDate,
    required String breed,
    double? weight,
    required String status,
  }) async {
    // Solo actualizar si tenemos un estado previo válido
    final currentAnimal = state.value;
    if (currentAnimal == null) return;

    state = const AsyncValue.loading();

    try {
      final updatedAnimal = await _repository.updateAnimal(
        id: currentAnimal.id,
        identifier: identifier,
        birthDate: birthDate,
        breed: breed,
        weight: weight,
        status: status,
      );

      state = AsyncValue.data(updatedAnimal);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAnimal() async {
    final currentAnimal = state.value;
    if (currentAnimal == null) return;

    try {
      await _repository.deleteAnimal(currentAnimal.id);
      state = const AsyncValue.loading(); // Marcar como eliminado
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    final currentAnimal = state.value;
    if (currentAnimal == null) return;

    state = const AsyncValue.loading();
    try {
      final refreshedAnimal = await _repository.getAnimal(currentAnimal.id);
      state = AsyncValue.data(refreshedAnimal);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
