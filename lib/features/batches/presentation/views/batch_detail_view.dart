import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_form_dialog.dart';
import 'package:porkapp/features/animals/providers/animals_provider.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_provider.dart'
    as single_batch;
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/biometrics/providers/biometric_providers.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF5D4037),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Detalle de Lote',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF5D4037),
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF07281),
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
        surfaceTintColor: Colors.transparent,
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

          // Botones para gestión de animales y biometría
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/batches/$batchId/animals');
                    },
                    icon: const Icon(Icons.pets),
                    label: const Text('Gestionar animales'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF07281),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/biometrics/batch/$batchId');
                    },
                    icon: const Icon(Icons.monitor_weight),
                    label: const Text('Gestionar biometría'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
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

class _BatchHeader extends ConsumerWidget {
  final Batch batch;

  const _BatchHeader({required this.batch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryDate = batch.entryDate ?? batch.createdAt;
    final daysElapsed = DateTime.now().difference(entryDate).inDays;
    final weekElapsed = (daysElapsed / 7).ceil();
    final animalsVivos =
        batch.animals.where((a) => a.status == 'active').length;
    final animalsMuertos =
        batch.animals.where((a) => a.status == 'deceased').length;
    final biometricsAsync = ref.watch(batchBiometricsProvider(batch.id));

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.calendar_today_rounded,
                        label: 'Ingreso',
                        value: _formatDate(entryDate),
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
                        icon: Icons.monitor_weight,
                        label: 'Peso Prom. Última Biom.',
                        value: biometricsAsync.when(
                          data: (measurements) => measurements.isNotEmpty
                              ? '${measurements.last.averageWeight.toStringAsFixed(1)} kg'
                              : '--',
                          loading: () => '...',
                          error: (e, _) => '--',
                        ),
                        iconColor: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.group,
                        label: 'Animales',
                        value: '$animalsVivos/${batch.headcountStart}',
                        iconColor: const Color(0xFF3B1D2D),
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
                        icon: Icons.timer,
                        label: 'Días desde ingreso',
                        value: '$daysElapsed',
                        iconColor: const Color(0xFFF07281),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.calendar_view_week,
                        label: 'Semana actual',
                        value: '$weekElapsed',
                        iconColor: const Color(0xFF4CAF50),
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
                        icon: Icons.food_bank,
                        label: 'Tipo de alimento',
                        value: 'Balanceado Premium', // mock
                        iconColor: const Color(0xFFE94C5D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.scale,
                        label: 'Cantidad alimento diario',
                        value: '2.5 kg', // mock
                        iconColor: const Color(0xFF3B1D2D),
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
                        icon: Icons.sentiment_very_dissatisfied,
                        label: 'Animales muertos',
                        value: '$animalsMuertos',
                        iconColor: const Color(0xFFE94C5D),
                      ),
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
