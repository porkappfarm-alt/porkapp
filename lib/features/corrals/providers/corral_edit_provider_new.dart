import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/data/corrals_repository.dart';
import 'package:porkapp/features/corrals/services/corral_service.dart';

final corralServiceProvider = Provider((ref) {
  final repository = ref.watch(corralsRepositoryProvider);
  return CorralService(repository);
});

final corralEditProvider =
    StateNotifierProvider.autoDispose<CorralEditNotifier, AsyncValue<void>>(
  (ref) => CorralEditNotifier(ref.watch(corralServiceProvider)),
);

class CorralEditNotifier extends StateNotifier<AsyncValue<void>> {
  final CorralService _service;

  CorralEditNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> updateCorral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
  }) async {
    try {
      state = const AsyncValue.loading();
      await _service.updateCorral(
        id: id,
        name: name,
        location: location,
        capacity: capacity,
        notes: notes,
      );
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> deleteCorral(String id) async {
    try {
      state = const AsyncValue.loading();
      // Implementar lógica de eliminación aquí
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}
