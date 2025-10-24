import 'package:porkapp/features/animals/domain/animal_status.dart';

class InvalidStateTransitionException implements Exception {
  final AnimalStatus from;
  final AnimalStatus to;
  final String message;

  InvalidStateTransitionException(this.from, this.to)
      : message =
            'No se puede cambiar el estado de ${from.toString()} a ${to.toString()}';

  @override
  String toString() => message;
}

class AnimalStateMachine {
  static final Map<AnimalStatus, Set<AnimalStatus>> _allowedTransitions = {
    AnimalStatus.active: {
      AnimalStatus.sold,
      AnimalStatus.deceased,
      AnimalStatus.removed,
    },
    AnimalStatus.sold: {}, // Estado terminal
    AnimalStatus.deceased: {}, // Estado terminal
    AnimalStatus.removed: {}, // Estado terminal
  };

  static bool canTransition(AnimalStatus from, AnimalStatus to) {
    // Si es el mismo estado, permitir
    if (from == to) return true;

    // Obtener las transiciones permitidas para el estado actual
    final allowedStates = _allowedTransitions[from] ?? {};

    // Verificar si la transición está permitida
    return allowedStates.contains(to);
  }

  static void validateTransition(AnimalStatus from, AnimalStatus to) {
    if (!canTransition(from, to)) {
      throw InvalidStateTransitionException(from, to);
    }
  }

  static String getTransitionMessage(AnimalStatus from, AnimalStatus to) {
    if (from == to) return 'No hay cambio de estado';

    return switch (to) {
      AnimalStatus.sold => 'Animal vendido',
      AnimalStatus.deceased => 'Animal fallecido',
      AnimalStatus.removed => 'Animal removido del inventario',
      AnimalStatus.active =>
        'Estado no permitido', // No se puede volver a activo
    };
  }
}
