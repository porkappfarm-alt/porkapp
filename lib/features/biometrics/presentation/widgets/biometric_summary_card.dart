import 'package:flutter/material.dart';
import '../../domain/batch_measurement.dart';
import 'package:intl/intl.dart';

class BiometricSummaryCard extends StatelessWidget {
  final BatchMeasurement? measurement;
  final VoidCallback? onTap;

  const BiometricSummaryCard({
    super.key,
    this.measurement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (measurement == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('No hay datos disponibles'),
          ),
        ),
      );
    }

    final dateFormatter = DateFormat('dd/MM/yyyy');
    final weightFormatter = NumberFormat('#,##0.00', 'es_ES');

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Biometría ${dateFormatter.format(measurement!.measurementDate)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(measurement!.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(measurement!.status),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Peso Promedio',
                      value:
                          '${weightFormatter.format(measurement!.averageWeight)} kg',
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Animales',
                      value: measurement!.animalCount.toString(),
                    ),
                  ),
                ],
              ),
              if (measurement!.notes != null &&
                  measurement!.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Notas: ${measurement!.notes}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Activo';
      case 'cancelled':
        return 'Cancelado';
      case 'archived':
        return 'Archivado';
      default:
        return 'Desconocido';
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
