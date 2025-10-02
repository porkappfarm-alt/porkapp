import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/presentation/widgets/batch_list_item.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';

class BatchesView extends ConsumerWidget {
  const BatchesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lotes'),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: ref
          .watch(batchListProvider)
          .when(
            data: (batches) {
              if (batches.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 64,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay lotes creados',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _showCreateBatchDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Crear Lote'),
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
                  itemCount: batches.length,
                  itemBuilder: (context, index) {
                    final batch = batches[index];
                    return BatchListItem(
                      name: batch.name,
                      startDate: batch.createdAt,
                      initialCount: batch.headcountStart,
                      initialAvgWeight: batch.initialAvgWeight ?? 0,
                      status: batch.status ?? 'active',
                      imageUrl: batch.imageUrl,
                      onTap: () => context.push('/batches/${batch.id}'),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar los lotes',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(batchListProvider);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBatchDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Lote'),
      ),
    );
  }

  void _showCreateBatchDialog(BuildContext context) {
    // TODO: Implementar diálogo de creación de lote
  }
}
