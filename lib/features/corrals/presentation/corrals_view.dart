import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/corrals/presentation/corral_details_view.dart';
import 'package:porkapp/features/corrals/presentation/create_corral_view.dart';
import 'package:porkapp/features/corrals/presentation/widgets/change_corral_status_dialog.dart';
import 'package:porkapp/features/corrals/presentation/widgets/corral_status_badge.dart';
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

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 900
                            ? 4
                            : MediaQuery.of(context).size.width > 600
                                ? 3
                                : 1, // Cambiado a 1 para móviles
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: MediaQuery.of(context).size.width >
                                600
                            ? 1.3
                            : 1.6, // Reducido para hacer las tarjetas más altas en móviles
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final corral = corrals[index];

                          return CorralCard(
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
                          );
                        },
                        childCount: corrals.length,
                      ),
                    ),
                  ),
                ],
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

  Color _getOccupancyColor(BuildContext context, num percentage) {
    if (percentage >= 90) return const Color(0xFFE57373); // Rojo suave
    if (percentage >= 75) return const Color(0xFFFFB74D); // Naranja
    if (percentage >= 50) return const Color(0xFFFFF176); // Amarillo
    return const Color(0xFF4CAF50); // Verde
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

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFFF07281).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con color de fondo basado en ocupación
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: _getOccupancyColor(context, ocupacionPorcentaje)
                    .withOpacity(0.08),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.max, // Asegura que la Row ocupe todo el ancho
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2, // Da más espacio al nombre
                    child: Text(
                      corral.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4), // Reducido el espaciado
                  Flexible(
                    flex: 1, // Da menos espacio al badge
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChangeCorralStatusDialog(
                            corral: corral,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: CorralStatusBadge(status: corral.status),
                    ),
                  ),
                ],
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar información del lote activo de forma compacta
                  if (corral.activeBatchCount > 0) ...[
                    // Fecha de ingreso y días transcurridos
                    if (corral.activeBatchEntryDate != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.inventory_2_outlined,
                                        size: 14, color: Color(0xFF2D3250)),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        '${corral.activeBatchName ?? ''} • ${corral.activeBatchCount} animales',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF2D3250),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 14, color: Color(0xFF2D3250)),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Fecha de ingreso:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF2D3250),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 34),
                                  child: Text(
                                    _formatDate(corral.activeBatchEntryDate!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF2D3250),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4), // ancho aumentado
                                constraints: const BoxConstraints(
                                    minWidth:
                                        56), // ancho mínimo para 3 dígitos
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(0xFF2D3250), width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Días',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF2D3250),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${_getDaysElapsed(corral.activeBatchEntryDate!)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF2D3250),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Ocupación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ocupación',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${corral.activeBatchCount}/${corral.capacity ?? "∞"}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: ocupacionPorcentaje / 100,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getOccupancyColor(
                                      context, ocupacionPorcentaje),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${ocupacionPorcentaje.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getOccupancyColor(
                                  context, ocupacionPorcentaje),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                  // Nueva sección para mostrar capacidad y ocupación
                  if (corral.status
                      .toString()
                      .toLowerCase()
                      .contains('disponible')) ...[
                    // Ocupación y capacidad igual que ocupados
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ocupación',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${corral.activeBatchCount}/${corral.capacity ?? "∞"}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: ocupacionPorcentaje / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getOccupancyColor(
                                    context, ocupacionPorcentaje),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${ocupacionPorcentaje.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getOccupancyColor(
                                context, ocupacionPorcentaje),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
