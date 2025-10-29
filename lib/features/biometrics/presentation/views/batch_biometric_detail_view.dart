import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
    String? status,
    VoidCallback? onTap,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    bool isLastMeasurement = false,
    bool isBatchActive = false,
  }) {
    final isPending = status == 'pending';
    final canEdit = isLastMeasurement && isBatchActive && !isPending;

    return InkWell(
      onTap: isPending ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isPending
              ? Border.all(color: Colors.orange.shade300, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPending)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pending_actions,
                          size: 16, color: Colors.orange.shade700),
                      const SizedBox(width: 6),
                      Text(
                        'Pendiente de medición',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  if (!isPending) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D3250).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.scale_outlined,
                        color: Color(0xFF2D3250),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            color: Color(0xFF2D3250),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  if (isPending) ...[
                    ElevatedButton(
                      onPressed: onEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3250),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Icon(Icons.edit, size: 18),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Icon(Icons.delete_outline, size: 18),
                    ),
                  ],
                  if (!isPending)
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
                                color: Color(0xFF2D3250),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'kg',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D6D).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.pets,
                                size: 12,
                                color: const Color(0xFFFF4D6D).withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$animalCount',
                                style: TextStyle(
                                  color:
                                      const Color(0xFFFF4D6D).withOpacity(0.8),
                                  fontSize: 12,
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
              // Botones de editar y eliminar para la última medición
              if (canEdit && (onEdit != null || onDelete != null))
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onEdit != null)
                        TextButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Editar'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF2D3250),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      if (onEdit != null && onDelete != null)
                        const SizedBox(width: 8),
                      if (onDelete != null)
                        TextButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text('Eliminar'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editBiometric(String biometricId) async {
    // Navegar a la vista de edición (reutilizando new_biometric_view)
    context.push('/biometrics/batch/${widget.batchId}/$biometricId/weights');
  }

  Future<void> _deleteBiometric(String biometricId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Biometría'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta biometría? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      print('🗑️ Iniciando eliminación de biometría: $biometricId');

      // Primero verificar cuántas mediciones hay
      final measurementsBeforeDelete = await Supabase.instance.client
          .from('biometric_measurements')
          .select()
          .eq('biometric_id', biometricId);

      print('🗑️ Mediciones encontradas: ${measurementsBeforeDelete.length}');

      // Eliminar todas las mediciones individuales usando select() para confirmar
      final deletedMeasurements = await Supabase.instance.client
          .from('biometric_measurements')
          .delete()
          .eq('biometric_id', biometricId)
          .select();

      print('🗑️ Mediciones eliminadas: ${deletedMeasurements.length}');

      // Verificar que se eliminaron
      final measurementsAfterDelete = await Supabase.instance.client
          .from('biometric_measurements')
          .select()
          .eq('biometric_id', biometricId);

      print(
          '🗑️ Mediciones restantes después de delete: ${measurementsAfterDelete.length}');

      // Eliminar el registro de biometría usando select() para confirmar
      final deletedBiometric = await Supabase.instance.client
          .from('batch_biometrics')
          .delete()
          .eq('id', biometricId)
          .select();

      print('🗑️ Biometría eliminada: ${deletedBiometric.length} registros');

      // Verificar que se eliminó
      final biometricAfterDelete = await Supabase.instance.client
          .from('batch_biometrics')
          .select()
          .eq('id', biometricId);

      print(
          '🗑️ Biometría restante después de delete: ${biometricAfterDelete.length}');

      if (mounted) {
        if (biometricAfterDelete.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometría eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          // Refrescar la lista
          ref.invalidate(batchBiometricsProvider(widget.batchId));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Error: La biometría no se eliminó de la base de datos'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('❌ Error al eliminar biometría: $e');
      print('❌ Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final biometricsAsync = ref.watch(batchBiometricsProvider(widget.batchId));
    final batchAsync = ref.watch(batchProvider(widget.batchId));

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: batchAsync.when(
          data: (batch) => Text(
            batch.name,
            style: const TextStyle(
              color: Color(0xFF2D3250),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          loading: () => const Text('Cargando...'),
          error: (_, __) => Text('Lote ${widget.batchId}'),
        ),
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
            data: (batch) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (biometrics.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
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
                                Text(
                                  'Última medición',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(biometrics.first.measurementDate),
                                  style: const TextStyle(
                                    color: Color(0xFF2D3250),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
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
                                Text(
                                  'Promedio actual',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      biometrics.first.averageWeight
                                          .toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Color(0xFF2D3250),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'kg',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
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
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D3250).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.pets,
                                  size: 14,
                                  color: Color(0xFF2D3250),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${biometrics.first.animalCount}',
                                  style: const TextStyle(
                                    color: Color(0xFF2D3250),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
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
                                      color: Colors.grey[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.scale_outlined,
                                      size: 64,
                                      color: Colors.grey[400],
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
                                  Text(
                                    'Este lote aún no tiene biometrías.\nUsa el botón + para agregar la primera.',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: biometrics.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 32),
                            itemBuilder: (context, index) {
                              final measurement = biometrics[index];
                              final isPending = measurement.status == 'pending';
                              final isLastMeasurement = index ==
                                  0; // Las biometrías se ordenan de más reciente a más antigua
                              final isBatchActive = batch.status == 'active';

                              return _buildMeasurementTile(
                                date: _formatDate(measurement.measurementDate),
                                weight: measurement.averageWeight,
                                animalCount: measurement.animalCount,
                                note: measurement.notes ??
                                    measurement.measurementName ??
                                    'Pesaje',
                                status: measurement.status,
                                onTap: isPending
                                    ? () =>
                                        _showWeightInputModal(measurement.id)
                                    : null,
                                isLastMeasurement: isLastMeasurement,
                                isBatchActive: isBatchActive,
                                onEdit: (isLastMeasurement && isBatchActive)
                                    ? () => _editBiometric(measurement.id)
                                    : null,
                                onDelete: (isLastMeasurement && isBatchActive)
                                    ? () => _deleteBiometric(measurement.id)
                                    : null,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text('Error al cargar información del lote'),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () => _showDatePickerAndNavigate(context),
          backgroundColor: const Color(0xFFFF4D6D),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white),
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
              title: const Text('Biometría Pendiente'),
              content: Text(
                  'Ya existe una biometría pendiente del ${DateFormat('dd/MM/yyyy').format(pendingDate)}.\n\n'
                  'Debes completarla o eliminarla antes de crear una nueva.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showWeightInputModal(pendingBiometric['id']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D6D),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Completar Ahora'),
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
