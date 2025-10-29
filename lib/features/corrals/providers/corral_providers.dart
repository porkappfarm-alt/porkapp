import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/data/corrals_repository.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

final corralsRepositoryProvider = Provider((ref) => CorralsRepository());

/// StateNotifier para manejar la lista de corrales con actualizaciones optimistas
class CorralsNotifier extends StateNotifier<AsyncValue<List<Corral>>> {
  CorralsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadCorrals();
  }

  final CorralsRepository _repository;

  Future<void> loadCorrals() async {
    state = const AsyncValue.loading();
    try {
      final corrals = await _repository.getCorrals();
      state = AsyncValue.data(corrals);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Agrega un corral a la lista de forma optimista
  void addCorralOptimistic(Corral corral) {
    state.whenData((corrals) {
      state = AsyncValue.data([...corrals, corral]);
    });
  }

  /// Actualiza un corral en la lista de forma optimista
  void updateCorralOptimistic(Corral updatedCorral) {
    state.whenData((corrals) {
      final index = corrals.indexWhere((c) => c.id == updatedCorral.id);
      if (index != -1) {
        final newList = [...corrals];
        newList[index] = updatedCorral;
        state = AsyncValue.data(newList);
      }
    });
  }

  /// Elimina un corral de la lista de forma optimista
  void removeCorralOptimistic(int corralId) {
    state.whenData((corrals) {
      state = AsyncValue.data(corrals.where((c) => c.id != corralId).toList());
    });
  }
}

/// Provider que obtiene la lista de corrales
final corralsProvider =
    StateNotifierProvider<CorralsNotifier, AsyncValue<List<Corral>>>((ref) {
  return CorralsNotifier(ref.read(corralsRepositoryProvider));
});
