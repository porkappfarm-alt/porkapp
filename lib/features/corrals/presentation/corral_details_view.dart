import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/corrals/presentation/edit_corral_view.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';
import 'package:porkapp/features/corrals/providers/corral_edit_provider_new.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/batches/domain/batch.dart';

class CorralDetailsView extends ConsumerStatefulWidget {
  final Map<String, dynamic> corral;
  final bool isEditing;

  const CorralDetailsView({
    super.key,
    required this.corral,
    this.isEditing = false,
  });

  @override
  ConsumerState<CorralDetailsView> createState() => _CorralDetailsViewState();
}

class _CorralDetailsViewState extends ConsumerState<CorralDetailsView> {
  Map<String, dynamic> get corral => widget.corral;
  bool get isEditing => widget.isEditing;

  Future<void> _editCorral() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCorralView(corral: corral),
      ),
    );

    // Si la edición fue exitosa, refrescar la lista de corrales y cerrar los detalles
    if (result == true && mounted) {
      // Recargar la lista de corrales
      ref.read(corralsProvider.notifier).loadCorrals();
      // Invalidar el provider del corral editado para que otras vistas (como lote) se actualicen
      final corralId = corral['id']?.toString();
      if (corralId != null && corralId.isNotEmpty) {
        ref.invalidate(corralByIdProvider(corralId));
      }
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Corral actualizado exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Cerrar la pantalla de detalles para que el usuario vea la lista actualizada
      Navigator.pop(context);
    }
  }

  Future<void> _deleteCorral() async {
    if (!mounted) return;

    final nombreCorral = corral['nombre'] ?? 'Sin nombre';

    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro que desea eliminar el corral "$nombreCorral"?\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    // Mostrar indicador de carga
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16),
            Text('Eliminando corral...'),
          ],
        ),
        duration: Duration(minutes: 1),
      ),
    );

    try {
      // Ejecutar la eliminación
      await ref
          .read(corralEditProvider.notifier)
          .deleteCorral(corral['id'].toString());

      if (!mounted) return;

      // Recargar la lista de corrales
      ref.read(corralsProvider.notifier).loadCorrals();

      // Limpiar indicadores y mostrar mensaje de éxito
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Corral "$nombreCorral" eliminado exitosamente'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Cerrar la pantalla de detalles
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      // Limpiar el indicador de carga
      ScaffoldMessenger.of(context).clearSnackBars();

      // Detectar si el error es por lotes asociados
      final errorMessage = error.toString().toLowerCase();
      final hasRelatedBatches = errorMessage.contains('batch') ||
          errorMessage.contains('lote') ||
          errorMessage.contains('foreign key') ||
          errorMessage.contains('constraint') ||
          errorMessage.contains('referenced');

      if (hasRelatedBatches) {
        // Error específico por lotes asociados
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No se puede eliminar el corral',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Este corral tiene o ha tenido lotes asociados. No es posible eliminarlo para mantener el historial de datos.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFD32F2F),
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        // Error genérico
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Error al eliminar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFD32F2F),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Detalle de Corral',
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildCorralHeaderCard(),
                  const SizedBox(height: 16),
                  _buildActiveBatchCard(),
                  // const SizedBox(height: 16),
                  // _buildOccupancyCard(),
                  if (isEditing) ...[
                    const SizedBox(height: 24),
                    _buildEditButtons(context),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorralHeaderCard() {
    final nombre = corral['nombre'] ?? 'Sin nombre';
    final estado = corral['estado'] ?? 'Desconocido';
    final capacidad = corral['capacidad'] ?? 0;
    final ocupacion = corral['ocupacion'] ?? 0;
    final percentage =
        capacidad > 0 ? ((ocupacion / capacidad) * 100).round() : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getBackgroundColorByStatus(estado),
            _getBackgroundColorByStatus(estado).withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getBorderColorByStatus(estado),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF07281).withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con ícono y nombre
          Row(
            children: [
              // Ícono cerdito circular con gradiente
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFF5F5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF07281).withOpacity(0.3),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF07281).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🐷',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B5E55), // Gris Taupe
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: 'Editar corral',
                icon: const Icon(Icons.edit, color: Color(0xFFF07281), size: 20),
                onPressed: _editCorral,
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Badges de estado
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4CAF50),
                      Color(0xFF66BB6A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Activo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFC1CC),
                      const Color(0xFFFFD6DD),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF07281).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '🏠 $capacidad capacidad',
                  style: const TextStyle(
                    color: Color(0xFFD81B60),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Texto de ocupación
          Row(
            children: [
              Icon(
                Icons.pets_rounded,
                size: 16,
                color: Color(0xFF6B5E55),
              ),
              const SizedBox(width: 6),
              Text(
                'Ocupación: $ocupacion / $capacidad animales',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7B7B7B),
                  fontFamily: 'Nunito Sans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$percentage% de capacidad utilizada',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7B7B7B),
              fontFamily: 'Nunito Sans',
            ),
          ),
          const SizedBox(height: 12),
          // Barra de progreso con gradiente
          Container(
            height: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFE9E9E9),
                  ),
                  FractionallySizedBox(
                    widthFactor: capacidad > 0 ? (ocupacion / capacidad).clamp(0.0, 1.0) : 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getProgressGradient(percentage),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getProgressColor(percentage).withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(int percentage) {
    if (percentage == 0) return const Color(0xFF4CAF50);
    if (percentage < 70) return const Color(0xFF4CAF50);
    if (percentage < 90) return const Color(0xFFF9C851);
    return const Color(0xFFF07281);
  }

  List<Color> _getProgressGradient(int percentage) {
    if (percentage == 0) return [const Color(0xFF66BB6A), const Color(0xFF4CAF50)];
    if (percentage < 70) return [const Color(0xFF66BB6A), const Color(0xFF4CAF50)];
    if (percentage < 90) return [const Color(0xFFFFD54F), const Color(0xFFF9C851)];
    return [const Color(0xFFFF6B7A), const Color(0xFFF07281)];
  }

  Color _getBackgroundColorByStatus(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('activo')) {
      return const Color(0xFFFFF7F3); // Fondo verde claro
    } else if (statusLower.contains('ocupado')) {
      return const Color(0xFFFFF5F5); // Fondo rosa claro
    } else if (statusLower.contains('mantenimiento')) {
      return const Color(0xFFFFFBE6); // Fondo amarillo claro
    }
    return const Color(0xFFFFF5EC); // Default crema pastel
  }

  Color _getBorderColorByStatus(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('activo')) {
      return const Color(0xFF5DA271); // Borde verde
    } else if (statusLower.contains('ocupado')) {
      return const Color(0xFFF07281); // Borde rosa
    } else if (statusLower.contains('mantenimiento')) {
      return const Color(0xFFF9C851); // Borde amarillo
    }
    return const Color(0xFFF07281).withOpacity(0.2); // Default
  }

  Widget _buildActiveBatchCard() {
    final batchName = corral['active_batch_name'];
    final entryDate = corral['active_batch_entry_date'];
    final avgWeight = corral['last_biometry_avg_weight'];
    final ocupacion = corral['ocupacion'];

    // Si no hay lote asociado, mostrar mensaje informativo
    final hasActiveBatch =
        batchName != null && batchName.toString().trim().isNotEmpty;

    if (!hasActiveBatch) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: Color(0xFFF57C00),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sin lote asociado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF57C00),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Este corral no tiene ningún lote asignado actualmente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6D4C41),
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFFFAFA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF07281).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF07281).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: Color(0xFFF07281),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lote: ${batchName ?? "Sin nombre"}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B5E55),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              if (batchName != null && batchName.toString().trim().isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    color: Color(0xFFF07281),
                    size: 18,
                  ),
                  tooltip: 'Ver detalle de lote',
                  padding: const EdgeInsets.all(4),
                  onPressed: () {
                    final batches = corral['batches'];
                    final batchId = corral['active_batch_id'] ??
                        corral['batch_id'] ??
                        corral['id_lote'];
                    print('[DEBUG] batchId: $batchId');
                    print('[DEBUG] batches: $batches');
                    print('[DEBUG] batches type: ${batches.runtimeType}');

                    dynamic batch;
                    if (batches != null && batches is List && batchId != null) {
                      // Verificar si batches es una lista de objetos Batch o de Maps
                      if (batches.isNotEmpty) {
                        final firstElement = batches.first;
                        print(
                            '[DEBUG] First batch type: ${firstElement.runtimeType}');

                        try {
                          batch = batches.firstWhere(
                            (b) {
                              // Si b es un objeto Batch, usar b.id
                              if (b is Batch) {
                                return b.id == batchId;
                              }
                              // Si b es un Map, usar b['id']
                              return b['id'] == batchId ||
                                  b['id_lote'] == batchId;
                            },
                          );
                        } catch (e) {
                          print(
                              '[DEBUG] No se encontró el batch con id: $batchId');
                          batch = null;
                        }
                      }
                      print('[DEBUG] batch encontrado: $batch');
                    }

                    if (batch != null && batch is Batch) {
                      print(
                          '[DEBUG] Navegando con GoRouter a /batches/${batch.id}');
                      context.push('/batches/${batch.id}');
                    } else {
                      print('[DEBUG] No se encontró información del lote');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No se encontró información del lote.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Fecha de ingreso
          if (entryDate != null)
            _buildInfoRow(
              icon: Icons.calendar_today,
              iconColor: const Color(0xFF4CAF50),
              backgroundColor: const Color(0xFFF0F9F4),
              label: 'Fecha de ingreso',
              value: entryDate.toString().substring(0, 10),
            ),
          if (entryDate != null && ocupacion != null) const SizedBox(height: 12),
          // Animales vivos
          if (ocupacion != null)
            _buildInfoRow(
              icon: Icons.pets_rounded,
              iconColor: const Color(0xFF6B5E55),
              backgroundColor: const Color(0xFFFFF5EC),
              label: 'Animales vivos',
              value: '$ocupacion',
            ),
          if (ocupacion != null && avgWeight != null) const SizedBox(height: 12),
          // Promedio de peso
          if (avgWeight != null)
            _buildInfoRow(
              icon: Icons.monitor_weight_outlined,
              iconColor: const Color(0xFFF07281),
              backgroundColor: const Color(0xFFFFF0F2),
              label: 'Promedio de peso',
              value: '${avgWeight.toStringAsFixed(2)} kg',
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                backgroundColor,
                backgroundColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B7B7B),
                  fontFamily: 'Nunito Sans',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B5E55),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cambios guardados correctamente'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Guardar cambios'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cambios guardados correctamente'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar cambios'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ),
        ],
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'activo':
        return const Color(0xFF1A8754);
      case 'mantenimiento':
        return const Color(0xFFF59E0B);
      case 'crítico':
      case 'inactivo':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  bool _canDeleteCorral() {
    // Verificar si el corral ha tenido algún lote asociado (activo, inactivo o cerrado)
    // Un corral solo se puede eliminar si NUNCA ha tenido lotes

    // Verificar si hay información de lote activo
    final activeBatchName = corral['active_batch_name'];
    if (activeBatchName != null &&
        activeBatchName.toString().trim().isNotEmpty) {
      return false; // Tiene lote activo
    }

    // Verificar si hay un array de batches (histórico)
    final batches = corral['batches'];
    if (batches != null && batches is List && batches.isNotEmpty) {
      return false; // Ha tenido lotes en algún momento
    }

    // Verificar el campo batch directamente
    final batch = corral['batch'];
    if (batch != null) {
      return false; // Tiene referencia a un lote
    }

    // Si llegamos aquí, el corral nunca ha tenido lotes asociados
    return true;
  }
}
