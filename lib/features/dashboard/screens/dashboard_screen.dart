import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/dashboard/providers/dashboard_providers.dart';
import 'package:porkapp/features/dashboard/domain/domain.dart';
import 'package:porkapp/features/dashboard/widgets/stat_card.dart';
import 'package:porkapp/supabase/supabase.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = supabase.auth.currentUser;

    // Observar métricas
    final corralMetrics = ref.watch(corralMetricsProvider);
    final batchMetrics = ref.watch(batchMetricsProvider);
    final populationMetrics = ref.watch(populationMetricsProvider);
    final weightMetrics = ref.watch(weightMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Invalidar todos los providers para forzar una actualización
            ref.invalidate(corralMetricsProvider);
            ref.invalidate(batchMetricsProvider);
            ref.invalidate(populationMetricsProvider);
            ref.invalidate(weightMetricsProvider);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header con información del usuario
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Icon(Icons.person,
                                    color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Bienvenido',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user?.email ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Estadísticas rápidas
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Resumen',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = constraints.maxWidth;
                          final crossAxisCount = screenWidth > 1200
                              ? 4
                              : screenWidth > 600
                                  ? 3
                                  : 2;

                          return GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: screenWidth > 600 ? 1.5 : 1.2,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              // Métricas de corrales
                              _StatCard(
                                title: 'Corrales Activos',
                                value: corralMetrics,
                                valueFormatter: (CorralMetrics? m) =>
                                    m?.activeCount.toString() ?? 'N/A',
                                icon: Icons.fence,
                                color: Colors.blue,
                              ),
                              _StatCard(
                                title: 'Ocupación',
                                value: corralMetrics,
                                valueFormatter: (CorralMetrics? m) => m != null
                                    ? '${m.occupancyRate.toStringAsFixed(1)}%'
                                    : 'N/A',
                                icon: Icons.percent,
                                color: Colors.teal,
                              ),
                              // Métricas de lotes
                              _StatCard(
                                title: 'Lotes Activos',
                                value: batchMetrics,
                                valueFormatter: (BatchMetrics? m) =>
                                    m?.activeCount.toString() ?? 'N/A',
                                icon: Icons.group,
                                color: Colors.green,
                              ),
                              _StatCard(
                                title: 'Lotes por Terminar',
                                value: batchMetrics,
                                valueFormatter: (BatchMetrics? m) =>
                                    m?.endingSoon.toString() ?? 'N/A',
                                icon: Icons.timer,
                                color: Colors.amber,
                              ),
                              // Métricas de población
                              _StatCard(
                                title: 'Total Animales',
                                value: populationMetrics,
                                valueFormatter: (PopulationMetrics? m) =>
                                    m?.totalCount.toString() ?? 'N/A',
                                icon: Icons.pets,
                                color: Colors.orange,
                              ),
                              _StatCard(
                                title: 'Entradas Hoy',
                                value: populationMetrics,
                                valueFormatter: (PopulationMetrics? m) =>
                                    m?.dailyEntries.toString() ?? 'N/A',
                                icon: Icons.add_circle_outline,
                                color: Colors.green.shade700,
                              ),
                              // Métricas de peso
                              _StatCard(
                                title: 'Peso Promedio',
                                value: weightMetrics,
                                valueFormatter: (WeightMetrics? m) => m != null
                                    ? '${m.averageWeight.toStringAsFixed(1)} kg'
                                    : 'N/A',
                                icon: Icons.monitor_weight,
                                color: Colors.purple,
                              ),
                              _StatCard(
                                title: 'Ganancia Diaria',
                                value: weightMetrics,
                                valueFormatter: (WeightMetrics? m) => m != null
                                    ? '${m.dailyGain.toStringAsFixed(2)} kg/d'
                                    : 'N/A',
                                icon: Icons.trending_up,
                                color: Colors.indigo,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard<T> extends StatelessWidget {
  final String title;
  final AsyncValue<T> value;
  final String Function(T) valueFormatter;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.valueFormatter,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(height: 4),
                    Flexible(
                      child: value.when(
                        data: (data) => Text(
                          valueFormatter(data),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        loading: () => SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color,
                          ),
                        ),
                        error: (error, _) => Text(
                          'Error',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.red,
                                  ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 12,
                            ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
