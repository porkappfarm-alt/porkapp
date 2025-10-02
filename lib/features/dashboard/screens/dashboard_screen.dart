import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/supabase/supabase.dart';
import 'package:porkapp/shared/widgets/main_bottom_navigation_bar.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = supabase.auth.currentUser;

    // Mock data para el dashboard
    final mockStats = {
      'totalCorrales': 12,
      'totallotes': 8,
      'totalAnimales': 245,
      'pesoPromedio': 85.5,
    };

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con información del usuario
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenido',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              user?.email ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Estadísticas rápidas
              const Text(
                'Resumen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StatCard(
                    title: 'Corrales',
                    value: mockStats['totalCorrales'].toString(),
                    icon: Icons.fence,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'Lotes',
                    value: mockStats['totallotes'].toString(),
                    icon: Icons.group,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: 'Animales',
                    value: mockStats['totalAnimales'].toString(),
                    icon: Icons.pets,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: 'Peso Promedio',
                    value: '${mockStats['pesoPromedio']} kg',
                    icon: Icons.monitor_weight,
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Accesos rápidos
              const Text(
                'Accesos Rápidos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.fence, color: Colors.blue),
                      title: const Text('Gestionar Corrales'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/corrals'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.group, color: Colors.green),
                      title: const Text('Gestionar Lotes'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/batches'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.pets, color: Colors.orange),
                      title: const Text('Gestionar Animales'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/animals'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 0),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
