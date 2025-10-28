import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/features/batches/domain/batch.dart';

class BatchCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = batch.animals.length / batch.headcountStart;

    return Card(
      elevation: 2,
      color: const Color(0xFFFFFFFF), // Blanco
      margin: EdgeInsets.zero, // Removido el margen ya que está en el SliverPadding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFFE94C5D).withOpacity(0.15), // Coral suave
          width: 1.5,
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
                color: _getStatusColor(context, batch.status),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    _getStatusColor(context, batch.status),
                    _getStatusColor(context, batch.status).withOpacity(0.8),
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
                    _getStatusIcon(batch.status),
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(batch.status),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
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
                      color: Color(0xFF3B1D2D), // Burdeos
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
                          label: 'Inicio',
                          value: _formatDate(batch.createdAt),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoItem(
                          icon: Icons.group,
                          label: 'Animales',
                          value:
                              '${batch.animals.length}/${batch.headcountStart}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Barra de progreso
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE94C5D)
                          .withOpacity(0.08), // Coral muy suave
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
                                color: const Color(0xFFE94C5D), // Coral
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(progress * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFFFF), // Blanco
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
                  ),
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return const Color(0xFF44C13C); // Verde más vivo
      case 'finalizado':
        return const Color(0xFFE94C5D); // Coral
      case 'suspendido':
        return const Color(0xFF7E1946); // Burdeos más vivo
      default:
        return const Color(0xFF3B1D2D); // Burdeos por defecto
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return Icons.play_circle_outline_rounded;
      case 'finalizado':
        return Icons.check_circle_outline_rounded;
      case 'suspendido':
        return Icons.pause_circle_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _getStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF), // Blanco
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFE94C5D).withOpacity(0.3), // Coral
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 14,
              color: const Color(0xFFE94C5D), // Coral
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
