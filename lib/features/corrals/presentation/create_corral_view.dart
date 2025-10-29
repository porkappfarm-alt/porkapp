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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2D3250)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.home_work_outlined,
                color: Color(0xFF4CAF50),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isEditing ? 'Editar Corral' : 'Nuevo Corral',
              style: const TextStyle(
                color: Color(0xFF2D3250),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField(
                          controller: _nameController,
                          label: 'Nombre',
                          placeholder: 'ej. Corral Sector Norte',
                          icon: Icons.label_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          controller: _locationController,
                          label: 'Ubicación',
                          placeholder: 'ej. Cerca del granero viejo',
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          controller: _capacityController,
                          label: 'Capacidad',
                          placeholder: 'ej. 50',
                          icon: Icons.groups_outlined,
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
                        const SizedBox(height: 20),
                        _buildField(
                          controller: _notesController,
                          label: 'Notas',
                          placeholder: 'ej. Necesita reparación de puerta',
                          icon: Icons.note_outlined,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D6D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 17,
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
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9E9E9E),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2D3250),
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4CAF50),
                size: 20,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF4CAF50),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFE53935),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
