import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_form_dialog.dart';
import 'package:porkapp/features/animals/providers/animals_provider.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_provider.dart'
    as single_batch;
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/batches/presentation/widgets/error_view.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';

class BatchDetailView extends ConsumerWidget {
  final String batchId;

  const BatchDetailView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final batchAsync = ref.watch(single_batch.batchProvider(batchId));
    // Eliminado: lógica incorrecta y referencias a Corral/corralProvider

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: StandardAppBar(
        title: 'Detalle de Lote',
        onBackPressed: () => context.pop(),
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
            child: ref.watch(batchAnimalsProvider(batchId)).when(
                  data: (animals) {
                    print(
                        'Cantidad de animales: ${animals.length}'); // Debug log

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
                          return GestureDetector(
                            onTap: () => context
                                .push('/batches/$batchId/animals/${animal.id}'),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      const Color(0xFFF07281).withOpacity(0.15),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      'assets/images/3800591.png',
                                      fit: BoxFit.cover,
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
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF5D4037),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${animal.breed} - ${animal.weight != null ? "${animal.weight!.toStringAsFixed(1)} kg" : "Sin peso"}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: animal.status == 'active'
                                          ? const Color(0xFF4CAF50)
                                          : const Color(0xFFE57373),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      animal.status == 'active'
                                          ? 'Activo'
                                          : 'Inactivo',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
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
      floatingActionButton: batchAsync.when(
        data: (batch) {
          final corralId = batch.corralId;
          if (corralId == null) {
            return FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.grey,
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'No se encontró corral',
            );
          }
          final corralAsync = ref.watch(corralByIdProvider(corralId));
          return corralAsync.when(
            data: (corral) {
              final corralCapacity = corral?.capacity ?? 0;
              return ref.watch(batchAnimalsProvider(batchId)).when(
                    data: (animals) {
                      final isFull = corralCapacity > 0 &&
                          animals.length >= corralCapacity;
                      return FloatingActionButton(
                        onPressed: isFull
                            ? () => _showMaxCapacityDialog(context)
                            : () => _showAddAnimalDialog(context),
                        backgroundColor:
                            isFull ? Colors.grey : const Color(0xFFFF5A6E),
                        elevation: 4,
                        child: const Icon(Icons.add, color: Colors.white),
                        tooltip: isFull
                            ? 'Capacidad máxima alcanzada'
                            : 'Agregar animal',
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (e, s) => const SizedBox.shrink(),
                  );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, s) => const SizedBox.shrink(),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (e, s) => const SizedBox.shrink(),
      ),
    );
  }

  void _showAddAnimalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AnimalFormDialog(preselectedBatchId: batchId),
    );
  }

  void _showMaxCapacityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Capacidad máxima alcanzada'),
        content: const Text(
            'No se pueden agregar más animales, el corral está lleno.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}

class _BatchHeader extends StatelessWidget {
  final Batch batch;

  const _BatchHeader({required this.batch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1EAEA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFF07281),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        batch.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3E3E3E),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4FAF6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Color(0xFF5DA271),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Activo',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5DA271),
                              fontFamily: 'Nunito Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _InfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Fecha de creación',
                      value: _formatDate(batch.createdAt),
                      iconColor: const Color(0xFFF07281),
                    ),
                    const SizedBox(width: 12),
                    _InfoItem(
                      icon: Icons.pets_outlined,
                      label: 'Animales iniciales',
                      value: '${batch.headcountStart} cerdos',
                      iconColor: const Color(0xFF5DA271),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B5E55),
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF3E3E3E),
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
