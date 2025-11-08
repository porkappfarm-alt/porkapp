import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/batches/providers/batch_providers.dart';
import 'package:porkapp/features/batches/providers/batch_progress_provider.dart';
import 'package:porkapp/features/biometrics/providers/batch_biometrics_provider.dart';
import 'package:porkapp/features/batches/presentation/widgets/error_view.dart';

class BatchDetailView extends ConsumerWidget {
  final String batchId;

  const BatchDetailView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Detalle de Lote',
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Información del lote
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ref.watch(batchProvider(batchId)).when(
                      data: (batch) {
                        print('=== BatchDetailView main build ===');
                        print('Batch loaded: ${batch.id}');
                        print('Animals count: ${batch.animals.length}');
                        return _BatchHeader(batch: batch);
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => BatchErrorView(
                        error: error.toString(),
                        onRetry: () => ref.invalidate(batchProvider(batchId)),
                      ),
                    ),
              ),
            ),

            // Botones para gestión de animales y biometría
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Use parentNavigatorKey to ensure navigation works like biometrics
                        GoRouter.of(context).push('/batches/$batchId/animals');
                      },
                      icon: const Icon(Icons.pets, size: 20),
                      label: const Text('Gestionar animales'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF07281),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('/batches/$batchId/biometrics');
                      },
                      icon: const Icon(Icons.monitor_weight, size: 20),
                      label: const Text('Gestionar biometría'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BatchHeader extends ConsumerWidget {
  final Batch batch;

  const _BatchHeader({required this.batch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryDate = batch.entryDate ?? batch.createdAt;

    // Calcular días y semanas desde la fecha de nacimiento
    final daysElapsed = batch.birthDate != null
        ? batch.daysOld
        : DateTime.now().difference(entryDate).inDays;
    final weekElapsed =
        (daysElapsed / 7).floor(); // Usar floor para semanas completas

    final animalsMuertos =
        batch.animals.where((a) => a.status == 'deceased').length;
    final biometricsAsync = ref.watch(batchBiometricsProvider(batch.id));

    return RefreshIndicator(
      onRefresh: () async {
        // Invalidar todos los providers para refrescar los datos
        ref.invalidate(batchProvider(batch.id));
        ref.invalidate(batchBiometricsProvider(batch.id));
        ref.invalidate(batchProgressProvider(batch));
        // Esperar un momento para que se complete la recarga
        await Future.delayed(const Duration(milliseconds: 300));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre y estado
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF07281).withOpacity(0.1),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF07281),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.view_module_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            batch.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4037),
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (batch.birthDate != null) ...[
                            Text(
                              batch.ageDescription,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Nac: ${batch.birthDate!.day.toString().padLeft(2, '0')}/${batch.birthDate!.month.toString().padLeft(2, '0')}/${batch.birthDate!.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ] else
                            Text(
                              'Semana $weekElapsed • $daysElapsed días',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'ACTIVO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sección de Progreso (si hay birthDate)
              if (batch.birthDate != null) ...[
                Consumer(
                  builder: (context, ref, child) {
                    final progressAsync =
                        ref.watch(batchProgressProvider(batch));

                    return progressAsync.when(
                      data: (progress) {
                        if (progress == null) return const SizedBox.shrink();

                        // Convert hex color string to Color
                        Color getColorFromHex(String hexColor) {
                          final hex = hexColor.replaceAll('#', '');
                          return Color(int.parse('0xFF$hex'));
                        }

                        final statusColor =
                            getColorFromHex(progress.statusColor);

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título con ícono
                              Row(
                                children: [
                                  Text(
                                    progress.statusIcon,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Progreso de Crecimiento',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Badge de estado en una línea separada
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  progress.statusDescription,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Peso actual
                              Row(
                                children: [
                                  Icon(
                                    Icons.monitor_weight_outlined,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Peso actual:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${progress.currentWeight.toStringAsFixed(1)} kg',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Peso de referencia
                              Row(
                                children: [
                                  Icon(
                                    Icons.straighten,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Peso referencia:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${progress.referenceWeight.toStringAsFixed(1)} kg',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Barra de progreso
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progress.progressPercentage / 100,
                                  minHeight: 10,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Porcentaje
                              Text(
                                '${progress.progressPercentage.toStringAsFixed(1)}% del peso objetivo',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              if (progress.hasPendingTasks) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.assignment_outlined,
                                        size: 16,
                                        color: Colors.orange[700],
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Tareas programadas pendientes',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],

              // Sección de Información Principal (Peso, Alimento, Consumo)
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Información Principal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Peso Promedio
                    biometricsAsync.when(
                      data: (measurements) {
                        if (measurements.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.grey[500], size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'No hay mediciones biométricas registradas',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        // Como el query está ordenado descendente, .first es la más reciente
                        final lastMeasurement = measurements.first;

                        return _InfoCard(
                          icon: Icons.scale_rounded,
                          label:
                              'Peso Promedio (${measurements.length} mediciones)',
                          value:
                              '${lastMeasurement.averageWeight.toStringAsFixed(1)} kg',
                          color: const Color(0xFF4CAF50),
                        );
                      },
                      loading: () => Container(
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      error: (e, stack) {
                        print('❌ ERROR EN BATCH DETAIL BIOMETRICS: $e');
                        print('❌ STACK: $stack');
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.orange[700], size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No se pudieron cargar las mediciones',
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Tipo de Alimento - desde BatchProgress
                    ref.watch(batchProgressProvider(batch)).when(
                          data: (progress) {
                            if (progress == null ||
                                progress.currentFeedType == null) {
                              return _InfoCard(
                                icon: Icons.restaurant_rounded,
                                label: 'Tipo de Alimento',
                                value: 'No disponible',
                                color: Colors.grey[400]!,
                              );
                            }

                            // Convertir el tipo de alimento a un nombre legible
                            String feedTypeName =
                                _getFeedTypeName(progress.currentFeedType!);

                            return _InfoCard(
                              icon: Icons.restaurant_rounded,
                              label: 'Tipo de Alimento',
                              value: feedTypeName,
                              color: const Color(0xFF795548),
                            );
                          },
                          loading: () => _InfoCard(
                            icon: Icons.restaurant_rounded,
                            label: 'Tipo de Alimento',
                            value: 'Cargando...',
                            color: Colors.grey[400]!,
                          ),
                          error: (_, __) => _InfoCard(
                            icon: Icons.restaurant_rounded,
                            label: 'Tipo de Alimento',
                            value: 'No disponible',
                            color: Colors.grey[400]!,
                          ),
                        ),
                    const SizedBox(height: 12),

                    // Consumo Diario - desde BatchProgress
                    ref.watch(batchProgressProvider(batch)).when(
                          data: (progress) {
                            if (progress == null ||
                                progress.dailyFeedKg == null) {
                              return _InfoCard(
                                icon: Icons.inventory_rounded,
                                label: 'Consumo Diario Estimado',
                                value: 'No disponible',
                                color: Colors.grey[400]!,
                              );
                            }

                            // Calcular consumo total del lote (consumo diario por animal * cantidad de animales)
                            final animalCount = batch.animals
                                .where((a) => a.status != 'deceased')
                                .length;
                            final totalDailyFeed =
                                progress.dailyFeedKg! * animalCount;

                            return _InfoCard(
                              icon: Icons.inventory_rounded,
                              label: 'Consumo Diario Estimado',
                              value:
                                  '${totalDailyFeed.toStringAsFixed(1)} kg/día (${animalCount} animales)',
                              color: const Color(0xFF607D8B),
                            );
                          },
                          loading: () => _InfoCard(
                            icon: Icons.inventory_rounded,
                            label: 'Consumo Diario Estimado',
                            value: 'Cargando...',
                            color: Colors.grey[400]!,
                          ),
                          error: (_, __) => _InfoCard(
                            icon: Icons.inventory_rounded,
                            label: 'Consumo Diario Estimado',
                            value: 'No disponible',
                            color: Colors.grey[400]!,
                          ),
                        ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey[200]),

              // Sección de Información del Lote
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_rounded,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Detalles del Lote',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Primera fila: Animales y Fallecidos
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.group_rounded,
                            label: 'Animales Activos',
                            value:
                                '${batch.animals.length}/${batch.headcountStart}',
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.error_rounded,
                            label: 'Fallecidos',
                            value: '$animalsMuertos',
                            color: const Color(0xFFE94C5D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Segunda fila: Fecha de Nacimiento (si existe)
                    if (batch.birthDate != null) ...[
                      _InfoCard(
                        icon: Icons.cake_rounded,
                        label: 'Fecha de Nacimiento',
                        value: _formatDate(batch.birthDate!),
                        color: const Color(0xFFE91E63),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Fecha de Ingreso
                    _InfoCard(
                      icon: Icons.calendar_today_rounded,
                      label: 'Fecha de Ingreso',
                      value: _formatDate(entryDate),
                      color: const Color(0xFF2196F3),
                    ),
                    const SizedBox(height: 12),

                    // Días y Semana (calculados desde fecha de nacimiento)
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.timer_rounded,
                            label: batch.birthDate != null
                                ? 'Edad (días)'
                                : 'Días Transcurridos',
                            value: '$daysElapsed días',
                            color: const Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.event_note_rounded,
                            label: batch.birthDate != null
                                ? 'Edad (semanas)'
                                : 'Semana Actual',
                            value: 'Sem. $weekElapsed',
                            color: const Color(0xFF9C27B0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ), // Column
        ), // Container
      ), // SingleChildScrollView
    ); // RefreshIndicator
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// Widget para tarjetas de información compactas
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Convierte el tipo de alimento del código de la BD a un nombre legible
String _getFeedTypeName(String feedType) {
  switch (feedType) {
    case 'pre_starter':
      return 'Pre-Iniciador';
    case 'starter':
      return 'Iniciador';
    case 'grower':
      return 'Crecimiento';
    case 'fattening':
      return 'Engorde';
    case 'finisher':
      return 'Finalización';
    default:
      return feedType;
  }
}
