import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/corrals/presentation/corral_details_view.dart';
import 'package:porkapp/features/corrals/presentation/create_corral_view.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

class CorralsView extends ConsumerWidget {
  const CorralsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corralsState = ref.watch(corralsProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Corrales',
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(corralsProvider.notifier).loadCorrals();
          },
          child: corralsState.when(
            data: (corrals) {
              // Ordenar por nombre alfabéticamente
              corrals.sort((a, b) => a.name.compareTo(b.name));
              if (corrals.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF07281).withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'imagenes/corrales-de-animales.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'No hay corrales disponibles',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5D4037),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Crea un nuevo corral para comenzar\na gestionar tus instalaciones',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
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
                                color: const Color(0xFFFF5A6E).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateCorralView(),
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
                            label: const Text(
                              'Crear corral',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: corrals.length,
                itemBuilder: (context, index) {
                  final corral = corrals[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < corrals.length - 1 ? 16.0 : 80.0,
                    ),
                    child: CorralCard(
                      corral: corral,
                      onTap: () async {
                        final corralMap = {
                          'id': corral.id,
                          'nombre': corral.name,
                          'ubicacion': corral.location ?? '',
                          'capacidad': corral.capacity ?? 0,
                          'notas': corral.notes ?? '',
                          'imagen_url': corral.imageUrl,
                          'estado': 'Activo',
                          'ocupacion': corral.activeBatchCount,
                          'creado_en': corral.createdAt.toIso8601String(),
                          'creado_por': corral.createdBy,
                          'actualizado_en':
                              corral.updatedAt.toIso8601String(),
                          // Datos del lote activo
                          'active_batch_name': corral.activeBatchName,
                          'active_batch_entry_date': corral
                              .activeBatchEntryDate
                              ?.toIso8601String(),
                          // Promedio de peso de última biometría
                          'last_biometry_avg_weight':
                              corral.lastBiometryAvgWeight ?? 0.0,
                          // NUEVO: array de lotes y id del lote activo
                          'batches': corral.batches,
                          'active_batch_id': corral.activeBatchId,
                        };

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CorralDetailsView(
                              corral: corralMap,
                            ),
                          ),
                        );
                        // Refrescar la lista cuando se vuelva de los detalles
                        // (en caso de que se haya editado o eliminado)
                        if (context.mounted) {
                          ref
                              .read(corralsProvider.notifier)
                              .loadCorrals();
                        }
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
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
                color: const Color(0xFFFF5A6E).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateCorralView(),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CorralCard extends ConsumerWidget {
  final Corral corral;
  final VoidCallback onTap;

  const CorralCard({
    super.key,
    required this.corral,
    required this.onTap,
  });

  Color _getStatusColor(CorralStatus status) {
    switch (status) {
      case CorralStatus.disponible:
        return const Color(0xFF4CAF50); // Verde Material
      case CorralStatus.ocupado:
        return const Color(0xFFF07281); // Rosa Cerdito
      case CorralStatus.mantenimiento:
        return const Color(0xFFF9C851); // Amarillo Suave
    }
  }

  String _getStatusText(CorralStatus status) {
    switch (status) {
      case CorralStatus.disponible:
        return 'Disponible';
      case CorralStatus.ocupado:
        return 'Ocupado';
      case CorralStatus.mantenimiento:
        return 'Mantenimiento';
    }
  }

  Color _getOccupancyColor(num percentage) {
    if (percentage == 0) return const Color(0xFF4CAF50); // Verde
    if (percentage < 70) return const Color(0xFF4CAF50); // Verde
    if (percentage < 90) return const Color(0xFFF9C851); // Amarillo
    return const Color(0xFFF07281); // Rosa
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  int _getDaysElapsed(DateTime entryDate) {
    return DateTime.now().difference(entryDate).inDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocupacionPorcentaje = corral.capacity != null && corral.capacity! > 0
        ? (corral.activeBatchCount.toDouble() /
            corral.capacity!.toDouble() *
            100)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      corral.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B5E55), // Gris Taupe
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(corral.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(corral.status),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Lote info (if occupied)
              if (corral.activeBatchCount > 0) ...[
                Text(
                  '${corral.activeBatchName ?? 'Sin nombre'} · ${corral.activeBatchCount} ${corral.activeBatchCount == 1 ? 'animal' : 'animales'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7B7B7B), // Gris Medio
                    fontFamily: 'Nunito Sans',
                  ),
                ),
                const SizedBox(height: 8),
                // Fecha de ingreso
                if (corral.activeBatchEntryDate != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(0xFF6B5E55),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Fecha de ingreso: ${_formatDate(corral.activeBatchEntryDate!)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7B7B7B),
                          fontFamily: 'Nunito Sans',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Días badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      border: Border.all(color: const Color(0xFFE9E9E9)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Días ${_getDaysElapsed(corral.activeBatchEntryDate!)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B5E55),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ],
              // Ubicación (si existe)
              if (corral.location != null && corral.location!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(0xFF6B5E55),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      corral.location!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7B7B7B),
                        fontFamily: 'Nunito Sans',
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              // Occupancy Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ocupación',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7B7B7B),
                      fontFamily: 'Nunito Sans',
                    ),
                  ),
                  Text(
                    '${corral.activeBatchCount}/${corral.capacity ?? "∞"}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7B7B7B),
                      fontFamily: 'Nunito Sans',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: ocupacionPorcentaje / 100,
                  backgroundColor: const Color(0xFFE9E9E9),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getOccupancyColor(ocupacionPorcentaje),
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${ocupacionPorcentaje.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getOccupancyColor(ocupacionPorcentaje),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              // Notas (if any)
              if (corral.notes != null && corral.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: const Color(0xFFE9E9E9)),
                    ),
                  ),
                  child: Text(
                    corral.notes!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF7B7B7B),
                      fontFamily: 'Nunito Sans',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
