import 'package:flutter/material.dart';

class BiometricHelp extends StatelessWidget {
  final String title;
  final String content;
  final Widget child;
  final bool showIcon;

  const BiometricHelp({
    super.key,
    required this.title,
    required this.content,
    required this.child,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: content,
      preferBelow: true,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          if (showIcon) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.help_outline,
              size: 16,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ],
        ],
      ),
    );
  }
}

class BiometricInfoCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onDismiss;

  const BiometricInfoCard({
    super.key,
    required this.title,
    required this.content,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (onDismiss != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onDismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
