import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/batch_measurement.dart';
import '../../providers/biometric_providers.dart';
import '../widgets/biometric_summary_card.dart';
import './biometric_detail_view.dart';
import './new_biometric_view.dart';
import '../../../../shared/design/app_styles.dart';

class BiometricListView extends ConsumerWidget {
  final String batchId;
  final String? batchName;

  const BiometricListView({
    super.key,
    required this.batchId,
    this.batchName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricsAsync = ref.watch(batchBiometricsProvider(batchId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Biometrías - ${batchName ?? 'Lote $batchId'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _navigateToStats(context),
            tooltip: 'Ver Estadísticas',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToNewBiometric(context),
            tooltip: 'Nueva Medición',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.background,
            ],
          ),
        ),
        child: biometricsAsync.when(
          data: (biometrics) {
            if (biometrics.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildBiometricsList(context, biometrics);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar las biometrías',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.refresh(batchBiometricsProvider(batchId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToNewBiometric(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Medición'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.scale_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay biometrías registradas',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Registra el primer pesaje del lote',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToNewBiometric(context),
            icon: const Icon(Icons.add),
            label: const Text('Nueva Medición'),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricsList(
      BuildContext context, List<BatchMeasurement> biometrics) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: biometrics.length,
      itemBuilder: (context, index) {
        final biometric = biometrics[index];
        return _BiometricCard(
          biometric: biometric,
          onTap: () => _navigateToDetail(context, biometric.id),
        );
      },
    );
  }

  void _navigateToNewBiometric(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewBiometricView(initialBatchId: batchId),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String biometricId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BiometricDetailView(biometricId: biometricId),
      ),
    );
  }

  void _navigateToStats(BuildContext context) {
    // Implementar navegación a estadísticas
  }
}

class _BiometricCard extends StatelessWidget {
  final BatchMeasurement biometric;
  final VoidCallback onTap;

  const _BiometricCard({
    required this.biometric,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final measurementDate = biometric.createdAt.toLocal();
    final formattedDate =
        '${measurementDate.day}/${measurementDate.month}/${measurementDate.year}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medición del $formattedDate',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${biometric.animalCount} animales pesados',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.verdeField.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${biometric.averageWeight.toStringAsFixed(2)} kg',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.verdeField,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (biometric.notes?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.note,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          biometric.notes!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
