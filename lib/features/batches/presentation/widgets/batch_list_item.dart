import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatchListItem extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final int initialCount;
  final double initialAvgWeight;
  final String status;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BatchListItem({
    super.key,
    required this.name,
    required this.startDate,
    required this.initialCount,
    required this.initialAvgWeight,
    required this.status,
    this.imageUrl,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1), // Gris Claro - Bordes/Divisores
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Franja superior de color según estado
          Container(
            height: 12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  statusColor,
                  statusColor.withOpacity(0.85),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
          ),
          // Contenido de la tarjeta
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Nombre y Badge de Estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3E3E3E),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Campos de información
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5EC), // Crema Pastel - Tarjetas
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE9E9E9),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14,
                                    color: Color(0xFFF07281),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Inicio',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B5E55),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(startDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B5E55),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5EC), // Crema Pastel - Tarjetas
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE9E9E9),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.pets_outlined,
                                    size: 14,
                                    color: Color(0xFFF07281),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Animales',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B5E55),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$initialCount/$initialCount',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B5E55),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progreso del Lote
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progreso del Lote',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B5E55),
                        ),
                      ),
                      Text(
                        '${progress.toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B5E55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFFDE7EA),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF5DA271), // Verde Agro - Secundario
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botones de Acción
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE9E9E9), width: 1), // Gris Claro
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onEdit,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Color(0xFFE9E9E9), width: 1), // Gris Claro
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Color(0xFFF07281),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF07281),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(14),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Color(0xFF6B5E55),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Eliminar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B5E55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProgress() {
    // Por ahora retornamos 100% si está activo, 0% si está pendiente
    switch (status.toLowerCase()) {
      case 'activo':
      case 'active':
        return 100.0;
      case 'finalizado':
      case 'finished':
        return 100.0;
      case 'pendiente':
      case 'pending':
        return 0.0;
      default:
        return 50.0;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'active':
        return const Color(0xFFF07281); // Rosa Cerdito Natural - Primario
      case 'finalizado':
      case 'finished':
        return const Color(0xFF5DA271); // Verde Agro - Secundario
      case 'pendiente':
      case 'pending':
        return const Color(0xFFF9C851); // Amarillo Suave - Advertencia
      case 'cancelado':
      case 'cancelled':
        return const Color(0xFFE45B5B); // Rojo Suave - Error/Eliminación
      default:
        return const Color(0xFF6B5E55); // Gris Taupe Moderno - Títulos
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'active':
        return 'Activo';
      case 'finalizado':
      case 'finished':
        return 'Finalizado';
      case 'pendiente':
      case 'pending':
        return 'Pendiente';
      case 'cancelado':
      case 'cancelled':
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }
}
