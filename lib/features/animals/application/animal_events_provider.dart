import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/data/animal_events_repository.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:porkapp/supabase/supabase.dart';

/// Provider para el repositorio de eventos de animales
final animalEventsRepositoryProvider = Provider<AnimalEventsRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AnimalEventsRepositoryImpl(supabase);
});

/// Provider principal para gestionar eventos de animales
final animalEventsProvider = AsyncNotifierProviderFamily<AnimalEventsNotifier, List<AnimalEvent>, String>(
  () => AnimalEventsNotifier(),
);

/// Notifier para gestionar el estado y las operaciones de eventos
class AnimalEventsNotifier extends FamilyAsyncNotifier<List<AnimalEvent>, String> {
  late final AnimalEventsRepository _repository;

  @override
  Future<List<AnimalEvent>> build(String animalId) async {
    print('Building AnimalEventsNotifier for animalId: $animalId');
    _repository = ref.watch(animalEventsRepositoryProvider);
    final result = await _repository.getEventsByAnimal(animalId);
    
    return result.fold(
      (error) {
        print('Error fetching events: $error');
        throw error;
      },
      (events) {
        print('Successfully fetched ${events.length} events');
        return events;
      },
    );
  }

  Future<void> addEvent(AnimalEvent event) async {
    state = const AsyncValue.loading();
    final result = await _repository.addEvent(event);
    
    state = await result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (newEvent) async {
        final updatedResult = await _repository.getEventsByAnimal(event.animalId);
        return updatedResult.fold(
          (error) => AsyncValue.error(error, StackTrace.current),
          (events) => AsyncValue.data(events),
        );
      },
    );
  }

  Future<void> updateEvent(AnimalEvent event) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateEvent(event);
    
    state = await result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (updatedEvent) async {
        final updatedResult = await _repository.getEventsByAnimal(event.animalId);
        return updatedResult.fold(
          (error) => AsyncValue.error(error, StackTrace.current),
          (events) => AsyncValue.data(events),
        );
      },
    );
  }

  Future<void> deleteEvent(String eventId) async {
    if (state case AsyncData(:final value)) {
      final animalId = value.firstWhere((e) => e.id == eventId).animalId;
      state = const AsyncValue.loading();
      final result = await _repository.deleteEvent(eventId);
      
      state = await result.fold(
        (error) => AsyncValue.error(error, StackTrace.current),
        (_) async {
          final updatedResult = await _repository.getEventsByAnimal(animalId);
          return updatedResult.fold(
            (error) => AsyncValue.error(error, StackTrace.current),
            (events) => AsyncValue.data(events),
          );
        },
      );
    }
  }
}
