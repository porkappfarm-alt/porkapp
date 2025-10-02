import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:porkapp/features/batches/presentation/batches_controller.dart';
import 'package:porkapp/features/batches/presentation/create_batch_view.dart';

class BatchesView extends ConsumerWidget {
  const BatchesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchesState = ref.watch(batchesControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: batchesState.when(
        data: (batches) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: batches.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            final batch = batches[index];
            return Slidable(
              key: ValueKey(batch.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('¿Eliminar lote?'),
                          content: Text(
                            '¿Está seguro que desea eliminar el lote "${batch.name}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ref
                                    .read(batchesControllerProvider.notifier)
                                    .deleteBatch(batch.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Lote "${batch.name}" eliminado',
                                    ),
                                    action: SnackBarAction(
                                      label: 'Deshacer',
                                      onPressed: () {
                                        // TODO: Implement undo
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Eliminar',
                  ),
                  if (batch.status == 'active')
                    SlidableAction(
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('¿Finalizar lote?'),
                            content: Text(
                              '¿Está seguro que desea finalizar el lote "${batch.name}"?\n\n'
                              'Una vez finalizado, no podrá agregar más animales a este lote y '
                              'el corral quedará disponible para un nuevo lote.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(batchesControllerProvider.notifier)
                                      .finishBatch(batch.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Lote "${batch.name}" finalizado',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Finalizar'),
                              ),
                            ],
                          ),
                        );
                      },
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      icon: Icons.check_circle,
                      label: 'Finalizar',
                    ),
                  SlidableAction(
                    onPressed: (context) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateBatchView(batch: batch),
                        ),
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Editar',
                  ),
                ],
              ),
              child: Card(
                child: InkWell(
                  onTap: () {
                    context.go('/batches/${batch.id}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: batch.status == 'active'
                                          ? Colors.green
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    batch.status == 'active'
                                        ? 'Activo'
                                        : 'Finalizado',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: batch.status == 'active'
                                          ? Colors.green
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                batch.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Fecha inicio: ${DateFormat('dd/MM/yyyy').format(batch.createdAt)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(
                                'Cantidad inicial: ${batch.headcountStart} cerdos',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              if (batch.initialAvgWeight != null)
                                Text(
                                  'Peso inicial promedio: ${batch.initialAvgWeight} kg',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            // TODO: Replace with actual image URL
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuB9AXXNRP9wpS4bnmZeIS0cSq9O7yh3L2QZSzzvkgYGXyjhELBN70WzXSb_p9p6BMHUTppfhn9OctPki_QYPVdYvFf1Oqmo7p_N782Z5SvUJoVRpRDsvHLBO5gNAyABkVy2cqCzKb0zVdD0sbHw9JQzOtU2Mr8LVsp0ht9SFdlL_ckiUMOOnnJHr5FOCIte-juHq3m90-8Vo7n39dtyYBqAGkrhMOryx7UhlkOTAjZCmoA0XtSbqEXJGA7tL-QnNBD5dKV6fmibZ7pM',
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 96,
                              height: 96,
                              color: theme.colorScheme.surface,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 96,
                              height: 96,
                              color: theme.colorScheme.surface,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error al cargar los lotes: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateBatchView()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Lote'),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
