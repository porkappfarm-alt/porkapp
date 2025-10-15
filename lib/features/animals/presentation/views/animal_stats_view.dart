import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';

class AnimalStatsView extends ConsumerWidget {
  final List<Animal> animals;

  const AnimalStatsView({super.key, required this.animals});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Calcular estadísticas
    final totalAnimals = animals.length;
    final activeAnimals = animals.where((a) => a.status == 'active').length;
    final soldAnimals = animals.where((a) => a.status == 'sold').length;
    final deceasedAnimals = animals.where((a) => a.status == 'deceased').length;
    final removedAnimals = animals.where((a) => a.status == 'removed').length;

    final avgWeight = animals.isEmpty
        ? 0.0
        : animals.map((a) => a.weight ?? 0.0).reduce((a, b) => a + b) / animals.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen del Lote', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          // Indicadores principales
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total de Animales',
                  value: totalAnimals.toString(),
                  icon: Icons.pets,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Peso Promedio',
                  value: '${avgWeight.toStringAsFixed(1)} kg',
                  icon: Icons.scale,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Estado de los Animales', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          // Estadísticas por estado
          Column(
            children: [
              _StatusBar(
                label: 'Activos',
                value: activeAnimals,
                total: totalAnimals,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              _StatusBar(
                label: 'Vendidos',
                value: soldAnimals,
                total: totalAnimals,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              _StatusBar(
                label: 'Fallecidos',
                value: deceasedAnimals,
                total: totalAnimals,
                color: Colors.red,
              ),
              const SizedBox(height: 8),
              _StatusBar(
                label: 'Retirados',
                value: removedAnimals,
                total: totalAnimals,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _StatusBar({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : (value / total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '$value (${(percentage * 100).toStringAsFixed(1)}%)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          color: color,
          backgroundColor: color.withOpacity(0.1),
        ),
      ],
    );
  }
}
