import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/providers/corral_edit_provider_new.dart';

class EditCorralView extends ConsumerStatefulWidget {
  final Map<String, dynamic> corral;

  const EditCorralView({
    super.key,
    required this.corral,
  });

  @override
  ConsumerState<EditCorralView> createState() => _EditCorralViewState();
}

class _EditCorralViewState extends ConsumerState<EditCorralView> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _capacityController;
  late TextEditingController _notesController;
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Asegurarnos de que los valores sean del tipo correcto
    String name = (widget.corral['name'] ?? '').toString();
    String location = (widget.corral['location'] ?? '').toString();
    String notes = (widget.corral['notes'] ?? '').toString();

    // Manejar capacity específicamente ya que debe ser un número
    String capacity = '';
    if (widget.corral['capacity'] != null) {
      try {
        capacity = widget.corral['capacity'].toString();
      } catch (e) {
        print('Error convirtiendo capacity: $e');
      }
    }

    _nameController = TextEditingController(text: name);
    _locationController = TextEditingController(text: location);
    _capacityController = TextEditingController(text: capacity);
    _notesController = TextEditingController(text: notes);

    _nameController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
    _capacityController.addListener(_onFieldChanged);
    _notesController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      corralEditProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stack) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
          data: (_) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Corral actualizado correctamente'),
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Corral'),
        actions: [
          if (_hasChanges)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
              tooltip: 'Guardar cambios',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre *',
                hintText: 'Ingrese el nombre del corral',
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
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                hintText: 'Ingrese la ubicación del corral',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacidad',
                hintText: 'Ingrese la capacidad del corral',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null; // La capacidad es opcional
                }

                // Remover espacios y verificar que solo contenga números
                value = value.trim();
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return 'Ingrese solo números';
                }

                try {
                  final number = int.parse(value);
                  if (number < 0) {
                    return 'La capacidad no puede ser negativa';
                  }
                  if (number > 1000) {
                    return 'La capacidad parece muy alta';
                  }
                } catch (e) {
                  return 'Número no válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas',
                hintText: 'Ingrese notas adicionales',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _hasChanges ? _saveChanges : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: ref.watch(corralEditProvider).maybeWhen(
                    loading: () => const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    orElse: () => const Text('Guardar cambios'),
                  ),
            ),
            if (_hasChanges) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Descartar cambios'),
              ),
            ],
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text('Eliminar corral'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      int? capacity;
      if (_capacityController.text.isNotEmpty) {
        capacity = int.parse(_capacityController.text.trim());
      }

      String id = widget.corral['id']?.toString() ?? '';
      if (id.isEmpty) {
        throw Exception('ID del corral no válido');
      }

      await ref.read(corralEditProvider.notifier).updateCorral(
            id: id,
            name: _nameController.text.trim(),
            location: _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
            capacity: capacity,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Está seguro que desea eliminar el corral "${widget.corral['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(corralEditProvider.notifier)
          .deleteCorral(widget.corral['id']);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Corral eliminado correctamente'),
          ),
        );
      }
    }
  }
}
