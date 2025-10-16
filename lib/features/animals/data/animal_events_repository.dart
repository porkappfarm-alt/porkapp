import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:porkapp/shared/exceptions/app_exception.dart';

abstract class AnimalEventsRepository {
  Future<Either<AppException, List<AnimalEvent>>> getEventsByAnimal(String animalId);
  Future<Either<AppException, AnimalEvent>> addEvent(AnimalEvent event);
  Future<Either<AppException, AnimalEvent>> updateEvent(AnimalEvent event);
  Future<Either<AppException, void>> deleteEvent(String eventId);
}

class AnimalEventsRepositoryImpl implements AnimalEventsRepository {
  final SupabaseClient _supabase;

  AnimalEventsRepositoryImpl(this._supabase);

  @override
  Future<Either<AppException, List<AnimalEvent>>> getEventsByAnimal(String animalId) async {
    try {
      print('Fetching events for animal: $animalId');
      final response = await _supabase
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
          .eq('animal_id', animalId)
          .order('event_date', ascending: false);
      
      print('Raw response: $response');
      
      final events = (response as List)
          .map((item) => AnimalEvent.fromJson({
            ...item,
            'date': item['event_date'],
          }))
          .toList();

      return Right(events);
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al obtener los eventos del animal: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }

  @override
  Future<Either<AppException, AnimalEvent>> addEvent(AnimalEvent event) async {
    try {
      final response = await _supabase
          .from('animal_events')
          .insert(event.toJson())
          .select()
          .single();

      return Right(AnimalEvent.fromJson(response));
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al crear el evento: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }

  @override
  Future<Either<AppException, AnimalEvent>> updateEvent(AnimalEvent event) async {
    try {
      final response = await _supabase
          .from('animal_events')
          .update(event.toJson())
          .eq('id', event.id)
          .select()
          .single();

      return Right(AnimalEvent.fromJson(response));
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al actualizar el evento: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteEvent(String eventId) async {
    try {
      await _supabase
          .from('animal_events')
          .delete()
          .eq('id', eventId);

      return const Right(null);
    } catch (e) {
      return Left(
        AppException(
          message: 'Error al eliminar el evento: ${e.toString()}',
          type: AppExceptionType.database,
        ),
      );
    }
  }
}