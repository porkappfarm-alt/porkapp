import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/dashboard/providers/dashboard_providers.dart';
import 'package:porkapp/features/dashboard/domain/domain.dart';
import 'package:porkapp/features/dashboard/widgets/stat_card.dart';
import 'package:porkapp/features/auth/providers/current_user_provider.dart';
import 'package:porkapp/shared/design/colors.dart';
import 'package:porkapp/supabase/supabase.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar el usuario actual a través del provider
    final user = ref.watch(currentUserProvider);

    // Observar métricas
    final corralMetrics = ref.watch(corralMetricsProvider);
    final batchMetrics = ref.watch(batchMetricsProvider);
    final populationMetrics = ref.watch(populationMetricsProvider);
    final weightMetrics = ref.watch(weightMetricsProvider);

    return Scaffold(
      backgroundColor: PorkAppColors.background,
      appBar: StandardAppBar(
        title: 'Dashboard',
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(Icons.logout_rounded, color: PorkAppColors.titleText),
              tooltip: 'Cerrar sesión',
              onPressed: () async {
                await supabase.auth.signOut();
              },
            ),
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
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: PorkAppColors.gradientPrimary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [PorkAppColors.primaryShadow],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Bienvenido',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.email ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                      const SizedBox(height: 20),

                      // Estadísticas rápidas
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Resumen',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: PorkAppColors.titleText,
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
                                color: PorkAppColors.secondary,
                              ),
                              _StatCard(
                                title: 'Ocupación',
                                value: corralMetrics,
                                valueFormatter: (CorralMetrics? m) => m != null
                                    ? '${m.occupancyRate.toStringAsFixed(1)}%'
                                    : 'N/A',
                                icon: Icons.percent,
                                color: PorkAppColors.primary,
                              ),
                              // Métricas de lotes
                              _StatCard(
                                title: 'Lotes Activos',
                                value: batchMetrics,
                                valueFormatter: (BatchMetrics? m) =>
                                    m?.activeCount.toString() ?? 'N/A',
                                icon: Icons.group,
                                color: PorkAppColors.success,
                              ),
                              _StatCard(
                                title: 'Lotes por Terminar',
                                value: batchMetrics,
                                valueFormatter: (BatchMetrics? m) =>
                                    m?.endingSoon.toString() ?? 'N/A',
                                icon: Icons.timer,
                                color: PorkAppColors.warning,
                              ),
                              // Métricas de población
                              _StatCard(
                                title: 'Total Animales',
                                value: populationMetrics,
                                valueFormatter: (PopulationMetrics? m) =>
                                    m?.totalCount.toString() ?? 'N/A',
                                icon: Icons.pets,
                                color: const Color(
                                    0xFFF07281), // Rosa Cerdito Natural - Primario
                              ),
                              _StatCard(
                                title: 'Entradas Hoy',
                                value: populationMetrics,
                                valueFormatter: (PopulationMetrics? m) =>
                                    m?.dailyEntries.toString() ?? 'N/A',
                                icon: Icons.add_circle_outline,
                                color: const Color(
                                    0xFF5DA271), // Verde Agro - Secundario
                              ),
                              // Métricas de peso
                              _StatCard(
                                title: 'Peso Promedio',
                                value: weightMetrics,
                                valueFormatter: (WeightMetrics? m) => m != null
                                    ? '${m.averageWeight.toStringAsFixed(1)} kg'
                                    : 'N/A',
                                icon: Icons.monitor_weight,
                                color: const Color(
                                    0xFF6B5E55), // Gris Taupe Moderno - Complementario
                              ),
                              _StatCard(
                                title: 'Ganancia Diaria',
                                value: weightMetrics,
                                valueFormatter: (WeightMetrics? m) => m != null
                                    ? '${m.dailyGain.toStringAsFixed(2)} kg/d'
                                    : 'N/A',
                                icon: Icons.trending_up,
                                color: const Color(
                                    0xFF8BC34A), // Verde Claro - Éxito/Activo
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
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: value.when(
                        data: (data) => Text(
                          valueFormatter(data),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: const Color(0xFF5D4037),
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
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
