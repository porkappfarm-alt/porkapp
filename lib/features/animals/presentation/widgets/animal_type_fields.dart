import 'package:flutter/material.dart';
import 'package:porkapp/features/animals/domain/animal.dart';

class AnimalTypeFields extends StatelessWidget {
  final String type;
  final Animal? animal;
  final void Function(String, dynamic) onFieldChanged;

  const AnimalTypeFields({
    super.key,
    required this.type,
    this.animal,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (type.toLowerCase()) {
      case 'fattening':
        return Column(
          children: [
            TextFormField(
              initialValue: animal?.weight?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'Peso inicial (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Ingrese el peso';
                if (double.tryParse(value) == null)
                  return 'Ingrese un número válido';
                return null;
              },
              onChanged: (value) =>
                  onFieldChanged('weight', double.tryParse(value)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: animal?.targetWeight?.toString(),
              decoration: const InputDecoration(
                labelText: 'Peso objetivo (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  onFieldChanged('target_weight', double.tryParse(value)),
            ),
          ],
        );

      case 'sow':
        return Column(
          children: [
            TextFormField(
              initialValue: animal?.parityNumber?.toString() ?? '0',
              decoration: const InputDecoration(
                labelText: 'Número de partos',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  onFieldChanged('parity_number', int.tryParse(value)),
            ),
          ],
        );

      case 'boar':
        return Column(
          children: [
            TextFormField(
              initialValue: animal?.serviceCount?.toString() ?? '0',
              decoration: const InputDecoration(
                labelText: 'Número de servicios',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  onFieldChanged('service_count', int.tryParse(value)),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
