import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_providers.dart';
import 'kpi_card.dart';

class KPISection extends ConsumerWidget {
  const KPISection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corralsMetrics = ref.watch(corralMetricsProvider);
    final batchMetrics = ref.watch(batchMetricsProvider);
    final populationMetrics = ref.watch(populationMetricsProvider);
    final weightMetrics = ref.watch(weightMetricsProvider);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
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

// Widget para mostrar durante la carga
class KPICardShimmer extends StatelessWidget {
  const KPICardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 20, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Container(width: 60, height: 30, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Container(width: 80, height: 16, color: Colors.grey[300]),
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
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 32),
            SizedBox(height: 8),
            Text(
              'Error al cargar datos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
