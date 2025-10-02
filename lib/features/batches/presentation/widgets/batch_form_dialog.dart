import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';

class BatchFormDialog extends ConsumerStatefulWidget {
  final Batch? batch;
  final String? corralId;

  const BatchFormDialog({super.key, this.batch, this.corralId});

  @override
  ConsumerState<BatchFormDialog> createState() => _BatchFormDialogState();
}

class _BatchFormDialogState extends ConsumerState<BatchFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _headcountController;
  late TextEditingController _avgWeightController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.batch?.name);
    _headcountController = TextEditingController(
      text: widget.batch?.headcountStart.toString() ?? '',
    );
    _avgWeightController = TextEditingController(
      text: widget.batch?.initialAvgWeight?.toString() ?? '',
    );
    _notesController = TextEditingController(text: widget.batch?.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headcountController.dispose();
    _avgWeightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final batch = Batch(
      id: widget.batch?.id ?? '',
      name: _nameController.text,
      corralId: widget.corralId ?? widget.batch?.corralId ?? '',
      createdAt: widget.batch?.createdAt ?? DateTime.now(),
      headcountStart: int.parse(_headcountController.text),
      initialAvgWeight: _avgWeightController.text.isNotEmpty
          ? double.parse(_avgWeightController.text)
          : null,
      status: widget.batch?.status ?? 'active',
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    final repository = ref.read(batchRepositoryProvider);
    final result = widget.batch != null
        ? await repository.updateBatch(batch)
        : await repository.createBatch(batch);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      },
      (savedBatch) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.batch != null
                  ? 'Lote actualizado exitosamente'
                  : 'Lote creado exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Invalidar caché para recargar la lista
        ref.invalidate(batchListProvider);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.batch != null ? 'Editar Lote' : 'Nuevo Lote',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del lote',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _headcountController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad inicial de animales',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La cantidad es requerida';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _avgWeightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso promedio inicial (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (double.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
