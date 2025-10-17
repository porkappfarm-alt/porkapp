import 'package:flutter/material.dart';

class AnimalStatusChange extends StatefulWidget {
  final String currentStatus;
  final Function(String newStatus, String? notes) onStatusChanged;

  const AnimalStatusChange({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  State<AnimalStatusChange> createState() => _AnimalStatusChangeState();
}

class _AnimalStatusChangeState extends State<AnimalStatusChange> {
  final _notesController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  List<String> _getValidNextStates() {
    // Solo permitir cambios válidos desde el estado actual
    if (widget.currentStatus == 'active') {
      return ['active', 'deceased', 'sold', 'removed'];
    }
    // No permitir cambios desde estados finales
    return [widget.currentStatus];
  }

  void _showNotesDialog(String newStatus) {
    if (newStatus == widget.currentStatus) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cambio a ${_getStatusLabel(newStatus)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '¿Estás seguro de cambiar el estado a ${_getStatusLabel(newStatus)}?'),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notas (requerido)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _selectedStatus = widget.currentStatus);
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (_notesController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Las notas son requeridas')),
                );
                return;
              }
              widget.onStatusChanged(newStatus, _notesController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ).then((_) => _notesController.clear());
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'deceased':
        return 'Fallecido';
      case 'sold':
        return 'Vendido';
      case 'removed':
        return 'Removido';
      default:
        return 'Desconocido';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'deceased':
        return Colors.red;
      case 'sold':
        return Colors.blue;
      case 'removed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _getValidNextStates().map((status) {
            final isSelected = status == _selectedStatus;
            final color = _getStatusColor(status);

            return ChoiceChip(
              label: Text(_getStatusLabel(status)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _showNotesDialog(status);
                }
              },
              backgroundColor: color.withOpacity(0.1),
              selectedColor: color.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? color : color.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
