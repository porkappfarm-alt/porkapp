import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/providers/corral_edit_provider_new.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';

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
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    // Asegurarnos de que los valores sean del tipo correcto
    String name = (widget.corral['nombre'] ?? '').toString();
    String location = (widget.corral['ubicacion'] ?? '').toString();
    String notes = (widget.corral['notas'] ?? '').toString();

    // Manejar capacity específicamente ya que debe ser un número
    String capacity = '';
    if (widget.corral['capacidad'] != null) {
      try {
        capacity = widget.corral['capacidad'].toString();
      } catch (e) {
        print('Error convirtiendo capacidad: $e');
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
    final editState = ref.watch(corralEditProvider);

    ref.listen<AsyncValue<void>>(
      corralEditProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stack) {
            if (mounted && !_isClosing) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          data: (_) {
            if (mounted && !_isClosing) {
              _isClosing = true;
              // Recargar la lista de corrales
              ref.read(corralsProvider.notifier).loadCorrals();
              // Usar addPostFrameCallback para asegurar que el cierre ocurra después del frame actual
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.pop(context, true);
                }
              });
            }
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3250)),
          onPressed: () => Navigator.pop(context),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Editar Corral',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF2D3250),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Actualiza la información del espacio',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (_hasChanges && !editState.isLoading)
            IconButton(
              icon: const Icon(Icons.check_rounded, color: Color(0xFF4CAF50)),
              onPressed: _saveChanges,
              tooltip: 'Guardar cambios',
            ),
        ],
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
                    placeholder: 'Ej. Corral Sector Norte',
                    icon: Icons.label_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    controller: _locationController,
                    label: 'Ubicación',
                    placeholder: 'Ej. Cerca del granero viejo',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    controller: _capacityController,
                    label: 'Capacidad',
                    placeholder: 'Ej. 50',
                    icon: Icons.groups_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }

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
                  const SizedBox(height: 20),
                  _buildField(
                    controller: _notesController,
                    label: 'Notas',
                    placeholder: 'Ej. Necesita reparación de puerta',
                    icon: Icons.note_outlined,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    _hasChanges && !editState.isLoading ? _saveChanges : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D6D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: editState.maybeWhen(
                  loading: () => const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  orElse: () => const Text(
                    'Guardar cambios',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (_hasChanges) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: editState.isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4CAF50),
                    side: const BorderSide(color: Color(0xFF81C784)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Descartar cambios',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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
    int maxLines = 1,
    bool isRequired = false,
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
              isRequired ? '${label.toUpperCase()} *' : label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
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
}
