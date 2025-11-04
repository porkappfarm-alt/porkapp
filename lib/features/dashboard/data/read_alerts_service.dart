import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para gestionar el estado de las alertas leídas
class ReadAlertsService {
  static const String _keyPrefix = 'read_alert_';

  /// Marca una alerta como leída
  Future<void> markAsRead(String alertId) async {
    print('📝 ReadAlertsService.markAsRead: Guardando $alertId');
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setBool('$_keyPrefix$alertId', true);
    print('✅ ReadAlertsService.markAsRead: Guardado con éxito: $success');
  }

  /// Verifica si una alerta ha sido leída
  Future<bool> isRead(String alertId) async {
    final prefs = await SharedPreferences.getInstance();
    final isRead = prefs.getBool('$_keyPrefix$alertId') ?? false;
    print('🔍 ReadAlertsService.isRead: $alertId = $isRead');
    return isRead;
  }

  /// Marca múltiples alertas como leídas
  Future<void> markMultipleAsRead(List<String> alertIds) async {
    final prefs = await SharedPreferences.getInstance();
    for (final id in alertIds) {
      await prefs.setBool('$_keyPrefix$id', true);
    }
  }

  /// Limpia todas las alertas leídas (opcional, para mantenimiento)
  Future<void> clearAllRead() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_keyPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  /// Limpia alertas leídas antiguas (mayores a 30 días)
  /// Nota: Requiere almacenar timestamp, implementación futura si es necesario
  Future<void> clearOldReadAlerts() async {
    // TODO: Implementar si se necesita limpiar alertas antiguas
    // Por ahora las alertas se regeneran cada vez que se consultan
  }
}
