import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import './biometric_local_models.dart';
import '../biometrics_repository.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/batch_measurement.dart';
import '../../domain/animal_measurement.dart';

final biometricSyncServiceProvider = Provider<BiometricSyncService>((ref) {
  final repository = ref.watch(biometricsRepositoryProvider);
  return BiometricSyncService(repository);
});

class BiometricSyncService {
  final BiometricsRepository _repository;
  late final Isar _isar;
  bool _initialized = false;

  BiometricSyncService(this._repository);

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final existingInstance = Isar.getInstance();
      if (existingInstance != null) {
        _isar = existingInstance;
      } else {
        _isar = await Isar.open(
          [LocalBatchMeasurementSchema, LocalAnimalMeasurementSchema],
          directory: dir.path,
          inspector: true,
        );
      }
      _initialized = true;
      print('Isar initialized successfully');
    } catch (e) {
      print('Error initializing Isar: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  Future<void> saveBatchMeasurement(LocalBatchMeasurement measurement) async {
    await _ensureInitialized();
    await _isar.writeTxn(() async {
      await _isar.localBatchMeasurements.put(measurement);
    });
  }

  Future<void> saveAnimalMeasurement(LocalAnimalMeasurement measurement) async {
    await _ensureInitialized();

    await _isar.writeTxn(() async {
      try {
        final startOfDay = DateTime(
          measurement.createdAt.year,
          measurement.createdAt.month,
          measurement.createdAt.day,
        );
        final endOfDay = startOfDay.add(const Duration(days: 1));

        // Buscar medición existente del mismo día
        final existingMeasurement = await _isar.localAnimalMeasurements
            .filter()
            .animalIdEqualTo(measurement.animalId)
            .createdAtBetween(startOfDay, endOfDay)
            .findFirst();

        // Obtener última medición para cálculos
        final lastMeasurement = await getLastMeasurement(measurement.animalId);
        if (lastMeasurement != null && lastMeasurement.id != measurement.id) {
          measurement.previousWeight = lastMeasurement.weight;
          measurement.weightGain = measurement.weight - lastMeasurement.weight;
          measurement.daysSinceLast = measurement.createdAt
              .difference(lastMeasurement.createdAt)
              .inDays;
          if (measurement.daysSinceLast! > 0) {
            measurement.adg =
                measurement.weightGain! / measurement.daysSinceLast!;
          }
        }

        if (existingMeasurement != null) {
          // Actualizar medición existente
          existingMeasurement.weight = measurement.weight;
          existingMeasurement.previousWeight = measurement.previousWeight;
          existingMeasurement.weightGain = measurement.weightGain;
          existingMeasurement.daysSinceLast = measurement.daysSinceLast;
          existingMeasurement.adg = measurement.adg;
          existingMeasurement.notes = measurement.notes;
          existingMeasurement.syncStatus = SyncStatus.pending;

          await _isar.localAnimalMeasurements.put(existingMeasurement);
        } else {
          // Asegurarse de que no haya conflictos de ID remoto
          if (measurement.remoteId != null) {
            final duplicateRemoteId = await _isar.localAnimalMeasurements
                .filter()
                .remoteIdEqualTo(measurement.remoteId)
                .findFirst();

            if (duplicateRemoteId != null) {
              measurement.remoteId = null;
            }
          }

          measurement.syncStatus = SyncStatus.pending;
          await _isar.localAnimalMeasurements.put(measurement);
        }
      } catch (e) {
        print('Error saving animal measurement: $e');
        throw Exception('Error al guardar la medición: $e');
      }
    });
  }

  Future<List<LocalBatchMeasurement>> getPendingBatchMeasurements() async {
    await _ensureInitialized();
    return _isar.localBatchMeasurements
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  Future<void> syncPendingMeasurements() async {
    final pendingBatches = await getPendingBatchMeasurements();

    for (final batch in pendingBatches) {
      try {
        if (batch.remoteId == null) {
          final remoteBatch = await _repository.createBatchMeasurement(
            BatchMeasurement(
              id: '',
              batchId: batch.batchId,
              measurementDate: batch.measurementDate,
              averageWeight: batch.averageWeight,
              animalCount: batch.animalCount,
              notes: batch.notes,
              createdBy: batch.createdBy,
              createdAt: batch.createdAt,
              updatedAt: DateTime.now(),
              status: batch.status,
            ),
          );

          batch.syncStatus = SyncStatus.synced;
          batch.remoteId = remoteBatch.id;
          await saveBatchMeasurement(batch);
        }

        final animalMeasurements = await _isar.localAnimalMeasurements
            .filter()
            .syncStatusEqualTo(SyncStatus.pending)
            .findAll();

        for (final measurement in animalMeasurements) {
          try {
            final remoteAnimalMeasurement =
                await _repository.createAnimalMeasurement(
              AnimalMeasurement(
                id: '',
                batchMeasurementId: batch.remoteId!,
                animalId: measurement.animalId,
                weight: measurement.weight,
                previousWeight: measurement.previousWeight,
                weightGain: measurement.weightGain,
                daysSinceLast: measurement.daysSinceLast,
                adg: measurement.adg,
                notes: measurement.notes,
                createdAt: measurement.createdAt,
              ),
            );

            measurement.syncStatus = SyncStatus.synced;
            measurement.remoteId = remoteAnimalMeasurement.id;
            await saveAnimalMeasurement(measurement);
          } catch (e) {
            measurement.syncStatus = SyncStatus.error;
            await saveAnimalMeasurement(measurement);
          }
        }
      } catch (e) {
        batch.syncStatus = SyncStatus.error;
        await saveBatchMeasurement(batch);
      }
    }
  }

  Future<void> clearSyncedData() async {
    await _ensureInitialized();
    await _isar.writeTxn(() async {
      await _isar.localBatchMeasurements
          .filter()
          .syncStatusEqualTo(SyncStatus.synced)
          .deleteAll();
      await _isar.localAnimalMeasurements
          .filter()
          .syncStatusEqualTo(SyncStatus.synced)
          .deleteAll();
    });
  }

  Future<LocalAnimalMeasurement?> getLastMeasurement(String animalId) async {
    await _ensureInitialized();
    return _isar.localAnimalMeasurements
        .filter()
        .animalIdEqualTo(animalId)
        .sortByCreatedAtDesc()
        .findFirst();
  }
}
