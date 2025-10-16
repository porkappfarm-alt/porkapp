import 'package:flutter/material.dart';
import 'package:porkapp/features/corrals/presentation/edit_corral_view.dart';

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
  Map<String, dynamic> get corral => widget.corral;
  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Corral ${corral['nombre'] ?? 'Sin nombre'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar corral',
            onPressed: () {
              // Navegar a la vista de edición
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCorralView(
                    corral: corral,
                  ),
                ),
              ).then((wasUpdated) {
                if (wasUpdated == true) {
                  // Cerrar esta vista también para volver a la lista actualizada
                  Navigator.pop(context);
                }
              });
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
                  if (isEditing) ...[
                    const SizedBox(height: 24),
                    _buildEditButtons(context),
                  ],
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
                      color: _getStatusColor(corral['estado']),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(corral['estado'] ?? 'Desconocido'),
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
                  'Identificador', corral['nombre'] ?? 'Sin nombre'),
              _buildDetailRow(
                  'Capacidad', '${corral['capacidad'] ?? 0} animales'),
              _buildDetailRow('Estado', corral['estado'] ?? 'No especificado'),
              _buildDetailRow(
                'Ocupación',
                '${corral['ocupacion'] ?? 0} animales',
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
              _buildDetailRow(
                'Capacidad máxima',
                '${corral['capacidad'] ?? 0} animales',
              ),
              _buildDetailRow(
                'Ocupación actual',
                '${corral['ocupacion'] ?? 0} animales',
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: ((corral['ocupacion'] as int? ?? 0) /
                        (corral['capacidad'] as int? ?? 1))
                    .clamp(0.0, 1.0),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getOccupancyColor(
                    corral['ocupacion'] as int? ?? 0,
                    corral['capacidad'] as int? ?? 1,
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

  Widget _buildEditButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cambios guardados correctamente'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Guardar cambios'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cambios guardados correctamente'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar cambios'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ),
        ],
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Colors.green;
      case 'mantenimiento':
        return Colors.orange;
      case 'crítico':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
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
