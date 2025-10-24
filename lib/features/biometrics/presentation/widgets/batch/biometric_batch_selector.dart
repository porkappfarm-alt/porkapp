import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/biometric_extensions.dart';

class BiometricBatchSelector extends ConsumerWidget {
  final String? selectedBatchId;
  final ValueChanged<String?>? onBatchSelected;

  const BiometricBatchSelector({
    super.key,
    this.selectedBatchId,
    this.onBatchSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () {
          _showBatchSelector(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lote Seleccionado',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedBatchId ?? 'Seleccionar Lote',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.expand_more),
            ],
          ),
        ),
      ).withSemantics(
        label: 'Selector de lote',
        hint: selectedBatchId != null
            ? 'Lote actual: $selectedBatchId. Toca para cambiar'
            : 'Toca para seleccionar un lote',
      ),
    );
  }

  Future<void> _showBatchSelector(BuildContext context) async {
    // TODO: Implementar diálogo de selección de lotes
    // Por ahora solo mostraremos un diálogo simple
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Lote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Lote 1'),
              onTap: () => Navigator.pop(context, 'Lote 1'),
            ),
            ListTile(
              title: const Text('Lote 2'),
              onTap: () => Navigator.pop(context, 'Lote 2'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );

    if (result != null && onBatchSelected != null) {
      onBatchSelected!(result);
    }
  }
}
