import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KPISection extends ConsumerWidget {
  const KPISection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: const [
        KPICard(
          title: 'Corrales Activos',
          icon: Icons.business,
          value: '8',
          trend: '+2',
          trendIsPositive: true,
          details: ['Ocupación: 85%', 'vs Mes anterior: +15%'],
        ),
        KPICard(
          title: 'Lotes en Producción',
          icon: Icons.inventory_2,
          value: '5',
          trend: '2 próximos',
          trendIsPositive: true,
          details: ['Estado: Normal', 'Finalización próxima: 2'],
        ),
        KPICard(
          title: 'Población Animal',
          icon: Icons.pets,
          value: '250',
          trend: '+10',
          trendIsPositive: true,
          details: ['Altas hoy: 10', 'Bajas hoy: 0'],
        ),
        KPICard(
          title: 'Peso Promedio',
          icon: Icons.monitor_weight,
          value: '75.5 kg',
          trend: '+2.3 kg',
          trendIsPositive: true,
          details: ['ADG: 0.85 kg/día', 'Tendencia: Positiva'],
        ),
      ],
    );
  }
}

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
                  Text(
                    widget.trend,
                    style: TextStyle(
                      color: widget.trendIsPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ...widget.details.map(
                (detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    detail,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
