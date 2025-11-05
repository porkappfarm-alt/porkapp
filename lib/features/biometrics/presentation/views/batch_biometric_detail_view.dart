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

  Future<void> _refreshData() async {
    ref.invalidate(batchBiometricsProvider(widget.batchId));
    await ref.read(batchBiometricsProvider(widget.batchId).future);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // Refrescar datos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refrescar cuando volvemos a la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshData();
      }
    });
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
        onRefresh: _refreshData,
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
            data: (batch) {
              // Obtener la biometría pendiente si existe
              final pendingBiometry = biometrics.where((b) => b.status == 'pending').firstOrNull;
              // Obtener todas las biometrías no pendientes
              final activeBiometrics = biometrics.where((b) => b.status != 'pending').toList();
              
              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mostrar la última biometría activa en una sección aparte destacada
                if (activeBiometrics.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      // Navegar al detalle de pesos de la última biometría activa
                      context.push(
                        '/batches/${widget.batchId}/biometrics/${activeBiometrics.first.id}/weights',
                      );
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
                            color: const Color(0xFFF07281).withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 6),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge "Última Medición"
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF07281),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'ÚLTIMA MEDICIÓN',
                                      style: TextStyle(
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
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFF07281).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                  color: Color(0xFFF07281),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Fecha
                          Text(
                            _formatDate(activeBiometrics.first.measurementDate),
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
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF07281)
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(16),
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
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${activeBiometrics.first.averageWeight.toStringAsFixed(1)} kg',
                                          style: const TextStyle(
                                            color: Color(0xFF5D4037),
                                            fontSize: 36,
                                            fontWeight: FontWeight.w900,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Animales medidos
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.pets,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 4),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${activeBiometrics.first.animalCount}\nanimales',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: activeBiometrics.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Builder(
                              builder: (context) {
                                // Buscar si hay biometría pendiente en la lista
                                final pendingBiometry = biometrics.where((b) => b.status == 'pending').firstOrNull;
                                final hasPendingBiometry = pendingBiometry != null;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: hasPendingBiometry
                                            ? const Color(0xFFFFF3E0)
                                            : const Color(0xFFF5F5F5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        hasPendingBiometry
                                            ? Icons.pending_actions
                                            : Icons.scale_outlined,
                                        size: 64,
                                        color: hasPendingBiometry
                                            ? const Color(0xFFF57C00)
                                            : const Color(0xFFBDBDBD),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      hasPendingBiometry
                                          ? 'Biometría Pendiente'
                                          : 'No hay mediciones registradas',
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
                                    Text(
                                      hasPendingBiometry
                                          ? 'Tienes una biometría pendiente por completar.\nPulsa el botón + para terminarla.'
                                          : 'Este lote aún no tiene biometrías.\nUsa el botón + para agregar la primera.',
                                      style: TextStyle(
                                        color: hasPendingBiometry
                                            ? const Color(0xFFF57C00)
                                            : const Color(0xFF9E9E9E),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (hasPendingBiometry) ...[
                                      const SizedBox(height: 16),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          _showWeightInputModal(pendingBiometry.id);
                                        },
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Completar Ahora'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFFF57C00),
                                          side: const BorderSide(
                                              color: Color(0xFFF57C00)),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : activeBiometrics.length == 1
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
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: activeBiometrics.length - 1,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                // Empezamos desde el índice 1 para omitir la primera (ya mostrada arriba)
                                final measurement = activeBiometrics[index + 1];

                                return Opacity(
                                  opacity: 0.6,
                                  child: Stack(
                                    children: [
                                      _buildMeasurementTile(
                                        date: _formatDate(
                                            measurement.measurementDate),
                                        weight: measurement.averageWeight,
                                        animalCount: measurement.animalCount,
                                        note: measurement.measurementName ??
                                            'Pesaje',
                                        onTap:
                                            null, // Sin acción, deshabilitado
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.05),
                                            borderRadius:
                                                BorderRadius.circular(16),
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
                                );
                              },
                            ),
                ),
              ],
            );
            },
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
      // Validar que no exista una biometría pendiente o activa para esta fecha
      final existingBiometry = await Supabase.instance.client
          .from('batch_biometrics')
          .select()
          .eq('batch_id', widget.batchId)
          .or('status.eq.pending,and(status.eq.active,measurement_date.eq.${selectedDate.toIso8601String()})')
          .maybeSingle();

      if (existingBiometry != null) {
        if (!context.mounted) return;

        // Cerrar el indicador de carga
        Navigator.of(context).pop();

        final status = existingBiometry['status'];

        if (status == 'pending') {
          // Mostrar diálogo para completar biometría pendiente
          final pendingDate =
              DateTime.parse(existingBiometry['measurement_date']);

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
                    _showWeightInputModal(existingBiometry['id']);
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
        } else {
          // Mostrar mensaje para biometría activa
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ya existe una biometría activa para esta fecha'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Crear el registro de biometría en estado "pending"
      final newBiometry = await Supabase.instance.client
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

      final biometricId = newBiometry['id'].toString();

      if (context.mounted) {
        // Cerrar el indicador de carga
        Navigator.of(context).pop();

        // Navegar a la vista de ingreso de pesos
        await _showWeightInputModal(biometricId);
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

  Future<void> _showWeightInputModal(String biometricId) async {
    // Navegar a la vista de ingreso de pesos y esperar el resultado
    final result = await context.push<bool>(
        '/batches/${widget.batchId}/biometrics/$biometricId/weights');

    // Si volvimos con un resultado true (biometría completada), refrescar los datos
    if (result == true && mounted) {
      await _refreshData();
    }
  }
}
