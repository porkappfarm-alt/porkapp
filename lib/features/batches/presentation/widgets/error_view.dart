import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatchErrorView extends ConsumerWidget {
  final String error;
  final VoidCallback onRetry;

  const BatchErrorView({super.key, required this.error, required this.onRetry});

  String _getErrorMessage(String error) {
    if (error.contains('Could not find host') ||
        error.contains('<!DOCTYPE html>') ||
        error.contains('CloudflareError')) {
      return 'Error de conexión con el servidor.\nPor favor verifica tu conexión a internet y vuelve a intentarlo.';
    }

    if (error.contains('PostgrestException')) {
      return 'Error al obtener los datos del lote.\nPor favor intenta de nuevo más tarde.';
    }

    return 'Ocurrió un error inesperado.\nPor favor intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              _getErrorMessage(error),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
