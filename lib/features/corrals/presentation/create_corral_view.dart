import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';
import 'package:porkapp/features/corrals/presentation/corrals_controller.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';

class CreateCorralView extends ConsumerStatefulWidget {
  final Corral? corral;

  const CreateCorralView({super.key, this.corral});

  @override
  ConsumerState<CreateCorralView> createState() => _CreateCorralViewState();
}

class _CreateCorralViewState extends ConsumerState<CreateCorralView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  bool get isEditing => widget.corral != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.corral!.name;
      _locationController.text = widget.corral!.location ?? '';
      _capacityController.text = widget.corral!.capacity?.toString() ?? '';
      _notesController.text = widget.corral!.notes ?? '';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (isEditing) {
        await ref.read(corralsControllerProvider.notifier).updateCorral(
              id: widget.corral!.id,
              name: _nameController.text,
              location: _locationController.text.isEmpty
                  ? null
                  : _locationController.text,
              capacity: int.parse(_capacityController.text),
              notes:
                  _notesController.text.isEmpty ? null : _notesController.text,
            );
      } else {
        // Crear el corral en la base de datos y obtener el corral creado
        final newCorral =
            await ref.read(corralsControllerProvider.notifier).createCorral(
                  name: _nameController.text,
                  location: _locationController.text.isEmpty
                      ? null
                      : _locationController.text,
                  capacity: int.parse(_capacityController.text),
                  notes: _notesController.text.isEmpty
                      ? null
                      : _notesController.text,
                );

        // Agregar el corral optimísticamente a la lista
        ref.read(corralsProvider.notifier).addCorralOptimistic(newCorral);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Retornar true para indicar éxito
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(isEditing ? 'Editar Corral' : 'Nuevo Corral'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildField(
                    controller: _nameController,
                    label: 'Nombre',
                    placeholder: 'ej. Corral Sector Norte',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _locationController,
                    label: 'Ubicación',
                    placeholder: 'ej. Cerca del granero viejo',
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _capacityController,
                    label: 'Capacidad',
                    placeholder: 'ej. 50',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la capacidad';
                      }
                      final capacity = int.tryParse(value);
                      if (capacity == null || capacity <= 0) {
                        return 'Ingrese un número válido mayor a 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _notesController,
                    label: 'Notas',
                    placeholder: 'ej. Necesita reparación de puerta',
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Guardar',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
