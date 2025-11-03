import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/auth/providers/user_role_provider.dart';

class BottomNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoleAsync = ref.watch(userRoleProvider);
    final isAdmin = userRoleAsync.asData?.value == 'admin';

    // Construir lista de items de navegación
    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_work),
        label: 'Corrales',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.group_work),
        label: 'Lotes',
      ),
      // Perfil siempre aparece después de Lotes
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];

    // Admin aparece al final, solo para administradores
    if (isAdmin) {
      items.add(const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'Admin',
      ));
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == navigationShell.currentIndex) {
            return;
          }

          // Mapear el índice del botón al índice del branch
          // Branches en router: 0=Dashboard, 1=Corrales, 2=Lotes, 3=Profile, 4=Admin
          // Botones para no-admin: 0=Dashboard, 1=Corrales, 2=Lotes, 3=Perfil
          // Botones para admin: 0=Dashboard, 1=Corrales, 2=Lotes, 3=Perfil, 4=Admin

          int branchIndex = index;
          // El mapeo es directo porque el orden es el mismo

          navigationShell.goBranch(branchIndex);
        },
        items: items,
      ),
    );
  }
}
