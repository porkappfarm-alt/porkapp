import 'package:flutter/material.dart';
import 'package:porkapp/features/animals/domain/animal_status.dart';
import 'package:porkapp/features/animals/domain/animal_state_machine.dart';

class AnimalStatusChangeDialog extends StatelessWidget {
  final AnimalStatus currentStatus;
  final Function(AnimalStatus) onStatusChanged;

  const AnimalStatusChangeDialog({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar Estado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: AnimalStatus.values
            .where((status) =>
                status != currentStatus &&
                AnimalStateMachine.canTransition(currentStatus, status))
            .map((status) => ListTile(
                  title: Text(_getStatusText(status)),
                  leading: Icon(
                    _getStatusIcon(status),
                    color: _getStatusColor(status),
                  ),
                  onTap: () {
                    onStatusChanged(status);
                    Navigator.of(context).pop();
                  },
                ))
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  String _getStatusText(AnimalStatus status) {
    return switch (status) {
      AnimalStatus.active => 'Activo',
      AnimalStatus.sold => 'Vendido',
      AnimalStatus.deceased => 'Fallecido',
      AnimalStatus.removed => 'Removido',
    };
  }

  Color _getStatusColor(AnimalStatus status) {
    return switch (status) {
      AnimalStatus.active => Colors.green,
      AnimalStatus.sold => Colors.blue,
      AnimalStatus.deceased => Colors.red,
      AnimalStatus.removed => Colors.orange,
    };
  }

  IconData _getStatusIcon(AnimalStatus status) {
    return switch (status) {
      AnimalStatus.active => Icons.check_circle,
      AnimalStatus.sold => Icons.monetization_on,
      AnimalStatus.deceased => Icons.warning,
      AnimalStatus.removed => Icons.remove_circle,
    };
  }
}

class AnimalStatusBadge extends StatelessWidget {
  final AnimalStatus status;

  const AnimalStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 16,
            color: _getStatusColor(status),
          ),
          const SizedBox(width: 8),
          Text(
            _getStatusText(status),
            style: TextStyle(
              color: _getStatusColor(status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(AnimalStatus status) {
    return switch (status) {
      AnimalStatus.active => 'Activo',
      AnimalStatus.sold => 'Vendido',
      AnimalStatus.deceased => 'Fallecido',
      AnimalStatus.removed => 'Removido',
    };
  }

  Color _getStatusColor(AnimalStatus status) {
    return switch (status) {
      AnimalStatus.active => Colors.green,
      AnimalStatus.sold => Colors.blue,
      AnimalStatus.deceased => Colors.red,
      AnimalStatus.removed => Colors.orange,
    };
  }

  IconData _getStatusIcon(AnimalStatus status) {
    return switch (status) {
      AnimalStatus.active => Icons.check_circle,
      AnimalStatus.sold => Icons.monetization_on,
      AnimalStatus.deceased => Icons.warning,
      AnimalStatus.removed => Icons.remove_circle,
    };
  }
}
