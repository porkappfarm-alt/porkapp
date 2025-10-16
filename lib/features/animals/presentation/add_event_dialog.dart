import 'package:flutter/material.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';

class AddEventDialog extends StatefulWidget {
  final String animalId;

  const AddEventDialog({super.key, required this.animalId});

  static Future<AnimalEvent?> show(BuildContext context, String animalId) {
    return showDialog<AnimalEvent>(
      context: context,
      builder: (context) => AddEventDialog(animalId: animalId),
    );
  }

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  String _eventType = 'weighing';
  final _formKey = GlobalKey<FormState>();
  late final _dateController = TextEditingController(
    text: DateTime.now().toIso8601String().split('T')[0],
  );
  late final _weightController = TextEditingController();
  late final _treatmentTypeController = TextEditingController();
  late final _descriptionController = TextEditingController();
  late final _causeController = TextEditingController();
  late final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Container(
        padding: const EdgeInsets.all(0),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Añadir Evento',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _eventType,
                decoration: const InputDecoration(labelText: 'Tipo de Evento'),
                items: const [
                  DropdownMenuItem(value: 'weighing', child: Text('Pesaje')),
                  DropdownMenuItem(
                    value: 'treatment',
                    child: Text('Tratamiento'),
                  ),
                  DropdownMenuItem(
                    value: 'mortality',
                    child: Text('Mortalidad'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  helperText: 'YYYY-MM-DD',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una fecha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_eventType == 'weighing')
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el peso';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
              if (_eventType == 'treatment') ...[
                TextFormField(
                  controller: _treatmentTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Tratamiento',
                    helperText: 'Vacuna, Desparasitación, Medicamento',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tipo de tratamiento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
              ],
              if (_eventType == 'mortality')
                TextFormField(
                  controller: _causeController,
                  decoration: const InputDecoration(labelText: 'Causa'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la causa';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final date = DateTime.parse(_dateController.text);
              final notes =
                  _notesController.text.isEmpty ? null : _notesController.text;

              final event = switch (_eventType) {
                'weighing' => AnimalEventHelpers.createWeighing(
                    animalId: widget.animalId,
                    date: date,
                    weight: double.parse(_weightController.text),
                    notes: notes,
                  ),
                'treatment' => AnimalEventHelpers.createTreatment(
                    animalId: widget.animalId,
                    date: date,
                    treatmentType: _treatmentTypeController.text,
                    description: _descriptionController.text,
                    notes: notes,
                  ),
                'mortality' => AnimalEventHelpers.createMortality(
                    animalId: widget.animalId,
                    date: date,
                    cause: _causeController.text,
                    notes: notes,
                  ),
                _ => throw Exception('Invalid event type'),
              };

              Navigator.of(context).pop(event);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _treatmentTypeController.dispose();
    _descriptionController.dispose();
    _causeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
