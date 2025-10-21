import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Detalle de Lote',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF6B0338),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
                          return GestureDetector(
                            onTap: () => context
                                .push('/batches/$batchId/animals/${animal.id}'),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
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
                                            fontWeight: FontWeight.w500,
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
                                          ? const Color(0xFF1A8754)
                                          : const Color(0xFFDC2626),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      animal.status == 'active'
                                          ? 'Activo'
                                          : 'Inactivo',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
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
}

class _BatchHeader extends StatelessWidget {
  final Batch batch;

  const _BatchHeader({required this.batch});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              batch.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1A8754),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Activo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Fecha inicio: ${_formatDate(batch.createdAt)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Cantidad inicial: ${batch.headcountStart} cerdos',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
