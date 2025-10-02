import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:porkapp/supabase/supabase.dart';

final animalEventsProvider =
    AsyncNotifierProviderFamily<
      AnimalEventsNotifier,
      List<AnimalEvent>,
      String
    >(() => AnimalEventsNotifier());

class AnimalEventsNotifier
    extends FamilyAsyncNotifier<List<AnimalEvent>, String> {
  @override
  Future<List<AnimalEvent>> build(String animalId) async {
    final client = ref.read(supabaseProvider);
    final response = await client
        .from('animal_events')
        .select()
        .eq('animal_id', animalId)
        .order('date', ascending: false);

    return (response as List<dynamic>)
        .map((json) => AnimalEvent.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addEvent(AnimalEvent event) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(supabaseProvider);
      await client.from('animal_events').insert(event.toJson());
      state = AsyncValue.data([event, ...state.value ?? []]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      final client = ref.read(supabaseProvider);
      await client.from('animal_events').delete().eq('id', eventId);
      state = AsyncValue.data(
        state.value?.where((e) => e.id != eventId).toList() ?? [],
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
