import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:porkapp/supabase/supabase.dart';

final animalEventsProvider = StateNotifierProvider.family
    .autoDispose<AnimalEventsNotifier, AsyncValue<List<AnimalEvent>>, String>(
      (ref, animalId) => AnimalEventsNotifier(animalId: animalId),
    );

class AnimalEventsNotifier
    extends StateNotifier<AsyncValue<List<AnimalEvent>>> {
  final String animalId;

  AnimalEventsNotifier({required this.animalId})
    : super(const AsyncValue.loading()) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final response = await supabase
          .from('animal_events')
          .select()
          .eq('animal_id', animalId)
          .order('date');

      final events = response
          .map((json) => AnimalEvent.fromJson(json))
          .toList()
          .cast<AnimalEvent>();

      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addEvent(AnimalEvent event) async {
    try {
      final response = await supabase
          .from('animal_events')
          .insert(event.toJson())
          .select();

      final newEvent = AnimalEvent.fromJson(response.first);

      state.whenData((events) {
        state = AsyncValue.data([...events, newEvent]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await supabase.from('animal_events').delete().eq('id', eventId);

      state.whenData((events) {
        state = AsyncValue.data(events.where((e) => e.id != eventId).toList());
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
