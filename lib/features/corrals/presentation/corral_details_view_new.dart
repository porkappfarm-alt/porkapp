import 'package:flutter/material.dart';

class CorralDetailsView extends StatefulWidget {
  final Map<String, dynamic> corral;
  final bool isEditing;

  const CorralDetailsView({
    super.key,
    required this.corral,
    this.isEditing = false,
  });

  @override
  State<CorralDetailsView> createState() => _CorralDetailsViewState();
}

class _CorralDetailsViewState extends State<CorralDetailsView> {
  late Map<String, dynamic> editedCorral;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    editedCorral = Map<String, dynamic>.from(widget.corral);
    isEditing = widget.isEditing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Corral ${editedCorral['nombre'] ?? 'Sin nombre'}'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            tooltip: isEditing ? 'Cancelar edición' : 'Editar corral',
            onPressed: () {
              if (isEditing) {
                // Cancelar edición
                setState(() {
                  editedCorral = Map<String, dynamic>.from(widget.corral);
                  isEditing = false;
                });
              } else {
                // Entrar en modo edición
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'Guardar cambios',
              onPressed: () {
                // TODO: Implementar guardado de cambios
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cambios guardados correctamente'),
                  ),
                );
                setState(() {
                  isEditing = false;
                });
                Navigator.pop(context, editedCorral);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatusCard(),
                  const SizedBox(height: 16),
                  _buildDetailsCard(),
                  const SizedBox(height: 16),
                  _buildOccupancyCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getStatusColor(editedCorral['estado']),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(editedCorral['estado'] ?? 'Desconocido'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Identificador',
                editedCorral['nombre'] ?? 'Sin nombre',
                isEditable: isEditing,
                onChanged: (value) =>
                    setState(() => editedCorral['nombre'] = value),
              ),
              _buildDetailRow(
                'Capacidad',
                '${editedCorral['capacidad'] ?? 0}',
                isEditable: isEditing,
                onChanged: (value) => setState(
                    () => editedCorral['capacidad'] = int.tryParse(value) ?? 0),
              ),
              _buildDetailRow(
                'Estado',
                editedCorral['estado'] ?? 'No especificado',
                isEditable: isEditing,
                onChanged: (value) =>
                    setState(() => editedCorral['estado'] = value),
              ),
              _buildDetailRow(
                'Ocupación',
                '${editedCorral['ocupacion'] ?? 0}',
                isEditable: isEditing,
                onChanged: (value) => setState(
                    () => editedCorral['ocupacion'] = int.tryParse(value) ?? 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccupancyCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ocupación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: ((editedCorral['ocupacion'] as int? ?? 0) /
                        (editedCorral['capacidad'] as int? ?? 1))
                    .clamp(0.0, 1.0),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getOccupancyColor(
                    editedCorral['ocupacion'] as int? ?? 0,
                    editedCorral['capacidad'] as int? ?? 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isEditable = false, ValueChanged<String>? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: isEditable
                ? TextFormField(
                    initialValue: value,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'mantenimiento':
        return Colors.orange;
      case 'inactivo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    if (status.isEmpty) return 'Desconocido';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  Color _getOccupancyColor(int occupancy, int capacity) {
    if (capacity <= 0) return Colors.grey;
    final ratio = occupancy / capacity;
    if (ratio < 0.7) return Colors.green;
    if (ratio < 0.9) return Colors.orange;
    return Colors.red;
  }
}
