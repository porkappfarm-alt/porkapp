import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/dashboard/data/models/dashboard_alert.dart';
import 'package:porkapp/features/dashboard/providers/dashboard_alerts_provider.dart';

/// Sección de alertas para el dashboard
class AlertSection extends ConsumerWidget {
  final List<DashboardAlert> alerts;

  const AlertSection({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (alerts.isEmpty) {
      return Card(
        elevation: 3,
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFE9E9E9), // Gris Claro - Bordes/Divisores
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A).withOpacity(0.1), // Verde Claro - Éxito/Activo
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF8BC34A), // Verde Claro - Éxito/Activo
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Todo en orden\nNo hay alertas pendientes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sort alerts by priority (critical > warning > info)
    final sortedAlerts = List<DashboardAlert>.from(alerts)
      ..sort((a, b) {
        // First by severity
        final severityOrder = {
          AlertSeverity.critical: 0,
          AlertSeverity.warning: 1,
          AlertSeverity.info: 2,
        };
        final severityComparison =
            severityOrder[a.severity]!.compareTo(severityOrder[b.severity]!);
        if (severityComparison != 0) return severityComparison;

        // Then by alert type priority
        final typeOrder = {
          AlertType.readyForSale: 0,
          AlertType.feedTypeChange: 1,
          AlertType.scheduledTask: 2,
          AlertType.belowTargetWeight: 3,
          AlertType.missingBiometry: 4,
          AlertType.lowPerformance: 5,
          AlertType.corralNearCapacity: 6,
          AlertType.highMortality: 7,
          AlertType.aboveTargetWeight: 8,
          AlertType.upcomingSale: 9,
          AlertType.other: 10,
        };
        return (typeOrder[a.type] ?? 99).compareTo(typeOrder[b.type] ?? 99);
      });

    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE9E9E9), // Gris Claro - Bordes/Divisores
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Color(0xFFF07281), // Rosa Cerdito Natural - Primario
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Requieren Atención (${alerts.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B5E55), // Gris Taupe Moderno - Títulos
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedAlerts.length > 3 ? 3 : sortedAlerts.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final alert = sortedAlerts[index];
              return Dismissible(
                key: Key(alert.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: const Color(0xFF8BC34A), // Verde Claro - Éxito/Activo
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                confirmDismiss: (direction) async {
                  await ref
                      .read(alertsNotifierProvider.notifier)
                      .markAsRead(alert.id);
                  return true;
                },
                child: AlertTile(alert: alert),
              );
            },
          ),
          if (sortedAlerts.length > 3)
            InkWell(
              onTap: () {
                context.push('/dashboard/alerts');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Ver todas (${alerts.length})',
                    style: const TextStyle(
                      color: Color(0xFFF07281), // Rosa Cerdito Natural - Primario
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tile individual de alerta
class AlertTile extends ConsumerWidget {
  final DashboardAlert alert;

  const AlertTile({
    super.key,
    required this.alert,
  });

  Color _getSeverityColor() {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return const Color(0xFFE45B5B); // Rojo Suave - Error/Eliminación
      case AlertSeverity.warning:
        return const Color(0xFFF9C851); // Amarillo Suave - Advertencia
      case AlertSeverity.info:
        return const Color(0xFF5DA271); // Verde Agro - Secundario
    }
  }

  IconData _getSeverityIcon() {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Icons.error;
      case AlertSeverity.warning:
        return Icons.warning;
      case AlertSeverity.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getSeverityColor();
    final typeIcon = alert.type.icon;

    return GestureDetector(
      onTap: () {
        if (alert.actionRoute != null) {
          context.push(alert.actionRoute!);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      typeIcon,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _getSeverityIcon(),
                      color: color,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B7B7B), // Gris Medio - Texto Secundario
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  await ref
                      .read(alertsNotifierProvider.notifier)
                      .markAsRead(alert.id);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8BC34A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF8BC34A).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF8BC34A), // Verde Claro - Éxito/Activo
                    size: 18,
                  ),
                ),
              ),
              if (alert.actionRoute != null) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFC7C7C7), // Gris Neutro - Inactivo/Neutro
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
