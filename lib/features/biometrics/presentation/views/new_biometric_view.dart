import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/biometric_providers.dart';
import '../../providers/biometric_form_provider.dart';
import '../../../batches/providers/batch_providers.dart';
import '../widgets/animal_weight_row.dart';

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

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el estado
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
  final Map<String, TextEditingController> _weightControllers = {};
  final dateFormat = DateFormat('dd/MM/yyyy');
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    for (var controller in _weightControllers.values) {
      controller.dispose();
    }
    _weightControllers.clear();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Biometría'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
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
                  Consumer(
                    builder: (context, ref, child) {
                      final batch =
                          ref.watch(batchProvider(widget.initialBatchId));
                      return batch.when(
                        data: (batch) => Text(
                          batch.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3250),
                                  ),
                        ),
                        loading: () => const Text('Cargando...'),
                        error: (error, _) => Text(
                          'Error al cargar el lote',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
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
            ),
            Expanded(
              child: ref.watch(batchProvider(formattedBatchId)).when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Error: ${error.toString()}'),
                    ),
                    data: (batch) {
                      final liveAnimals = batch.animals
                          .where((animal) => animal.status == 'active')
                          .toList();
                      final animalCount = liveAnimals.length;

                      if (animalCount == 0) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 64,
                                color: Colors.grey[400],
                              ),
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

                      return ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Animales vivos del lote',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: const Color(0xFF2D3250),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2D3250)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Total: $animalCount',
                                          style: TextStyle(
                                            color: const Color(0xFF2D3250),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: liveAnimals.length,
                                    itemBuilder: (context, index) {
                                      final animal = liveAnimals[index];
                                      final animalId = animal.id;
                                      if (!_weightControllers
                                          .containsKey(animalId)) {
                                        _weightControllers[animalId] =
                                            TextEditingController();
                                      }

                                      return AnimalWeightRow(
                                        animalId: animalId,
                                        identifier: animal.identifier,
                                        initialWeight: animal.weight,
                                        controller:
                                            _weightControllers[animalId]!,
                                        isSaving: _isSaving,
                                        onSaved: () {
                                          // Enfocar el siguiente campo
                                          final currentIndex =
                                              liveAnimals.indexOf(animal);
                                          if (currentIndex <
                                              liveAnimals.length - 1) {
                                            final nextAnimal =
                                                liveAnimals[currentIndex + 1];
                                            final nextController =
                                                _weightControllers[
                                                    nextAnimal.id];
                                            if (nextController != null) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              nextController.clear();
                                            }
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nota',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _notesController,
                                    enabled: !_isSaving,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Agregar notas sobre la medición...',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
