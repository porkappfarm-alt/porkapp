import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/domain/animal_filters.dart';
import 'package:porkapp/features/animals/providers/animals_provider.dart';
import 'package:porkapp/features/animals/data/animals_repository.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_type_fields.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_status_change.dart';
import 'package:porkapp/features/animals/presentation/widgets/form_feedback.dart';
import 'package:porkapp/features/animals/presentation/controllers/animal_form_controller.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';

class AnimalFormDialog extends ConsumerStatefulWidget {
  final Animal? animal;
  final String? preselectedBatchId;

  const AnimalFormDialog({super.key, this.animal, this.preselectedBatchId});

  @override
  ConsumerState<AnimalFormDialog> createState() => _AnimalFormDialogState();
}

class _AnimalFormDialogState extends ConsumerState<AnimalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _formController = AnimalFormController();
  late TextEditingController _identifierController;
  late TextEditingController _weightController;
  late TextEditingController _breedController;
  late TextEditingController _notesController;
  late final DateTime _birthDate;
  bool _isMale = true;
  AnimalType _selectedType = AnimalType.piglet;

  @override
  void initState() {
    super.initState();
    _birthDate = widget.animal?.birthDate ?? DateTime.now();
    _identifierController =
        TextEditingController(text: widget.animal?.identifier ?? '');
    _weightController =
        TextEditingController(text: widget.animal?.weight?.toString() ?? '');
    _breedController = TextEditingController(text: widget.animal?.breed ?? '');
    _notesController = TextEditingController(text: widget.animal?.notes ?? '');

    _formController.initForm(widget.animal);

    // Escuchar cambios en los campos
    _identifierController.addListener(() {
      _formController.updateField('identifier', _identifierController.text);
    });
    _weightController.addListener(() {
      _formController.updateField('weight', _weightController.text);
    });
    _breedController.addListener(() {
      _formController.updateField('breed', _breedController.text);
    });
    _notesController.addListener(() {
      _formController.updateField('notes', _notesController.text);
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _weightController.dispose();
    _breedController.dispose();
    _notesController.dispose();
    _formController.dispose();
    super.dispose();
  }

  String _getAnimalTypeLabel(AnimalType type) {
    switch (type) {
      case AnimalType.piglet:
        return 'Lechón';
      case AnimalType.sow:
        return 'Reproductora';
      case AnimalType.boar:
        return 'Padrillo';
      case AnimalType.fattening:
        return 'Engorde';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _formController
          .setError('Por favor corrige los errores en el formulario');
      return;
    }

    _formController.setLoading(true);
    final animal = Animal(
      id: widget.animal?.id ?? '',
      identifier: _identifierController.text,
      birthDate: _birthDate,
      weight: double.parse(_weightController.text),
      breed: _breedController.text,
      type: _getAnimalTypeLabel(_selectedType),
      entryDate: DateTime.now(),
      createdAt: widget.animal?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      batchId: widget.preselectedBatchId ?? widget.animal?.batchId ?? '',
      status: widget.animal?.status ?? 'active',
      gender: _isMale ? 'male' : 'female',
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    try {
      final repository = ref.read(animalsRepositoryProvider);

      if (widget.animal != null) {
        await repository.updateAnimal(
          id: animal.id,
          identifier: animal.identifier,
          birthDate: animal.birthDate ?? DateTime.now(),
          breed: animal.breed,
          weight: animal.weight,
          status: animal.status,
          type: animal.type,
        );
      } else {
        await repository.createAnimal(
          batchId: animal.batchId,
          identifier: animal.identifier,
          birthDate: animal.birthDate ?? DateTime.now(),
          breed: animal.breed,
          weight: animal.weight,
          status: animal.status,
          type: animal.type,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.animal != null
                  ? 'Animal actualizado exitosamente'
                  : 'Animal creado exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Invalidar los providers para recargar la lista
        if (widget.preselectedBatchId != null) {
          ref.invalidate(batchAnimalsProvider(widget.preselectedBatchId!));
          ref.invalidate(batchProvider(widget.preselectedBatchId!));
        }
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: PopScope(
        canPop: !_formController.isDirty,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final shouldPop = await _formController.shouldPop(context);
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.animal != null ? 'Editar Animal' : 'Nuevo Animal',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Tipo de animal
                  DropdownButtonFormField<AnimalType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de animal',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      AnimalType.piglet,
                      AnimalType.sow,
                      AnimalType.boar,
                      AnimalType.fattening,
                    ].map((type) {
                      return DropdownMenuItem<AnimalType>(
                        value: type,
                        child: Text(_getAnimalTypeLabel(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campos específicos por tipo
                  AnimalTypeFields(
                    type: _getAnimalTypeLabel(_selectedType),
                    animal: widget.animal,
                    onFieldChanged: (field, value) {
                      // Los valores se manejarán en _submit
                    },
                  ),
                  const SizedBox(height: 16),

                  // Identificador
                  Consumer(
                    builder: (context, ref, child) {
                      return TextFormField(
                        controller: _identifierController,
                        decoration: const InputDecoration(
                          labelText: 'Identificador/Arete',
                          border: OutlineInputBorder(),
                          helperText: 'Este identificador debe ser único',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El identificador es requerido';
                          }
                          return null;
                        },
                        onChanged: (value) async {
                          if (value.isNotEmpty && widget.animal == null) {
                            final repository =
                                ref.read(animalsRepositoryProvider);
                            final isUnique =
                                await repository.isIdentifierUnique(value);
                            if (!isUnique) {
                              _formController.setError(
                                  'Este identificador ya está en uso');
                            } else {
                              _formController.clearError();
                            }
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Peso
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Peso inicial (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El peso es requerido';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Fecha de nacimiento
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _birthDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _birthDate = date;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Raza/Genética
                  TextFormField(
                    controller: _breedController,
                    decoration: const InputDecoration(
                      labelText: 'Raza/Línea genética',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La raza es requerida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Género
                  Row(
                    children: [
                      const Text('Género:'),
                      const SizedBox(width: 16),
                      ChoiceChip(
                        label: const Text('Macho'),
                        selected: _isMale,
                        onSelected: (selected) {
                          setState(() {
                            _isMale = selected;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Hembra'),
                        selected: !_isMale,
                        onSelected: (selected) {
                          setState(() {
                            _isMale = !selected;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Notas
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notas (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Estado (solo para edición)
                  if (widget.animal != null) ...[
                    AnimalStatusChange(
                      currentStatus: widget.animal!.status,
                      onStatusChanged: (newStatus, notes) {
                        setState(() {
                          if (notes != null && notes.isNotEmpty) {
                            _notesController.text = notes;
                          }
                        });
                        // El nuevo estado se manejará en _submit
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Feedback del formulario
                  FormFeedback(
                    isLoading: _formController.isLoading,
                    errorMessage: _formController.errorMessage,
                    onRetry: _submit,
                  ),
                  const SizedBox(height: 16),

                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: _formController.isLoading ? null : _submit,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
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
