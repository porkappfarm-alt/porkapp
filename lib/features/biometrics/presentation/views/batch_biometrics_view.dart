import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import '../../providers/batch_biometrics_provider.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/date_picker_dialog.dart';

class BatchBiometricsView extends ConsumerStatefulWidget {
  final String batchId;

  const BatchBiometricsView({
    super.key,
    required this.batchId,
  });

  @override
  ConsumerState<BatchBiometricsView> createState() =>
      _BatchBiometricsViewState();
}

class _BatchBiometricsViewState extends ConsumerState<BatchBiometricsView> {
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
    // Usar listen=true para asegurar que se reconstruya cuando cambie el provider
    final biometricsAsync = ref.watch(batchBiometricsProvider(widget.batchId));
    final batchAsync = ref.watch(batchProvider(widget.batchId));

    print('🔄 BUILD: BatchBiometricsView para batch ${widget.batchId}');
    print('🔄 BUILD: biometricsAsync state = ${biometricsAsync.runtimeType}');

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Biometrías del lote',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print('🔄 Pull-to-refresh: Invalidando provider...');
          ref.invalidate(batchBiometricsProvider(widget.batchId));
          // Esperar un momento para que se complete la recarga
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: biometricsAsync.when(
          loading: () => ListView(
            children: const [
              SizedBox(height: 200),
              Center(child: CircularProgressIndicator()),
            ],
          ),
          error: (error, stack) => ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const SizedBox(height: 100),
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
              Center(
                child: ElevatedButton.icon(
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
              ),
            ],
          ),
          data: (biometrics) => batchAsync.when(
            data: (batch) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mostrar la última biometría en una sección aparte destacada
                      if (biometrics.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            // Solo permitir editar si es activa o pending
                            final firstBiometric = biometrics.first;
                            if (firstBiometric.status == 'active' ||
                                firstBiometric.status == 'pending') {
                              // Navegar al formulario para agregar/editar pesos
                              context.push(
                                '/batches/${widget.batchId}/biometrics/${firstBiometric.id}/weights',
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFF07281).withOpacity(0.1),
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFF07281),
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFF07281).withOpacity(0.15),
                                  blurRadius: 24,
                                  offset: const Offset(0, 6),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge con estado de la biometría
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            biometrics.first.status == 'active'
                                                ? const Color(0xFFF07281)
                                                : biometrics.first.status ==
                                                        'pending'
                                                    ? const Color(0xFFFFA726)
                                                    : Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            biometrics.first.status == 'active'
                                                ? Icons.check_circle
                                                : biometrics.first.status ==
                                                        'pending'
                                                    ? Icons.pending
                                                    : Icons.lock,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            biometrics.first.status == 'active'
                                                ? 'ACTIVA'
                                                : biometrics.first.status ==
                                                        'pending'
                                                    ? 'PENDIENTE'
                                                    : 'HISTÓRICA',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    if (biometrics.first.status == 'active' ||
                                        biometrics.first.status == 'pending')
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF07281)
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          biometrics.first.status == 'active'
                                              ? Icons.edit_outlined
                                              : Icons.add,
                                          size: 20,
                                          color: const Color(0xFFF07281),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Fecha
                                Text(
                                  _formatDate(biometrics.first.measurementDate),
                                  style: const TextStyle(
                                    color: Color(0xFF5D4037),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Información principal
                                Row(
                                  children: [
                                    // Peso Promedio
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF07281)
                                              .withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: const Color(0xFFF07281)
                                                .withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'PESO PROMEDIO',
                                              style: TextStyle(
                                                color: Color(0xFF9E9E9E),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  biometrics.first.averageWeight
                                                      .toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    color: Color(0xFF5D4037),
                                                    fontSize: 36,
                                                    fontWeight: FontWeight.w900,
                                                    height: 1.0,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  'kg',
                                                  style: TextStyle(
                                                    color: Color(0xFF9E9E9E),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Animales medidos
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFF07281),
                                            Color(0xFFE94C5D)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFF07281)
                                                .withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.pets,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${biometrics.first.animalCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                              height: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'animales',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
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
                        ),
                    ],
                  ),
                ),
                // Sección de lista de biometrías
                if (biometrics.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
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
                    ),
                  )
                else if (biometrics.length == 1)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
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
                                Icons.history,
                                size: 64,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Solo hay una medición',
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
                              'Usa el botón + para agregar más mediciones.',
                              style: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Empezamos desde el índice 1 para omitir la primera (ya mostrada arriba)
                          final measurement = biometrics[index + 1];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Opacity(
                              opacity: 0.6,
                              child: Stack(
                                children: [
                                  _buildMeasurementTile(
                                    date: _formatDate(
                                        measurement.measurementDate),
                                    weight: measurement.averageWeight,
                                    animalCount: measurement.animalCount,
                                    note:
                                        measurement.measurementName ?? 'Pesaje',
                                    onTap: null, // Sin acción, deshabilitado
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.lock_outline,
                                          size: 32,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: biometrics.length - 1,
                      ),
                    ),
                  ),
              ],
            ),
            loading: () => ListView(
              children: const [
                SizedBox(height: 200),
                Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF4D6D)),
                ),
              ],
            ),
            error: (_, __) => ListView(
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text('Error al cargar información del lote'),
                ),
              ],
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
      final newBiometric = await Supabase.instance.client
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

      print('✅ Biometría creada con ID: ${newBiometric['id']}');

      if (context.mounted) {
        // Cerrar el indicador de carga
        Navigator.of(context).pop();

        // Refrescar el listado inmediatamente - usando múltiples métodos para asegurar refresh
        print('🔄 Invalidando provider para batch: ${widget.batchId}');

        // Método 1: Invalidar el provider (limpia el cache)
        ref.invalidate(batchBiometricsProvider(widget.batchId));

        // Método 2: Esperar un frame y leer el provider para forzar recarga
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            print('🔄 Post-frame: Leyendo provider para forzar recarga');
            ref.read(batchBiometricsProvider(widget.batchId));
          }
        });

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometría creada exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
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
