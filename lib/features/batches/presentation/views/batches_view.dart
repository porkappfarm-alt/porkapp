import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/providers/batches_provider.dart';
import 'package:porkapp/features/batches/presentation/widgets/batch_form_dialog.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/presentation/widgets/batch_list_item.dart';

class BatchesView extends ConsumerWidget {
  const BatchesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gestión de Lotes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B5E55),
                fontFamily: 'Poppins',
              ),
            ),
            ref.watch(batchListProvider).maybeWhen(
              data: (batches) => Text(
                'Total: ${batches.length} lotes',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7B7B7B),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
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
                      const Icon(
                        Icons.folder_open,
                        size: 64,
                        color: Color(0xFFC7C7C7), // Gris Neutro - Inactivo
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay lotes creados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _showCreateBatchDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5DA271), // Verde Agro - Secundario
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Crear Lote'),
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
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF07281)), // Rosa Cerdito Natural
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFE45B5B), // Rojo Suave - Error/Eliminación
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error al cargar los lotes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      error.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7B7B7B), // Gris Medio - Texto Secundario
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(batchListProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF07281), // Rosa Cerdito Natural
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5DA271).withOpacity(0.3), // Verde Agro - Secundario
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showCreateBatchDialog(context),
          backgroundColor: const Color(0xFF5DA271), // Verde Agro - Secundario
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Ordenar'),
        ),
      ),
    );
  }

  void _showCreateBatchDialog(BuildContext context) {
    // TODO: Implementar diálogo de creación de lote
  }
}
