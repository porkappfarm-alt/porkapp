import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/data/corrals_repository.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

final corralEditProvider =
    StateNotifierProvider.autoDispose<CorralEditNotifier, AsyncValue<void>>(
        (ref) {
  return CorralEditNotifier(ref.watch(corralsRepositoryProvider));
});

class CorralEditNotifier extends StateNotifier<AsyncValue<void>> {
  final CorralsRepository _repository;

  CorralEditNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateCorral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
  }) async {
    try {
      state = const AsyncValue.loading();
      await _repository.updateCorral(
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
      await _repository.deleteCorral(id);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}
