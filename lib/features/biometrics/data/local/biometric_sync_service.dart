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

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [LocalBatchMeasurementSchema, LocalAnimalMeasurementSchema],
      directory: dir.path,
    );
    _initialized = true;
  }

  Future<void> saveBatchMeasurement(LocalBatchMeasurement measurement) async {
    await _isar.writeTxn(() async {
      await _isar.localBatchMeasurements.put(measurement);
    });
  }

  Future<void> saveAnimalMeasurement(LocalAnimalMeasurement measurement) async {
    await _isar.writeTxn(() async {
      await _isar.localAnimalMeasurements.put(measurement);
    });
  }

  Future<List<LocalBatchMeasurement>> getPendingBatchMeasurements() async {
    return _isar.localBatchMeasurements
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();
  }

  Future<void> syncPendingMeasurements() async {
    final pendingBatches = await getPendingBatchMeasurements();

    for (final batch in pendingBatches) {
      try {
        // Solo crear si no tiene ID remoto (es nuevo)
        if (batch.remoteId == null) {
          final remoteBatch = await _repository.createBatchMeasurement(
            BatchMeasurement(
              id: '', // Se generará en el servidor
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

          // Actualizar estado local
          batch.syncStatus = SyncStatus.synced;
          batch.remoteId = remoteBatch.id;
          await saveBatchMeasurement(batch);
        }

        // Sincronizar mediciones de animales asociadas
        final animalMeasurements = await _isar.localAnimalMeasurements
            .filter()
            .syncStatusEqualTo(SyncStatus.pending)
            .findAll();
        for (final measurement in animalMeasurements) {
          if (measurement.syncStatus == SyncStatus.pending) {
            try {
              final remoteAnimalMeasurement =
                  await _repository.createAnimalMeasurement(
                AnimalMeasurement(
                  id: '',
                  batchMeasurementId: batch.remoteId!, // Ya debe existir
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
        }
      } catch (e) {
        batch.syncStatus = SyncStatus.error;
        await saveBatchMeasurement(batch);
      }
    }
  }

  Future<void> clearSyncedData() async {
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
}
