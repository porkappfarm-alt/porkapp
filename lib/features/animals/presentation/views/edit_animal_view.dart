import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/providers/animal_providers.dart';

class EditAnimalView extends ConsumerStatefulWidget {
  final String? animalId;
  final String batchId;

  const EditAnimalView({super.key, this.animalId, required this.batchId});

  @override
  ConsumerState<EditAnimalView> createState() => _EditAnimalViewState();
}

class _EditAnimalViewState extends ConsumerState<EditAnimalView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _identifierController;
  late TextEditingController _weightController;
  late TextEditingController _breedController;
  late TextEditingController _typeController;
  late TextEditingController _notesController;
  late DateTime _birthDate;
  late DateTime _entryDate;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
    _weightController = TextEditingController();
    _breedController = TextEditingController();
    _typeController = TextEditingController();
    _notesController = TextEditingController();
    _birthDate = DateTime.now();
    _entryDate = DateTime.now();

    if (widget.animalId != null) {
      // Cargar datos del animal existente
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadAnimalData();
      });
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _weightController.dispose();
    _breedController.dispose();
    _typeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadAnimalData() async {
    if (widget.animalId == null) return;

    final animalResult =
        await ref.read(animalRepositoryProvider).getAnimal(widget.animalId!);

    animalResult.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el animal: ${error.message}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      },
      (animal) {
        setState(() {
          _identifierController.text = animal.identifier;
          _weightController.text = animal.weight.toString();
          _breedController.text = animal.breed ?? '';
          _typeController.text = animal.type;
          _notesController.text = animal.notes ?? '';
          _birthDate = animal.birthDate ?? DateTime.now();
          _entryDate = animal.entryDate ?? DateTime.now();
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthDate ? _birthDate : _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _birthDate = picked;
        } else {
          _entryDate = picked;
        }
      });
    }
  }

  Future<void> _saveAnimal() async {
    if (!_formKey.currentState!.validate()) return;

    final animal = Animal(
      id: widget.animalId ?? '',
      batchId: widget.batchId,
      identifier: _identifierController.text,
      weight: double.parse(_weightController.text),
      breed: _breedController.text,
      type: _typeController.text,
      birthDate: _birthDate,
      entryDate: _entryDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      gender: 'unknown', // You might want to add a field to capture gender in your form
    );

    final repository = ref.read(animalRepositoryProvider);
    final result = widget.animalId != null
        ? await repository.updateAnimal(animal)
        : await repository.createAnimal(animal);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (savedAnimal) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Animal guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animalId != null ? 'Editar Animal' : 'Nuevo Animal'),
        actions: [
          IconButton(onPressed: _saveAnimal, icon: const Icon(Icons.save)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Identificador
            TextFormField(
              controller: _identifierController,
              decoration: const InputDecoration(
                labelText: 'Identificador (Arete)',
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
                labelText: 'Peso (kg)',
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
            // Tipo de animal
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Tipo de Animal',
                border: OutlineInputBorder(),
                hintText: 'Ej: Cerdo de engorde, Reproductor, etc.',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El tipo de animal es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Raza
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(
                labelText: 'Raza',
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
            // Fecha de nacimiento
            ListTile(
              title: const Text('Fecha de nacimiento'),
              subtitle: Text(_formatDate(_birthDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 16),
            // Fecha de ingreso
            ListTile(
              title: const Text('Fecha de ingreso'),
              subtitle: Text(_formatDate(_entryDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 16),
            // Notas
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
