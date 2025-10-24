import 'package:flutter_test/flutter_test.dart';
import 'package:porkapp/features/biometrics/domain/animal_measurement.dart';
import 'package:porkapp/features/biometrics/domain/batch_measurement.dart';
import 'package:porkapp/features/biometrics/domain/validation/biometric_validator.dart';

void main() {
  group('BiometricValidator', () {
    group('validateBatchMeasurement', () {
      test('should validate a valid batch measurement', () {
        final measurement = BatchMeasurement(
          id: '1',
          batchId: '1',
          measurementDate: DateTime.now(),
          averageWeight: 100.0,
          animalCount: 10,
          createdBy: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          measurements: [
            AnimalMeasurement(
              id: '1',
              batchMeasurementId: '1',
              animalId: '1',
              weight: 100.0,
              createdAt: DateTime.now(),
            ),
          ],
        );

        final result = BiometricValidator.validateBatchMeasurement(measurement);
        expect(result.isRight(), true);
      });

      test('should reject future measurement date', () {
        final measurement = BatchMeasurement(
          id: '1',
          batchId: '1',
          measurementDate: DateTime.now().add(const Duration(days: 1)),
          averageWeight: 100.0,
          animalCount: 10,
          createdBy: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          measurements: [],
        );

        final result = BiometricValidator.validateBatchMeasurement(measurement);
        expect(result.isLeft(), true);
        result.fold(
          (errors) => expect(
            errors.any((e) => e.field == 'measurementDate'),
            true,
          ),
          (_) => fail('Should have failed validation'),
        );
      });

      test('should reject invalid animal count', () {
        final measurement = BatchMeasurement(
          id: '1',
          batchId: '1',
          measurementDate: DateTime.now(),
          averageWeight: 100.0,
          animalCount: 0,
          createdBy: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          measurements: [],
        );

        final result = BiometricValidator.validateBatchMeasurement(measurement);
        expect(result.isLeft(), true);
        result.fold(
          (errors) => expect(
            errors.any((e) => e.field == 'animalCount'),
            true,
          ),
          (_) => fail('Should have failed validation'),
        );
      });

      test('should reject invalid average weight', () {
        final measurement = BatchMeasurement(
          id: '1',
          batchId: '1',
          measurementDate: DateTime.now(),
          averageWeight: 0.0,
          animalCount: 10,
          createdBy: '1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          measurements: [],
        );

        final result = BiometricValidator.validateBatchMeasurement(measurement);
        expect(result.isLeft(), true);
        result.fold(
          (errors) => expect(
            errors.any((e) => e.field == 'averageWeight'),
            true,
          ),
          (_) => fail('Should have failed validation'),
        );
      });
    });

    group('validateAnimalMeasurement', () {
      test('should validate a valid animal measurement', () {
        final measurement = AnimalMeasurement(
          id: '1',
          batchMeasurementId: '1',
          animalId: '1',
          weight: 100.0,
          createdAt: DateTime.now(),
        );

        final result =
            BiometricValidator.validateAnimalMeasurement(measurement);
        expect(result.isRight(), true);
      });

      test('should reject invalid weight', () {
        final measurement = AnimalMeasurement(
          id: '1',
          batchMeasurementId: '1',
          animalId: '1',
          weight: 0.0,
          createdAt: DateTime.now(),
        );

        final result =
            BiometricValidator.validateAnimalMeasurement(measurement);
        expect(result.isLeft(), true);
        result.fold(
          (errors) => expect(
            errors.any((e) => e.field == 'weight'),
            true,
          ),
          (_) => fail('Should have failed validation'),
        );
      });

      test('should validate weight gain calculations', () {
        final previousDate = DateTime.now().subtract(const Duration(days: 30));
        final currentDate = DateTime.now();

        final measurement = AnimalMeasurement(
          id: '1',
          batchMeasurementId: '1',
          animalId: '1',
          weight: 130.0,
          previousWeight: 100.0,
          daysSinceLast: 30,
          createdAt: currentDate,
        );

        final result =
            BiometricValidator.validateAnimalMeasurement(measurement);
        expect(result.isRight(), true);
      });

      test('should reject invalid daily gain', () {
        final measurement = AnimalMeasurement(
          id: '1',
          batchMeasurementId: '1',
          animalId: '1',
          weight: 200.0,
          previousWeight: 100.0,
          daysSinceLast: 30,
          createdAt: DateTime.now(),
        );

        final result =
            BiometricValidator.validateAnimalMeasurement(measurement);
        expect(result.isLeft(), true);
        result.fold(
          (errors) => expect(
            errors.any((e) => e.field == 'adg'),
            true,
          ),
          (_) => fail('Should have failed validation'),
        );
      });
    });
  });
}
