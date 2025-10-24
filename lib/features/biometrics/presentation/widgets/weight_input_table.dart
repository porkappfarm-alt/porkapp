import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/animal_measurement.dart';
import './animal_selector_dialog.dart';
import '../widgets/help/biometric_help.dart';
import '../widgets/feedback/biometric_feedback.dart';
import '../utils/biometric_extensions.dart';

class WeightInputTable extends ConsumerStatefulWidget {
  final String batchId;
  final List<AnimalMeasurement>? initialMeasurements;
  final Function(List<AnimalMeasurement>) onMeasurementsChanged;

  const WeightInputTable({
    super.key,
    required this.batchId,
    this.initialMeasurements,
    required this.onMeasurementsChanged,
  });

  @override
  ConsumerState<WeightInputTable> createState() => _WeightInputTableState();
}

class _WeightInputTableState extends ConsumerState<WeightInputTable> {
  late List<AnimalMeasurement> _measurements;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _measurements = widget.initialMeasurements ?? [];
  }

  void _addMeasurement() async {
    final animal = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AnimalSelectorDialog(batchId: widget.batchId),
    );

    if (animal != null) {
      final measurement = AnimalMeasurement(
        id: '',
        batchMeasurementId: '',
        animalId: animal['id'],
        weight: 0,
        createdAt: DateTime.now(),
      );

      setState(() {
        _measurements.add(measurement);
        widget.onMeasurementsChanged(_measurements);
      });
    }
  }

  void _updateMeasurement(int index, AnimalMeasurement measurement) {
    setState(() {
      _measurements[index] = measurement;
      widget.onMeasurementsChanged(_measurements);
    });
  }

  void _removeMeasurement(int index) {
    setState(() {
      _measurements.removeAt(index);
      widget.onMeasurementsChanged(_measurements);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildHeader(),
          _buildMeasurementsList(),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: BiometricHelp(
              title: 'Identificación del Animal',
              content: 'Muestra el identificador único del animal',
              child: const Text(
                'Animal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: BiometricHelp(
              title: 'Peso del Animal',
              content: 'Ingresa el peso actual del animal en kilogramos',
              child: const Text(
                'Peso Actual (kg)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Acciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).withSemantics(
      label: 'Encabezados de la tabla de registro de pesos',
    );
  }

  Widget _buildMeasurementsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _measurements.length,
      itemBuilder: (context, index) {
        final measurement = _measurements[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(measurement.animalId).withSemantics(
                  label: 'Animal número ${measurement.animalId}',
                ),
              ),
              Expanded(
                flex: 2,
                child: BiometricHelp(
                  title: 'Ingreso de Peso',
                  content: 'Ingresa el peso del animal en kilogramos',
                  showIcon: false,
                  child: TextFormField(
                    initialValue: measurement.weight.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      helperText: 'Peso en kg',
                      errorStyle: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return 'Peso inválido';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final weight = double.tryParse(value) ?? 0;
                      _updateMeasurement(
                        index,
                        measurement.copyWith(
                          weight: weight,
                          createdAt: DateTime.now(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Eliminación'),
                        content: Text(
                          '¿Estás seguro de eliminar la medición del animal ${measurement.animalId}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _removeMeasurement(index);
                              context.showBiometricSuccess(
                                'Medición eliminada',
                              );
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Eliminar medición',
                ).withSemantics(
                  label: 'Eliminar medición del animal ${measurement.animalId}',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: _addMeasurement,
        icon: const Icon(Icons.add),
        label: const Text('Añadir Animal'),
      ).withSemantics(
        label: 'Añadir nueva medición de animal',
        hint: 'Toca para seleccionar un animal y registrar su peso',
      ),
    );
  }
}
