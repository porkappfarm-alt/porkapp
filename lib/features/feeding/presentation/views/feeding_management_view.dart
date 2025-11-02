import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/feeding/domain/feeding_schedule.dart';
import 'package:porkapp/features/feeding/providers/feeding_schedule_provider.dart';
import 'package:porkapp/features/feeding/presentation/widgets/feeding_schedule_card.dart';
import 'package:porkapp/features/feeding/presentation/widgets/feeding_schedule_form.dart';

class FeedingManagementView extends ConsumerStatefulWidget {
  const FeedingManagementView({super.key});

  @override
  ConsumerState<FeedingManagementView> createState() =>
      _FeedingManagementViewState();
}

class _FeedingManagementViewState extends ConsumerState<FeedingManagementView> {
  FeedType? _filterType;

  @override
  Widget build(BuildContext context) {
    final feedingListAsync = _filterType == null
        ? ref.watch(feedingScheduleListProvider)
        : ref.watch(feedingScheduleByTypeProvider(_filterType));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tabla de Alimentación',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Filtro por tipo
          PopupMenuButton<FeedType?>(
            icon: Icon(
              Icons.filter_list,
              color: _filterType != null
                  ? const Color(0xFF6B0338)
                  : Colors.black87,
            ),
            onSelected: (value) {
              setState(() => _filterType = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Todos'),
              ),
              ...FeedType.values.map((type) => PopupMenuItem(
                    value: type,
                    child: Text(type.label),
                  )),
            ],
          ),
          // Botón agregar
          Container(
            margin: const EdgeInsets.only(right: 12, left: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5A6E), Color(0xFFFF7F8F)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => showFeedingFormBottomSheet(context, ref),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feedingScheduleListProvider);
        },
        child: feedingListAsync.when(
          data: (feedingList) {
            if (feedingList.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedingList.length,
              itemBuilder: (context, index) {
                final feeding = feedingList[index];
                return FeedingScheduleCard(
                  feeding: feeding,
                  onTap: () => showFeedingFormBottomSheet(
                    context,
                    ref,
                    feedingToEdit: feeding,
                  ),
                  onEdit: () => showFeedingFormBottomSheet(
                    context,
                    ref,
                    feedingToEdit: feeding,
                  ),
                  onDelete: () => _deleteFeeding(feeding.id),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6B0338),
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Color(0xFFE53935),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar datos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(feedingScheduleListProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B0338),
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF07281).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: 64,
              color: const Color(0xFFF07281).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay registros de alimentación',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Crea un nuevo registro para comenzar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5A6E), Color(0xFFFF7F8F)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5A6E).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => showFeedingFormBottomSheet(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Crear Registro',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFeeding(String id) async {
    final notifier = ref.read(feedingScheduleNotifierProvider.notifier);
    try {
      await notifier.delete(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro eliminado exitosamente'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: ${e.toString()}'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    }
  }
}
