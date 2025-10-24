import 'package:flutter/material.dart';

enum BiometricFeedbackType {
  success,
  error,
  warning,
  info,
}

class BiometricFeedback extends StatelessWidget {
  final String message;
  final BiometricFeedbackType type;
  final VoidCallback? onAction;
  final String? actionLabel;

  const BiometricFeedback({
    super.key,
    required this.message,
    this.type = BiometricFeedbackType.info,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: _getBorderColor(context),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _getIcon(),
              color: _getIconColor(context),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getTextColor(context),
                    ),
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(width: 12.0),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _getActionColor(context),
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (type) {
      case BiometricFeedbackType.success:
        return Colors.green.withOpacity(0.1);
      case BiometricFeedbackType.error:
        return Colors.red.withOpacity(0.1);
      case BiometricFeedbackType.warning:
        return Colors.orange.withOpacity(0.1);
      case BiometricFeedbackType.info:
        return Colors.blue.withOpacity(0.1);
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (type) {
      case BiometricFeedbackType.success:
        return Colors.green.withOpacity(0.3);
      case BiometricFeedbackType.error:
        return Colors.red.withOpacity(0.3);
      case BiometricFeedbackType.warning:
        return Colors.orange.withOpacity(0.3);
      case BiometricFeedbackType.info:
        return Colors.blue.withOpacity(0.3);
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (type) {
      case BiometricFeedbackType.success:
        return Colors.green;
      case BiometricFeedbackType.error:
        return Colors.red;
      case BiometricFeedbackType.warning:
        return Colors.orange;
      case BiometricFeedbackType.info:
        return Colors.blue;
    }
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
  }

  Color _getActionColor(BuildContext context) {
    switch (type) {
      case BiometricFeedbackType.success:
        return Colors.green;
      case BiometricFeedbackType.error:
        return Colors.red;
      case BiometricFeedbackType.warning:
        return Colors.orange;
      case BiometricFeedbackType.info:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case BiometricFeedbackType.success:
        return Icons.check_circle_outline;
      case BiometricFeedbackType.error:
        return Icons.error_outline;
      case BiometricFeedbackType.warning:
        return Icons.warning_amber_outlined;
      case BiometricFeedbackType.info:
        return Icons.info_outline;
    }
  }
}
