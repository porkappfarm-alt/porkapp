import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              ref.invalidate(dashboardAlertsProvider);
              ref.invalidate(batchSummariesProvider);
            },
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeCard(),
              const SizedBox(height: 16),
              _SectionHeader(
                title: 'Alertas',
                icon: Icons.notifications_active,
              ),
              const SizedBox(height: 8),
              alertsAsync.when(
                data: (alerts) => AlertSection(alerts: alerts),
                loading: () => const _LoadingCard(),
                error: (error, stack) => _ErrorCard(
                  message: 'Error al cargar alertas',
                  error: error.toString(),
                ),
              ),
              const SizedBox(height: 16),
              _SectionHeader(
                title: 'Lotes Activos',
                icon: Icons.inventory_2,
                actionLabel: 'Ver todos',
                onActionTap: () => context.go('/batches'),
              ),
              const SizedBox(height: 8),
              batchSummariesAsync.when(
                data: (batches) {
                  if (batches.isEmpty) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No hay lotes activos',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
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
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: BatchSummaryCard(
                                batch: batch,
                                onTap: () => context.go('/batches/${batch.id}'),
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

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF6B0338),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: const Color(0xFF6B0338),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B0338),
              ),
            ),
          ],
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: Color(0xFF6B0338),
                fontWeight: FontWeight.w600,
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B0338)),
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
