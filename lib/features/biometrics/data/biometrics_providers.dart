import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/biometrics_repository.dart';
import '../domain/batch_measurement.dart';
import '../domain/animal_measurement.dart';
import '../domain/batch_statistics.dart';

final batchMeasurementsProvider =
    FutureProvider.family<List<BatchMeasurement>, String>((ref, batchId) {
  final repository = ref.watch(biometricsRepositoryProvider);
  return repository.getBatchMeasurements(batchId);
});

final animalMeasurementsProvider =
    FutureProvider.family<List<AnimalMeasurement>, String>(
        (ref, batchMeasurementId) {
  final repository = ref.watch(biometricsRepositoryProvider);
  return repository.getAnimalMeasurements(batchMeasurementId);
});

final animalHistoryProvider =
    FutureProvider.family<List<AnimalMeasurement>, String>((ref, animalId) {
  final repository = ref.watch(biometricsRepositoryProvider);
  return repository.getAnimalHistory(animalId);
});

final batchStatisticsProvider =
    FutureProvider.family<BatchStatistics, String>((ref, batchId) {
  final repository = ref.watch(biometricsRepositoryProvider);
  return repository.getBatchStatistics(batchId);
});

final selectedBatchMeasurementProvider =
    StateProvider<BatchMeasurement?>((ref) => null);

final biometricsNotifierProvider =
    StateNotifierProvider<BiometricsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(biometricsRepositoryProvider);
  return BiometricsNotifier(repository);
});

class BiometricsNotifier extends StateNotifier<AsyncValue<void>> {
  final BiometricsRepository _repository;

  BiometricsNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createBatchMeasurement(BatchMeasurement measurement) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _repository.createBatchMeasurement(measurement));
  }

  Future<void> createAnimalMeasurement(AnimalMeasurement measurement) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _repository.createAnimalMeasurement(measurement));
  }

  Future<void> updateBatchMeasurementStatus(String id, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _repository.updateBatchMeasurementStatus(id, status));
  }

  Future<void> deleteBatchMeasurement(String id) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _repository.deleteBatchMeasurement(id));
  }

  Future<void> deleteAnimalMeasurement(String id) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _repository.deleteAnimalMeasurement(id));
  }
}
