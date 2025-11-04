import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
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
  final Map<String, String> _originalWeights =
      {}; // Store original weight values for edit mode
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

  // Verificar si hubo cambios en los pesos (para modo edición)
  bool _hasChanges() {
    if (!isEditMode)
      return true; // En modo creación, siempre permitir guardar si hay pesos

    for (final entry in _weightControllers.entries) {
      final animalId = entry.key;
      final currentValue = entry.value.text.trim();
      final originalValue = _originalWeights[animalId] ?? '';

      if (currentValue != originalValue) {
        return true; // Hubo al menos un cambio
      }
    }
    return false; // No hubo cambios
  }

  void _updateButtonState(List<Animal> animals) {
    final allEntered = _allWeightsEntered(animals);
    final hasChanges = _hasChanges();
    _buttonEnabled.value = allEntered && hasChanges;
  }

  @override
  void initState() {
    super.initState();
    _biometricId = widget.biometricId;
    _loadBiometricData();
    _loadPreviousWeights();
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
        final weightText = measurement['weight']?.toString() ?? '';
        _weightControllers[animalId] = TextEditingController(
          text: weightText,
        );
        // Guardar el valor original para detectar cambios
        _originalWeights[animalId] = weightText;
      }
    } catch (e) {
      print('Error loading biometric data: $e');
    }
  }

  Future<void> _loadPreviousWeights() async {
    try {
      // Obtener la biometría actual
      final currentBiometric = await Supabase.instance.client
          .from('batch_biometrics')
          .select('batch_id, measurement_date')
          .eq('id', _biometricId!)
          .single();

      final batchId = currentBiometric['batch_id'];
      final currentDate = DateTime.parse(currentBiometric['measurement_date']);

      // Buscar la biometría anterior del mismo lote
      final previousBiometrics = await Supabase.instance.client
          .from('batch_biometrics')
          .select('id, measurement_date')
          .eq('batch_id', batchId)
          .eq('status', 'active')
          .lt('measurement_date', currentDate.toIso8601String())
          .order('measurement_date', ascending: false)
          .limit(1);

      if (previousBiometrics.isEmpty) {
        print('No previous biometric found for this batch');
        return;
      }

      final previousBiometricId = previousBiometrics.first['id'];

      // Cargar los pesos de la biometría anterior
      final previousMeasurements = await Supabase.instance.client
          .from('biometric_measurements')
          .select('animal_id, weight')
          .eq('biometric_id', previousBiometricId);

      // Guardar los pesos anteriores en el mapa
      for (final measurement in previousMeasurements) {
        final animalId = measurement['animal_id'];
        final weight = measurement['weight'];
        if (weight != null) {
          _previousWeights[animalId] = double.parse(weight.toString());
        }
      }

      print('Loaded ${_previousWeights.length} previous weights');
    } catch (e) {
      print('Error loading previous weights: $e');
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
      final measurementsToInsert = <Map<String, dynamic>>[];

      for (final data in weightsToSave) {
        final measurement = <String, dynamic>{
          'biometric_id': _biometricId,
          'animal_id': data['animal_id'] as String,
          'weight': data['weight'] as double,
          'previous_weight': data['previous_weight'] as double? ?? 0.0,
        };

        measurementsToInsert.add(measurement);
      }

      print('Inserting ${measurementsToInsert.length} measurements');
      print(
          'First measurement sample: ${measurementsToInsert.isNotEmpty ? measurementsToInsert.first : "none"}');

      await Supabase.instance.client
          .from('biometric_measurements')
          .insert(measurementsToInsert);

      // Paso 4: Calcular estadísticas básicas
      final avgWeight = weights.reduce((a, b) => a + b) / weights.length;
      final minWeight = weights.reduce((a, b) => a < b ? a : b);
      final maxWeight = weights.reduce((a, b) => a > b ? a : b);

      // Calcular desviación estándar
      final mean = avgWeight;
      final variance =
          weights.map((w) => (w - mean) * (w - mean)).reduce((a, b) => a + b) /
              weights.length;
      final stdDev = sqrt(variance);

      // Paso 5: Calcular ADG promedio desde las mediciones individuales
      double avgAdg = 0.0;
      final adgValues = <double>[];

      // Obtener las mediciones recién insertadas para calcular el ADG promedio
      final insertedMeasurements = await Supabase.instance.client
          .from('biometric_measurements')
          .select('adg')
          .eq('biometric_id', _biometricId!);

      for (final measurement in insertedMeasurements) {
        final adg = measurement['adg'];
        if (adg != null) {
          final adgValue = double.parse(adg.toString());
          // Solo incluir valores mayores a 0 en el promedio
          if (adgValue > 0) {
            adgValues.add(adgValue);
          }
        }
      }

      if (adgValues.isNotEmpty) {
        avgAdg = adgValues.reduce((a, b) => a + b) / adgValues.length;
      }

      // Paso 6: Obtener el batch_id de la biometría actual (lo usaremos varias veces)
      final currentBiometric = await Supabase.instance.client
          .from('batch_biometrics')
          .select('batch_id')
          .eq('id', _biometricId!)
          .single();

      final batchId = currentBiometric['batch_id'] as String;

      // Paso 7: Marcar biometría anterior como inactiva si no estamos en modo edición
      if (!isEditMode) {
        // Marcar todas las biometrías activas anteriores como inactivas
        await Supabase.instance.client
            .from('batch_biometrics')
            .update({'status': 'inactive'})
            .eq('batch_id', batchId)
            .eq('status', 'active')
            .neq('id', _biometricId!);
      }

      // Paso 8: Actualizar la biometría actual como activa con todas las estadísticas
      await Supabase.instance.client.from('batch_biometrics').update({
        'animals_measured': weights.length,
        'avg_weight': avgWeight,
        'min_weight': minWeight,
        'max_weight': maxWeight,
        'weight_std_dev': stdDev,
        'avg_adg': avgAdg,
        'status': 'active',
      }).eq('id', _biometricId!);

      print('Biometric updated successfully');

      if (mounted) {
        // Refrescar el listado de biometrías usando el batchId que ya tenemos
        ref.invalidate(batchBiometricsProvider(batchId));

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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Nueva Biometría',
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
                    // Header mejorado
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFE5EC),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4D6D).withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF4D6D),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      batch.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3250),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              size: 14,
                                              color: Color(0xFF757575)),
                                          const SizedBox(width: 6),
                                          Text(
                                            dateFormat.format(
                                                _measurementDate ??
                                                    DateTime.now()),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF757575),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.pets,
                                              size: 14,
                                              color: Color(0xFF4CAF50)),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${liveAnimals.length} animales',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF4CAF50),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
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

                            // Guardar valor original vacío para animales sin peso previo
                            if (isEditMode &&
                                !_originalWeights.containsKey(animalId)) {
                              _originalWeights[animalId] = '';
                            }

                            // Add listener to update button state when text changes
                            _weightControllers[animalId]!.addListener(() {
                              _updateButtonState(liveAnimals);
                            });
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
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
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE8F5E9),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.pets,
                                                size: 16,
                                                color: Color(0xFF4CAF50),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '#${animal.identifier}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2D3250),
                                              ),
                                            ),
                                          ],
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
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                        suffixText: 'kg',
                                        suffixStyle: const TextStyle(
                                          color: Color(0xFF757575),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFFAFAFA),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0),
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0),
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF4D6D),
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
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
                                            const Color(0xFFFF4D6D),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
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
