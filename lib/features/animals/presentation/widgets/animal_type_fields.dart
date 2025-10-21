import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final theme = Theme.of(context);

    Widget _buildNumberField({
      required String label,
      required String field,
      String? initialValue,
      String? hint,
      bool isRequired = false,
      bool isInteger = false,
      double? min,
      double? max,
      String? Function(String?)? extraValidation,
    }) {
      return TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          helperText: hint,
          helperMaxLines: 2,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(isInteger ? r'[0-9]' : r'[0-9.]')),
        ],
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Este campo es requerido';
          }

          final number = isInteger
              ? int.tryParse(value ?? '')
              : double.tryParse(value ?? '');
          if (value != null && value.isNotEmpty && number == null) {
            return 'Ingrese un número válido';
          }

          if (number != null) {
            if (min != null && number < min) {
              return 'El valor debe ser mayor o igual a $min';
            }
            if (max != null && number > max) {
              return 'El valor debe ser menor o igual a $max';
            }
          }

          return extraValidation?.call(value);
        },
        onChanged: (value) {
          final number =
              isInteger ? int.tryParse(value) : double.tryParse(value);
          onFieldChanged(field, number);
        },
      );
    }

    switch (type.toLowerCase()) {
      case 'fattening':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos de Engorde',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: 'Peso inicial (kg)',
              field: 'weight',
              initialValue: animal?.weight?.toString(),
              hint: 'Peso del animal al ingresar al lote',
              isRequired: true,
              min: 0.1,
              max: 300,
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: 'Peso objetivo (kg)',
              field: 'target_weight',
              initialValue: animal?.targetWeight?.toString(),
              hint: 'Peso esperado al finalizar el engorde',
              min: 1,
              max: 350,
            ),
          ],
        );

      case 'sow':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos de Reproductora',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: 'Número de partos',
              field: 'parity_number',
              initialValue: animal?.parityNumber?.toString() ?? '0',
              hint: 'Cantidad de partos que ha tenido la cerda',
              isInteger: true,
              min: 0,
              max: 20,
            ),
          ],
        );

      case 'boar':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos de Semental',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: 'Número de servicios',
              field: 'service_count',
              initialValue: animal?.serviceCount?.toString() ?? '0',
              hint: 'Cantidad de servicios realizados',
              isInteger: true,
              min: 0,
              max: 1000,
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
