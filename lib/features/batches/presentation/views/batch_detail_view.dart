import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_form_dialog.dart';
import 'package:porkapp/features/animals/providers/animals_provider.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_provider.dart'
    as single_batch;
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/batches/presentation/widgets/error_view.dart';

class BatchDetailView extends ConsumerWidget {
  final String batchId;

  const BatchDetailView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Lote'),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          // Información del lote
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ref.watch(single_batch.batchProvider(batchId)).when(
                  data: (batch) => _BatchHeader(batch: batch),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => BatchErrorView(
                    error: error.toString(),
                    onRetry: () =>
                        ref.invalidate(single_batch.batchProvider(batchId)),
                  ),
                ),
          ),

          // Lista de animales del lote
          Expanded(
            child: ref.watch(single_batch.batchProvider(batchId)).when(
                  data: (batch) {
                    print('Batch recibido: ${batch.toString()}'); // Debug log
                    print(
                        'Cantidad de animales: ${batch.animals.length}'); // Debug log

                    final animals = batch.animals;
                    if (animals.isEmpty) {
                      print(
                          'No se encontraron animales en el lote'); // Debug log
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pets,
                              size: 64,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay animales en este lote',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                print(
                                    'Intentando agregar animal...'); // Debug log
                                _showAddAnimalDialog(context);
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar Animal'),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(batchListProvider);
                      },
                      child: ListView.builder(
                        itemCount: animals.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final animal = animals[index];
                          return Card(
                            child: InkWell(
                              onTap: () => context.push(
                                  '/batches/$batchId/animals/${animal.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: Text(
                                        animal.identifier
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            animal.identifier,
                                            style: theme.textTheme.titleMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${animal.breed} - ${animal.weight != null ? "${animal.weight!.toStringAsFixed(1)} kg" : "Sin peso"}',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.7),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: animal.status == 'active'
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        animal.status,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: animal.status == 'active'
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => BatchErrorView(
                    error: error.toString(),
                    onRetry: () =>
                        ref.invalidate(batchAnimalsProvider(batchId)),
                  ),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAnimalDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Animal'),
      ),
    );
  }

  void _showAddAnimalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AnimalFormDialog(preselectedBatchId: batchId),
    );
  }

  void _showEditAnimalDialog(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (context) => AnimalFormDialog(animal: animal),
    );
  }
}

class _BatchHeader extends StatelessWidget {
  final Batch batch;

  const _BatchHeader({required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(batch.name, style: theme.textTheme.headlineSmall),
                      const SizedBox(width: 8),
                      _StatusChip(status: batch.status),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.monitor_weight),
                  onPressed: () => context.go('/biometrics/${batch.id}'),
                  tooltip: 'Ver Biometrías',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha inicio: ${_formatDate(batch.createdAt)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Cantidad inicial: ${batch.headcountStart} cerdos',
              style: theme.textTheme.bodyMedium,
            ),
            if (batch.initialAvgWeight != null) ...[
              const SizedBox(height: 4),
              Text(
                'Peso inicial promedio: ${batch.initialAvgWeight!.toStringAsFixed(1)} kg',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (batch.notes != null && batch.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text('Notas:', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(batch.notes!, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_getStatusText(status)),
      backgroundColor: _getStatusColor(status),
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'active':
        return Colors.green;
      case 'finalizado':
      case 'finished':
        return Colors.blue;
      case 'cancelado':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
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
      case 'cancelado':
      case 'cancelled':
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }
}
