import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityTimeline extends ConsumerWidget {
  const ActivityTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implementar provider para obtener actividades
    final activities = [
      Activity(
        type: ActivityType.weight,
        description: 'Registro de peso del Lote A1',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        details: 'Peso promedio: 75.5 kg',
      ),
      Activity(
        type: ActivityType.move,
        description: 'Movimiento de animales',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        details: 'Corral C3 → C4',
      ),
      Activity(
        type: ActivityType.medical,
        description: 'Tratamiento aplicado',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        details: 'Vacunación lote B2',
      ),
    ];

    return Column(
      children: [
        // Filtros
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ActivityType.values.map((type) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(type.label),
                  selected: false, // TODO: Implementar selección
                  onSelected: (selected) {
                    // TODO: Implementar filtrado
                  },
                  avatar: Icon(type.icon, size: 16),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Timeline
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final isLast = index == activities.length - 1;

            return IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      timeago.format(activity.timestamp, locale: 'es'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: activity.type.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          activity.type.icon,
                          size: 16,
                          color: activity.type.color,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.description,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (activity.details != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            activity.details!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (!isLast) const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

enum ActivityType {
  weight(Icons.monitor_weight, 'Peso', Colors.blue),
  move(Icons.transfer_within_a_station, 'Movimientos', Colors.orange),
  medical(Icons.medical_services, 'Tratamientos', Colors.red),
  note(Icons.note, 'Notas', Colors.grey);

  final IconData icon;
  final String label;
  final Color color;

  const ActivityType(this.icon, this.label, this.color);
}

class Activity {
  final ActivityType type;
  final String description;
  final DateTime timestamp;
  final String? details;

  const Activity({
    required this.type,
    required this.description,
    required this.timestamp,
    this.details,
  });
}
