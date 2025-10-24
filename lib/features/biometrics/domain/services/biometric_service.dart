import 'package:dartz/dartz.dart';
import '../batch_measurement.dart';
import '../animal_measurement.dart';
import '../validation/biometric_validator.dart';
import '../statistics/biometric_statistics.dart';

class BiometricService {
  /// Valida y procesa una medición por lote
  Future<Either<List<BiometricValidationFailure>, BatchMeasurement>>
      processBatchMeasurement(
    BatchMeasurement measurement,
  ) async {
    // Validar la medición
    final validationResult =
        BiometricValidator.validateBatchMeasurement(measurement);
    if (validationResult.isLeft()) {
      return validationResult.fold(
        (errors) => left(errors),
        (_) => right(measurement),
      );
    }

    // Calcular estadísticas
    final stats = BiometricStatistics.calculateBatchStats(measurement);

    // Verificar si hay valores atípicos significativos
    if (stats.coefficientOfVariation > 30) {
      return left([
        const BiometricValidationFailure(
          'Alta variabilidad en los pesos. Revise posibles errores de medición.',
          field: 'measurements',
        ),
      ]);
    }

    // Si todo está bien, retornar la medición
    return right(measurement);
  }

  /// Procesa una medición individual y calcula sus valores derivados
  AnimalMeasurement processAnimalMeasurement(
    AnimalMeasurement current,
    AnimalMeasurement? previous,
  ) {
    if (previous == null) {
      return current;
    }

    final daysBetween = current.createdAt.difference(previous.createdAt).inDays;
    final weightGain = current.weight - previous.weight;
    final adg = daysBetween > 0 ? weightGain / daysBetween : null;

    return current.copyWith(
      previousWeight: previous.weight,
      weightGain: weightGain,
      daysSinceLast: daysBetween,
      adg: adg,
    );
  }

  /// Proyecta el peso esperado para una fecha futura
  double projectWeight(
    AnimalMeasurement measurement,
    DateTime targetDate, {
    double? customAdg,
  }) {
    if (measurement.adg == null && customAdg == null) {
      throw ArgumentError(
          'Se requiere ADG actual o personalizado para la proyección');
    }

    final daysToProject = targetDate.difference(measurement.createdAt).inDays;
    final adgToUse = customAdg ?? measurement.adg!;

    return BiometricStatistics.projectFutureWeight(
      measurement.weight,
      adgToUse,
      daysToProject,
    );
  }

  /// Calcula los percentiles de peso para un grupo de mediciones
  Map<int, double> calculateGroupPercentiles(
    List<AnimalMeasurement> measurements,
  ) {
    return BiometricStatistics.calculateWeightPercentiles(
      measurements,
      [10, 25, 50, 75, 90],
    );
  }
}
