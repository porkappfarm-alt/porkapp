import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/data/animals_repository.dart';
import 'package:porkapp/features/animals/domain/animal.dart';

class AnimalsController extends StateNotifier<AsyncValue<List<Animal>>> {
  AnimalsController(this.ref) : super(const AsyncValue.loading());

  final Ref ref;
  String? _currentBatchId;

  Future<void> loadAnimals(String batchId) async {
    if (_currentBatchId == batchId) return;
    _currentBatchId = batchId;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(animalsRepositoryProvider).getAnimalsByBatch(batchId),
    );
  }

  Future<void> createAnimal({
    required String batchId,
    required String identifier,
    required DateTime birthDate,
    required String breed,
    double? weight,
    String status = 'active',
  }) async {
    await ref.read(animalsRepositoryProvider).createAnimal(
          batchId: batchId,
          identifier: identifier,
          birthDate: birthDate,
          breed: breed,
          weight: weight,
          status: status,
        );
    loadAnimals(batchId);
  }

  Future<void> updateAnimal({
    required String id,
    required String identifier,
    required DateTime birthDate,
    required String breed,
    double? weight,
    required String status,
  }) async {
    await ref.read(animalsRepositoryProvider).updateAnimal(
          id: id,
          identifier: identifier,
          birthDate: birthDate,
          breed: breed,
          weight: weight,
          status: status,
        );
    if (_currentBatchId != null) {
      loadAnimals(_currentBatchId!);
    }
  }

  Future<void> deleteAnimal(String id) async {
    await ref.read(animalsRepositoryProvider).deleteAnimal(id);
    if (_currentBatchId != null) {
      loadAnimals(_currentBatchId!);
    }
  }
}

final animalsControllerProvider =
    StateNotifierProvider<AnimalsController, AsyncValue<List<Animal>>>((ref) {
  return AnimalsController(ref);
});
