import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/dashboard/data/models/dashboard_alert.dart';

/// Sección de alertas para el dashboard
class AlertSection extends StatelessWidget {
  final List<DashboardAlert> alerts;

  const AlertSection({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
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
                    color: Colors.black87,
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
          AlertType.scheduledTask: 0,
          AlertType.belowTargetWeight: 1,
          AlertType.missingBiometry: 2,
          AlertType.lowPerformance: 3,
          AlertType.corralNearCapacity: 4,
          AlertType.highMortality: 5,
          AlertType.aboveTargetWeight: 6,
          AlertType.upcomingSale: 7,
          AlertType.other: 8,
        };
        return (typeOrder[a.type] ?? 99).compareTo(typeOrder[b.type] ?? 99);
      });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
                  color: Color(0xFF6B0338),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Requieren Atención (${alerts.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B0338),
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
              return AlertTile(alert: alert);
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
                      color: Color(0xFF6B0338),
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
class AlertTile extends StatelessWidget {
  final DashboardAlert alert;

  const AlertTile({
    super.key,
    required this.alert,
  });

  Color _getSeverityColor() {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.warning:
        return Colors.orange;
      case AlertSeverity.info:
        return Colors.blue;
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
  Widget build(BuildContext context) {
    final color = _getSeverityColor();
    final typeIcon = alert.type.icon;

    return InkWell(
      onTap: () {
        if (alert.actionRoute != null) {
          context.push(alert.actionRoute!);
        }
      },
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
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            if (alert.actionRoute != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
