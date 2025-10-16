import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

// Widget principal que muestra la sección de KPIs
class KPISection extends ConsumerWidget {
  const KPISection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corralsMetrics = ref.watch(corralMetricsProvider);
    final batchMetrics = ref.watch(batchMetricsProvider);
    final populationMetrics = ref.watch(populationMetricsProvider);
    final weightMetrics = ref.watch(weightMetricsProvider);

    // Usar MediaQuery para obtener el ancho de la pantalla
    final width = MediaQuery.of(context).size.width;
    final itemWidth =
        (width - 44) / 2; // 44 = padding horizontal (16 * 2) + spacing (12)

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.1, // Proporción más compacta
      padding: EdgeInsets.zero,
      children: [
        // Corrales Activos
        corralsMetrics.when(
          data: (data) => KPICard(
            title: 'Corrales Activos',
            icon: Icons.business,
            value: data.activeCount.toString(),
            trend: '\${data.monthlyChange.toStringAsFixed(1)}%',
            trendIsPositive: data.monthlyChange >= 0,
            details: [
              'Ocupación: \${data.occupancyRate.toStringAsFixed(1)}%',
              'vs Mes anterior: \${data.monthlyChange >= 0 ? ' ' : '
                      '}\${data.monthlyChange.toStringAsFixed(1)}%',
            ],
          ),
          loading: () => const KPICardShimmer(),
          error: (_, __) => const KPICardError(),
        ),

        // Lotes en Producción
        batchMetrics.when(
          data: (data) => KPICard(
            title: 'Lotes en Producción',
            icon: Icons.inventory_2,
            value: data.activeCount.toString(),
            trend: '\${data.endingSoon} próximos',
            trendIsPositive: true,
            details: [
              'Estado: \${data.generalStatus}',
              'Finalización próxima: \${data.endingSoon}',
            ],
          ),
          loading: () => const KPICardShimmer(),
          error: (_, __) => const KPICardError(),
        ),

        // Población Animal
        populationMetrics.when(
          data: (data) => KPICard(
            title: 'Población Animal',
            icon: Icons.pets,
            value: data.totalCount.toString(),
            trend: '+\${data.dailyEntries - data.dailyExits}',
            trendIsPositive: data.dailyEntries >= data.dailyExits,
            details: [
              'Altas hoy: \${data.dailyEntries}',
              'Bajas hoy: \${data.dailyExits}',
            ],
          ),
          loading: () => const KPICardShimmer(),
          error: (_, __) => const KPICardError(),
        ),

        // Métricas de Peso
        weightMetrics.when(
          data: (data) => KPICard(
            title: 'Peso Promedio',
            icon: Icons.monitor_weight,
            value: '\${data.averageWeight.toStringAsFixed(1)} kg',
            trend:
                '\${data.dailyGain >= 0 ? ' ' : '
                    '}\${data.dailyGain.toStringAsFixed(2)} kg/día',
            trendIsPositive: data.weeklyTrend == 'Positiva',
            details: [
              'ADG: \${data.dailyGain.toStringAsFixed(2)} kg/día',
              'Tendencia: \${data.weeklyTrend}',
            ],
          ),
          loading: () => const KPICardShimmer(),
          error: (_, __) => const KPICardError(),
        ),
      ],
    );
  }
}

// Widget para mostrar una tarjeta de KPI individual
class KPICard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String value;
  final String trend;
  final bool trendIsPositive;
  final List<String> details;

  const KPICard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.trend,
    required this.trendIsPositive,
    required this.details,
  });

  @override
  State<KPICard> createState() => _KPICardState();
}

class _KPICardState extends State<KPICard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    widget.trendIsPositive
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 16,
                    color: widget.trendIsPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      widget.trend,
                      style: TextStyle(
                        color: widget.trendIsPositive
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.details
                      .map(
                        (detail) => Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            detail,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontSize: 11, height: 1.1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para mostrar durante la carga
class KPICardShimmer extends StatelessWidget {
  const KPICardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 16, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Container(width: 60, height: 24, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Container(width: 80, height: 12, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar en caso de error
class KPICardError extends StatelessWidget {
  const KPICardError({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            SizedBox(height: 8),
            Text(
              'Error al cargar datos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
