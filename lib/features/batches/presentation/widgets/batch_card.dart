import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_progress_provider.dart';
import 'package:porkapp/features/biometrics/providers/batch_biometrics_provider.dart';

class BatchCard extends ConsumerWidget {
  final Batch batch;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BatchCard({
    super.key,
    required this.batch,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = batch.headcountStart > 0
        ? batch.animals.length / batch.headcountStart
        : 0.0;
    final statusColor = _getStatusColor(context, batch.status);
    final statusBackgroundColor = _getStatusBackgroundColor(statusColor);
    final statusForegroundColor = _getStatusForegroundColor(statusColor);

    // Consultar la última biometría
    final biometricsAsync = ref.watch(batchBiometricsProvider(batch.id));

    final entryDate = batch.entryDate ?? batch.createdAt;
    final daysElapsed = DateTime.now().difference(entryDate).inDays;

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.08),
      color: Colors.white,
      margin: EdgeInsets.zero,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con estado
            Container(
              decoration: BoxDecoration(
                color: statusBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: statusColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(batch.status),
                    color: statusForegroundColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(batch.status),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: statusForegroundColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del lote
                  Text(
                    batch.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Información del lote
                  Row(
                    children: [
                      Expanded(
                        child: _InfoItem(
                          icon: Icons.calendar_today,
                          label: 'Ingreso',
                          value: _formatDate(entryDate),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoItem(
                          icon: Icons.monitor_weight,
                          label: 'Peso Prom. Última Biom.',
                          value: biometricsAsync.when(
                            data: (measurements) => measurements.isNotEmpty
                                ? '${measurements.last.averageWeight.toStringAsFixed(1)} kg'
                                : '--',
                            loading: () => '...',
                            error: (e, _) => '--',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoItem(
                          icon: Icons.group,
                          label: 'Animales',
                          value:
                              '${batch.animals.length}/${batch.headcountStart}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: batch.birthDate != null
                            ? _InfoItem(
                                icon: Icons.cake,
                                label: 'Edad',
                                value: batch.ageDescription,
                              )
                            : _InfoItem(
                                icon: Icons.timer,
                                label: 'Días desde ingreso',
                                value: '$daysElapsed',
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Barra de progreso
                  if (batch.birthDate != null) ...[
                    // Progress from batch_progress if birthDate is present
                    Consumer(
                      builder: (context, ref, child) {
                        final progressAsync =
                            ref.watch(batchProgressProvider(batch));

                        return progressAsync.when(
                          data: (batchProgress) {
                            if (batchProgress == null) {
                              // Fallback to original progress
                              return _buildDefaultProgressBar(
                                  context, theme, progress);
                            }

                            // Convert hex color to Color
                            Color getColorFromHex(String hexColor) {
                              final hex = hexColor.replaceAll('#', '');
                              return Color(int.parse('0xFF$hex'));
                            }

                            final statusColor =
                                getColorFromHex(batchProgress.statusColor);

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.12),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            batchProgress.statusIcon,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Progreso de Peso',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${batchProgress.progressPercentage.toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: batchProgress.progressPercentage /
                                          100,
                                      backgroundColor:
                                          theme.colorScheme.surface,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          statusColor),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          loading: () => _buildDefaultProgressBar(
                              context, theme, progress),
                          error: (_, __) => _buildDefaultProgressBar(
                              context, theme, progress),
                        );
                      },
                    ),
                  ] else
                    _buildDefaultProgressBar(context, theme, progress),
                ],
              ),
            ),
            // Botones de acción
            if (onEdit != null || onDelete != null)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: onEdit,
                        tooltip: 'Editar lote',
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primaryContainer
                              .withOpacity(0.3),
                        ),
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: theme.colorScheme.error,
                        ),
                        onPressed: onDelete,
                        tooltip: 'Eliminar lote',
                        style: IconButton.styleFrom(
                          backgroundColor:
                              theme.colorScheme.errorContainer.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultProgressBar(
      BuildContext context, ThemeData theme, double progress) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE94C5D).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE94C5D).withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso del Lote',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE94C5D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(context, progress),
              ),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'active':
        return const Color(0xFF4CAF50); // Verde más vibrante
      case 'finalizado':
      case 'finalized':
        return const Color(0xFFFF5A6E); // Rosa coral intenso
      case 'suspendido':
      case 'suspended':
        return const Color(0xFFFFA726); // Naranja llamativo
      default:
        return const Color(0xFF9C27B0); // Púrpura vibrante
    }
  }

  Color _getStatusBackgroundColor(Color color) {
    return Color.lerp(color, Colors.white, 0.82)!;
  }

  Color _getStatusForegroundColor(Color color) {
    final luminance = color.computeLuminance();
    if (luminance < 0.35) {
      return color;
    }
    return Color.lerp(color, Colors.black, 0.25)!;
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'active':
        return Icons.play_circle_outline_rounded;
      case 'finalizado':
      case 'finalized':
        return Icons.check_circle_outline_rounded;
      case 'suspendido':
      case 'suspended':
        return Icons.pause_circle_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'active':
        return 'Activo';
      case 'finalizado':
      case 'finalized':
        return 'Finalizado';
      case 'suspendido':
      case 'suspended':
        return 'Suspendido';
      default:
        return status.isEmpty
            ? '--'
            : status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  Color _getProgressColor(BuildContext context, double progress) {
    if (progress < 0.3) return const Color(0xFFE94C5D); // Coral
    if (progress < 0.7) return const Color(0xFF3B1D2D); // Burdeos
    return const Color(0xFF5CB85C); // Verde campo
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCD8D4).withOpacity(0.3), // Rosa cerdito
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFFE94C5D), // Coral
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
