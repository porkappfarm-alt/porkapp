import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == navigationShell.currentIndex) {
            // Si ya estamos en la pestaña actual, no hacemos nada
            return;
          }
          navigationShell.goBranch(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work),
            label: 'Corrales',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group_work), label: 'Lotes'),
        ],
      ),
    );
  }
}
