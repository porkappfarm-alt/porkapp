import 'package:dartz/dartz.dart';
import '../animal_measurement.dart';
import '../batch_measurement.dart';

class BiometricValidationFailure {
  final String message;
  final String? field;

  const BiometricValidationFailure(this.message, {this.field});
}

class BiometricValidator {
  // Constantes para validación
  static const double minWeight = 0.1; // 100 gramos mínimo
  static const double maxWeight = 400.0; // 400 kg máximo
  static const double maxDailyGain = 2.0; // 2 kg por día máximo
  static const double minDailyGain = 0.0; // 0 kg por día mínimo
  static const double maxWeightVariation = 30.0; // 30% máximo de variación

  /// Valida una medición por lote completa
  static Either<List<BiometricValidationFailure>, Unit>
      validateBatchMeasurement(
    BatchMeasurement measurement,
  ) {
    final errors = <BiometricValidationFailure>[];

    // Validar fecha
    if (measurement.measurementDate.isAfter(DateTime.now())) {
      errors.add(
        const BiometricValidationFailure(
          'La fecha de medición no puede ser futura',
          field: 'measurementDate',
        ),
      );
    }

    // Validar cantidad de animales
    if (measurement.animalCount <= 0) {
      errors.add(
        const BiometricValidationFailure(
          'El número de animales debe ser mayor a 0',
          field: 'animalCount',
        ),
      );
    }

    // Validar peso promedio
    if (measurement.averageWeight < minWeight ||
        measurement.averageWeight > maxWeight) {
      errors.add(
        BiometricValidationFailure(
          'El peso promedio debe estar entre $minWeight y $maxWeight kg',
          field: 'averageWeight',
        ),
      );
    }

    // Validar mediciones individuales
    final measurementErrors = measurement.measurements
        .expand((m) => validateAnimalMeasurement(m).fold(
              (l) => l,
              (r) => <BiometricValidationFailure>[],
            ))
        .toList();

    errors.addAll(measurementErrors);

    // Validar coherencia entre mediciones
    if (measurement.measurements.isNotEmpty) {
      final calculatedAverage = measurement.measurements
              .map((m) => m.weight)
              .reduce((a, b) => a + b) /
          measurement.measurements.length;

      if ((calculatedAverage - measurement.averageWeight).abs() > 0.01) {
        errors.add(
          const BiometricValidationFailure(
            'El peso promedio no coincide con las mediciones individuales',
            field: 'averageWeight',
          ),
        );
      }

      if (measurement.animalCount != measurement.measurements.length) {
        errors.add(
          const BiometricValidationFailure(
            'El número de animales no coincide con las mediciones individuales',
            field: 'animalCount',
          ),
        );
      }
    }

    return errors.isEmpty ? right(unit) : left(errors);
  }

  /// Valida una medición individual
  static Either<List<BiometricValidationFailure>, Unit>
      validateAnimalMeasurement(
    AnimalMeasurement measurement,
  ) {
    final errors = <BiometricValidationFailure>[];

    // Validar peso actual
    if (measurement.weight < minWeight || measurement.weight > maxWeight) {
      errors.add(
        BiometricValidationFailure(
          'El peso debe estar entre $minWeight y $maxWeight kg',
          field: 'weight',
        ),
      );
    }

    // Validar ganancia diaria si hay peso anterior
    if (measurement.previousWeight != null &&
        measurement.daysSinceLast != null &&
        measurement.daysSinceLast! > 0) {
      final dailyGain = (measurement.weight - measurement.previousWeight!) /
          measurement.daysSinceLast!;

      if (dailyGain < minDailyGain || dailyGain > maxDailyGain) {
        errors.add(
          BiometricValidationFailure(
            'La ganancia diaria debe estar entre $minDailyGain y $maxDailyGain kg/día',
            field: 'adg',
          ),
        );
      }

      // Validar variación de peso
      final weightVariation =
          ((measurement.weight - measurement.previousWeight!) /
                  measurement.previousWeight!) *
              100;

      if (weightVariation.abs() > maxWeightVariation) {
        errors.add(
          BiometricValidationFailure(
            'La variación de peso no puede ser mayor al $maxWeightVariation%',
            field: 'weight',
          ),
        );
      }
    }

    return errors.isEmpty ? right(unit) : left(errors);
  }
}
