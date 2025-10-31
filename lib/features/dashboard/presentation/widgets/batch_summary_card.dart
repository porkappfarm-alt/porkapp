import 'package:flutter/material.dart';
import 'package:porkapp/features/dashboard/data/models/batch_summary.dart';

/// Tarjeta de resumen de lote para el dashboard
class BatchSummaryCard extends StatelessWidget {
  final BatchSummary batch;
  final VoidCallback? onTap;

  const BatchSummaryCard({
    super.key,
    required this.batch,
    this.onTap,
  });

  Color _getProgressColor() {
    if (batch.progressToTarget < 30) return Colors.red;
    if (batch.progressToTarget < 60) return Colors.orange;
    if (batch.progressToTarget < 90) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Nombre del lote y corral
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          batch.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B0338),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.home_work,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              batch.corralName,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B0338).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${batch.daysInFarm} días',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B0338),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Métricas: Animales y peso
              Row(
                children: [
                  Expanded(
                    child: _MetricItem(
                      icon: Icons.pets,
                      label: 'Animales',
                      value: '${batch.animalCount}',
                    ),
                  ),
                  Expanded(
                    child: _MetricItem(
                      icon: Icons.monitor_weight,
                      label: 'Peso prom',
                      value: batch.currentAvgWeight != null
                          ? '${batch.currentAvgWeight!.toStringAsFixed(1)} kg'
                          : 'N/A',
                    ),
                  ),
                  Expanded(
                    child: _MetricItem(
                      icon: Icons.trending_up,
                      label: 'ADG',
                      value: batch.avgADG != null
                          ? '${batch.avgADG!.toStringAsFixed(2)} kg/d'
                          : 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barra de progreso
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progreso al objetivo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${batch.progressToTarget.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getProgressColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: batch.progressToTarget / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(),
                      ),
                    ),
                  ),
                ],
              ),

              // Alertas si las hay
              if (batch.hasLowADG || batch.needsBiometry) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (batch.hasLowADG)
                      _AlertChip(
                        icon: Icons.trending_down,
                        label: 'ADG bajo',
                        color: Colors.orange,
                      ),
                    if (batch.hasLowADG && batch.needsBiometry)
                      const SizedBox(width: 8),
                    if (batch.needsBiometry)
                      _AlertChip(
                        icon: Icons.warning,
                        label: 'Necesita biometría',
                        color: Colors.red,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Item de métrica pequeño
class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// Chip de alerta pequeño
class _AlertChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _AlertChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
