import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/dashboard/data/dashboard_repository.dart';
import 'package:porkapp/features/dashboard/data/models/dashboard_alert.dart';

/// Provider para obtener las alertas del dashboard
final dashboardAlertsProvider =
    FutureProvider<List<DashboardAlert>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getAlerts();
});

/// Provider para contar alertas no leídas
final unreadAlertsCountProvider = Provider<int>((ref) {
  final alertsAsyncValue = ref.watch(dashboardAlertsProvider);

  return alertsAsyncValue.when(
    data: (alerts) => alerts.where((alert) => !alert.isRead).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider para alertas críticas
final criticalAlertsProvider = Provider<List<DashboardAlert>>((ref) {
  final alertsAsyncValue = ref.watch(dashboardAlertsProvider);

  return alertsAsyncValue.when(
    data: (alerts) => alerts
        .where((alert) => alert.severity == AlertSeverity.critical)
        .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});
