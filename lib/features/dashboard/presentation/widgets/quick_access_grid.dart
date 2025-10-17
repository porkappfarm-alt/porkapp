import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        QuickAccessCard(
          icon: Icons.business,
          title: 'Corrales',
          subtitle: 'Gestión de espacios',
          onTap: () => context.go('/corrals'),
          color: Colors.blue,
        ),
        QuickAccessCard(
          icon: Icons.inventory_2,
          title: 'Lotes',
          subtitle: 'Control de producción',
          onTap: () => context.go('/batches'),
          color: Colors.orange,
        ),
        QuickAccessCard(
          icon: Icons.pets,
          title: 'Animales',
          subtitle: 'Ver por lotes',
          onTap: () => context.go('/batches'),
          color: Colors.green,
        ),
        QuickAccessCard(
          icon: Icons.analytics,
          title: 'Biometría',
          subtitle: 'Análisis y métricas',
          onTap: () => context.go('/biometrics'),
          color: Colors.purple,
        ),
        QuickAccessCard(
          icon: Icons.event_note,
          title: 'Eventos',
          subtitle: 'Registro rápido',
          onTap: () => context.go('/events'),
          color: Colors.red,
        ),
        QuickAccessCard(
          icon: Icons.bar_chart,
          title: 'Reportes',
          subtitle: 'Informes del día',
          onTap: () => context.go('/reports'),
          color: Colors.teal,
        ),
      ],
    );
  }
}

class QuickAccessCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const QuickAccessCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  State<QuickAccessCard> createState() => _QuickAccessCardState();
}

class _QuickAccessCardState extends State<QuickAccessCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.color, widget.color.withOpacity(0.8)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, size: 32, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
