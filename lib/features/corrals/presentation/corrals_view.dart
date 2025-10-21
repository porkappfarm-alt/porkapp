import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/presentation/corral_details_view.dart';
import 'package:porkapp/features/corrals/presentation/create_corral_view.dart';
import 'package:porkapp/features/corrals/presentation/widgets/change_corral_status_dialog.dart';
import 'package:porkapp/features/corrals/presentation/widgets/corral_status_badge.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

class CorralsView extends ConsumerWidget {
  const CorralsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corralsAsyncValue = ref.watch(corralsProvider);

    return Scaffold(
      appBar: AppBar(
        title: ref.watch(corralsProvider).when(
              data: (corrals) => Text(
                'Corrales (${corrals.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              loading: () => const Text('Cargando...'),
              error: (error, stack) => const Text('Error'),
            ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros
            },
            tooltip: 'Filtrar corrales',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateCorralView(),
                ),
              );
            },
            tooltip: 'Añadir corral',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(corralsProvider);
          },
          child: ref.watch(corralsProvider).when(
                data: (corrals) {
                  if (corrals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fence,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay corrales disponibles',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateCorralView(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Crear corral'),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 900
                                    ? 4
                                    : MediaQuery.of(context).size.width > 600
                                        ? 3
                                        : 1, // Cambiado a 1 para móviles
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width >
                                    600
                                ? 1.3
                                : 2.0, // Ajustado para mejor visualización en móviles
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final corral = corrals[index];

                              return CorralCard(
                                corral: corral,
                                onTap: () {
                                  final corralMap = {
                                    'id': corral.id,
                                    'nombre': corral.name,
                                    'ubicacion': corral.location ?? '',
                                    'capacidad': corral.capacity ?? 0,
                                    'notas': corral.notes ?? '',
                                    'imagen_url': corral.imageUrl,
                                    'estado': 'Activo',
                                    'ocupacion': corral.activeBatchCount,
                                    'creado_en':
                                        corral.createdAt.toIso8601String(),
                                    'creado_por': corral.createdBy,
                                    'actualizado_en':
                                        corral.updatedAt.toIso8601String(),
                                  };

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CorralDetailsView(
                                        corral: corralMap,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: corrals.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateCorralView(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Corral'),
      ),
    );
  }
}

class CorralCard extends ConsumerWidget {
  final Corral corral;
  final VoidCallback onTap;

  const CorralCard({
    super.key,
    required this.corral,
    required this.onTap,
  });

  Color _getOccupancyColor(BuildContext context, num percentage) {
    final theme = Theme.of(context);
    if (percentage >= 90) return theme.colorScheme.error;
    if (percentage >= 75) return theme.colorScheme.secondary;
    return theme.colorScheme.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ocupacionPorcentaje = corral.capacity != null && corral.capacity! > 0
        ? (corral.activeBatchCount.toDouble() /
            corral.capacity!.toDouble() *
            100)
        : 0.0;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: theme.colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con color de fondo basado en ocupación
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: _getOccupancyColor(context, ocupacionPorcentaje)
                    .withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.max, // Asegura que la Row ocupe todo el ancho
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2, // Da más espacio al nombre
                    child: Text(
                      corral.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4), // Reducido el espaciado
                  Flexible(
                    flex: 1, // Da menos espacio al badge
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChangeCorralStatusDialog(
                            corral: corral,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: CorralStatusBadge(status: corral.status),
                    ),
                  ),
                ],
              ),
            ),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información de ocupación
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Ocupación',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${corral.activeBatchCount}/${corral.capacity ?? "∞"}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getOccupancyColor(
                                        context, ocupacionPorcentaje),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Barra de progreso
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ocupación',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${ocupacionPorcentaje.toStringAsFixed(1)}%',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: _getOccupancyColor(
                                        context, ocupacionPorcentaje),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: ocupacionPorcentaje / 100,
                              backgroundColor: theme.colorScheme.surface,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getOccupancyColor(
                                    context, ocupacionPorcentaje),
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
