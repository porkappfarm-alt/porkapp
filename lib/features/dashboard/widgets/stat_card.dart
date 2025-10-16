import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatCard<T> extends StatelessWidget {
  final String title;
  final AsyncValue<T> value;
  final String Function(T) valueFormatter;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String? tooltip;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueFormatter,
    required this.icon,
    required this.color,
    this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final Widget card = Card(
      elevation: onTap != null ? 2 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return color.withOpacity(0.04);
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return color.withOpacity(0.12);
            }
            return null;
          },
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              value.when(
                data: (data) => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    valueFormatter(data),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                loading: () => SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                ),
                error: (error, _) => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Error: $error',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: color.withOpacity(0.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: card,
      );
    }

    return card;
  }
}
