import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: StandardAppBar(
        title: 'Historial de Biometrías',
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: BiometricHelp(
                      title: 'Filtros',
                      content:
                          'Aplica filtros para encontrar registros específicos',
                      child: Text(
                        'Filtros de Búsqueda',
                        style: TextStyle(
                          color: const Color(0xFF5D4037),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    content: BiometricFilters(),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cerrar',
                          style: TextStyle(
                            color: const Color(0xFF4CAF50),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.tune,
                size: 18,
                color: const Color(0xFF4CAF50),
              ),
              label: Text(
                'Ver evolución',
                style: TextStyle(
                  color: const Color(0xFFF07281),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ).withSemantics(
              label: 'Ver evolución',
              hint: 'Abre el gráfico de evolución',
            ),
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF07281).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.timeline,
                      size: 64,
                      color: const Color(0xFFF07281).withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No hay mediciones registradas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5D4037),
                    ),
                  ).withSemantics(
                    label: 'Sin registros',
                    hint: 'No se encontraron registros de biometrías',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comienza registrando la primera medición',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF5A6E),
                          Color(0xFFFF7F8F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5A6E).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Función en desarrollo'),
                            backgroundColor: const Color(0xFF4CAF50),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: Text(
                        'Nueva Biometría',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ).withSemantics(
                      label: 'Agregar medición',
                      hint: 'Crear un nuevo registro de biometría',
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
        loading: () => BiometricLoadingState(
          isLoading: true,
          loadingText: 'Cargando historial...',
          child: const SizedBox(),
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
                    SnackBar(
                      content: const Text('Datos actualizados'),
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
