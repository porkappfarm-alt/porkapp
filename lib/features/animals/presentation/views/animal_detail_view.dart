import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/providers/animal_detail_provider.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_form_dialog.dart';

class AnimalDetailView extends ConsumerStatefulWidget {
  final String animalId;

  const AnimalDetailView({super.key, required this.animalId});

  @override
  ConsumerState<AnimalDetailView> createState() => _AnimalDetailViewState();
}

class _AnimalDetailViewState extends ConsumerState<AnimalDetailView> {
  void _showEditDialog(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (context) => AnimalFormDialog(animal: animal),
    ).then((_) {
      // Refrescar los datos después de editar
      ref.read(animalDetailProvider(widget.animalId).notifier).refresh();
    });
  }

  Future<void> _confirmDelete(BuildContext context, Animal animal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            Text('¿Estás seguro de eliminar el animal ${animal.identifier}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(animalDetailProvider(widget.animalId).notifier)
            .deleteAnimal();
        if (context.mounted) {
          context.pop(); // Volver a la vista anterior
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final animalAsync = ref.watch(animalDetailProvider(widget.animalId));

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
        actions: animalAsync.whenOrNull(
          data: (animal) => [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(context, animal),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, animal),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: animalAsync.when(
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando información...'),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${error.toString()}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ref
                      .read(animalDetailProvider(widget.animalId).notifier)
                      .refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          data: (animal) => _AnimalDetailContent(animal: animal),
        ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'sold':
        return Colors.blue;
      case 'deceased':
        return Colors.red;
      case 'removed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Activo';
      case 'sold':
        return 'Vendido';
      case 'deceased':
        return 'Fallecido';
      case 'removed':
        return 'Removido';
      default:
        return 'Desconocido';
    }
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = _getStatusColor(animal.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            _getStatusText(animal.status),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Información Básica',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusBadge(context),
                  ],
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
