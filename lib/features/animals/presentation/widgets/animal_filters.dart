import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimalFilters extends ConsumerStatefulWidget {
  final Function(String) onSearch;
  final Function(String?) onStatusFilter;
  final Function(DateTimeRange?) onDateFilter;

  const AnimalFilters({
    super.key,
    required this.onSearch,
    required this.onStatusFilter,
    required this.onDateFilter,
  });

  @override
  ConsumerState<AnimalFilters> createState() => _AnimalFiltersState();
}

class _AnimalFiltersState extends ConsumerState<AnimalFilters> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  DateTimeRange? _selectedDateRange;

  final List<DropdownMenuItem<String>> _statusItems = const [
    DropdownMenuItem(value: null, child: Text('Todos')),
    DropdownMenuItem(value: 'active', child: Text('Activos')),
    DropdownMenuItem(value: 'sold', child: Text('Vendidos')),
    DropdownMenuItem(value: 'deceased', child: Text('Fallecidos')),
    DropdownMenuItem(value: 'removed', child: Text('Retirados')),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showDateRangePicker() async {
    final initialDateRange =
        _selectedDateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 30)),
          end: DateTime.now(),
        );

    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() => _selectedDateRange = pickedRange);
      widget.onDateFilter(pickedRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por ID o notas...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearch('');
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: widget.onSearch,
          ),
          const SizedBox(height: 16),
          // Filtros
          Row(
            children: [
              // Filtro por estado
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  items: _statusItems,
                  onChanged: (value) {
                    setState(() => _selectedStatus = value);
                    widget.onStatusFilter(value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Filtro por fecha
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showDateRangePicker,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDateRange != null
                        ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                        : 'Seleccionar fechas',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
