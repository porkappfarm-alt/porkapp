import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: const Color(0xFF5D4037),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalle de Corral',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF5D4037),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/3800591.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '$nombre',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3250),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Editar corral',
                    icon: const Icon(Icons.edit, color: Color(0xFF6B0338)),
                    onPressed: _editCorral,
                  ),
                  if (_canDeleteCorral())
                    IconButton(
                      tooltip: 'Eliminar corral',
                      icon: const Icon(Icons.delete_outline,
                          color: Color(0xFFB71C1C)),
                      onPressed: _deleteCorral,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: _buildStatusChip(
                  icon: Icons.circle,
                  label: _getStatusText(estado),
                  backgroundColor: _getStatusColor(estado).withAlpha(38),
                  foregroundColor: _getStatusColor(estado),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: _buildStatusChip(
                  icon: Icons.groups_outlined,
                  label: '$capacidad capacidad',
                  backgroundColor: const Color(0xFFFFE5EC),
                  foregroundColor: const Color(0xFFFF4D6D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.pets_rounded,
                  size: 18, color: Color(0xFF6B0338)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ocupación: $ocupacion / $capacidad animales',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('$percentage% de capacidad utilizada',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value:
                  capacidad > 0 ? (ocupacion / capacidad).clamp(0.0, 1.0) : 0.0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B0338)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBatchCard() {
    final batchName = corral['active_batch_name'];
    final entryDate = corral['active_batch_entry_date'];
    final avgWeight = corral['last_biometry_avg_weight'];
    final ocupacion = corral['ocupacion'];

    // Si no hay lote asociado, mostrar mensaje informativo
    // Verificamos si batchName es null o si es una cadena vacía
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B0338).withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    color: Color(0xFF6B0338), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Lote: ${batchName ?? "Sin nombre"}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B0338)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (batchName != null && batchName.toString().trim().isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded,
                      color: Color(0xFF6B0338)),
                  tooltip: 'Ver detalle de lote',
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
          if (entryDate != null)
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 18, color: Color(0xFF6B0338)),
                const SizedBox(width: 8),
                Text(
                    'Fecha de ingreso: ${entryDate.toString().substring(0, 10)}',
                    style: const TextStyle(fontSize: 15)),
              ],
            ),
          if (ocupacion != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.pets_rounded,
                      size: 18, color: Color(0xFF6B0338)),
                  const SizedBox(width: 8),
                  Text('Animales vivos: $ocupacion',
                      style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          if (avgWeight != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.monitor_weight_outlined,
                      size: 18, color: Color(0xFF6B0338)),
                  const SizedBox(width: 8),
                  Text('Promedio de peso: ${avgWeight.toStringAsFixed(2)} kg',
                      style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
        ],
      ),
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
