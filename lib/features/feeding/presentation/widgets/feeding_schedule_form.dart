import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/feeding/domain/feeding_schedule.dart';
import 'package:porkapp/features/feeding/providers/feeding_schedule_provider.dart';

/// Muestra el bottom sheet con el formulario
void showFeedingFormBottomSheet(
  BuildContext context,
  WidgetRef ref, {
  FeedingSchedule? feedingToEdit,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: FeedingScheduleForm(
          scrollController: scrollController,
          feedingToEdit: feedingToEdit,
        ),
      ),
    ),
  );
}

/// Formulario para crear/editar registros de alimentación
class FeedingScheduleForm extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final FeedingSchedule? feedingToEdit;

  const FeedingScheduleForm({
    super.key,
    required this.scrollController,
    this.feedingToEdit,
  });

  @override
  ConsumerState<FeedingScheduleForm> createState() =>
      _FeedingScheduleFormState();
}

class _FeedingScheduleFormState extends ConsumerState<FeedingScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _daysController;
  late TextEditingController _weightController;
  late TextEditingController _dailyFeedController;
  FeedType? _selectedFeedType;
  final Set<FeedingTask> _selectedTasks = {};

  @override
  void initState() {
    super.initState();
    _daysController = TextEditingController(
      text: widget.feedingToEdit?.daysOld.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.feedingToEdit?.averageWeightKg.toString() ?? '',
    );
    _dailyFeedController = TextEditingController(
      text: widget.feedingToEdit?.dailyFeedKg.toString() ?? '',
    );
    _selectedFeedType = widget.feedingToEdit?.feedType;
    _selectedTasks.addAll(widget.feedingToEdit?.tasks ?? []);
  }

  @override
  void dispose() {
    _daysController.dispose();
    _weightController.dispose();
    _dailyFeedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle del bottom sheet
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        _buildHeader(),

        // Contenido del formulario
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                _buildAgeSection(),
                const SizedBox(height: 24),
                _buildWeightAndFeedSection(),
                const SizedBox(height: 24),
                _buildFeedTypeSection(),
                const SizedBox(height: 24),
                _buildTasksSection(),
                const SizedBox(height: 32),
                _buildActionButtons(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6B0338).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Color(0xFF6B0338),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.feedingToEdit == null
                      ? 'Nuevo Registro'
                      : 'Editar Registro',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                Text(
                  'Plan de alimentación',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Edad del Animal'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _daysController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Días de nacido',
            hintText: 'Ej: 30',
            prefixIcon:
                const Icon(Icons.calendar_today, color: Color(0xFF6B0338)),
            suffixText: 'días',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B0338), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese los días';
            }
            final days = int.tryParse(value);
            if (days == null || days <= 0) {
              return 'Debe ser un número positivo';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6B0338).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF6B0338).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: Color(0xFF6B0338), size: 20),
              const SizedBox(width: 8),
              Text(
                'Semanas: ${_calculateWeeks()}',
                style: const TextStyle(
                  color: Color(0xFF6B0338),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeightAndFeedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Peso y Alimentación'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: 'Peso promedio',
            hintText: 'Ej: 25.5',
            prefixIcon:
                const Icon(Icons.monitor_weight, color: Color(0xFF8B1548)),
            suffixText: 'kg',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B1548), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese el peso';
            }
            final weight = double.tryParse(value);
            if (weight == null || weight <= 0) {
              return 'Debe ser un número positivo';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _dailyFeedController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: 'Alimento diario',
            hintText: 'Ej: 1.5',
            prefixIcon: const Icon(Icons.restaurant, color: Color(0xFFAB2758)),
            suffixText: 'kg/día',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFAB2758), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese la cantidad';
            }
            final feed = double.tryParse(value);
            if (feed == null || feed <= 0) {
              return 'Debe ser un número positivo';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFAB2758).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFAB2758).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: Color(0xFFAB2758), size: 20),
              const SizedBox(width: 8),
              Text(
                'Alimento semanal: ${_calculateWeeklyFeed()} kg',
                style: const TextStyle(
                  color: Color(0xFFAB2758),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Tipo de Alimento'),
        const SizedBox(height: 8),
        DropdownButtonFormField<FeedType>(
          value: _selectedFeedType,
          decoration: InputDecoration(
            labelText: 'Seleccionar tipo',
            prefixIcon: const Icon(Icons.fastfood, color: Color(0xFF6B0338)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B0338), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items: [
            _buildDropdownItem(
              FeedType.preStarter,
              'Preiniciador',
              Icons.child_care,
              const Color(0xFF6B0338),
            ),
            _buildDropdownItem(
              FeedType.starter,
              'Iniciador',
              Icons.restaurant,
              const Color(0xFF8B1548),
            ),
            _buildDropdownItem(
              FeedType.grower,
              'Levante',
              Icons.trending_up,
              const Color(0xFFAB2758),
            ),
            _buildDropdownItem(
              FeedType.fattening,
              'Engorde',
              Icons.fastfood,
              const Color(0xFFF07281),
            ),
            _buildDropdownItem(
              FeedType.finisher,
              'Finalizador',
              Icons.check_circle,
              const Color(0xFFE94C5D),
            ),
          ],
          onChanged: (value) => setState(() => _selectedFeedType = value),
          validator: (value) =>
              value == null ? 'Seleccione un tipo de alimento' : null,
        ),
      ],
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Tareas Adicionales'),
        const SizedBox(height: 8),
        Text(
          'Seleccione las tareas a realizar',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('Vitaminar'),
              avatar: const Icon(Icons.medical_services, size: 18),
              selected: _selectedTasks.contains(FeedingTask.vitamin),
              selectedColor: const Color(0xFF6B0338).withOpacity(0.2),
              checkmarkColor: const Color(0xFF6B0338),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _selectedTasks.contains(FeedingTask.vitamin)
                      ? const Color(0xFF6B0338)
                      : Colors.grey[300]!,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTasks.add(FeedingTask.vitamin);
                  } else {
                    _selectedTasks.remove(FeedingTask.vitamin);
                  }
                });
              },
            ),
            FilterChip(
              label: const Text('Desparasitar'),
              avatar: const Icon(Icons.healing, size: 18),
              selected: _selectedTasks.contains(FeedingTask.deworm),
              selectedColor: const Color(0xFF8B1548).withOpacity(0.2),
              checkmarkColor: const Color(0xFF8B1548),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _selectedTasks.contains(FeedingTask.deworm)
                      ? const Color(0xFF8B1548)
                      : Colors.grey[300]!,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTasks.add(FeedingTask.deworm);
                  } else {
                    _selectedTasks.remove(FeedingTask.deworm);
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF6B0338)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Color(0xFF6B0338),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5A6E), Color(0xFFFF7F8F)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5A6E).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
    );
  }

  DropdownMenuItem<FeedType> _buildDropdownItem(
    FeedType value,
    String label,
    IconData icon,
    Color color,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  String _calculateWeeks() {
    final days = int.tryParse(_daysController.text) ?? 0;
    return (days / 7.0).toStringAsFixed(1);
  }

  String _calculateWeeklyFeed() {
    final daily = double.tryParse(_dailyFeedController.text) ?? 0;
    return (daily * 7).toStringAsFixed(2);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFeedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un tipo de alimento'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    final notifier = ref.read(feedingScheduleNotifierProvider.notifier);
    final days = int.parse(_daysController.text);
    final weight = double.parse(_weightController.text);
    final dailyFeed = double.parse(_dailyFeedController.text);

    try {
      if (widget.feedingToEdit == null) {
        await notifier.create(
          daysOld: days,
          averageWeightKg: weight,
          dailyFeedKg: dailyFeed,
          feedType: _selectedFeedType!,
          tasks: _selectedTasks.toList(),
        );
      } else {
        await notifier.update(
          id: widget.feedingToEdit!.id,
          daysOld: days,
          averageWeightKg: weight,
          dailyFeedKg: dailyFeed,
          feedType: _selectedFeedType!,
          tasks: _selectedTasks.toList(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.feedingToEdit == null
                  ? 'Registro creado exitosamente'
                  : 'Registro actualizado exitosamente',
            ),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    }
  }
}
