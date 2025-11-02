import 'package:flutter/material.dart';
import 'package:porkapp/features/feeding/domain/feeding_schedule.dart';

/// Card para mostrar un registro de alimentación
class FeedingScheduleCard extends StatelessWidget {
  final FeedingSchedule feeding;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FeedingScheduleCard({
    super.key,
    required this.feeding,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFFE94C5D).withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header con tipo de alimento
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getFeedTypeColor(feeding.feedType),
                    _getFeedTypeColor(feeding.feedType).withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _getFeedTypeIcon(feeding.feedType),
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    feeding.feedType.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          _showDeleteConfirmation(context);
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Eliminar',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // KPIs en grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniKpi(
                          icon: Icons.calendar_today,
                          label: 'Días',
                          value: '${feeding.daysOld}',
                          subtitle:
                              '${feeding.weeksOld.toStringAsFixed(1)} sem',
                          color: const Color(0xFF6B0338),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMiniKpi(
                          icon: Icons.monitor_weight,
                          label: 'Peso',
                          value: '${feeding.averageWeightKg}',
                          subtitle: 'kg promedio',
                          color: const Color(0xFF8B1548),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMiniKpi(
                          icon: Icons.restaurant,
                          label: 'Diario',
                          value: '${feeding.dailyFeedKg}',
                          subtitle: 'kg/día',
                          color: const Color(0xFFAB2758),
                        ),
                      ),
                    ],
                  ),

                  // Cantidad semanal
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF07281).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_view_week,
                          color: Color(0xFFF07281),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Alimento semanal: ${feeding.weeklyFeedKg.toStringAsFixed(2)} kg',
                          style: const TextStyle(
                            color: Color(0xFF6B0338),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tareas
                  if (feeding.tasks.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: feeding.tasks
                          .map((task) => Chip(
                                label: Text(
                                  task.label,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                avatar: Icon(
                                  _getTaskIcon(task),
                                  size: 14,
                                  color: const Color(0xFF6B0338),
                                ),
                                backgroundColor:
                                    const Color(0xFFF07281).withOpacity(0.1),
                                labelStyle: const TextStyle(
                                  color: Color(0xFF6B0338),
                                  fontSize: 12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                ),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniKpi({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFE53935)),
            SizedBox(width: 8),
            Text('Confirmar eliminación'),
          ],
        ),
        content: Text(
          '¿Está seguro de eliminar el registro del día ${feeding.daysOld}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onDelete != null) onDelete!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Color _getFeedTypeColor(FeedType type) {
    switch (type) {
      case FeedType.preStarter:
        return const Color(0xFF6B0338);
      case FeedType.starter:
        return const Color(0xFF8B1548);
      case FeedType.grower:
        return const Color(0xFFAB2758);
      case FeedType.fattening:
        return const Color(0xFFF07281);
      case FeedType.finisher:
        return const Color(0xFFE94C5D);
    }
  }

  IconData _getFeedTypeIcon(FeedType type) {
    switch (type) {
      case FeedType.preStarter:
        return Icons.child_care;
      case FeedType.starter:
        return Icons.restaurant;
      case FeedType.grower:
        return Icons.trending_up;
      case FeedType.fattening:
        return Icons.fastfood;
      case FeedType.finisher:
        return Icons.check_circle;
    }
  }

  IconData _getTaskIcon(FeedingTask task) {
    switch (task) {
      case FeedingTask.vitamin:
        return Icons.medical_services;
      case FeedingTask.deworm:
        return Icons.healing;
    }
  }
}
