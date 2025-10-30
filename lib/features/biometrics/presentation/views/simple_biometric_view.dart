import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/biometrics/presentation/widgets/date_picker_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _primaryPink = Color(0xFFF07281);
const _taupeText = Color(0xFF6B5E55);
const _softBackground = Color(0xFFFFFFFF);
const _instructionBackground = Color(0xFFFFF7F5);
const _neutralBorder = Color(0xFFF1EAEA);

class SimpleBiometricView extends ConsumerStatefulWidget {
  final String? batchId;

  const SimpleBiometricView({
    super.key,
    this.batchId,
  });

  @override
  ConsumerState<SimpleBiometricView> createState() =>
      _SimpleBiometricViewState();
}

class _SimpleBiometricViewState extends ConsumerState<SimpleBiometricView> {
  @override
  Widget build(BuildContext context) {
    // Asegurarnos de que la vista se monte correctamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Verificar si estamos en un estado válido
      if (ModalRoute.of(context)?.isCurrent != true) {
        context.go('/biometrics');
      }
    });

    final batchesAsync = ref.watch(activeBatchesProvider);

    return Scaffold(
      backgroundColor: _softBackground,
      appBar: StandardAppBar(
        title: 'Biometrías',
        onBackPressed: () {
          if (Navigator.of(context).canPop()) {
            context.pop();
          } else {
            context.go('/dashboard');
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona un lote para ver sus biometrías',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E3E3E),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _instructionBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFFFE3E8),
                    child: Icon(
                      Icons.analytics_outlined,
                      color: _primaryPink,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Selecciona un lote para ver sus biometrías registradas',
                      style: TextStyle(
                        fontSize: 14,
                        color: _taupeText,
                        fontFamily: 'Nunito Sans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: batchesAsync.when(
                data: (batches) {
                  if (batches.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pending_actions,
                            size: 64,
                            color: _primaryPink.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay lotes activos',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: _taupeText.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () =>
                                ref.invalidate(activeBatchesProvider),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _primaryPink,
                              side: const BorderSide(color: _primaryPink),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Actualizar'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(activeBatchesProvider);
                    },
                    child: ListView.separated(
                      itemCount: batches.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final batch = batches[index];
                        return _buildBatchCard(
                          batch.name,
                          '${batch.createdAt.year}-${batch.createdAt.month.toString().padLeft(2, '0')}-${batch.createdAt.day.toString().padLeft(2, '0')}',
                          batch.animals.length,
                          onTap: () =>
                              context.go('/biometrics/batch/${batch.id}'),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: _primaryPink,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar los lotes',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: _taupeText,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _taupeText.withOpacity(0.6),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => ref.invalidate(activeBatchesProvider),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryPink,
                          side: const BorderSide(color: _primaryPink),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchCard(String batchName, String createdDate, int animalCount,
      {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _neutralBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: _primaryPink.withOpacity(0.08),
          highlightColor: _primaryPink.withOpacity(0.04),
          child: Column(
            children: [
              Container(
                height: 8,
                decoration: const BoxDecoration(
                  color: _primaryPink,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            batchName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3E3E3E),
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4FAF6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Color(0xFF5DA271),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Activo',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5DA271),
                                  fontFamily: 'Nunito Sans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _InfoTile(
                          icon: Icons.calendar_today_outlined,
                          label: 'Fecha de creación',
                          value: createdDate,
                        ),
                        const SizedBox(width: 12),
                        _InfoTile(
                          icon: Icons.pets_outlined,
                          label: 'Total de animales',
                          value: '$animalCount animales',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFF3E6E2), width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'Ver biometrías',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _primaryPink,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: _primaryPink,
                      size: 18,
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

  Future<void> _showDatePickerAndCreateBiometric(BuildContext context, String batchId) async {
    // Importar el widget necesario
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BiometricDatePickerDialog(),
    );

    if (selectedDate == null || !mounted) return;

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
          .eq('batch_id', batchId)
          .eq('status', 'pending');

      if (pendingBiometrics.isNotEmpty) {
        if (mounted) {
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ya existe una biometría pendiente para este lote'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Crear el registro de biometría en estado "pending"
      await Supabase.instance.client.from('batch_biometrics').insert({
        'batch_id': batchId,
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
      }).select().single();

      if (mounted) {
        Navigator.of(context).pop();
        ref.invalidate(activeBatchesProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometría creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar al detalle del lote
        context.go('/biometrics/batch/$batchId');
      }
    } catch (e) {
      if (mounted) {
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

  void _showBatchSelectionDialog(BuildContext context, List batches) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Seleccionar Lote',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E3E3E),
            fontFamily: 'Poppins',
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: batches.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final batch = batches[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  _showDatePickerAndCreateBiometric(context, batch.id);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _primaryPink.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _primaryPink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.analytics_outlined,
                          color: _primaryPink,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              batch.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3E3E3E),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '${batch.animals.length} animales',
                              style: const TextStyle(
                                fontSize: 12,
                                color: _taupeText,
                                fontFamily: 'Nunito Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: _primaryPink,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: _taupeText,
            ),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: _primaryPink),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _taupeText,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3E3E3E),
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
