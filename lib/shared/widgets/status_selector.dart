import 'package:flutter/material.dart';
import 'package:porkapp/features/animals/domain/animal_type_config.dart';

class StatusSelector extends StatelessWidget {
  final AnimalStatus currentStatus;
  final Function(AnimalStatus) onStatusChanged;

  const StatusSelector({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AnimalStatus.values.map((status) {
            // Verificar si la transición es válida
            final isValidTransition = StatusTransition.isValidTransition(
              currentStatus,
              status,
            );

            return FilterChip(
              label: Text(status.displayName),
              selected: currentStatus == status,
              onSelected: isValidTransition
                  ? (selected) {
                      if (selected) {
                        onStatusChanged(status);
                      }
                    }
                  : null,
              labelStyle: TextStyle(
                color: currentStatus == status
                    ? Colors.white
                    : isValidTransition
                        ? null
                        : Colors.grey,
              ),
              backgroundColor: Colors.transparent,
              selectedColor: status.color,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isValidTransition ? status.color : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}