import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/batch_measurement.dart';
import '../../providers/biometric_providers.dart';
import '../widgets/biometric_summary_card.dart';

class BiometricDetailView extends ConsumerWidget {
  final String biometricId;

  const BiometricDetailView({
    super.key,
    required this.biometricId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricAsync = ref.watch(batchBiometricProvider(biometricId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Biometría'),
      ),
      body: biometricAsync.when(
        data: (biometric) {
          if (biometric == null) {
            return const Center(
              child: Text('No se encontró la biometría'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              BiometricSummaryCard(measurement: biometric),
              const SizedBox(height: 16),
              _buildStatsSection(biometric),
              const SizedBox(height: 16),
              _buildMeasurementsTable(biometric),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BatchMeasurement biometric) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Peso Promedio', '${biometric.averageWeight} kg'),
            _buildStatRow('Cantidad de Animales', '${biometric.animalCount}'),
            if (biometric.notes?.isNotEmpty ?? false)
              _buildStatRow('Notas', biometric.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildMeasurementsTable(BatchMeasurement biometric) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mediciones Individuales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID Animal')),
                  DataColumn(label: Text('Peso (kg)')),
                  DataColumn(label: Text('Ganancia')),
                  DataColumn(label: Text('GDP')),
                ],
                rows: biometric.measurements.map((measurement) {
                  return DataRow(
                    cells: [
                      DataCell(Text(measurement.animalId)),
                      DataCell(Text('${measurement.weight}')),
                      DataCell(Text(measurement.weightGain != null
                          ? '${measurement.weightGain} kg'
                          : '-')),
                      DataCell(Text(measurement.adg != null
                          ? '${measurement.adg} kg/día'
                          : '-')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
