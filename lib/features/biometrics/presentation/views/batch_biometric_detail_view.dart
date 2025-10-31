import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import '../../providers/batch_biometrics_provider.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/date_picker_dialog.dart';

class BatchBiometricDetailView extends ConsumerStatefulWidget {
  final String batchId;

  const BatchBiometricDetailView({
    super.key,
    required this.batchId,
  });

  @override
  ConsumerState<BatchBiometricDetailView> createState() =>
      _BatchBiometricDetailViewState();
}

class _BatchBiometricDetailViewState
    extends ConsumerState<BatchBiometricDetailView> {
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildMeasurementTile({
    required String date,
    required double weight,
    required int animalCount,
    required String note,
    VoidCallback? onTap,
  }) {
    const pink = Color(0xFFF07281);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF1EAEA),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              decoration: const BoxDecoration(
                color: pink,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE3E8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.monitor_weight_outlined,
                      color: pink,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            color: Color(0xFF3E3E3E),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.pets,
                              size: 14,
                              color: Color(0xFF7B7B7B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$animalCount animales medidos',
                              style: const TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontSize: 13,
                                fontFamily: 'Nunito Sans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            weight.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xFF3E3E3E),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'kg',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'promedio',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 11,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final biometricsAsync = ref.watch(batchBiometricsProvider(widget.batchId));
    final batchAsync = ref.watch(batchProvider(widget.batchId));

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Detalle Biometría',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(batchBiometricsProvider(widget.batchId));
        },
        child: biometricsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar las biometrías',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No se pudieron cargar las mediciones de este lote',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.refresh(batchBiometricsProvider(widget.batchId)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4D6D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
          data: (biometrics) => batchAsync.when(
            data: (batch) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (biometrics.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFE5EC),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4D6D).withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Última medición
                        Expanded(
                          flex: 2,
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
                                  const SizedBox(width: 6),
                                  const Text(
                                    'ÚLTIMA MEDICIÓN',
                                    style: TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(biometrics.first.measurementDate),
                                style: const TextStyle(
                                  color: Color(0xFF2D3250),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Promedio actual
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'PROMEDIO ACTUAL',
                                    style: TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    biometrics.first.averageWeight
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Color(0xFF2D3250),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Text(
                                    'kg',
                                    style: TextStyle(
                                      color: Color(0xFF9E9E9E),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Cantidad de animales
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.pets,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${biometrics.first.animalCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: biometrics.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.scale_outlined,
                                    size: 64,
                                    color: Color(0xFFBDBDBD),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No hay mediciones registradas',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: const Color(0xFF2D3250),
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Este lote aún no tiene biometrías.\nUsa el botón + para agregar la primera.',
                                  style: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: biometrics.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final measurement = biometrics[index];

                            return _buildMeasurementTile(
                              date: _formatDate(measurement.measurementDate),
                              weight: measurement.averageWeight,
                              animalCount: measurement.animalCount,
                              note: measurement.measurementName ?? 'Pesaje',
                              onTap: () {
                                // Navegar al detalle de la biometría o mostrar más información
                                print('Tap on biometric: ${measurement.id}');
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
            loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF4D6D))),
            error: (_, __) => const Center(
              child: Text('Error al cargar información del lote'),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF07281).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showDatePickerAndNavigate(context),
          backgroundColor: const Color(0xFFF07281),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Future<void> _showDatePickerAndNavigate(BuildContext context) async {
    // Mostrar el bottom sheet modal para seleccionar la fecha
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BiometricDatePickerDialog(),
    );

    if (selectedDate == null || !context.mounted) return;

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Validar que no exista una biometría pendiente
      final pendingBiometrics = await Supabase.instance.client
          .from('batch_biometrics')
          .select()
          .eq('batch_id', widget.batchId)
          .eq('status', 'pending');

      if (pendingBiometrics.isNotEmpty) {
        if (context.mounted) {
          // Cerrar el indicador de carga
          Navigator.of(context).pop();

          // Mostrar mensaje informando sobre la biometría pendiente
          final pendingBiometric = pendingBiometrics.first;
          final pendingDate =
              DateTime.parse(pendingBiometric['measurement_date']);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.pending_actions,
                      color: Color(0xFFF57C00),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Biometría Pendiente',
                      style: TextStyle(
                        color: Color(0xFF2D3250),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'Ya existe una biometría pendiente del ${DateFormat('dd/MM/yyyy').format(pendingDate)}.\n\nDebes completarla o eliminarla antes de crear una nueva.',
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF757575),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showWeightInputModal(pendingBiometric['id']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D6D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Completar Ahora',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Crear el registro de biometría en estado "pending"
      await Supabase.instance.client
          .from('batch_biometrics')
          .insert({
            'batch_id': widget.batchId,
            'measurement_date': selectedDate.toIso8601String(),
            'animals_measured': 0,
            'avg_weight': 0.0,
            'min_weight': 0.0,
            'max_weight': 0.0,
            'weight_std_dev': 0.0,
            'avg_adg': 0.0,
            'mortality_count': 0,
            'mortality_causes': {},
            'status': 'pending',
          })
          .select()
          .single();

      if (context.mounted) {
        // Cerrar el indicador de carga
        Navigator.of(context).pop();

        // Refrescar el listado
        ref.invalidate(batchBiometricsProvider(widget.batchId));

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometría creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Cerrar el indicador de carga
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la biometría: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showWeightInputModal(String biometricId) {
    // Navegar a la vista de ingreso de pesos
    context.push('/biometrics/batch/${widget.batchId}/$biometricId/weights');
  }
}
