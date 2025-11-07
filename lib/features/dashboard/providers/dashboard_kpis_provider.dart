import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/dashboard/data/dashboard_repository.dart';
import 'package:porkapp/features/dashboard/data/models/dashboard_kpis.dart';

/// Provider para obtener los KPIs del dashboard
final dashboardKPIsProvider = FutureProvider<DashboardKPIs>((ref) async {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getKPIs();
});

/// Provider con auto-refresh cada 30 segundos
final dashboardKPIsAutoRefreshProvider =
    StreamProvider<DashboardKPIs>((ref) async* {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);

  // Emitir inmediatamente
  yield await repository.getKPIs();

  // Luego emitir cada 30 segundos
  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    yield await repository.getKPIs();
  }
});
