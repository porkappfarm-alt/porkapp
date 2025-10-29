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

class BatchDetailView extends ConsumerWidget {
  final String batchId;

  const BatchDetailView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
                                  color: const Color(0xFFF07281).withOpacity(0.15),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF5A6E),
                Color(0xFFFF7F8F),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF5A6E).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => _showAddAnimalDialog(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Agregar Animal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF07281).withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  batch.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Activo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Fecha inicio',
                    value: _formatDate(batch.createdAt),
                    iconColor: const Color(0xFFF07281),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.pets_rounded,
                    label: 'Cantidad inicial',
                    value: '${batch.headcountStart} cerdos',
                    iconColor: const Color(0xFF4CAF50),
                  ),
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5D4037),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
