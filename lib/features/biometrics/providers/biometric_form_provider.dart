import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/biometric_local_models.dart';
import '../data/local/biometric_sync_service.dart';

final biometricFormStateProvider = StateNotifierProvider<BiometricFormNotifier,
    Map<String, BiometricFieldState>>((ref) {
  final syncService = ref.watch(biometricSyncServiceProvider);
  return BiometricFormNotifier(syncService);
});

class BiometricFieldState {
  final bool isSaved;
  final bool hasError;
  final String? errorMessage;
  final double? weight;

  BiometricFieldState({
    this.isSaved = false,
    this.hasError = false,
    this.errorMessage,
    this.weight,
  });

  BiometricFieldState copyWith({
    bool? isSaved,
    bool? hasError,
    String? errorMessage,
    double? weight,
  }) {
    return BiometricFieldState(
      isSaved: isSaved ?? this.isSaved,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      weight: weight ?? this.weight,
    );
  }
}

class BiometricFormNotifier
    extends StateNotifier<Map<String, BiometricFieldState>> {
  final BiometricSyncService _syncService;

  BiometricFormNotifier(this._syncService) : super({});

  Future<void> saveWeight(String animalId, String value) async {
    // Validar el peso
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      state = {
        ...state,
        animalId: BiometricFieldState(
          hasError: true,
          errorMessage: 'El peso debe ser un número mayor a 0',
          weight: null,
        ),
      };
      return;
    }

    try {
      final measurement = LocalAnimalMeasurement()
        ..animalId = animalId
        ..weight = weight
        ..createdAt = DateTime.now()
        ..syncStatus = SyncStatus.pending;

      await _syncService.saveAnimalMeasurement(measurement);

      state = {
        ...state,
        animalId: BiometricFieldState(
          isSaved: true,
          hasError: false,
          weight: weight,
        ),
      };
    } catch (e) {
      state = {
        ...state,
        animalId: BiometricFieldState(
          hasError: true,
          errorMessage: 'Error al guardar: ${e.toString()}',
          weight: weight,
        ),
      };
    }
  }

  void resetFieldState(String animalId) {
    final newState = Map<String, BiometricFieldState>.from(state);
    newState.remove(animalId);
    state = newState;
  }
}
