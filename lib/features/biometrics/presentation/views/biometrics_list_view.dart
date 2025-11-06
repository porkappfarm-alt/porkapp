import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp_new/core/design/design.dart' as design;
import 'package:porkapp_new/features/biometrics/data/providers/biometrics_providers.dart';
import 'package:porkapp_new/features/biometrics/domain/entities/batch_measurement.dart';
import 'package:porkapp_new/shared/widgets/standard_app_bar.dart';

class BiometricsListView extends ConsumerStatefulWidget {
  final String batchId;

  const BiometricsListView({
    Key? key,
    required this.batchId,
  }) : super(key: key);

  @override
  ConsumerState<BiometricsListView> createState() => _BiometricsListViewState();
}

class _BiometricsListViewState extends ConsumerState<BiometricsListView> {
  String _statusFilter = 'all';

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildBiometryCard(BatchMeasurement biometry) {
    final statusColor = _getStatusColor(biometry.status);
    final statusText = _getStatusText(biometry.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implementar navegación al detalle/edición
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(biometry.measurementDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: design.AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Peso Promedio',
                          style: TextStyle(
                            color: design.AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${biometry.averageWeight.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: design.AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Animales',
                          style: TextStyle(
                            color: design.AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${biometry.animalCount}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: design.AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF57C00);
      case 'active':
        return const Color(0xFF43A047);
      case 'cancelled':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'PENDIENTE';
      case 'active':
        return 'ACTIVA';
      case 'cancelled':
        return 'CANCELADA';
      default:
        return status.toUpperCase();
    }
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      selected: _statusFilter == value,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _statusFilter = selected ? value : 'all';
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: design.AppColors.coral.withOpacity(0.2),
      checkmarkColor: design.AppColors.coral,
      labelStyle: TextStyle(
        color: _statusFilter == value
            ? design.AppColors.coral
            : design.AppColors.textSecondary,
        fontWeight: _statusFilter == value ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biometricsAsync = ref.watch(batchBiometricsProvider(widget.batchId));

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const StandardAppBar(
        title: 'Biometrías',
      ),
      body: Column(
        children: [
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Todas', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Activas', 'active'),
                const SizedBox(width: 8),
                _buildFilterChip('Pendientes', 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Canceladas', 'cancelled'),
              ],
            ),
          ),

          // Lista de biometrías
          Expanded(
            child: biometricsAsync.when(
              data: (biometrics) {
                final filteredBiometrics = _statusFilter == 'all'
                    ? biometrics
                    : biometrics
                        .where((b) => b.status == _statusFilter)
                        .toList();

                if (filteredBiometrics.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay biometrías${_statusFilter != 'all' ? ' ' + _getStatusText(_statusFilter).toLowerCase() : ''}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(batchBiometricsProvider(widget.batchId));
                  },
                  child: ListView.builder(
                    itemCount: filteredBiometrics.length,
                    itemBuilder: (context, index) {
                      return _buildBiometryCard(filteredBiometrics[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: design.AppColors.coral,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error al cargar las biometrías',
                      style: TextStyle(
                        color: design.AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(batchBiometricsProvider(widget.batchId));
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar navegación a creación de biometría
        },
        backgroundColor: design.AppColors.coral,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}