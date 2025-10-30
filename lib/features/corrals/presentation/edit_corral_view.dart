import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
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
      appBar: StandardAppBar(
        title: 'Editar Corral',
        actions: [
          if (_hasChanges && !editState.isLoading)
            IconButton(
              icon: const Icon(Icons.check_rounded, color: Color(0xFF5DA271)),
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
            _buildField(
              controller: _nameController,
              label: 'Nombre',
              placeholder: 'Ej. Corral Sector Norte',
              icon: Icons.label_outline,
              iconColor: const Color(0xFFF07281),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
              isRequired: true,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _locationController,
              label: 'Ubicación',
              placeholder: 'Ej. Cerca del granero viejo',
              icon: Icons.location_on_outlined,
              iconColor: const Color(0xFF5DA271),
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _capacityController,
              label: 'Capacidad',
              placeholder: 'Ej. 50',
              icon: Icons.groups_outlined,
              iconColor: const Color(0xFF6B5E55),
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
            const SizedBox(height: 12),
            _buildField(
              controller: _notesController,
              label: 'Notas',
              placeholder: 'Ej. Necesita reparación de puerta',
              icon: Icons.note_outlined,
              iconColor: const Color(0xFF7B7B7B), // Gris Medio
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed:
                    _hasChanges && !editState.isLoading ? _saveChanges : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D6D), // Rosa Cerdito corporativo
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: editState.maybeWhen(
                  loading: () => const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  orElse: () => const Text(
                    'Guardar cambios',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
            if (_hasChanges) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: editState.isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B5E55),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFFE9E9E9),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Descartar cambios',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 16,
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
    required Color iconColor,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '${label.toUpperCase()} *' : label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: Color(0xFF7B7B7B),
            fontFamily: 'Nunito Sans',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF3E3E3E),
            fontFamily: 'Nunito Sans',
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15,
              fontFamily: 'Nunito Sans',
            ),
            prefixIcon: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE9E9E9),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE9E9E9),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFF07281),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE45B5B),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE45B5B),
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
