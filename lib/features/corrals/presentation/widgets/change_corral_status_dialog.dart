import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';
import 'package:porkapp/features/corrals/presentation/widgets/corral_status_badge.dart';
import 'package:porkapp/features/corrals/providers/corral_providers.dart';

class ChangeCorralStatusDialog extends ConsumerWidget {
  final Corral corral;

  const ChangeCorralStatusDialog({
    super.key,
    required this.corral,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Cambiar estado del corral'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusOption(
            status: CorralStatus.disponible,
            currentStatus: corral.status,
            onSelected: (status) async {
              if (corral.status == CorralStatus.ocupado) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No se puede cambiar manualmente el estado a disponible cuando hay un lote activo',
                    ),
                  ),
                );
                return;
              }
              await ref
                  .read(corralsRepositoryProvider)
                  .updateCorralStatus(corral.id, status);
              if (context.mounted) {
                Navigator.of(context).pop();
                ref.invalidate(corralsProvider);
              }
            },
          ),
          const SizedBox(height: 8),
          _StatusOption(
            status: CorralStatus.mantenimiento,
            currentStatus: corral.status,
            onSelected: (status) async {
              await ref
                  .read(corralsRepositoryProvider)
                  .updateCorralStatus(corral.id, status);
              if (context.mounted) {
                Navigator.of(context).pop();
                ref.invalidate(corralsProvider);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

class _StatusOption extends StatelessWidget {
  final CorralStatus status;
  final CorralStatus currentStatus;
  final void Function(CorralStatus) onSelected;

  const _StatusOption({
    required this.status,
    required this.currentStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(status),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: status == currentStatus
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CorralStatusBadge(status: status),
            ),
            if (status == currentStatus)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
