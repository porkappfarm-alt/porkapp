import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/dashboard/data/dashboard_repository.dart';
import 'package:porkapp/features/dashboard/data/models/dashboard_alert.dart';
import 'package:porkapp/features/dashboard/data/read_alerts_service.dart';

/// Provider del servicio de alertas leídas
final readAlertsServiceProvider = Provider<ReadAlertsService>((ref) {
  return ReadAlertsService();
});

/// Provider para obtener todas las alertas (incluyendo leídas)
final allAlertsProvider = FutureProvider<List<DashboardAlert>>((ref) async {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getAlerts();
});

/// Provider para obtener solo las alertas no leídas
final dashboardAlertsProvider =
    FutureProvider<List<DashboardAlert>>((ref) async {
  print('🔄 dashboardAlertsProvider: Cargando alertas...');
  final alerts = await ref.watch(allAlertsProvider.future);
  print(
      '📊 dashboardAlertsProvider: Total alertas generadas: ${alerts.length}');
  final readService = ref.watch(readAlertsServiceProvider);

  // Filtrar alertas no leídas
  final unreadAlerts = <DashboardAlert>[];
  for (final alert in alerts) {
    final isRead = await readService.isRead(alert.id);
    if (!isRead) {
      unreadAlerts.add(alert);
    }
  }

  print('✅ dashboardAlertsProvider: Alertas no leídas: ${unreadAlerts.length}');
  return unreadAlerts;
});

/// StateNotifier para manejar acciones sobre las alertas
class AlertsNotifier extends StateNotifier<AsyncValue<void>> {
  AlertsNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  /// Marca una alerta como leída
  Future<void> markAsRead(String alertId) async {
    print('🎯 AlertsNotifier.markAsRead: Iniciando para $alertId');
    state = const AsyncValue.loading();
    try {
      final readService = ref.read(readAlertsServiceProvider);
      await readService.markAsRead(alertId);

      print('♻️ AlertsNotifier.markAsRead: Invalidando providers...');
      // Invalidar ambos providers para refrescar la lista
      ref.invalidate(allAlertsProvider);
      ref.invalidate(dashboardAlertsProvider);

      state = const AsyncValue.data(null);
      print('✅ AlertsNotifier.markAsRead: Completado exitosamente');
    } catch (error, stackTrace) {
      print('❌ AlertsNotifier.markAsRead: Error - $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Marca todas las alertas actuales como leídas
  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    try {
      final alerts = await ref.read(dashboardAlertsProvider.future);
      final readService = ref.read(readAlertsServiceProvider);

      final alertIds = alerts.map((alert) => alert.id).toList();
      await readService.markMultipleAsRead(alertIds);

      // Invalidar ambos providers para refrescar la lista
      ref.invalidate(allAlertsProvider);
      ref.invalidate(dashboardAlertsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider del AlertsNotifier
final alertsNotifierProvider =
    StateNotifierProvider<AlertsNotifier, AsyncValue<void>>((ref) {
  return AlertsNotifier(ref);
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
