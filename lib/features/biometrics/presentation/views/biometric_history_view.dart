import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/biometric_history_card.dart';
import '../widgets/biometric_filters.dart';
import '../widgets/feedback/biometric_feedback.dart';
import '../widgets/loading/biometric_loading_state.dart';
import '../widgets/help/biometric_help.dart';
import '../utils/biometric_extensions.dart';
import '../../providers/simple_biometric_provider.dart';

class BiometricHistoryView extends ConsumerWidget {
  final String? batchId;

  const BiometricHistoryView({
    super.key,
    this.batchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricsAsync = ref.watch(simpleBiometricProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Biometrías').withSemantics(
          label: 'Historial de mediciones biométricas',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: BiometricHelp(
                    title: 'Filtros',
                    content:
                        'Aplica filtros para encontrar registros específicos',
                    child: const Text('Filtros de Búsqueda'),
                  ),
                  content: const BiometricFilters(),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Filtrar registros',
          ).withSemantics(
            label: 'Filtrar',
            hint: 'Abre el diálogo de filtros',
          ),
        ],
      ),
      body: biometricsAsync.when(
        data: (biometrics) {
          if (biometrics.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.line_weight, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No hay registros de biometrías',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).withSemantics(
                    label: 'Sin registros',
                    hint: 'No se encontraron registros de biometrías',
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función en desarrollo'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva medición'),
                  ).withSemantics(
                    label: 'Agregar medición',
                    hint: 'Crear un nuevo registro de biometría',
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: BiometricFilters(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: biometrics.length,
                  itemBuilder: (context, index) {
                    final biometric = biometrics[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: BiometricHistoryCard(
                        batchName: biometric.batchName ?? 'Sin nombre',
                        date: biometric.measurementDate,
                        averageWeight: biometric.averageWeight,
                        animalCount: biometric.animalCount,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const BiometricLoadingState(
          isLoading: true,
          loadingText: 'Cargando historial...',
          child: SizedBox(),
        ),
        error: (error, stack) => Center(
          child: BiometricFeedback(
            message: 'Error al cargar el historial\n${error.toString()}',
            type: BiometricFeedbackType.error,
            onAction: () {
              final value = ref.refresh(simpleBiometricProvider);
              value.whenData((data) {
                if (data.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datos actualizados'),
                    ),
                  );
                }
              });
            },
            actionLabel: 'Reintentar',
          ),
        ),
      ),
    );
  }
}
