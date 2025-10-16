import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/biometrics_provider.dart';
import 'package:porkapp/features/biometrics/domain/biometric_stats.dart';
import 'package:porkapp/shared/design/theme.dart';
import 'package:porkapp/shared/widgets/animated_counter.dart';

class BiometricsView extends ConsumerWidget {
  final String batchId;

  const BiometricsView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricsAsync = ref.watch(biometricsProvider(batchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometrías del Lote'),
        elevation: 0,
      ),
      body: biometricsAsync.when(
        data: (stats) => BiometricsContent(stats: stats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar las biometrías',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendPositive;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shadowColor: color.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.only(right: 16, bottom: 4),
        child: Container(
          width: 200,
          height: 160, // Altura fija para evitar overflow
          padding: const EdgeInsets.all(12), // Reducido de 16 a 12
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Usar el mínimo espacio necesario
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6), // Reducido de 8 a 6
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(10), // Reducido de 12 a 10
                    ),
                    child: Icon(icon,
                        color: color, size: 18), // Reducido de 20 a 18
                  ),
                  const SizedBox(width: 8), // Reducido de 12 a 8
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Reducido de 16 a 12
              AnimatedCounter(
                value: value,
                textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                unit: unit,
              ),
              const Spacer(), // Usar Spacer en lugar de SizedBox con altura fija
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, // Reducido de 10 a 8
                  vertical: 4, // Reducido de 6 a 4
                ),
                decoration: BoxDecoration(
                  color: (trendPositive ? AppColors.success : AppColors.danger)
                      .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(10), // Reducido de 12 a 10
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color:
                          trendPositive ? AppColors.success : AppColors.danger,
                      size: 14, // Reducido de 16 a 14
                    ),
                    const SizedBox(width: 4), // Reducido de 6 a 4
                    Flexible(
                      child: Text(
                        trend,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: trendPositive
                                  ? AppColors.success
                                  : AppColors.danger,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
}

class BiometricsContent extends StatelessWidget {
  final BiometricStats stats;

  const BiometricsContent({super.key, required this.stats});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKPIRow(stats),
          const SizedBox(height: 24),
          _buildWeightChart(context, stats.weightTimeline),
          const SizedBox(height: 24),
          _buildMortalityChart(context, stats.mortalityByCause),
          const SizedBox(height: 24),
          _buildDetailsExpansion(context, stats),
          const SizedBox(height: 16), // Espacio adicional al final
        ],
      ),
    );
  }

  Widget _buildKPIRow(BiometricStats stats) {
    return SizedBox(
      height: 170, // Aumentado de 140 a 170 para evitar overflow
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _MetricCard(
            title: 'Ganancia Diaria',
            value: stats.adg,
            unit: 'kg/día',
            icon: Icons.trending_up,
            color: AppColors.success,
            trend: stats.adg > 0.8 ? 'Óptima' : 'Por mejorar',
            trendPositive: stats.adg > 0.8,
          ),
          _MetricCard(
            title: 'Conversión',
            value: stats.fcr,
            unit: 'kg/kg',
            icon: Icons.balance,
            color: AppColors.warning,
            trend: stats.fcr < 3.0 ? 'Eficiente' : 'Ineficiente',
            trendPositive: stats.fcr < 3.0,
          ),
          _MetricCard(
            title: 'Mortalidad',
            value: stats.mortalityRate,
            unit: '%',
            icon: Icons.warning_amber,
            color: AppColors.danger,
            trend: stats.mortalityRate < 3.0 ? 'Normal' : 'Alta',
            trendPositive: stats.mortalityRate < 3.0,
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart(
      BuildContext context, List<WeightPoint> weightTimeline) {
    if (weightTimeline.isEmpty) {
      return Card(
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.scale, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No hay datos de peso disponibles',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Calcular el peso mínimo y máximo para mejorar la visualización
    final minWeight = weightTimeline
        .map((point) => point.avgWeight)
        .reduce((a, b) => a < b ? a : b);
    final maxWeight = weightTimeline
        .map((point) => point.avgWeight)
        .reduce((a, b) => a > b ? a : b);

    // Calcular el intervalo para las líneas horizontales
    final range = maxWeight - minWeight;
    final interval = range > 50 ? 20.0 : (range > 20 ? 10.0 : 5.0);

    // Ajustar los límites para que haya espacio en el gráfico
    final minY = (minWeight - interval).clamp(0.0, double.infinity);
    final maxY = maxWeight + interval;

    return Card(
      elevation: 3,
      shadowColor: AppColors.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.monitor_weight_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Evolución del Peso',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {
                    // TODO: Implementar vista detallada
                    _showFullScreenChart(context, weightTimeline);
                  },
                  tooltip: 'Ver en pantalla completa',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < weightTimeline.length) {
                            final date = weightTimeline[value.toInt()].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.day}/${date.month}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text(
                        'Peso (kg)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()} kg',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  minY: minY,
                  maxY: maxY,
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightTimeline.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.avgWeight,
                        );
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.7),
                          AppColors.primary,
                        ],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: AppColors.primary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withOpacity(0.3),
                            AppColors.primary.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBorder: BorderSide.none,
                      // tooltipBgColor: AppColors.primary.withOpacity(0.8), // Deprecated in fl_chart 0.69.2
                      tooltipPadding: const EdgeInsets.all(10),
                      tooltipMargin: 8,
                      // tooltipRoundedRadius: 8, // Deprecated in fl_chart 0.69.2
                      maxContentWidth: 200,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final date =
                              weightTimeline[touchedSpot.x.toInt()].date;
                          return LineTooltipItem(
                            '${touchedSpot.y.toStringAsFixed(1)} kg\n${_formatDate(date)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Leyenda o información adicional
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Peso promedio (kg)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenChart(
      BuildContext context, List<WeightPoint> weightTimeline) {
    // Calcular el peso mínimo y máximo para mejorar la visualización
    final minWeight = weightTimeline
        .map((point) => point.avgWeight)
        .reduce((a, b) => a < b ? a : b);
    final maxWeight = weightTimeline
        .map((point) => point.avgWeight)
        .reduce((a, b) => a > b ? a : b);

    // Calcular el intervalo para las líneas horizontales
    final range = maxWeight - minWeight;
    final interval = range > 50 ? 20.0 : (range > 20 ? 10.0 : 5.0);

    // Ajustar los límites para que haya espacio en el gráfico
    final minY = (minWeight - interval).clamp(0.0, double.infinity);
    final maxY = maxWeight + interval;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.monitor_weight_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Evolución del Peso',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Fecha',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < weightTimeline.length) {
                              final date = weightTimeline[value.toInt()].date;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${date.day}/${date.month}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Peso (kg)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: interval,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()} kg',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    minY: minY,
                    maxY: maxY,
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: weightTimeline.asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            entry.value.avgWeight,
                          );
                        }).toList(),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.7),
                            AppColors.primary,
                          ],
                        ),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: AppColors.primary,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withOpacity(0.3),
                              AppColors.primary.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBorder: BorderSide.none,
                        // tooltipBgColor: AppColors.primary.withOpacity(0.8), // Deprecated in fl_chart 0.69.2
                        tooltipPadding: const EdgeInsets.all(10),
                        tooltipMargin: 8,
                        // tooltipRoundedRadius: 8, // Deprecated in fl_chart 0.69.2
                        maxContentWidth: 200,
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            final date =
                                weightTimeline[touchedSpot.x.toInt()].date;
                            return LineTooltipItem(
                              '${touchedSpot.y.toStringAsFixed(1)} kg\n${_formatDate(date)}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      handleBuiltInTouches: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Información adicional o estadísticas
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estadísticas',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Peso inicial',
                          '${weightTimeline.first.avgWeight.toStringAsFixed(1)} kg',
                          Icons.arrow_circle_down_outlined,
                        ),
                        _buildStatItem(
                          'Peso final',
                          '${weightTimeline.last.avgWeight.toStringAsFixed(1)} kg',
                          Icons.arrow_circle_up_outlined,
                        ),
                        _buildStatItem(
                          'Ganancia',
                          '${(weightTimeline.last.avgWeight - weightTimeline.first.avgWeight).toStringAsFixed(1)} kg',
                          Icons.trending_up,
                        ),
                      ],
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

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMortalityChart(
      BuildContext context, List<MortalityByCause> mortalityByCause) {
    if (mortalityByCause.isEmpty) {
      return Card(
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bar_chart, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No hay datos de mortalidad disponibles',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Calcular el valor máximo para ajustar la escala
    final maxValue = mortalityByCause
        .map((m) => m.count.toDouble())
        .reduce((a, b) => a > b ? a : b);
    final interval = maxValue > 20 ? 5.0 : (maxValue > 10 ? 2.0 : 1.0);

    return Card(
      elevation: 3,
      shadowColor: AppColors.danger.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.danger.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.warning_amber_outlined,
                        color: AppColors.danger,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Mortalidad por Causa',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {
                    // Calcular el total de mortalidad
                    final totalMortality = mortalityByCause.fold(
                        0, (sum, item) => sum + item.count);

                    // Encontrar la causa principal
                    final principalCause = mortalityByCause
                        .reduce((a, b) => a.count > b.count ? a : b);

                    showDialog(
                      context: context,
                      builder: (context) => Dialog.fullscreen(
                        child: Scaffold(
                          appBar: AppBar(
                            title: const Text('Mortalidad por Causa'),
                            leading: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          body: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Estadísticas resumen
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildStatColumn(
                                          'Mortalidad Total',
                                          '$totalMortality animales',
                                          Icons.warning_amber_outlined,
                                          AppColors.danger,
                                        ),
                                        _buildStatColumn(
                                          'Causa Principal',
                                          principalCause.cause,
                                          Icons.priority_high_outlined,
                                          Colors.orange,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Gráfico ampliado
                                Expanded(
                                  child: _buildMortalityChart(
                                      context, mortalityByCause),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  tooltip: 'Ver en pantalla completa',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: maxValue * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBorder: BorderSide.none,
                      // tooltipBgColor: AppColors.danger.withOpacity(0.8), // Deprecated in fl_chart 0.69.2
                      tooltipPadding: const EdgeInsets.all(10),
                      tooltipMargin: 8,
                      // tooltipRoundedRadius: 8, // Deprecated in fl_chart 0.69.2
                      maxContentWidth: 200,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${mortalityByCause[group.x].cause}\n${rod.toY.toInt()} muertes',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          'Causas',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < mortalityByCause.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  mortalityByCause[value.toInt()].cause,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text(
                        'Cantidad',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  barGroups: mortalityByCause.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.count.toDouble(),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.danger.withOpacity(0.7),
                              AppColors.danger,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxValue * 1.2,
                            color: Colors.grey[200],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.danger.withOpacity(0.7),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Muertes',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailsExpansion(BuildContext context, BiometricStats stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Detalles'),
          childrenPadding: const EdgeInsets.all(16.0),
          children: [
            _buildDetailRow(
              context,
              'Total de pesajes',
              '${stats.weightTimeline.length}',
              Icons.scale,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              'Primer pesaje',
              _formatDate(stats.weightTimeline.first.date),
              Icons.calendar_today,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              'Último pesaje',
              _formatDate(stats.weightTimeline.last.date),
              Icons.event,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              'Total muertes',
              stats.mortalityByCause
                  .fold<int>(0, (sum, cause) => sum + cause.count)
                  .toString(),
              Icons.warning,
            ),
          ],
        ),
      ),
    );
  }
}
