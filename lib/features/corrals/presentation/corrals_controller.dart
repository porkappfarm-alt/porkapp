import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/data/corrals_repository.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

class CorralsController extends StateNotifier<AsyncValue<List<Corral>>> {
  CorralsController(this.ref) : super(const AsyncValue.loading()) {
    loadCorrals();
  }

  final Ref ref;

  Future<void> loadCorrals() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => 
      ref.read(corralsRepositoryProvider).getCorrals()
    );
  }

  Future<void> createCorral({
    required String name,
    String? location,
    int? capacity,
    String? notes,
  }) async {
    await ref.read(corralsRepositoryProvider).createCorral(
      name: name,
      location: location,
      capacity: capacity,
      notes: notes,
    );
    loadCorrals();
  }

  Future<void> updateCorral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
  }) async {
    await ref.read(corralsRepositoryProvider).updateCorral(
      id: id,
      name: name,
      location: location,
      capacity: capacity,
      notes: notes,
    );
    loadCorrals();
  }

  Future<void> deleteCorral(String id) async {
    await ref.read(corralsRepositoryProvider).deleteCorral(id);
    loadCorrals();
  }
}

final corralsControllerProvider = StateNotifierProvider<CorralsController, AsyncValue<List<Corral>>>((ref) {
  return CorralsController(ref);
});