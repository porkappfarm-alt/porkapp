import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/dashboard/data/dashboard_repository.dart';
import 'package:porkapp/features/dashboard/data/models/batch_summary.dart';
import 'package:porkapp/features/dashboard/data/models/chart_data.dart';

/// Provider para obtener resúmenes de lotes
final batchSummariesProvider = FutureProvider<List<BatchSummary>>((ref) async {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getBatchSummaries(limit: 3);
});

/// Provider para obtener datos de tendencia de peso
final weightTrendDataProvider =
    FutureProvider.family<List<WeightDataPoint>, int>(
  (ref, days) async {
    // Observar el estado de autenticación para reiniciar cuando cambie el usuario
    ref.watch(authStateProvider);
    final repository = ref.watch(dashboardRepositoryProvider);
    return repository.getWeightTrendData(days: days);
  },
);

/// Provider por defecto para tendencia de 30 días
final weightTrend30DaysProvider =
    FutureProvider<List<WeightDataPoint>>((ref) async {
  return ref.watch(weightTrendDataProvider(30).future);
});

/// Provider para obtener datos de comparación de ADG
final adgComparisonDataProvider =
    FutureProvider<List<ADGComparisonData>>((ref) async {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getADGComparisonData();
});

/// Provider para verificar si hay datos disponibles para gráficos
final hasChartDataProvider = Provider<bool>((ref) {
  final weightData = ref.watch(weightTrend30DaysProvider);
  final adgData = ref.watch(adgComparisonDataProvider);

  return weightData.when(
        data: (data) => data.isNotEmpty,
        loading: () => false,
        error: (_, __) => false,
      ) ||
      adgData.when(
        data: (data) => data.isNotEmpty,
        loading: () => false,
        error: (_, __) => false,
      );
});
