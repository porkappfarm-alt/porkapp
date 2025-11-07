import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/dashboard/providers/dashboard_alerts_provider.dart';
import 'package:porkapp/features/dashboard/providers/dashboard_charts_provider.dart';
import 'package:porkapp/features/dashboard/presentation/widgets/alert_section.dart';
import 'package:porkapp/features/dashboard/presentation/widgets/batch_summary_card.dart';
import '../widgets/welcome_card.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(dashboardAlertsProvider);
    final batchSummariesAsync = ref.watch(batchSummariesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StandardAppBar(
        title: 'Dashboard',
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF07281), Color(0xFFFF9AA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF07281).withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                ref.invalidate(dashboardAlertsProvider);
                ref.invalidate(batchSummariesProvider);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardAlertsProvider);
          ref.invalidate(batchSummariesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeCard(
                onTap: () => context.go('/profile'),
              ),
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Alertas',
                icon: Icons.notifications_active,
                accentColor: const Color(0xFFF07281),
              ),
              const SizedBox(height: 10),
              alertsAsync.when(
                data: (alerts) => AlertSection(alerts: alerts),
                loading: () => const _LoadingCard(),
                error: (error, stack) => _ErrorCard(
                  message: 'Error al cargar alertas',
                  error: error.toString(),
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Lotes Activos',
                icon: Icons.inventory_2,
                accentColor: const Color(0xFFFF9AA2),
                actionLabel: 'Ver todos',
                onActionTap: () => context.go('/batches'),
              ),
              const SizedBox(height: 10),
              batchSummariesAsync.when(
                data: (batches) {
                  if (batches.isEmpty) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF07281).withOpacity(0.18),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFF07281),
                                      Color(0xFFFF9AA2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No hay lotes activos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4A3F3F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: batches
                        .map((batch) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12.0),
                              child: BatchSummaryCard(
                                batch: batch,
                                onTap: () =>
                                    context.go('/batches/${batch.id}'),
                              ),
                            ))
                        .toList(),
                  );
                },
                loading: () => const _LoadingCard(),
                error: (error, stack) => _ErrorCard(
                  message: 'Error al cargar lotes',
                  error: error.toString(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Color accentColor;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.actionLabel,
    this.onActionTap,
    this.accentColor = const Color(0xFFFF8A9D),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5D4037),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        if (actionLabel != null && onActionTap != null)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE9E9E9), // Gris Claro - Bordes/Divisores
          width: 1,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFF07281)), // Rosa Cerdito Natural
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final String error;

  const _ErrorCard({
    required this.message,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE9E9E9), // Gris Claro - Bordes/Divisores
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFE45B5B), // Rojo Suave - Error/Eliminación
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E3E3E), // Gris Oscuro - Texto Principal
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF7B7B7B), // Gris Medio - Texto Secundario
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
