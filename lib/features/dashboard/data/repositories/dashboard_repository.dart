import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/domain.dart';
import '../../utils/stream_throttle.dart';

class DashboardRepository {
  final SupabaseClient _supabase;

  DashboardRepository(this._supabase);

  Future<CorralMetrics> getCorralMetrics() async {
    try {
      // Obtener corrales activos
      final response = await _supabase.rpc('get_corral_metrics').single();

      return CorralMetrics(
        activeCount: response['active_count'] ?? 0,
        occupancyRate: (response['occupancy_rate'] ?? 0).toDouble(),
        monthlyChange: (response['monthly_change'] ?? 0).toDouble(),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      return CorralMetrics.empty();
    }
  }

  Future<BatchMetrics> getBatchMetrics() async {
    try {
      // Obtener métricas de lotes
      final response = await _supabase.rpc('get_batch_metrics').single();

      return BatchMetrics(
        activeCount: response['active_count'] ?? 0,
        generalStatus: response['general_status'] ?? 'Sin datos',
        endingSoon: response['ending_soon'] ?? 0,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      return BatchMetrics.empty();
    }
  }

  Future<PopulationMetrics> getPopulationMetrics() async {
    try {
      // Obtener métricas de población
      final response = await _supabase.rpc('get_population_metrics').single();

      return PopulationMetrics(
        totalCount: response['total_count'] ?? 0,
        statusDistribution: Map<String, int>.from(
          response['status_distribution'] ?? {},
        ),
        dailyEntries: response['daily_entries'] ?? 0,
        dailyExits: response['daily_exits'] ?? 0,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      return PopulationMetrics.empty();
    }
  }

  Future<WeightMetrics> getWeightMetrics() async {
    try {
      // Obtener métricas de peso
      final response = await _supabase.rpc('get_weight_metrics').single();

      return WeightMetrics(
        averageWeight: (response['average_weight'] ?? 0).toDouble(),
        dailyGain: (response['daily_gain'] ?? 0).toDouble(),
        weeklyTrend: response['weekly_trend'] ?? 'Sin datos',
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      return WeightMetrics.empty();
    }
  }

  Stream<CorralMetrics> watchCorralMetrics() async* {
    // Emitir el valor inicial
    yield await getCorralMetrics();

    // Escuchar cambios
    await for (final _ in _supabase
        .from('corrals')
        .stream(primaryKey: ['id']).throttle(const Duration(seconds: 5))) {
      yield await getCorralMetrics();
    }
  }

  Stream<BatchMetrics> watchBatchMetrics() async* {
    yield await getBatchMetrics();

    await for (final _ in _supabase
        .from('batches')
        .stream(primaryKey: ['id']).throttle(const Duration(seconds: 5))) {
      yield await getBatchMetrics();
    }
  }

  Stream<PopulationMetrics> watchPopulationMetrics() async* {
    yield await getPopulationMetrics();

    await for (final _ in _supabase
        .from('animals')
        .stream(primaryKey: ['id']).throttle(const Duration(seconds: 5))) {
      yield await getPopulationMetrics();
    }
  }

  Stream<WeightMetrics> watchWeightMetrics() async* {
    yield await getWeightMetrics();

    await for (final _ in _supabase
        .from('animal_events')
        .stream(primaryKey: ['id']).throttle(const Duration(seconds: 5))) {
      yield await getWeightMetrics();
    }
  }
}
