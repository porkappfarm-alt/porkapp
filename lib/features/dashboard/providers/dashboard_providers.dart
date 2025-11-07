import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import '../domain/domain.dart';
import '../data/data.dart';

// Provider del repositorio
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final supabase = Supabase.instance.client;
  return DashboardRepository(supabase);
});

// Providers para métricas de corrales
final corralMetricsProvider = StreamProvider<CorralMetrics>((ref) {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchCorralMetrics();
});

final corralMetricsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(corralMetricsProvider).isLoading;
});

// Providers para métricas de lotes
final batchMetricsProvider = StreamProvider<BatchMetrics>((ref) {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchBatchMetrics();
});

final batchMetricsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(batchMetricsProvider).isLoading;
});

// Providers para métricas de población
final populationMetricsProvider = StreamProvider<PopulationMetrics>((ref) {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchPopulationMetrics();
});

final populationMetricsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(populationMetricsProvider).isLoading;
});

// Providers para métricas de peso
final weightMetricsProvider = StreamProvider<WeightMetrics>((ref) {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchWeightMetrics();
});

final weightMetricsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(weightMetricsProvider).isLoading;
});
