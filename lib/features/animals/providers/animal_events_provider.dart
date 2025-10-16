import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final animalEventsProvider = StateNotifierProvider.family<AnimalEventsNotifier,
    AsyncValue<List<AnimalEvent>>, String>((ref, animalId) {
  final client = Supabase.instance.client;
  return AnimalEventsNotifier(client, animalId);
});

class AnimalEventsNotifier
    extends StateNotifier<AsyncValue<List<AnimalEvent>>> {
  final SupabaseClient _client;
  final String _animalId;

  AnimalEventsNotifier(this._client, this._animalId) : super(const AsyncValue.loading()) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      print('Loading events for animal: $_animalId');
      final response = await _client
          .from('animal_events')
          .select('''
            id,
            animal_id,
            event_date,
            type,
            data,
            notes,
            created_at,
            updated_at,
            weight,
            qty_feed,
            death_cause,
            batch_id,
            description
          ''')
          .eq('animal_id', _animalId)
          .order('event_date', ascending: false);

      print('Raw response: $response');

      final events = (response as List)
          .map((event) => AnimalEvent.fromJson({
                ...event,
                'date': event['event_date'],
              }))
          .toList();

      print('Parsed events: $events');
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      print('Error loading events: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addEvent(AnimalEvent event) async {
    try {
      final eventData = event.toJson();
      // Corrige el campo de fecha para la base de datos
      eventData['event_date'] = eventData.remove('date');
      
      print('Adding event: $eventData');
      await _client.from('animal_events').insert(eventData);
      await loadEvents();
    } catch (error, stackTrace) {
      print('Error adding event: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _client.from('animal_events').delete().eq('id', eventId);
      await loadEvents();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  List<AnimalEvent> getEventsForAnimal(String animalId) {
    return state.maybeWhen(
      data: (events) =>
          events.where((event) => event.animalId == animalId).toList(),
      orElse: () => [],
    );
  }
}
