import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/batches/presentation/widgets/batch_card.dart';
import 'package:porkapp/features/batches/presentation/widgets/batch_form_dialog.dart';

class BatchesView extends ConsumerWidget {
  const BatchesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Lotes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros
            },
            tooltip: 'Filtrar lotes',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(batchListProvider);
        },
        child: ref.watch(batchListProvider).when(
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
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
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

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final batch = batches[index];
                            return BatchCard(
                              batch: batch,
                              onTap: () => context.push('/batches/${batch.id}'),
                              onEdit: () => _onBatchEdit(context, batch),
                              onDelete: () => _onBatchDelete(context, batch),
                            );
                          },
                          childCount: batches.length,
                        ),
                      ),
                    ),
                    // Espacio adicional al final de la lista
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                );
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBatchDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Lote'),
      ),
    );
  }

  void _onBatchTap(BuildContext context, Batch batch) {
    context.go('/batches/${batch.id}');
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 4; // Pantallas grandes
    if (width > 900) return 3; // Tablets horizontales
    if (width > 600) return 2; // Tablets verticales
    return 1; // Móviles
  }

  double _calculateHorizontalPadding(double width) {
    if (width > 1200) return 32;
    if (width > 900) return 24;
    if (width > 600) return 16;
    return 8;
  }

  double _calculateChildAspectRatio(double width) {
    if (width > 1200) return 1.2;
    if (width > 900) return 1.1;
    if (width > 600) return 1.0;
    return 0.9;
  }

  void _onBatchEdit(BuildContext context, Batch batch) {
    context.push('/batches/edit/${batch.id}');
  }

  void _onBatchDelete(BuildContext context, Batch batch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar lote?'),
        content: Text(
          '¿Está seguro que desea eliminar el lote "${batch.name}"?\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementar eliminación del lote
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showCreateBatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const BatchFormDialog(),
    );
  }
}
