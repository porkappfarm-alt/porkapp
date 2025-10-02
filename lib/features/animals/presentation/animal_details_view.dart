import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:porkapp/features/animals/presentation/add_event_dialog.dart';
import 'package:porkapp/features/animals/presentation/create_animal_view.dart';
import 'package:porkapp/features/animals/application/animal_events_provider.dart';
import 'package:porkapp/shared/design/app_colors.dart';
import 'package:porkapp/shared/design/app_typography.dart';

class AnimalDetailsView extends ConsumerWidget {
  final Animal animal;

  const AnimalDetailsView({super.key, required this.animal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detalles del Animal'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.background.withOpacity(0.8),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CreateAnimalView(batchId: animal.batchId, animal: animal),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información del Animal',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                items: [
                  _InfoItem(
                    label: 'Identificador',
                    value: '#${animal.identifier}',
                  ),
                  _InfoItem(label: 'Raza', value: animal.breed),
                  _InfoItem(
                    label: 'Fecha de Nacimiento',
                    value: dateFormat.format(animal.birthDate),
                  ),
                  _InfoItem(
                    label: 'Fecha de Ingreso',
                    value: dateFormat.format(animal.entryDate),
                  ),
                  _InfoItem(
                    label: 'Peso Inicial',
                    value: '${animal.weight} kg',
                  ),
                  _InfoItem(
                    label: 'Estado',
                    value: _getStatusText(animal.status),
                    isHighlighted: true,
                  ),
                  if (animal.notes != null)
                    _InfoItem(label: 'Notas', value: animal.notes!),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Eventos',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final event = await showDialog<AnimalEvent>(
                        context: context,
                        builder: (context) =>
                            AddEventDialog(animalId: animal.id),
                      );

                      if (event != null) {
                        await ref
                            .read(animalEventsProvider(animal.id).notifier)
                            .addEvent(event);
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final eventsState = ref.watch(
                    animalEventsProvider(animal.id),
                  );

                  return eventsState.when(
                    data: (events) {
                      if (events.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Text(
                              'No hay eventos registrados',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Card(
                            child: ListTile(
                              leading: _getEventIcon(event.type),
                              title: Text(_getEventTitle(event)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dateFormat.format(event.date)),
                                  if (event.notes != null)
                                    Text(
                                      event.notes!,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('¿Eliminar evento?'),
                                      content: const Text(
                                        '¿Está seguro que desea eliminar este evento?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            'Eliminar',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    await ref
                                        .read(
                                          animalEventsProvider(
                                            animal.id,
                                          ).notifier,
                                        )
                                        .deleteEvent(event.id);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error al cargar los eventos: $error'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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
        return 'Retirado';
      default:
        return 'Desconocido';
    }
  }

  Widget _getEventIcon(String type) {
    switch (type) {
      case 'weighing':
        return const Icon(Icons.monitor_weight);
      case 'treatment':
        return const Icon(Icons.medication);
      case 'mortality':
        return const Icon(Icons.warning);
      default:
        return const Icon(Icons.event);
    }
  }

  String _getEventTitle(AnimalEvent event) {
    switch (event.type) {
      case 'weighing':
        final data = event.data;
        return 'Pesaje: ${data['weight']} kg';
      case 'treatment':
        final data = event.data;
        return 'Tratamiento: ${data['treatmentType']} - ${data['description']}';
      case 'mortality':
        final data = event.data;
        return 'Mortalidad: ${data['cause']}';
      default:
        return 'Evento desconocido';
    }
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required List<_InfoItem> items,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
          children: items.map((item) {
            return TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: item.isHighlighted
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.value,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Text(
                            item.value,
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  final bool isHighlighted;

  _InfoItem({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });
}
