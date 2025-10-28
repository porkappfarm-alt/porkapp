import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/animal_measurement.dart';
import '../../providers/biometric_providers.dart';
import '../../providers/biometric_form_provider.dart';
import '../../../batches/providers/batch_providers.dart';

class NewBiometricView extends ConsumerStatefulWidget {
  final String initialBatchId;

  const NewBiometricView({
    super.key,
    required this.initialBatchId,
  });

  @override
  ConsumerState<NewBiometricView> createState() => _NewBiometricViewState();
}

class _NewBiometricViewState extends ConsumerState<NewBiometricView> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final Map<String, TextEditingController> _weightControllers = {};
  final dateFormat = DateFormat('dd/MM/yyyy');
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(newBiometricProvider, (previous, next) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    });
  }

  String get formattedBatchId => widget.initialBatchId;

  @override
  void dispose() {
    _notesController.dispose();
    for (var controller in _weightControllers.values) {
      controller.dispose();
    }
    _weightControllers.clear();
    super.dispose();
  }

  Widget _buildWeightField(
      String animalId, String identifier, double? initialWeight) {
    return Consumer(
      builder: (context, ref, _) {
        final formState = ref.watch(biometricFormStateProvider);
        final fieldState = formState[animalId];

        if (!_weightControllers.containsKey(animalId)) {
          _weightControllers[animalId] = TextEditingController();
        }

        return TextFormField(
          controller: _weightControllers[animalId],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          enabled: !_isSaving && !(fieldState?.isSaved ?? false),
          onFieldSubmitted: (value) async {
            if (!mounted) return;

            await ref
                .read(biometricFormStateProvider.notifier)
                .saveWeight(animalId, value);
            final currentState = ref.read(biometricFormStateProvider)[animalId];

            if (currentState?.isSaved ?? false) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('Peso guardado: ${currentState?.weight} kg'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(8),
                    duration: const Duration(seconds: 1),
                  ),
                );

                // Mover al siguiente campo automáticamente
                final nextController = _getNextController(animalId);
                if (nextController != null) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  nextController.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              }
            } else if (currentState?.hasError ?? false) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(currentState?.errorMessage ?? 'Error desconocido'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(8),
                  ),
                );
              }
            }
          },
          decoration: InputDecoration(
            suffixIcon: fieldState?.isSaved == true
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : null,
            suffixText: 'kg',
            isDense: true,
            filled: true,
            fillColor: fieldState?.isSaved == true
                ? Colors.green.withOpacity(0.1)
                : fieldState?.hasError == true
                    ? Colors.red.withOpacity(0.1)
                    : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: fieldState?.hasError == true
                    ? Colors.red
                    : Colors.transparent,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Requerido';
            }
            final weight = double.tryParse(value);
            if (weight == null || weight <= 0) {
              return 'Inválido';
            }
            return null;
          },
        );
      },
    );
  }

  TextEditingController? _getNextController(String currentAnimalId) {
    final batch = ref.read(batchProvider(formattedBatchId)).value;
    if (batch == null) return null;

    final liveAnimals =
        batch.animals.where((animal) => animal.status == 'active').toList();
    final currentIndex =
        liveAnimals.indexWhere((animal) => animal.id == currentAnimalId);

    if (currentIndex < liveAnimals.length - 1) {
      final nextAnimal = liveAnimals[currentIndex + 1];
      return _weightControllers[nextAnimal.id];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Biometría'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildAnimalsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
          Consumer(
            builder: (context, ref, _) {
              final batch = ref.watch(batchProvider(widget.initialBatchId));
              return batch.when(
                data: (batch) => Text(
                  batch.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3250),
                      ),
                ),
                loading: () => const Text('Cargando...'),
                error: (error, _) => Text(
                  'Error al cargar el lote',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                      ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text(
                'Fecha: ${dateFormat.format(_selectedDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalsList() {
    return ref.watch(batchProvider(formattedBatchId)).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error: ${error.toString()}')),
          data: (batch) {
            final liveAnimals = batch.animals
                .where((animal) => animal.status == 'active')
                .toList();

            if (liveAnimals.isEmpty) {
              return _buildEmptyState();
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimalListHeader(liveAnimals.length),
                        const SizedBox(height: 16),
                        ...liveAnimals
                            .map((animal) => _buildAnimalItem(animal)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay animales vivos en este lote',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Verifica el estado de los animales',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalListHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Animales vivos del lote',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF2D3250),
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3250).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Total: $count',
            style: const TextStyle(
              color: Color(0xFF2D3250),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimalItem(dynamic animal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '#${animal.identifier}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF2D3250),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identificador: ${animal.identifier}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (animal.weight != null)
                  Text(
                    'Peso inicial: ${animal.weight?.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child:
                _buildWeightField(animal.id, animal.identifier, animal.weight),
          ),
        ],
      ),
    );
  }
}
