import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_form_dialog.dart';
import 'package:porkapp/features/animals/providers/animals_provider.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';

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
            child: ref
                .watch(batchProvider(batchId))
                .when(
                  data: (batch) => _BatchHeader(batch: batch),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                ),
          ),

          // Lista de animales
          Expanded(
            child: ref
                .watch(batchAnimalsProvider(batchId))
                .when(
                  data: (animals) {
                    if (animals.isEmpty) {
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
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _showAddAnimalDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar Animal'),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(batchAnimalsProvider(batchId));
                      },
                      child: ListView.builder(
                        itemCount: animals.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final animal = animals[index];
                          return _AnimalListItem(
                            animal: animal,
                            onTap: () => _showEditAnimalDialog(context, animal),
                          );
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
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
                Text(batch.name, style: theme.textTheme.headlineSmall),
                _StatusChip(status: batch.status),
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

class _AnimalListItem extends StatelessWidget {
  final Animal animal;
  final VoidCallback onTap;

  const _AnimalListItem({required this.animal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.pets, color: Colors.white),
        ),
        title: Text(animal.identifier),
        subtitle: Text('${animal.breed} - ${animal.weight}kg'),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
