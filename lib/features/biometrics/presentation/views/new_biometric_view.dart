import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../batches/providers/batch_providers.dart';

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
  final _notesController = TextEditingController();
  final Map<String, TextEditingController> _weightControllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, bool> _savedWeights = {}; // Track which weights are saved
  final Map<String, double?> _previousWeights = {}; // Store previous weights

  String? _biometricId;
  DateTime? _measurementDate;
  bool _isSaving = false;
  final dateFormat = DateFormat('dd/MM/yyyy');

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
      _notesController.text = biometricData['notes'] ?? '';

      // Cargar pesos ya guardados
      final savedMeasurements = await Supabase.instance.client
          .from('biometric_measurements')
          .select()
          .eq('biometric_id', _biometricId!);

      for (final measurement in savedMeasurements) {
        final animalId = measurement['animal_id'];
        _savedWeights[animalId] = true;
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
    _notesController.dispose();
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

  Future<void> _saveAnimalWeight(String animalId, String weightText) async {
    final weight = double.tryParse(weightText);
    if (weight == null || weight <= 0) return;

    try {
      // Check if measurement already exists
      final existing = await Supabase.instance.client
          .from('biometric_measurements')
          .select()
          .eq('biometric_id', _biometricId!)
          .eq('animal_id', animalId)
          .maybeSingle();

      if (existing != null) {
        // Update existing
        await Supabase.instance.client.from('biometric_measurements').update({
          'weight': weight,
          'previous_weight': _previousWeights[animalId],
        }).eq('id', existing['id']);
      } else {
        // Insert new
        await Supabase.instance.client.from('biometric_measurements').insert({
          'biometric_id': _biometricId,
          'animal_id': animalId,
          'weight': weight,
          'previous_weight': _previousWeights[animalId],
        });
      }

      setState(() {
        _savedWeights[animalId] = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Peso guardado para animal #${_getAnimalIdentifier(animalId)}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('Error saving weight: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar peso: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getAnimalIdentifier(String animalId) {
    final batch = ref.read(batchProvider(widget.initialBatchId)).value;
    if (batch == null) return '';
    final animal = batch.animals.firstWhere((a) => a.id == animalId);
    return animal.identifier;
  }

  Future<void> _saveProgress() async {
    setState(() => _isSaving = true);

    try {
      // Save notes and calculate partial statistics
      await Supabase.instance.client.from('batch_biometrics').update({
        'notes': _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      }).eq('id', _biometricId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progreso guardado'),
            backgroundColor: Colors.green,
          ),
        );
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

  Future<void> _finalizeBiometric() async {
    setState(() => _isSaving = true);

    try {
      // Get all measurements
      final measurements = await Supabase.instance.client
          .from('biometric_measurements')
          .select()
          .eq('biometric_id', _biometricId!);

      if (measurements.isEmpty) {
        throw Exception('No hay mediciones guardadas');
      }

      // Calculate statistics
      final weights =
          measurements.map((m) => (m['weight'] as num).toDouble()).toList();

      final avgWeight = weights.reduce((a, b) => a + b) / weights.length;
      final minWeight = weights.reduce((a, b) => a < b ? a : b);
      final maxWeight = weights.reduce((a, b) => a > b ? a : b);

      // Calculate standard deviation
      final mean = avgWeight;
      final variance =
          weights.map((w) => (w - mean) * (w - mean)).reduce((a, b) => a + b) /
              weights.length;
      final stdDev = sqrt(variance);

      // TODO: Calculate ADG if there's a previous biometric

      // Update batch_biometrics
      await Supabase.instance.client.from('batch_biometrics').update({
        'animals_measured': weights.length,
        'avg_weight': avgWeight,
        'min_weight': minWeight,
        'max_weight': maxWeight,
        'weight_std_dev': stdDev,
        'status': 'active',
        'notes': _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      }).eq('id', _biometricId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometría finalizada exitosamente'),
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

              final allAnimalsHaveWeights = liveAnimals.every(
                (animal) => _savedWeights[animal.id] == true,
              );

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

              return Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          batch.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3250),
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Fecha: ${dateFormat.format(_measurementDate ?? DateTime.now())}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _savedWeights.length / liveAnimals.length,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            allAnimalsHaveWeights ? Colors.green : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_savedWeights.length} de ${liveAnimals.length} animales pesados',
                          style: Theme.of(context).textTheme.bodySmall,
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

                          // Add listener to save when focus is lost
                          _focusNodes[animalId]!.addListener(() {
                            if (!_focusNodes[animalId]!.hasFocus) {
                              final weightText =
                                  _weightControllers[animalId]!.text;
                              if (weightText.isNotEmpty) {
                                _saveAnimalWeight(animalId, weightText);
                              }
                            }
                          });
                        }

                        final isSaved = _savedWeights[animalId] == true;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: isSaved ? 0 : 2,
                          color: isSaved ? Colors.green.shade50 : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color:
                                  isSaved ? Colors.green : Colors.grey.shade300,
                              width: isSaved ? 2 : 1,
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
                                      suffixIcon: isSaved
                                          ? const Icon(Icons.check_circle,
                                              color: Colors.green, size: 20)
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                    ),
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        _saveAnimalWeight(animalId, value);
                                        // Move to next animal
                                        if (index < liveAnimals.length - 1) {
                                          final nextAnimalId =
                                              liveAnimals[index + 1].id;
                                          _focusNodes[nextAnimalId]
                                              ?.requestFocus();
                                        }
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
                        TextField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notas (opcional)',
                            hintText:
                                'Agregar comentarios sobre la medición...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          enabled: !_isSaving,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _isSaving ? null : _saveProgress,
                                icon: const Icon(Icons.save),
                                label: const Text('Guardar Avance'),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(
                                      color: Color(0xFF2D3250)),
                                  foregroundColor: const Color(0xFF2D3250),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: (_isSaving || !allAnimalsHaveWeights)
                                    ? null
                                    : _finalizeBiometric,
                                icon: const Icon(Icons.check),
                                label: const Text('Finalizar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D3250),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  disabledBackgroundColor: Colors.grey[300],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!allAnimalsHaveWeights)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Debes pesar todos los animales para finalizar',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
