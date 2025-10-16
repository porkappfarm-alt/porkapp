import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/animals/domain/animal.dart';

// TODO: Crear provider para animal individual
final animalProvider = FutureProvider.family<Animal, String>(
  (ref, animalId) async {
    throw UnimplementedError('Implementar provider de animal');
  },
);

class AnimalDetailView extends ConsumerWidget {
  final String animalId;

  const AnimalDetailView({super.key, required this.animalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animalAsync = ref.watch(animalProvider(animalId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Detalle del Animal'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
      ),
      body: animalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        data: (animal) => _AnimalDetailContent(animal: animal),
      ),
    );
  }
}

class _AnimalDetailContent extends StatelessWidget {
  final Animal animal;

  const _AnimalDetailContent({required this.animal});

  String _formatDate(DateTime? date) {
    if (date == null) return 'No disponible';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Información básica
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información Básica',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context: context,
                  label: 'ID',
                  value: animal.identifier,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Tipo',
                  value: animal.type,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Raza',
                  value: animal.breed,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Fecha de nacimiento',
                  value: _formatDate(animal.birthDate),
                ),
                if (animal.weight != null)
                  _buildInfoRow(
                    context: context,
                    label: 'Peso inicial',
                    value: '${animal.weight} kg',
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Historial
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historial',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context: context,
                  label: 'Fecha de ingreso',
                  value: _formatDate(animal.entryDate),
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Estado',
                  value: animal.status,
                ),
              ],
            ),
          ),
        ),
        if (animal.notes != null && animal.notes!.isNotEmpty) ...[
          const SizedBox(height: 16),
          // Notas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notas',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    animal.notes!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String? value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value ?? 'No disponible',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
