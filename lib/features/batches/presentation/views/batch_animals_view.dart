import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_form_dialog.dart';
import 'package:porkapp/supabase/providers/supabase_providers.dart';
import 'package:intl/intl.dart';

// Provider para obtener la última biometría de un animal
final animalLastWeightProvider =
    FutureProvider.family<double?, String>((ref, animalId) async {
  final supabase = ref.watch(supabaseProvider);

  try {
    final result = await supabase
        .from('biometric_measurements')
        .select('weight')
        .eq('animal_id', animalId)
        .not('weight', 'is', null)
        .order('created_at', ascending: false)
        .limit(1);

    if (result.isEmpty) return null;
    return (result.first['weight'] as num?)?.toDouble();
  } catch (e) {
    print('Error obteniendo última biometría: $e');
    return null;
  }
});

class BatchAnimalsView extends ConsumerWidget {
  final String batchId;

  const BatchAnimalsView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batch = ref.watch(batchProvider(batchId));

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    AnimalFormDialog(preselectedBatchId: batchId),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Agregar Animal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF5D4037),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Animales del Lote',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF5D4037),
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: batch.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        data: (batch) => _BatchAnimalsList(batch: batch),
      ),
    );
  }
}

class _BatchAnimalsList extends StatelessWidget {
  final Batch batch;

  const _BatchAnimalsList({required this.batch});

  @override
  Widget build(BuildContext context) {
    if (batch.animals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF07281).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/3800591.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'No hay animales registrados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Agrega un animal para comenzar\na gestionar tu lote',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Información del lote
        Container(
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
                        fontSize: 24,
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
                        value: DateFormat('dd/MM/yyyy').format(batch.createdAt),
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
                        label: 'Animales',
                        value:
                            '${batch.animals.length}/${batch.headcountStart}',
                        iconColor: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Título de lista
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Lista de Animales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Lista de animales
        ...batch.animals.map((animal) => _AnimalCard(
              animal: animal,
              batchId: batch.id,
            )),
        const SizedBox(height: 80),
      ],
    );
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

class _AnimalCard extends ConsumerWidget {
  final Animal animal;
  final String batchId;

  const _AnimalCard({required this.animal, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () => context.push('/batches/$batchId/animals/${animal.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF5A6E),
                      Color(0xFFFF7F8F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    animal.identifier.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Consumer(
                      builder: (context, ref, child) {
                        final lastWeightAsync =
                            ref.watch(animalLastWeightProvider(animal.id));

                        return lastWeightAsync.when(
                          data: (lastWeight) {
                            final weightText = lastWeight != null
                                ? "${lastWeight.toStringAsFixed(1)} kg"
                                : (animal.weight != null
                                    ? "${animal.weight!.toStringAsFixed(1)} kg"
                                    : "Sin peso");

                            return Text(
                              '${animal.breed} • $weightText',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            );
                          },
                          loading: () => Text(
                            '${animal.breed} • Cargando...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          error: (_, __) => Text(
                            '${animal.breed} • ${animal.weight != null ? "${animal.weight!.toStringAsFixed(1)} kg" : "Sin peso"}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: animal.status == 'active'
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE57373),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  animal.status == 'active' ? 'Activo' : 'Inactivo',
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
      ),
    );
  }
}
