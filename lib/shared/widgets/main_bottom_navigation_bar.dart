import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavigationBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        color: colorScheme.surface.withOpacity(0.8),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItem(
                  icon: 'door_front',
                  label: 'Corrales',
                  isActive: currentIndex == 0,
                  onTap: () => context.go('/corrals'),
                ),
                _NavItem(
                  icon: 'dashboard',
                  label: 'Dashboard',
                  isActive: currentIndex == 1,
                  onTap: () => context.go('/'),
                ),
                _NavItem(
                  icon: 'inventory_2',
                  label: 'Lotes',
                  isActive: currentIndex == 2,
                  onTap: () => context.go('/batches'),
                ),
                _NavItem(
                  icon: 'monitoring',
                  label: 'Biometrías',
                  isActive: currentIndex == 3,
                  onTap: () => context.go('/biometrics'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            // Find the corresponding Material icon
            switch (icon) {
              'home' => Icons.home,
              'inventory_2' => Icons.inventory_2,
              'savings' => Icons.savings,
              'leaderboard' => Icons.leaderboard,
              'settings' => Icons.settings,
              String _ => Icons.error,
            },
            size: 24,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
