import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatchSelector extends ConsumerWidget {
  final void Function(String) onBatchSelected;

  const BatchSelector({
    super.key,
    required this.onBatchSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implementar provider para obtener lotes activos
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Lote',
        border: OutlineInputBorder(),
      ),
      items: const [], // TODO: Lista de lotes activos
      onChanged: (value) {
        if (value != null) {
          onBatchSelected(value);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione un lote';
        }
        return null;
      },
    );
  }
}
