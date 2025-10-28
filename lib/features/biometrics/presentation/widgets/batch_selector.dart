import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';

class BatchSelector extends ConsumerWidget {
  final void Function(String) onBatchSelected;

  const BatchSelector({
    super.key,
    required this.onBatchSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ref.watch(activeBatchesProvider).when(
          data: (batches) {
            if (batches.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: theme.colorScheme.error),
                      const SizedBox(height: 8),
                      const Text('No hay lotes activos'),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.invalidate(activeBatchesProvider),
                        child: const Text('Actualizar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Selecciona un lote para ver sus biometrías',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ...batches.map((batch) {
                  final animalCount = batch.animals.length;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => onBatchSelected(batch.id),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    batch.name,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Creado: ${batch.createdAt.day}/${batch.createdAt.month}/${batch.createdAt.year}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$animalCount',
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text(
                                  'animales',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(height: 8),
                  Text('Error: $error'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref.invalidate(activeBatchesProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
