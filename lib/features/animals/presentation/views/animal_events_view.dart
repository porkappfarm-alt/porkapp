import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:porkapp/features/animals/providers/animal_events_provider.dart';
import 'package:porkapp/features/animals/presentation/dialogs/add_event_dialog.dart';
import 'package:porkapp/shared/widgets/error_view.dart';
import 'package:porkapp/shared/widgets/loading_view.dart';

class AnimalEventsView extends ConsumerWidget {
  final Animal animal;

  const AnimalEventsView({Key? key, required this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos - ${animal.identifier}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(animalEventsProvider(animal.id)),
            tooltip: 'Actualizar eventos',
          ),
        ],
      ),
      body: ref.watch(animalEventsProvider(animal.id)).when(
            data: (events) {
              final sortedEvents = List<AnimalEvent>.from(events)
                ..sort((a, b) => b.date.compareTo(a.date));

              if (sortedEvents.isEmpty) {
                return _buildEmptyState(theme);
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildEventsList(sortedEvents, theme, ref),
              );
            },
            loading: () => const LoadingView(),
            error: (error, stack) => ErrorView(
              message: 'Error al cargar los eventos',
              details: error.toString(),
              onRetry: () => ref.refresh(animalEventsProvider(animal.id)),
            ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Evento'),
        tooltip: 'Agregar nuevo evento',
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: theme.colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay eventos registrados',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega un nuevo evento usando el botón inferior',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(
    List<AnimalEvent> events,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return ListView.builder(
      itemCount: events.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final event = events[index];
        final bool isFirstEvent = index == 0;
        final bool isLastEvent = index == events.length - 1;

        return _EventCard(
          key: ValueKey(event.id),
          event: event,
          isFirstEvent: isFirstEvent,
          isLastEvent: isLastEvent,
          onDelete: () => _confirmDeleteEvent(context, ref, event),
        );
      },
    );
  }

  void _showAddEventDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) => AddEventDialog(animalId: animal.id),
    );
  }

  void _confirmDeleteEvent(
    BuildContext context,
    WidgetRef ref,
    AnimalEvent event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este evento?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(animalEventsProvider(animal.id).notifier).deleteEvent(event.id);
    }
  }
}

class _EventCard extends StatelessWidget {
  final AnimalEvent event;
  final bool isFirstEvent;
  final bool isLastEvent;
  final VoidCallback? onDelete;

  const _EventCard({
    super.key,
    required this.event,
    this.isFirstEvent = false,
    this.isLastEvent = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.only(
        bottom: isLastEvent ? 0 : 8,
        top: isFirstEvent ? 0 : 0,
      ),
      child: InkWell(
        onLongPress: onDelete,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _EventTypeIcon(type: event.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getEventTypeText(event.type),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(event.date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onDelete,
                      color: colorScheme.error,
                      tooltip: 'Eliminar evento',
                    ),
                ],
              ),
              if (event.data['description'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  event.data['description'] as String,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
        return type[0].toUpperCase() + type.substring(1);
    }
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
      case 'vaccination':
        return Icons.vaccines;
      default:
        return Icons.event_note;
    }
  }
}

