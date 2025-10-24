import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/biometrics/domain/batch_measurement.dart';
import 'package:porkapp/features/biometrics/domain/biometrics_repository.dart';

/// Provider para el filtro de búsqueda
final biometricSearchFilterProvider = StateProvider<String>((ref) => '');

/// Provider para el filtro de fecha
final biometricDateFilterProvider = StateProvider<DateTime?>((ref) => null);

/// Provider para manejar el estado de la vista simplificada de biometrías
final simpleBiometricProvider = StateNotifierProvider<SimpleBiometricNotifier,
    AsyncValue<List<BatchMeasurement>>>((ref) {
  final repository = ref.watch(biometricsRepositoryProvider);
  return SimpleBiometricNotifier(repository);
});

class SimpleBiometricNotifier
    extends StateNotifier<AsyncValue<List<BatchMeasurement>>> {
  final BiometricsRepository _repository;

  SimpleBiometricNotifier(this._repository)
      : super(const AsyncValue.loading()) {
    loadBiometrics();
  }

  Future<void> loadBiometrics({String? batchId}) async {
    try {
      state = const AsyncValue.loading();
      final measurements =
          await _repository.getBatchMeasurements(batchId: batchId);
      state = AsyncValue.data(measurements);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveBiometric(BatchMeasurement measurement) async {
    try {
      await _repository.saveBatchMeasurement(measurement);
      loadBiometrics(batchId: measurement.batchId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  List<BatchMeasurement> filterByDate(DateTime date) {
    if (state.hasValue) {
      return state.value!
          .where((m) =>
              m.measurementDate.year == date.year &&
              m.measurementDate.month == date.month &&
              m.measurementDate.day == date.day)
          .toList();
    }
    return [];
  }

  List<BatchMeasurement> searchBiometrics(String query) {
    if (state.hasValue && query.isNotEmpty) {
      return state.value!
          .where((m) =>
              m.batchName?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    return state.valueOrNull ?? [];
  }
}
