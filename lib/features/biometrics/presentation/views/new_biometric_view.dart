import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../batches/providers/batch_providers.dart';
import '../../../animals/domain/animal.dart';
import '../../providers/batch_biometrics_provider.dart';

class NewBiometricView extends ConsumerStatefulWidget {
  final String initialBatchId;
  final String? biometricId; // ID del registro de biometría ya creado

  const NewBiometricView({
    super.key,
    required this.initialBatchId,
    this.biometricId,
  });

  @override
  ConsumerState<NewBiometricView> createState() => _NewBiometricViewState();
}

class _NewBiometricViewState extends ConsumerState<NewBiometricView> {
  final Map<String, TextEditingController> _weightControllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, double?> _previousWeights = {}; // Store previous weights
  final ValueNotifier<bool> _buttonEnabled = ValueNotifier<bool>(false);

  String? _biometricId;
  DateTime? _measurementDate;
  bool _isSaving = false;
  final dateFormat = DateFormat('dd/MM/yyyy');

  bool get isEditMode => widget.biometricId != null;

  // Verificar si todos los animales tienen peso ingresado
  bool _allWeightsEntered(List<Animal> animals) {
    for (final animal in animals) {
      final controller = _weightControllers[animal.id];
      if (controller == null || controller.text.trim().isEmpty) {
        return false;
      }
      final weight = double.tryParse(controller.text.trim());
      if (weight == null || weight <= 0) {
        return false;
      }
    }
    return animals.isNotEmpty; // Solo true si hay animales y todos tienen peso
  }

  void _updateButtonState(List<Animal> animals) {
    _buttonEnabled.value = _allWeightsEntered(animals);
  }

  @override
  void initState() {
    super.initState();
    _biometricId = widget.biometricId;
    _loadBiometricData();
  }

  Future<void> _loadBiometricData() async {
    if (_biometricId == null) return;

    try {
      // Cargar datos de la biometría
      final biometricData = await Supabase.instance.client
          .from('batch_biometrics')
          .select()
          .eq('id', _biometricId!)
          .single();

      _measurementDate = DateTime.parse(biometricData['measurement_date']);

      // Cargar pesos ya guardados
      final savedMeasurements = await Supabase.instance.client
          .from('biometric_measurements')
          .select()
          .eq('biometric_id', _biometricId!);

      for (final measurement in savedMeasurements) {
        final animalId = measurement['animal_id'];
        _weightControllers[animalId] = TextEditingController(
          text: measurement['weight']?.toString() ?? '',
        );
      }
    } catch (e) {
      print('Error loading biometric data: $e');
    }
  }

  @override
  void dispose() {
    _buttonEnabled.dispose();
    for (var controller in _weightControllers.values) {
      controller.dispose();
    }
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    _weightControllers.clear();
    _focusNodes.clear();
    super.dispose();
  }

  Future<void> _finalizeBiometric() async {
    setState(() => _isSaving = true);

    try {
      // Paso 1: Recopilar y validar todos los pesos de los controladores
      final batch = ref.read(batchProvider(widget.initialBatchId)).value;
      if (batch == null) {
        throw Exception('No se pudo cargar el lote');
      }

      final liveAnimals =
          batch.animals.where((animal) => animal.status == 'active').toList();

      final weightsToSave = <Map<String, dynamic>>[];
      final weights = <double>[];

      for (final animal in liveAnimals) {
        final controller = _weightControllers[animal.id];
        if (controller == null) continue;

        final weightText = controller.text.trim();
        if (weightText.isEmpty) continue;

        final weight = double.tryParse(weightText);
        if (weight == null || weight <= 0) {
          throw Exception(
              'Peso inválido para animal #${animal.identifier}: $weightText');
        }

        weightsToSave.add({
          'animal_id': animal.id,
          'weight': weight,
          'previous_weight': _previousWeights[animal.id],
        });
        weights.add(weight);
      }

      if (weightsToSave.isEmpty) {
        throw Exception('No hay pesos ingresados para guardar');
      }

      // Paso 2: Eliminar mediciones existentes (en modo edición puede haber duplicados)
      if (isEditMode) {
        await Supabase.instance.client
            .from('biometric_measurements')
            .delete()
            .eq('biometric_id', _biometricId!);
      }

      // Paso 3: Insertar todos los pesos en lote
      final measurementsToInsert = weightsToSave.map((data) {
        return {
          'biometric_id': _biometricId,
          'animal_id': data['animal_id'],
          'weight': data['weight'],
          'previous_weight': data['previous_weight'],
        };
      }).toList();

      await Supabase.instance.client
          .from('biometric_measurements')
          .insert(measurementsToInsert);

      // Paso 4: Calcular estadísticas
      final avgWeight = weights.reduce((a, b) => a + b) / weights.length;
      final minWeight = weights.reduce((a, b) => a < b ? a : b);
      final maxWeight = weights.reduce((a, b) => a > b ? a : b);

      // Calcular desviación estándar
      final mean = avgWeight;
      final variance =
          weights.map((w) => (w - mean) * (w - mean)).reduce((a, b) => a + b) /
              weights.length;
      final stdDev = sqrt(variance);

      // Paso 5: Marcar biometría anterior como inactiva si no estamos en modo edición
      if (!isEditMode) {
        // Obtener el batch_id de la biometría actual
        final currentBiometric = await Supabase.instance.client
            .from('batch_biometrics')
            .select('batch_id')
            .eq('id', _biometricId!)
            .single();

        final batchId = currentBiometric['batch_id'];

        // Marcar todas las biometrías activas anteriores como inactivas
        await Supabase.instance.client
            .from('batch_biometrics')
            .update({'status': 'inactive'})
            .eq('batch_id', batchId)
            .eq('status', 'active')
            .neq('id', _biometricId!);
      }

      // Paso 6: Actualizar la biometría actual como activa
      await Supabase.instance.client
          .from('batch_biometrics')
          .update({
            'animals_measured': weights.length,
            'avg_weight': avgWeight,
            'min_weight': minWeight,
            'max_weight': maxWeight,
            'weight_std_dev': stdDev,
            'status': 'active',
          })
          .eq('id', _biometricId!)
          .single();

      if (mounted) {
        // Refrescar el listado de biometrías
        final currentBiometric = await Supabase.instance.client
            .from('batch_biometrics')
            .select('batch_id')
            .eq('id', _biometricId!)
            .single();

        ref.invalidate(batchBiometricsProvider(currentBiometric['batch_id']));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode
                ? 'Biometría actualizada exitosamente'
                : 'Biometría finalizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Pesos'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: ref.watch(batchProvider(widget.initialBatchId)).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${error.toString()}'),
                ],
              ),
            ),
            data: (batch) {
              final liveAnimals = batch.animals
                  .where((animal) => animal.status == 'active')
                  .toList();

              // Store previous weights for ADG calculation
              for (final animal in liveAnimals) {
                _previousWeights[animal.id] = animal.weight;
              }

              // Update button state after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updateButtonState(liveAnimals);
              });

              if (liveAnimals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No hay animales vivos en este lote',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SafeArea(
                child: Column(
                  children: [
                    // Header compacto
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batch.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3250),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      dateFormat.format(
                                          _measurementDate ?? DateTime.now()),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.pets,
                                        size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${liveAnimals.length} animales',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Animals List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: liveAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = liveAnimals[index];
                          final animalId = animal.id;

                          // Initialize controllers and focus nodes
                          if (!_weightControllers.containsKey(animalId)) {
                            _weightControllers[animalId] =
                                TextEditingController();
                            _focusNodes[animalId] = FocusNode();

                            // Add listener to update button state when text changes
                            _weightControllers[animalId]!.addListener(() {
                              _updateButtonState(liveAnimals);
                            });
                          }

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#${animal.identifier}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (animal.weight != null)
                                          Text(
                                            'Peso anterior: ${animal.weight!.toStringAsFixed(1)} kg',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 120,
                                    child: TextField(
                                      controller: _weightControllers[animalId],
                                      focusNode: _focusNodes[animalId],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      textAlign: TextAlign.center,
                                      enabled: !_isSaving,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Peso',
                                        suffixText: 'kg',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        // Solo mover al siguiente campo, NO guardar
                                        if (index < liveAnimals.length - 1) {
                                          final nextAnimalId =
                                              liveAnimals[index + 1].id;
                                          _focusNodes[nextAnimalId]
                                              ?.requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Notes and Buttons
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
                      child: Column(
                        children: [
                          // Botón único de finalizar/actualizar
                          ValueListenableBuilder<bool>(
                            valueListenable: _buttonEnabled,
                            builder: (context, isEnabled, child) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: (_isSaving || !isEnabled)
                                          ? null
                                          : _finalizeBiometric,
                                      icon: const Icon(Icons.check),
                                      label: Text(isEditMode
                                          ? 'Actualizar'
                                          : 'Finalizar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2D3250),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        disabledBackgroundColor:
                                            Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  if (!isEnabled)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        isEditMode
                                            ? 'Debes ingresar todos los pesos para actualizar'
                                            : 'Debes ingresar todos los pesos para finalizar',
                                        style: TextStyle(
                                          color: Colors.orange[700],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
