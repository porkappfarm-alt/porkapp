import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/data/animals_repository.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/domain/animal_status.dart';
import 'package:porkapp/features/animals/domain/animal_filters.dart' as filters;
import 'package:porkapp/features/animals/domain/animal_state_machine.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_status_widgets.dart';

class NewAnimalFormDialog extends ConsumerStatefulWidget {
  final Animal? animal;
  final String? preselectedBatchId;

  const NewAnimalFormDialog({
    super.key,
    this.animal,
    this.preselectedBatchId,
  });

  @override
  ConsumerState<NewAnimalFormDialog> createState() =>
      _NewAnimalFormDialogState();
}

class _NewAnimalFormDialogState extends ConsumerState<NewAnimalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _identifierController;
  late TextEditingController _weightController;
  late TextEditingController _breedController;
  late TextEditingController _notesController;
  late DateTime _birthDate;
  AnimalStatus _status = AnimalStatus.active;
  filters.AnimalType _type = const filters.AnimalType.fattening();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _identifierController =
        TextEditingController(text: widget.animal?.identifier);
    _weightController =
        TextEditingController(text: widget.animal?.weight?.toString());
    _breedController = TextEditingController(text: widget.animal?.breed);
    _notesController = TextEditingController(text: widget.animal?.notes);
    _birthDate = widget.animal?.birthDate ?? DateTime.now();
    _status = (widget.animal?.status as AnimalStatus?) ?? AnimalStatus.active;
    _type = (widget.animal?.type as filters.AnimalType?) ??
        const filters.AnimalType.fattening();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _weightController.dispose();
    _breedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.animal != null) {
        // Validar transición de estado
        if (widget.animal!.status != _status) {
          final currentStatus = AnimalStatus.values.firstWhere(
            (s) => s.name == widget.animal!.status,
          );
          AnimalStateMachine.validateTransition(currentStatus, _status);
        }
      }

      final animal = Animal(
        id: widget.animal?.id ?? '',
        batchId: widget.preselectedBatchId ?? widget.animal!.batchId,
        identifier: _identifierController.text,
        birthDate: _birthDate,
        weight: double.tryParse(_weightController.text),
        breed: _breedController.text,
        type: _type.toString(),
        status: _status.name,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        entryDate: widget.animal?.entryDate ?? DateTime.now(),
        createdAt: widget.animal?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repository = ref.read(animalsRepositoryProvider);

      if (widget.animal != null) {
        await repository.updateAnimal(
          id: animal.id,
          identifier: animal.identifier,
          birthDate: animal.birthDate ?? DateTime.now(),
          breed: animal.breed,
          type: animal.type.toString(),
          weight: animal.weight,
          status: _status.name,
        );
      } else {
        await repository.createAnimal(
          batchId: animal.batchId,
          identifier: animal.identifier,
          birthDate: animal.birthDate ?? DateTime.now(),
          breed: animal.breed,
          type: animal.type.toString(),
          weight: animal.weight,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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

                // Estado actual (solo en edición)
                if (widget.animal != null) ...[
                  ListTile(
                    title: const Text('Estado'),
                    subtitle: AnimalStatusBadge(status: _status),
                    trailing: _status.canEdit
                        ? IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AnimalStatusChangeDialog(
                                  currentStatus: _status,
                                  onStatusChanged: (newStatus) {
                                    setState(() => _status = newStatus);
                                  },
                                ),
                              );
                            },
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Identificador
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    labelText: 'Identificador/Arete',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _status.canEdit,
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
                  enabled: _status.canEdit,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (double.tryParse(value) == null) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Raza/Genética
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    labelText: 'Raza/Genética',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _status.canEdit,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La raza es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tipo de Animal (solo para nuevos animales)
                if (widget.animal == null) ...[
                  DropdownButtonFormField<String>(
                    value: _type.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Animal',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'piglet',
                        child: Text('Lechón'),
                      ),
                      DropdownMenuItem(
                        value: 'sow',
                        child: Text('Reproductora'),
                      ),
                      DropdownMenuItem(
                        value: 'boar',
                        child: Text('Padrillo'),
                      ),
                      DropdownMenuItem(
                        value: 'fattening',
                        child: Text('Engorde'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          switch (value) {
                            case 'piglet':
                              _type = const filters.AnimalType.piglet();
                              break;
                            case 'sow':
                              _type = const filters.AnimalType.sow();
                              break;
                            case 'boar':
                              _type = const filters.AnimalType.boar();
                              break;
                            case 'fattening':
                              _type = const filters.AnimalType.fattening();
                              break;
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Notas
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _status.canEdit,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Mensajes de error y feedback
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed:
                          _isLoading || !_status.canEdit ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Guardar'),
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
