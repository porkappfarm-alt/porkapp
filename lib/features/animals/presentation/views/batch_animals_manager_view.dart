import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/presentation/animal_details_view.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_filters.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_list_item.dart';
import 'package:porkapp/features/animals/presentation/views/animal_stats_view.dart';
import 'package:porkapp/features/animals/presentation/views/edit_animal_view.dart';
import 'package:porkapp/features/animals/presentation/views/animal_events_view.dart';
import 'package:porkapp/features/animals/providers/animals_provider.dart';
import 'package:porkapp/features/animals/data/animals_repository.dart';

class BatchAnimalsManagerView extends ConsumerStatefulWidget {
  final String batchId;

  const BatchAnimalsManagerView({super.key, required this.batchId});

  @override
  ConsumerState<BatchAnimalsManagerView> createState() =>
      _BatchAnimalsManagerViewState();
}

class _BatchAnimalsManagerViewState
    extends ConsumerState<BatchAnimalsManagerView> {
  String _searchQuery = '';
  String? _statusFilter;
  DateTimeRange? _dateFilter;

  List<Animal> _filterAnimals(List<Animal> animals) {
    return animals.where((animal) {
      // Filtro por búsqueda
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!animal.identifier.toLowerCase().contains(query) &&
            !(animal.notes?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      // Filtro por estado
      if (_statusFilter != null && animal.status != _statusFilter) {
        return false;
      }

      // Filtro por fecha
      if (_dateFilter != null) {
        if (animal.entryDate?.isBefore(_dateFilter!.start) == true ||
            animal.entryDate?.isAfter(_dateFilter!.end) == true) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print('BatchAnimalsView - batchId: ${widget.batchId}'); // Debug log
    return Scaffold(
      body: Column(
        children: [
          // Filtros
          AnimalFilters(
            onSearch: (query) => setState(() => _searchQuery = query),
            onStatusFilter: (status) => setState(() => _statusFilter = status),
            onDateFilter: (dateRange) =>
                setState(() => _dateFilter = dateRange),
          ),

          // Lista de animales
          Expanded(
            child: ref.watch(batchAnimalsProvider(widget.batchId)).when(
                  data: (animals) {
                    final filteredAnimals = _filterAnimals(animals);

                    if (filteredAnimals.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              animals.isEmpty
                                  ? 'No hay animales en este lote'
                                  : 'No se encontraron animales con los filtros actuales',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                            if (animals.isEmpty) ...[
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => _showAddAnimalDialog(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Agregar Animal'),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        // Invalidar el cache para recargar
                        ref.invalidate(batchAnimalsProvider(widget.batchId));
                      },
                      child: ListView.builder(
                        itemCount: filteredAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = filteredAnimals[index];
                          return AnimalListItem(
                            onTap: () => _showAnimalDetails(context, animal),
                            animal: animal,
                            onEdit: () =>
                                _showEditAnimalDialog(context, animal.id),
                            onDelete: () =>
                                _confirmDeleteAnimal(context, animal),
                            onAddEvent: () =>
                                _showAddEventDialog(context, animal),
                          );
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar los animales',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(
                              batchAnimalsProvider(widget.batchId),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón de estadísticas
          FloatingActionButton.small(
            heroTag: 'stats_${widget.batchId}',
            onPressed: () => _showStatsDialog(context),
            child: const Icon(Icons.bar_chart),
          ),
          const SizedBox(height: 8),
          // Botón de agregar animal
          FloatingActionButton(
            heroTag: 'add_${widget.batchId}',
            onPressed: () => _showAddAnimalDialog(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showAnimalDetails(BuildContext context, Animal animal) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnimalDetailsView(animalId: animal.id),
      ),
    );
    // Recargar la lista de animales al volver
    ref.invalidate(batchAnimalsProvider(widget.batchId));
  }

  void _showAddAnimalDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditAnimalView(batchId: widget.batchId),
      ),
    );
  }

  void _showEditAnimalDialog(BuildContext context, String animalId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EditAnimalView(animalId: animalId, batchId: widget.batchId),
      ),
    );
  }

  Future<void> _confirmDeleteAnimal(BuildContext context, Animal animal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar el animal ${animal.identifier}?'
          '\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(animalsRepositoryProvider).deleteAnimal(animal.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Animal eliminado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          // Recargar la lista
          ref.invalidate(batchAnimalsProvider(widget.batchId));
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showAddEventDialog(BuildContext context, Animal animal) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AnimalEventsView(animal: animal)),
    );
  }

  void _showStatsDialog(BuildContext context) {
    final animals = ref.read(batchAnimalsProvider(widget.batchId)).value;
    if (animals == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(child: AnimalStatsView(animals: animals)),
          ],
        ),
      ),
    );
  }
}
