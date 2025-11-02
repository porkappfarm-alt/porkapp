import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/feeding/data/feeding_schedule_repository.dart';
import 'package:porkapp/features/feeding/domain/feeding_schedule.dart';

/// Provider del repositorio
final feedingScheduleRepositoryProvider = Provider<FeedingScheduleRepository>(
  (ref) => FeedingScheduleRepository(),
);

/// Provider de la lista de registros
final feedingScheduleListProvider =
    FutureProvider<List<FeedingSchedule>>((ref) async {
  final repository = ref.watch(feedingScheduleRepositoryProvider);
  return repository.getAll();
});

/// Provider para filtrar por tipo de alimento
final feedingScheduleByTypeProvider =
    FutureProvider.family<List<FeedingSchedule>, FeedType?>(
        (ref, feedType) async {
  final repository = ref.watch(feedingScheduleRepositoryProvider);
  if (feedType == null) {
    return repository.getAll();
  }
  return repository.getByFeedType(feedType);
});

/// State notifier para operaciones CRUD
class FeedingScheduleNotifier extends StateNotifier<AsyncValue<void>> {
  final FeedingScheduleRepository _repository;
  final Ref _ref;

  FeedingScheduleNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// Crear nuevo registro
  Future<void> create({
    required int daysOld,
    required double averageWeightKg,
    required double dailyFeedKg,
    required FeedType feedType,
    required List<FeedingTask> tasks,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.create(
        daysOld: daysOld,
        averageWeightKg: averageWeightKg,
        dailyFeedKg: dailyFeedKg,
        feedType: feedType,
        tasks: tasks,
      );
      // Invalidar la lista para refrescar
      _ref.invalidate(feedingScheduleListProvider);
    });
  }

  /// Actualizar registro
  Future<void> update({
    required String id,
    required int daysOld,
    required double averageWeightKg,
    required double dailyFeedKg,
    required FeedType feedType,
    required List<FeedingTask> tasks,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.update(
        id: id,
        daysOld: daysOld,
        averageWeightKg: averageWeightKg,
        dailyFeedKg: dailyFeedKg,
        feedType: feedType,
        tasks: tasks,
      );
      // Invalidar la lista para refrescar
      _ref.invalidate(feedingScheduleListProvider);
    });
  }

  /// Eliminar registro
  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      // Invalidar la lista para refrescar
      _ref.invalidate(feedingScheduleListProvider);
    });
  }
}

/// Provider del notifier
final feedingScheduleNotifierProvider =
    StateNotifierProvider<FeedingScheduleNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(feedingScheduleRepositoryProvider);
  return FeedingScheduleNotifier(repository, ref);
});
