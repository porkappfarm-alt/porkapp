import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KPISection extends ConsumerWidget {
  const KPISection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: const [
        KPICard(
          title: 'Corrales Activos',
          icon: Icons.grid_view_rounded,
          value: '2',
          trend: '',
          trendIsPositive: true,
          details: [],
        ),
        KPICard(
          title: 'Ocupación',
          icon: Icons.bar_chart_rounded,
          value: '0.2%',
          trend: '',
          trendIsPositive: true,
          details: [],
        ),
        KPICard(
          title: 'Lotes Activos',
          icon: Icons.group_rounded,
          value: '2',
          trend: '',
          trendIsPositive: true,
          details: [],
        ),
        KPICard(
          title: 'Lotes por Terminar',
          icon: Icons.warning_amber_rounded,
          value: '2',
          trend: '',
          trendIsPositive: true,
          details: [],
        ),
        KPICard(
          title: 'Total Animales',
          icon: Icons.pets_rounded,
          value: '52',
          trend: '',
          trendIsPositive: true,
          details: [],
        ),
        KPICard(
          title: 'Entradas Hoy',
          icon: Icons.add_circle_outline_rounded,
          value: '0',
          trend: '',
          trendIsPositive: true,
          details: [],
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B0338).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: const Color(0xFF6B0338),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B6B6B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
