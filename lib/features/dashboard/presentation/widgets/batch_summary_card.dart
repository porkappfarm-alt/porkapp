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
    if (batch.progressToTarget < 30) return const Color(0xFFE45B5B); // Rojo Suave - Error
    if (batch.progressToTarget < 60) return const Color(0xFFF9C851); // Amarillo Suave - Advertencia
    if (batch.progressToTarget < 90) return const Color(0xFF5DA271); // Verde Agro - Secundario
    return const Color(0xFF8BC34A); // Verde Claro - Éxito/Activo
  }

  @override
  Widget build(BuildContext context) {
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
                            color: Color(0xFF6B5E55), // Gris Taupe Moderno - Títulos
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.home_work,
                              size: 14,
                              color: Color(0xFF7B7B7B), // Gris Medio - Texto Secundario
                            ),
                            const SizedBox(width: 4),
                            Text(
                              batch.corralName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7B7B7B), // Gris Medio - Texto Secundario
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
                      color: const Color(0xFFF07281).withOpacity(0.1), // Rosa Cerdito Natural
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${batch.daysInFarm} días',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF07281), // Rosa Cerdito Natural - Primario
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
                      const Text(
                        'Progreso al objetivo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
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
                      backgroundColor: const Color(0xFFE9E9E9), // Gris Claro - Bordes/Divisores
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
                        color: const Color(0xFFF9C851), // Amarillo Suave - Advertencia
                      ),
                    if (batch.hasLowADG && batch.needsBiometry)
                      const SizedBox(width: 8),
                    if (batch.needsBiometry)
                      _AlertChip(
                        icon: Icons.warning,
                        label: 'Necesita biometría',
                        color: const Color(0xFFE45B5B), // Rojo Suave - Error/Eliminación
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
          color: const Color(0xFF6B5E55), // Gris Taupe Moderno
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF7B7B7B), // Gris Medio - Texto Secundario
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
