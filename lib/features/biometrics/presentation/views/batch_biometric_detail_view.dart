import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/shared/design/app_styles.dart' as design;
import '../../providers/batch_biometrics_provider.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/date_picker_dialog.dart';
import '../../domain/batch_measurement.dart';

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
  Widget _buildPendingBiometryCard(BatchMeasurement biometry) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
          color: design.AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ) ??
        const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: design.AppColors.textPrimary,
        );
    final dateStyle = theme.textTheme.bodyMedium?.copyWith(
          color: design.AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(
          fontSize: 16,
          color: design.AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        );
    final messageStyle = theme.textTheme.bodyMedium?.copyWith(
          color: design.AppColors.textSecondary,
          height: 1.5,
        ) ??
        const TextStyle(
          fontSize: 15,
          color: design.AppColors.textSecondary,
          height: 1.5,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            design.AppColors.backgroundSecondary,
            design.AppColors.backgroundPrimary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: design.AppColors.coral.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: design.AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.pending_actions,
                  size: 32,
                  color: design.AppColors.coral,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Biometría Pendiente',
                  style: titleStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Fecha: ${_formatDate(biometry.measurementDate)}',
            style: dateStyle,
          ),
          const SizedBox(height: 24),
          Text(
            'Tienes una biometría pendiente por completar.\nIngresa los pesos de los animales para finalizarla.',
            style: messageStyle,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showWeightInputModal(biometry.id),
              icon: const Icon(Icons.edit),
              label: const Text('Completar Ahora'),
              style: ElevatedButton.styleFrom(
                backgroundColor: design.AppColors.coral,
                foregroundColor: design.AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    );
  }

  Widget _buildSingleBiometryCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    );
  }

  Widget _buildBiometricsListView(List<BatchMeasurement> biometrics) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: biometrics.length - 1,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final measurement = biometrics[index + 1];
        return Opacity(
          opacity: 0.6,
          child: Stack(
            children: [
              _buildMeasurementTile(
                date: _formatDate(measurement.measurementDate),
                weight: measurement.averageWeight,
                animalCount: measurement.animalCount,
                note: measurement.measurementName ?? 'Pesaje',
                onTap: null,
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
        );
      },
    );
  }

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
              print('🔍 Checking biometrics: ${biometrics.length} total');
              biometrics.forEach((b) => print(
                  '🔍 Biometric: id=${b.id}, status=${b.status}, date=${b.measurementDate}'));

              final pendingBiometry = biometrics.where((b) {
                print('🔍 Checking biometry ${b.id} status: ${b.status}');
                return b.status == 'pending';
              }).firstOrNull;
              print('🔍 Pending biometry found: ${pendingBiometry?.id}');

              // Obtener todas las biometrías no pendientes
              final activeBiometrics = biometrics.where((b) {
                print(
                    '🔍 Checking active biometry ${b.id} status: ${b.status}');
                return b.status != 'pending';
              }).toList();
              print('🔍 Active biometrics found: ${activeBiometrics.length}');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar primero la biometría pendiente si existe
                  if (pendingBiometry != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: _buildPendingBiometryCard(pendingBiometry),
                    ),
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
                                    color: const Color(0xFFF07281)
                                        .withOpacity(0.1),
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
                              _formatDate(
                                  activeBiometrics.first.measurementDate),
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
                  if (pendingBiometry != null) ...[
                    const SizedBox(height: 16),
                  ],
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (activeBiometrics.isEmpty &&
                            pendingBiometry == null) {
                          return Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(32.0),
                              child: _buildEmptyStateCard(),
                            ),
                          );
                        } else if (activeBiometrics.length == 1 &&
                            pendingBiometry == null) {
                          return _buildSingleBiometryCard();
                        } else {
                          return _buildBiometricsListView(activeBiometrics);
                        }
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
      print('🔍 Checking for existing biometry:');
      print('  📋 Batch ID: ${widget.batchId}');
      print('  🔤 Batch ID Type: ${widget.batchId.runtimeType}');
      print('  📅 Selected Date: ${selectedDate.toIso8601String()}');
      
      final existingBiometry = await Supabase.instance.client
          .from('batch_biometrics')
          .select()
          .eq('batch_id', widget.batchId)
          .or('status.eq.pending,status.eq.active,measurement_date.eq.${selectedDate.toIso8601String()}')
          .maybeSingle();
          
      print('  📊 Query Result: $existingBiometry');

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

      print('  🆕 Creating new biometry record:');
      final data = {
        'batch_id': widget.batchId,
        'measurement_date': selectedDate.toIso8601String(),
        'average_weight': 0.0,
        'animal_count': 0,
        'status': 'pending',
      };
      print('  📝 Insert Data: $data');
      
      // Crear el registro de biometría en estado "pending"
      final newBiometry = await Supabase.instance.client
          .from('batch_biometrics')
          .insert(data)
          .select()
          .single();
          
      print('  ✅ Created biometry: $newBiometry');

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
    try {
      print('🔍 Verifying biometry status:');
      print('  🆔 Biometric ID: $biometricId (${biometricId.runtimeType})');
      
      Map<String, dynamic> biometry;
      List<dynamic> measurements = [];
      
      try {
        print('🔍 Verificando biometría con ID: $biometricId');
        
        // Usar la función segura para obtener toda la información
        final result = await Supabase.instance.client
            .rpc('get_biometry_safe', params: {'p_biometric_id': biometricId});
        
        if (result == null) {
          throw Exception('No se encontró la biometría');
        }
        
        biometry = result['biometry'];
        measurements = result['measurements'];
        
        print('  📊 Biometry Result: $biometry');
        print('  📊 Measurements Result: $measurements');
      } catch (e) {
        print('Error al consultar biometrías: $e');
        print('Error detallado: ${e.toString()}');
        rethrow;
      }
      print('  📊 Measurements Result: $measurements');

      if (biometry['status'] != 'pending') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Esta biometría ya no está pendiente'),
              backgroundColor: Colors.red,
            ),
          );
          await _refreshData();
        }
        return;
      }

      if (!mounted) return;

      // Si está pendiente, navegar a la vista de ingreso de pesos
      final result = await context.push<bool>(
          '/batches/${widget.batchId}/biometrics/$biometricId/weights');

      // Si volvimos con un resultado true (biometría completada), refrescar los datos
      if (result == true && mounted) {
        await _refreshData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al verificar la biometría: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
