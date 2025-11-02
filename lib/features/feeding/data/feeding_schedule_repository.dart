import 'package:porkapp/features/feeding/domain/feeding_schedule.dart';
import 'package:porkapp/supabase/supabase.dart';

/// Repositorio para operaciones CRUD de feeding_schedule
class FeedingScheduleRepository {
  /// Helper para convertir JSON de Supabase a FeedingSchedule
  FeedingSchedule _fromSupabaseJson(Map<String, dynamic> json) {
    // Convertir DateTime a String ISO si es necesario
    final createdAt = json['created_at'];
    final updatedAt = json['updated_at'];

    return FeedingSchedule.fromJson({
      'id': json['id'],
      'daysOld': json['days_old'],
      'weeksOld': double.parse(json['weeks_old'].toString()),
      'averageWeightKg': double.parse(json['average_weight_kg'].toString()),
      'dailyFeedKg': double.parse(json['daily_feed_kg'].toString()),
      'weeklyFeedKg': double.parse(json['weekly_feed_kg'].toString()),
      'feedType': json['feed_type'],
      'tasks': (json['tasks'] as List? ?? []).cast<String>(),
      'createdAt': createdAt is String
          ? createdAt
          : (createdAt as DateTime).toIso8601String(),
      'updatedAt': updatedAt is String
          ? updatedAt
          : (updatedAt as DateTime).toIso8601String(),
    });
  }

  /// Obtener todos los registros ordenados por días
  Future<List<FeedingSchedule>> getAll() async {
    try {
      final response = await supabase
          .from('feeding_schedule')
          .select()
          .order('days_old', ascending: true);

      return (response as List).map((json) => _fromSupabaseJson(json)).toList();
    } catch (e) {
      print('[FeedingScheduleRepository] Error getting all: $e');
      rethrow;
    }
  }

  /// Obtener un registro por ID
  Future<FeedingSchedule?> getById(String id) async {
    try {
      final response = await supabase
          .from('feeding_schedule')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return _fromSupabaseJson(response);
    } catch (e) {
      print('[FeedingScheduleRepository] Error getting by id: $e');
      rethrow;
    }
  }

  /// Crear un nuevo registro
  Future<FeedingSchedule> create({
    required int daysOld,
    required double averageWeightKg,
    required double dailyFeedKg,
    required FeedType feedType,
    required List<FeedingTask> tasks,
  }) async {
    try {
      final response = await supabase
          .from('feeding_schedule')
          .insert({
            'days_old': daysOld,
            'average_weight_kg': averageWeightKg,
            'daily_feed_kg': dailyFeedKg,
            'feed_type': feedType.value,
            'tasks': tasks.map((t) => t.value).toList(),
          })
          .select()
          .single();

      return _fromSupabaseJson(response);
    } catch (e) {
      print('[FeedingScheduleRepository] Error creating: $e');
      rethrow;
    }
  }

  /// Actualizar un registro existente
  Future<FeedingSchedule> update({
    required String id,
    required int daysOld,
    required double averageWeightKg,
    required double dailyFeedKg,
    required FeedType feedType,
    required List<FeedingTask> tasks,
  }) async {
    try {
      final response = await supabase
          .from('feeding_schedule')
          .update({
            'days_old': daysOld,
            'average_weight_kg': averageWeightKg,
            'daily_feed_kg': dailyFeedKg,
            'feed_type': feedType.value,
            'tasks': tasks.map((t) => t.value).toList(),
          })
          .eq('id', id)
          .select()
          .single();

      return _fromSupabaseJson(response);
    } catch (e) {
      print('[FeedingScheduleRepository] Error updating: $e');
      rethrow;
    }
  }

  /// Eliminar un registro
  Future<void> delete(String id) async {
    try {
      await supabase.from('feeding_schedule').delete().eq('id', id);
    } catch (e) {
      print('[FeedingScheduleRepository] Error deleting: $e');
      rethrow;
    }
  }

  /// Obtener registros por tipo de alimento
  Future<List<FeedingSchedule>> getByFeedType(FeedType feedType) async {
    try {
      final response = await supabase
          .from('feeding_schedule')
          .select()
          .eq('feed_type', feedType.value)
          .order('days_old', ascending: true);

      return (response as List).map((json) => _fromSupabaseJson(json)).toList();
    } catch (e) {
      print('[FeedingScheduleRepository] Error getting by feed type: $e');
      rethrow;
    }
  }
}
