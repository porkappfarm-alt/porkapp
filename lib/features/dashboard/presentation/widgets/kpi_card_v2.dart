import 'package:flutter/material.dart';

/// Tarjeta de KPI mejorada con animaciones y diseño Material 3
class KpiCardV2 extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const KpiCardV2({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color = const Color(0xFF6B0338),
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: backgroundColor ?? Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icono y título
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Valor principal
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              // Subtítulo opcional
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Grid de KPIs para el dashboard
class KpiGrid extends StatelessWidget {
  final int totalAnimals;
  final String corralsStatus;
  final double avgWeight;
  final double avgADG;

  const KpiGrid({
    super.key,
    required this.totalAnimals,
    required this.corralsStatus,
    required this.avgWeight,
    required this.avgADG,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        KpiCardV2(
          title: 'Animales',
          value: '$totalAnimals',
          subtitle: 'activos',
          icon: Icons.pets,
          color: const Color(0xFF6B0338),
        ),
        KpiCardV2(
          title: 'Corrales',
          value: corralsStatus,
          subtitle: 'en uso',
          icon: Icons.home_work,
          color: const Color(0xFF8B1548),
        ),
        KpiCardV2(
          title: 'Peso Prom',
          value: '${avgWeight.toStringAsFixed(1)}',
          subtitle: 'kg actual',
          icon: Icons.monitor_weight,
          color: const Color(0xFFAB2758),
        ),
        KpiCardV2(
          title: 'ADG Prom',
          value: '${avgADG.toStringAsFixed(2)}',
          subtitle: 'kg/día',
          icon: Icons.trending_up,
          color: const Color(0xFFCB3968),
        ),
      ],
    );
  }
}
