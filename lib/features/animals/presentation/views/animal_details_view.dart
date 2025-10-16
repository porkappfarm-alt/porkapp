import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/presentation/views/animal_events_view.dart';
import 'package:porkapp/features/animals/providers/animal_provider.dart';
import 'package:porkapp/features/animals/providers/animal_events_provider.dart';
import 'package:porkapp/shared/widgets/error_view.dart';
import 'package:porkapp/shared/widgets/loading_view.dart';
import 'package:porkapp/features/animals/presentation/dialogs/add_event_dialog.dart';

class AnimalDetailsView extends ConsumerWidget {
  final String animalId;

  const AnimalDetailsView({
    super.key,
    required this.animalId,
  });
  
  Future<void> _showAddEventDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) =>   (animalId: animalId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animalAsync = ref.watch(animalProvider(animalId));
    
    return animalAsync.when(
      data: (animal) => Scaffold(
        appBar: AppBar(
          title: Text('Animal ${animal.identifier}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar animal',
              onPressed: () => _showEditDialog(context, animal),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(theme, animal),
              const Divider(height: 32),
              _buildEventsSection(context, theme, ref, animal),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEventDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Agregar Evento'),
          tooltip: 'Agregar nuevo evento',
        ),
      ),
      loading: () => const LoadingView(),
      error: (error, stackTrace) => ErrorView(
        message: 'Error al cargar el animal: $error',
        onRetry: () => ref.refresh(animalProvider(animalId)),
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, Animal animal) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información General',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            child: Column(
              children: [
                _InfoRow(
                  label: 'Identificador',
                  value: animal.identifier,
                  icon: Icons.tag,
                ),
                _InfoRow(
                  label: 'Tipo',
                  value: _getAnimalTypeText(animal.type),
                  icon: Icons.category,
                ),
                _InfoRow(
                  label: 'Raza',
                  value: animal.breed,
                  icon: Icons.pets,
                ),
                _InfoRow(
                  label: 'Género',
                  value: animal.gender == 'M' ? 'Macho' : 'Hembra',
                  icon: Icons.male,
                ),
                _InfoRow(
                  label: 'Fecha de nacimiento',
                  value: DateFormat('dd/MM/yyyy').format(animal.birthDate ?? DateTime.now()),
                  icon: Icons.calendar_today,
                ),
                if (animal.weight != null)
                  _InfoRow(
                    label: 'Peso inicial',
                    value: '${animal.weight} kg',
                    icon: Icons.scale,
                  ),
                _InfoRow(
                  label: 'Estado',
                  value: _getStatusText(animal.status),
                  icon: Icons.info_outline,
                ),
                if (animal.notes?.isNotEmpty ?? false)
                  _InfoRow(
                    label: 'Notas',
                    value: animal.notes!,
                    icon: Icons.note,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection(BuildContext context, ThemeData theme, WidgetRef ref, Animal animal) {
    final eventsAsync = ref.watch(animalEventsProvider(animal.id));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eventos',
                style: theme.textTheme.titleLarge,
              ),
              TextButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('Ver todos'),
                onPressed: () => _showAllEvents(context, animal),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: eventsAsync.when(
              data: (events) {
                final animalEvents = events
                    .where((e) => e.animalId == animal.id)
                    .toList()
                  ..sort((a, b) => b.date.compareTo(a.date));

                if (animalEvents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 48,
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay eventos registrados',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: animalEvents.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, index) {
                    final event = animalEvents[index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: InkWell(
                          onTap: () => _showEventDetails(context, event),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _EventTypeIcon(type: event.type),
                                const SizedBox(height: 8),
                                Text(
                                  _getEventTypeText(event.type),
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(event.date),
                                  style: theme.textTheme.bodySmall,
                                ),
                                if (event.data['description'] != null) ...[
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      event.data['description'] as String,
                                      style: theme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                message: 'Error al cargar eventos',
                details: error.toString(),
                onRetry: () => ref.refresh(animalEventsProvider(animal.id)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Animal animal) {
    // TODO: Implementar diálogo de edición
  }

  void _showAllEvents(BuildContext context, Animal animal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnimalEventsView(animal: animal),
      ),
    );
  }

  void _showEventDetails(BuildContext context, dynamic event) {
    // TODO: Implementar diálogo de detalles del evento
  }

  String _getAnimalTypeText(String type) {
    switch (type) {
      case 'piglet':
        return 'Lechón';
      case 'sow':
        return 'Reproductora';
      case 'boar':
        return 'Padrillo';
      case 'fattening':
        return 'Engorde';
      default:
        return type;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'sold':
        return 'Vendido';
      case 'deceased':
        return 'Fallecido';
      case 'removed':
        return 'Removido';
      default:
        return status;
    }
  }

  String _getEventTypeText(String type) {
    switch (type) {
      case 'weighing':
        return 'Pesaje';
      case 'treatment':
        return 'Tratamiento';
      case 'feeding':
        return 'Alimentación';
      case 'mortality':
        return 'Mortalidad';
      case 'sale':
        return 'Venta';
      case 'transfer':
        return 'Transferencia';
      case 'vaccination':
        return 'Vacunación';
      default:
        return type;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventTypeIcon extends StatelessWidget {
  final String type;

  const _EventTypeIcon({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getIconData(),
        color: color,
        size: 24,
      ),
    );
  }

  IconData _getIconData() {
    switch (type) {
      case 'weighing':
        return Icons.scale;
      case 'treatment':
        return Icons.medical_services;
      case 'feeding':
        return Icons.restaurant;
      case 'mortality':
        return Icons.warning;
      case 'sale':
        return Icons.attach_money;
      case 'transfer':
        return Icons.sync_alt;
      default:
        return Icons.event;
    }
  }
}

// Fin del archivo