/// Severidad de las alertas del dashboard
enum AlertSeverity {
  /// Crítico - Requiere atención inmediata (rojo)
  critical,

  /// Advertencia - Requiere atención pronto (amarillo)
  warning,

  /// Información - Notificación general (azul)
  info,
}

/// Tipo de alerta para mejor categorización
enum AlertType {
  /// Lote sin biometría reciente
  missingBiometry,

  /// Corral cerca de capacidad máxima
  corralNearCapacity,

  /// Animal con bajo rendimiento (ADG)
  lowPerformance,

  /// Mortalidad sobre el promedio
  highMortality,

  /// Lote próximo a fecha estimada de venta
  upcomingSale,

  /// Otro tipo de alerta
  other,
}

/// Modelo de alerta para el dashboard
class DashboardAlert {
  /// ID único de la alerta
  final String id;

  /// Severidad de la alerta
  final AlertSeverity severity;

  /// Tipo de alerta
  final AlertType type;

  /// Título de la alerta
  final String title;

  /// Descripción detallada
  final String description;

  /// Cantidad de elementos afectados (opcional)
  final int? affectedCount;

  /// Ruta de navegación para ver más detalles (opcional)
  final String? actionRoute;

  /// Parámetros para la navegación (opcional)
  final Map<String, dynamic>? actionParams;

  /// Fecha de creación de la alerta
  final DateTime createdAt;

  /// Indica si la alerta ha sido leída
  final bool isRead;

  const DashboardAlert({
    required this.id,
    required this.severity,
    required this.type,
    required this.title,
    required this.description,
    this.affectedCount,
    this.actionRoute,
    this.actionParams,
    required this.createdAt,
    this.isRead = false,
  });
}

/// Extensión para obtener el icono según el tipo de alerta
extension AlertTypeExtension on AlertType {
  String get icon {
    switch (this) {
      case AlertType.missingBiometry:
        return '⚖️';
      case AlertType.corralNearCapacity:
        return '🏠';
      case AlertType.lowPerformance:
        return '📉';
      case AlertType.highMortality:
        return '💔';
      case AlertType.upcomingSale:
        return '💰';
      case AlertType.other:
        return 'ℹ️';
    }
  }
}
