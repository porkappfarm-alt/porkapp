import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/providers/animal_providers.dart';

class EditAnimalView extends ConsumerStatefulWidget {
  final String? animalId;
  final String batchId;

  const EditAnimalView({super.key, this.animalId, required this.batchId});

  static Future<void> show(BuildContext context, {String? animalId, required String batchId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditAnimalView(animalId: animalId, batchId: batchId),
    );
  }

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
  String _selectedGender = 'male';

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
      gender: _selectedGender
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra superior
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFE5EC), Color(0xFFFFF0F2)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFE5EC), Color(0xFFFFF0F2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFF07281),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.pets_rounded,
                          color: Color(0xFFF07281),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.animalId != null ? 'Editar Animal' : 'Nuevo Animal',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3250),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Completa la información del animal',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                      _buildField(
                        label: 'Tipo de animal',
                        controller: _typeController,
                        placeholder: 'Lechón',
                        icon: Icons.pets_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El tipo de animal es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        label: 'Identificador/Arete',
                        controller: _identifierController,
                        placeholder: 'L0004-0001',
                        icon: Icons.tag_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El identificador es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Este identificador debe ser único',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7B7B7B),
                          fontFamily: 'Nunito Sans',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        label: 'Peso inicial (kg)',
                        controller: _weightController,
                        placeholder: '',
                        icon: Icons.monitor_weight_outlined,
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
                      _buildDateField(
                        label: 'Fecha de nacimiento',
                        date: _birthDate,
                        onTap: () => _selectDate(context, true),
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        label: 'Raza/Línea genética',
                        controller: _breedController,
                        placeholder: 'No especificada',
                        icon: Icons.science_outlined,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Género:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7B7B7B),
                          fontFamily: 'Nunito Sans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderButton('Macho', true),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildGenderButton('Hembra', false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        label: 'Notas (opcional)',
                        controller: _notesController,
                        placeholder: '',
                        icon: Icons.note_outlined,
                        maxLines: 3,
                      ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _saveAnimal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4D6D),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
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
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 15,
              fontFamily: 'Nunito Sans',
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF7B7B7B),
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

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: Color(0xFF7B7B7B),
            fontFamily: 'Nunito Sans',
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE9E9E9)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF7B7B7B),
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF3E3E3E),
                    fontFamily: 'Nunito Sans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String label, bool isMale) {
    final isSelected = isMale; // Puedes agregar lógica de estado aquí
    return OutlinedButton(
      onPressed: () {
        // Agregar lógica de selección
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF5DA271) : Colors.white,
        foregroundColor: isSelected ? Colors.white : const Color(0xFF6B5E55),
        side: BorderSide(
          color: isSelected ? const Color(0xFF5DA271) : const Color(0xFFE9E9E9),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          fontSize: 15,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
