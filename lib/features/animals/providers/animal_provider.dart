import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/data/animal_repository.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/providers/animal_repository_provider.dart';

final animalProvider = FutureProvider.family<Animal, String>((ref, animalId) async {
  final repo = ref.watch(animalRepositoryProvider);
  final result = await repo.getAnimal(animalId);
  return result.fold(
    (error) => throw error,
    (animal) => animal,
  );
});