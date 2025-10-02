import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:porkapp/features/corrals/presentation/corrals_controller.dart';
import 'package:porkapp/features/corrals/presentation/create_corral_view.dart';

class CorralsView extends ConsumerWidget {
  const CorralsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corralsState = ref.watch(corralsControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: corralsState.when(
        data: (corrals) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: corrals.length,
          itemBuilder: (context, index) {
            final corral = corrals[index];
            return Slidable(
              key: ValueKey(corral.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('¿Eliminar corral?'),
                          content: Text(
                            '¿Está seguro que desea eliminar el corral "${corral.name}"?',
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
                                    .read(corralsControllerProvider.notifier)
                                    .deleteCorral(corral.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Corral "${corral.name}" eliminado',
                                    ),
                                    action: SnackBarAction(
                                      label: 'Deshacer',
                                      onPressed: () {
                                        ref
                                            .read(
                                              corralsControllerProvider
                                                  .notifier,
                                            )
                                            .createCorral(
                                              name: corral.name,
                                              location: corral.location,
                                              capacity: corral.capacity,
                                              notes: corral.notes,
                                            );
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
                  SlidableAction(
                    onPressed: (context) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateCorralView(corral: corral),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateCorralView(corral: corral),
                      ),
                    );
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
                              Text(
                                corral.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (corral.location != null)
                                Text(
                                  'Ubicación: ${corral.location}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              if (corral.capacity != null)
                                Text(
                                  'Capacidad: ${corral.capacity}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  corral.activeBatchCount == 0
                                      ? 'Sin lotes activos'
                                      : '${corral.activeBatchCount} ${corral.activeBatchCount == 1 ? 'lote activo' : 'lotes activos'}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            // TODO: Replace with actual image URL from backend
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB9AXXNRP9wpS4bnmZeIS0cSq9O7yh3L2QZSzzvkgYGXyjhELBN70WzXSb_p9p6BMHUTppfhn9OctPki_QYPVdYvFf1Oqmo7p_N782Z5SvUJoVRpRDsvHLBO5gNAyABkVy2cqCzKb0zVdD0sbHw9JQzOtU2Mr8LVsp0ht9SFdlL_ckiUMOOnnJHr5FOCIte-juHq3m90-8Vo7n39dtyYBqAGkrhMOryx7UhlkOTAjZCmoA0XtSbqEXJGA7tL-QnNBD5dKV6fmibZ7pM',
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 96,
                                height: 96,
                                color: theme.colorScheme.surface,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                              );
                            },
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
            Center(child: Text('Error al cargar los corrales: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateCorralView()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Corral'),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
