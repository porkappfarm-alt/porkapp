import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';

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
  String? _selectedCorralId;
  DateTime? _birthDate;

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
    _selectedCorralId = widget.corralId ?? widget.batch?.corralId;
    _birthDate = widget.batch?.birthDate;
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

    if (_selectedCorralId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar un corral'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final batchData = Batch(
        // Solo incluir ID si estamos editando
        id: widget.batch?.id ?? DateTime.now().toIso8601String(),
        name: _nameController.text.trim(),
        corralId: _selectedCorralId!,
        createdAt: widget.batch?.createdAt ?? DateTime.now(),
        headcountStart: int.parse(_headcountController.text.trim()),
        initialAvgWeight: _avgWeightController.text.trim().isNotEmpty
            ? double.parse(_avgWeightController.text.trim())
            : null,
        status: widget.batch?.status ?? 'active',
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        birthDate: _birthDate,
      );

      final repository = ref.read(batchRepositoryProvider);
      final result = widget.batch != null
          ? await repository.updateBatch(batchData)
          : await repository.createBatch(batchData);

      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar el lote: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: screenSize.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  // Birth Date Picker (movido más arriba para mayor visibilidad)
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _birthDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        helpText: 'Seleccionar fecha de nacimiento',
                        cancelText: 'Cancelar',
                        confirmText: 'Aceptar',
                      );
                      if (picked != null) {
                        setState(() {
                          _birthDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Fecha de nacimiento (opcional)',
                        border: const OutlineInputBorder(),
                        suffixIcon: _birthDate != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _birthDate = null;
                                  });
                                },
                              )
                            : const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _birthDate != null
                            ? '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}'
                            : 'Seleccionar fecha',
                        style: TextStyle(
                          color: _birthDate != null
                              ? Colors.black87
                              : Colors.grey[600],
                        ),
                      ),
                    ),
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
                  Consumer(
                    builder: (context, ref, child) {
                      final corralsAsyncValue = ref.watch(corralsProvider);

                      return corralsAsyncValue.when(
                        data: (corrals) {
                          if (corrals.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'No hay corrales disponibles. Por favor, cree un corral primero.',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          // Si no hay corral seleccionado y hay corrales disponibles, seleccionar el primero
                          if (_selectedCorralId == null && corrals.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _selectedCorralId = corrals.first.id;
                              });
                            });
                          }

                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Corral',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            value: _selectedCorralId,
                            items: corrals.map((corral) {
                              return DropdownMenuItem(
                                value: corral.id,
                                child: Text(
                                  corral.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCorralId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione un corral';
                              }
                              return null;
                            },
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stack) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Error al cargar corrales: $error',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
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
      ),
    );
  }
}
