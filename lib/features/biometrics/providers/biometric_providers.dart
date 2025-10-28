import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/batch_measurement.dart';
import '../domain/animal_measurement.dart';
import '../data/biometrics_repository.dart';
import '../data/local/biometric_sync_service.dart';
import '../data/local/biometric_local_models.dart';

/// Provider para obtener todas las biometrías
final allBiometricsProvider =
    FutureProvider<List<BatchMeasurement>>((ref) async {
  final repository = ref.watch(biometricsRepositoryProvider);
  return repository.getAllBatchMeasurements();
});

/// Provider para obtener todas las biometrías de un lote
final batchBiometricsProvider =
    FutureProvider.family<List<BatchMeasurement>, String>((ref, batchId) async {
  final repository = ref.watch(biometricsRepositoryProvider);
  return repository.getBatchMeasurements(batchId);
});

/// Provider para obtener una biometría específica por ID
final batchBiometricProvider =
    FutureProvider.family<BatchMeasurement?, String>((ref, biometricId) async {
  final repository = ref.watch(biometricsRepositoryProvider);
  return repository.getBatchMeasurement(biometricId);
});

/// Provider para la última biometría de un lote
final latestBiometricProvider =
    FutureProvider.family<BatchMeasurement?, String>((ref, batchId) async {
  final measurements = await ref.watch(batchBiometricsProvider(batchId).future);
  if (measurements.isEmpty) return null;
  return measurements.first;
});

/// Estado para el formulario de nueva biometría
class NewBiometricState {
  final bool isLoading;
  final String? error;
  final BatchMeasurement? measurement;

  const NewBiometricState({
    this.isLoading = false,
    this.error,
    this.measurement,
  });

  NewBiometricState copyWith({
    bool? isLoading,
    String? error,
    BatchMeasurement? measurement,
  }) {
    return NewBiometricState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      measurement: measurement ?? this.measurement,
    );
  }
}

/// Provider para manejar el estado del formulario de nueva biometría
final newBiometricProvider =
    StateNotifierProvider<NewBiometricNotifier, NewBiometricState>((ref) {
  final repository = ref.watch(biometricsRepositoryProvider);
  final syncService = ref.watch(biometricSyncServiceProvider);
  return NewBiometricNotifier(repository, syncService);
});

class NewBiometricNotifier extends StateNotifier<NewBiometricState> {
  final BiometricsRepository _repository;
  final BiometricSyncService _syncService;

  NewBiometricNotifier(this._repository, this._syncService)
      : super(const NewBiometricState());

  /// Crea el registro inicial de biometría en la base de datos
  /// Retorna el ID del registro creado o null si hay error
  Future<String?> createInitialBiometric({
    required String batchId,
    required DateTime measurementDate,
    String? notes,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final batchMeasurement = BatchMeasurement(
        id: '',
        batchId: batchId,
        measurementDate: measurementDate,
        averageWeight: 0.0, // Se actualizará al guardar los pesos
        animalCount: 0, // Se actualizará al guardar los pesos
        notes: notes,
        createdBy: 'current_user', // TODO: Obtener usuario actual
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'draft', // Estado draft hasta que se completen los pesos
      );

      try {
        // Intentar guardar online
        final savedMeasurement =
            await _repository.createBatchMeasurement(batchMeasurement);

        state = state.copyWith(
          isLoading: false,
          measurement: savedMeasurement,
        );
        return savedMeasurement.id;
      } catch (e) {
        // Si falla, guardar offline
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final localMeasurement = batchMeasurement.copyWith(id: tempId);

        await _syncService.saveBatchMeasurement(localMeasurement.toLocal());

        state = state.copyWith(
          isLoading: false,
          measurement: localMeasurement,
          error: 'Guardado offline. Se sincronizará cuando haya conexión.',
        );
        return tempId;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al crear la biometría: ${e.toString()}',
      );
      return null;
    }
  }

  Future<bool> saveAnimalMeasurement({
    required String batchId,
    required AnimalMeasurement measurement,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Intentar guardar online
      try {
        BatchMeasurement? existingMeasurement;
        if (state.measurement == null) {
          final batchMeasurement = BatchMeasurement(
            id: '',
            batchId: batchId,
            measurementDate: DateTime.now(),
            averageWeight: measurement.weight,
            animalCount: 1,
            notes: '',
            createdBy: 'current_user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            status: 'active',
          );

          existingMeasurement =
              await _repository.createBatchMeasurement(batchMeasurement);
          state = state.copyWith(measurement: existingMeasurement);
        }

        await _repository.createAnimalMeasurement(
          measurement.copyWith(
            batchMeasurementId:
                state.measurement?.id ?? existingMeasurement!.id,
          ),
        );

        state = state.copyWith(isLoading: false);
        return true;
      } catch (e) {
        // Si falla el guardado online, intentar guardar offline
        try {
          if (state.measurement == null) {
            final batchMeasurement = BatchMeasurement(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              batchId: batchId,
              measurementDate: DateTime.now(),
              averageWeight: measurement.weight,
              animalCount: 1,
              notes: '',
              createdBy: 'current_user',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              status: 'active',
            );

            await _syncService.saveBatchMeasurement(batchMeasurement.toLocal());
            state = state.copyWith(measurement: batchMeasurement);
          }

          final localMeasurement = measurement.toLocal()
            ..remoteId =
                null // Forzar que no tenga remoteId para evitar conflictos
            ..syncStatus = SyncStatus.pending;

          await _syncService.saveAnimalMeasurement(localMeasurement);

          state = state.copyWith(
            isLoading: false,
            error: 'Guardado offline. Se sincronizará cuando haya conexión.',
          );
          return true;
        } catch (e) {
          throw Exception('Error al guardar localmente: ${e.toString()}');
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> saveBiometric({
    required String batchId,
    required List<AnimalMeasurement> measurements,
    String? notes,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Calcular promedio y crear la medición del lote
      final averageWeight = measurements.isEmpty
          ? 0.0
          : measurements.map((m) => m.weight).reduce((a, b) => a + b) /
              measurements.length;

      final batchMeasurement = BatchMeasurement(
        id: '',
        batchId: batchId,
        measurementDate: DateTime.now(),
        averageWeight: averageWeight,
        animalCount: measurements.length,
        notes: notes,
        createdBy: 'current_user', // TODO: Obtener usuario actual
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'active',
      );

      // Intentar guardar online
      try {
        final savedMeasurement =
            await _repository.createBatchMeasurement(batchMeasurement);

        // Guardar mediciones individuales
        for (final measurement in measurements) {
          await _repository.createAnimalMeasurement(measurement.copyWith(
            batchMeasurementId: savedMeasurement.id,
          ));
        }

        state = state.copyWith(
          isLoading: false,
          measurement: savedMeasurement,
        );
        return true;
      } catch (e) {
        // Si falla, guardar offline
        await _syncService.saveBatchMeasurement(batchMeasurement.toLocal());
        for (final measurement in measurements) {
          await _syncService.saveAnimalMeasurement(measurement.toLocal());
        }

        state = state.copyWith(
          isLoading: false,
          error: 'Guardado offline. Se sincronizará cuando haya conexión.',
        );
        return true;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al guardar la biometría: ${e.toString()}',
      );
      return false;
    }
  }

  /// Guarda las mediciones individuales y actualiza el registro de biometría
  Future<bool> saveAnimalMeasurements({
    required String biometricId,
    required String batchId,
    required List<AnimalMeasurement> measurements,
    String? notes,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Calcular promedio
      final averageWeight = measurements.isEmpty
          ? 0.0
          : measurements.map((m) => m.weight).reduce((a, b) => a + b) /
              measurements.length;

      // Intentar guardar online
      try {
        // Guardar mediciones individuales
        for (final measurement in measurements) {
          await _repository.createAnimalMeasurement(measurement.copyWith(
            batchMeasurementId: biometricId,
          ));
        }

        // Actualizar el registro principal con los datos finales
        final updatedMeasurement = await _repository.updateBatchMeasurement(
          id: biometricId,
          averageWeight: averageWeight,
          animalCount: measurements.length,
          notes: notes,
          status: 'active', // Cambiar de draft a active
        );

        state = state.copyWith(
          isLoading: false,
          measurement: updatedMeasurement,
        );
        return true;
      } catch (e) {
        // Si falla, guardar offline
        for (final measurement in measurements) {
          await _syncService.saveAnimalMeasurement(measurement.toLocal());
        }

        state = state.copyWith(
          isLoading: false,
          error: 'Guardado offline. Se sincronizará cuando haya conexión.',
        );
        return true;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al guardar las mediciones: ${e.toString()}',
      );
      return false;
    }
  }
}

/// Provider para obtener los lotes activos
final activeBatchesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // TODO: Implementar obtención de lotes activos
  return [];
});
