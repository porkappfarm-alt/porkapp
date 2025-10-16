import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/domain/animal_filters.dart';
import 'package:porkapp/features/animals/providers/animals_provider.dart';
import 'package:porkapp/features/animals/data/animals_repository.dart';

class AnimalFormDialog extends ConsumerStatefulWidget {
  final Animal? animal;
  final String? preselectedBatchId;

  const AnimalFormDialog({super.key, this.animal, this.preselectedBatchId});

  @override
  ConsumerState<AnimalFormDialog> createState() => _AnimalFormDialogState();
}

class _AnimalFormDialogState extends ConsumerState<AnimalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _identifierController;
  late TextEditingController _weightController;
  late TextEditingController _breedController;
  late TextEditingController _notesController;
  DateTime _birthDate = DateTime.now();
  bool _isMale = true;
  AnimalType _selectedType = const AnimalType.piglet();

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController(
      text: widget.animal?.identifier,
    );
    _weightController = TextEditingController(
      text: widget.animal?.weight.toString() ?? '',
    );
    _breedController = TextEditingController(text: widget.animal?.breed);
    _notesController = TextEditingController(text: widget.animal?.notes);

    if (widget.animal != null) {
      _birthDate = widget.animal!.birthDate ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _weightController.dispose();
    _breedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _getAnimalTypeLabel(AnimalType type) {
    return type.when(
      piglet: () => 'Lechón',
      sow: () => 'Reproductora',
      boar: () => 'Padrillo',
      fattening: () => 'Engorde',
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

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
      status: 'active',
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
          breed: animal.breed ?? '',
          weight: animal.weight,
          status: animal.status,
          type: animal.type,
        );
      } else {
        await repository.createAnimal(
          batchId: animal.batchId,
          identifier: animal.identifier,
          birthDate: animal.birthDate ?? DateTime.now(),
          breed: animal.breed ?? '',
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

        // Invalidar el caché para recargar la lista
        if (widget.preselectedBatchId != null) {
          ref.invalidate(batchAnimalsProvider(widget.preselectedBatchId!));
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
                    AnimalType.piglet(),
                    AnimalType.sow(),
                    AnimalType.boar(),
                    AnimalType.fattening(),
                  ].map((type) {
                    return DropdownMenuItem(
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

                // Identificador
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    labelText: 'Identificador/Arete',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El identificador es requerido';
                    }
                    return null;
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
                const SizedBox(height: 24),

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
                      onPressed: _submit,
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
    );
  }
}
