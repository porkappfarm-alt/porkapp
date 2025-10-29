import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/batches/presentation/batches_controller.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

class CreateBatchView extends ConsumerStatefulWidget {
  final String? batchId;

  const CreateBatchView({super.key, this.batchId});

  @override
  ConsumerState<CreateBatchView> createState() => _CreateBatchViewState();
}

class _CreateBatchViewState extends ConsumerState<CreateBatchView> {
  final _formKey = GlobalKey<FormState>();
  final _animalCountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedCorralId;
  int? _selectedCorralCapacity;
  String? _batchName; // Para edición
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get isEditing => widget.batchId != null;

  @override
  void dispose() {
    _animalCountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCorralId == null) return;

    setState(() => _isLoading = true);
    try {
      if (isEditing) {
        await ref.read(batchesControllerProvider.notifier).updateBatch(
              id: widget.batchId!,
              name: _batchName!, // Mantener el nombre original
              corralId: _selectedCorralId!,
              createdAt: _selectedDate,
              headcountStart: int.parse(_animalCountController.text),
            );
      } else {
        await ref.read(batchesControllerProvider.notifier).createBatch(
              corralId: _selectedCorralId!,
              entryDate: _selectedDate,
              animalCount: int.parse(_animalCountController.text),
            );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing
                ? 'Lote actualizado exitosamente'
                : 'Lote creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cargar datos para edición
    if (isEditing) {
      final batchAsync = ref.watch(batchProvider(widget.batchId!));
      batchAsync.whenData((batch) {
        if (!_isInitialized) {
          // Usar WidgetsBinding para evitar modificar estado durante build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isInitialized) {
              setState(() {
                _batchName = batch.name;
                _selectedDate = batch.createdAt;
                _selectedCorralId = batch.corralId;
                _animalCountController.text = batch.headcountStart.toString();
                _isInitialized = true;
              });
            }
          });
        }
      });
    }

    // En modo edición, necesitamos filtrar los corrales manualmente
    // para incluir el corral actual más los disponibles
    final corralsAsync = isEditing
        ? ref.watch(corralsProvider) // Todos los corrales
        : ref
            .watch(availableCorralsProvider)
            .whenData((corrals) => corrals); // Solo disponibles

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Crear Lote',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Info card - solo mostrar en modo crear
                  if (!isEditing)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Color(0xFF4CAF50), size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'El nombre del lote se generará automáticamente',
                              style: TextStyle(
                                color: Colors.green[900],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Section: Corral
                  _buildSectionLabel('Corral *', Icons.home_work),
                  const SizedBox(height: 8),
                  corralsAsync.when(
                    data: (corrals) {
                      // En modo edición, filtrar para mostrar solo:
                      // - Corrales disponibles (status == disponible o activeBatchCount == 0)
                      // - El corral actual del lote
                      List<Corral> availableCorrals = isEditing
                          ? corrals
                              .where((c) =>
                                  c.status == CorralStatus.disponible ||
                                  c.activeBatchCount == 0 ||
                                  c.id == _selectedCorralId)
                              .toList()
                          : corrals;

                      if (availableCorrals.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber,
                                  color: Colors.orange[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No hay corrales disponibles. Todos tienen lotes activos.',
                                  style: TextStyle(color: Colors.orange[900]),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        value: _selectedCorralId,
                        decoration: InputDecoration(
                          hintText: 'Seleccione un corral',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFF4CAF50), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        items: availableCorrals
                            .map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(
                                    '${c.name}${c.capacity != null ? ' (Cap: ${c.capacity})' : ''}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCorralId = value;
                            _selectedCorralCapacity = availableCorrals
                                .firstWhere((c) => c.id == value)
                                .capacity;
                          });
                        },
                        validator: (v) =>
                            v == null ? 'Seleccione un corral' : null,
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Error: $e',
                          style: TextStyle(color: Colors.red[900])),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section: Fecha de Ingreso
                  _buildSectionLabel(
                      'Fecha de Ingreso *', Icons.calendar_today),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Color(0xFF4CAF50), size: 20),
                              const SizedBox(width: 12),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section: Cantidad de Animales
                  _buildSectionLabel('Cantidad de Animales *', Icons.pets),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _animalCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Ejemplo: 50',
                      prefixIcon:
                          const Icon(Icons.pets, color: Color(0xFF4CAF50)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF4CAF50), width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingrese la cantidad';
                      final n = int.tryParse(v);
                      if (n == null || n <= 0) return 'Cantidad inválida';
                      if (_selectedCorralCapacity != null &&
                          n > _selectedCorralCapacity!) {
                        return '⚠️ Excede capacidad ($_selectedCorralCapacity)';
                      }
                      return null;
                    },
                    onChanged: (value) => _formKey.currentState?.validate(),
                  ),
                  const SizedBox(height: 12),

                  // Info sobre creación automática - solo en modo crear
                  if (!isEditing)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome,
                              color: Colors.blue[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Se crearán automáticamente con código consecutivo',
                              style: TextStyle(
                                  color: Colors.blue[900], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Bottom button
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
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
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEC407A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            isEditing ? 'Actualizar Lote' : 'Crear Lote',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF5D4037)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5D4037),
          ),
        ),
      ],
    );
  }
}
