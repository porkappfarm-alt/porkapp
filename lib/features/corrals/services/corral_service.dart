import 'package:porkapp/features/corrals/data/corrals_repository.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

class CorralService {
  final CorralsRepository _repository;

  CorralService(this._repository);

  Future<Corral> updateCorral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
  }) async {
    try {
      // Validar datos de entrada
      if (name.trim().isEmpty) {
        throw Exception('El nombre del corral es requerido');
      }

      if (capacity != null && capacity < 0) {
        throw Exception('La capacidad no puede ser negativa');
      }

      // Obtener el corral actual
      final currentCorral = await _repository.getCorral(id);

      // Crear el objeto Corral con los nuevos datos
      final updatedCorral = Corral(
        id: currentCorral.id,
        name: name.trim(),
        location: location?.trim(),
        capacity: capacity,
        notes: notes?.trim(),
        imageUrl: currentCorral.imageUrl,
        createdAt: currentCorral.createdAt,
        createdBy: currentCorral.createdBy,
        updatedAt: DateTime.now(),
        activeBatchCount: currentCorral.activeBatchCount,
        status: currentCorral.status,
      );

      // Actualizar en el repositorio
      return await _repository.updateCorral(
        id: id,
        name: updatedCorral.name,
        location: updatedCorral.location,
        capacity: updatedCorral.capacity,
        notes: updatedCorral.notes,
      );
    } catch (e) {
      print('Error en CorralService.updateCorral: $e');
      rethrow;
    }
  }

  Future<void> deleteCorral(String id) async {
    try {
      // Validar que el corral no tenga lotes activos antes de eliminar
      final corral = await _repository.getCorral(id);

      if (corral.activeBatchCount > 0) {
        throw Exception(
            'No se puede eliminar un corral que tiene lotes activos. '
            'Por favor, mueva o finalice los lotes antes de eliminar.');
      }

      // Eliminar el corral
      await _repository.deleteCorral(id);
    } catch (e) {
      print('Error en CorralService.deleteCorral: $e');
      rethrow;
    }
  }
}
