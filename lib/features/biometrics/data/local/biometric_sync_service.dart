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
          inspector: true, // Habilitar el inspector para debug
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
        // Normalizar la fecha al inicio del día
        final startOfDay = DateTime(
          measurement.createdAt.year,
          measurement.createdAt.month,
          measurement.createdAt.day,
        );
        final endOfDay = startOfDay.add(const Duration(days: 1));

        // Primero, limpiar cualquier medición anterior que pueda causar conflictos
        final conflictingMeasurements = await _isar.localAnimalMeasurements
            .filter()
            .remoteIdIsNotNull()
            .remoteIdEqualTo(measurement.remoteId ?? '')
            .findAll();

        for (final conflicting in conflictingMeasurements) {
          await _isar.localAnimalMeasurements.delete(conflicting.id);
        }

        // Obtener la última medición del animal para cálculos
        final lastMeasurement = await getLastMeasurement(measurement.animalId);

        // Establecer el peso anterior y calcular la ganancia
        if (lastMeasurement != null) {
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

        // Buscar si ya existe una medición para el mismo día y animal
        final existingMeasurement = await _isar.localAnimalMeasurements
            .filter()
            .animalIdEqualTo(measurement.animalId)
            .createdAtBetween(startOfDay, endOfDay)
            .findFirst();

        if (existingMeasurement != null) {
          // Actualizar medición existente
          existingMeasurement
            ..weight = measurement.weight
            ..notes = measurement.notes
            ..previousWeight = measurement.previousWeight
            ..weightGain = measurement.weightGain
            ..daysSinceLast = measurement.daysSinceLast
            ..adg = measurement.adg
            ..syncStatus = SyncStatus.pending;

          // Si ya tiene un remoteId, mantenerlo
          if (measurement.remoteId != null) {
            existingMeasurement.remoteId = measurement.remoteId;
          }

          await _isar.localAnimalMeasurements.put(existingMeasurement);
          return;
        }

        // Si es una nueva medición, verificar duplicación de remoteId
        if (measurement.remoteId != null) {
          final duplicateRemoteId = await _isar.localAnimalMeasurements
              .filter()
              .remoteIdEqualTo(measurement.remoteId)
              .findFirst();

          if (duplicateRemoteId != null) {
            // Si encontramos un duplicado, crear una nueva medición sin remoteId
            measurement.remoteId = null;
            measurement.syncStatus = SyncStatus.pending;
          }
        }

        // Insertar la nueva medición
        measurement.syncStatus = SyncStatus.pending;
        await _isar.localAnimalMeasurements.put(measurement);
      } catch (e) {
        print('Error saving animal measurement: $e');
        if (e.toString().contains('Unique index violation')) {
          throw Exception(
              'Ya existe una medición para este animal en esta fecha. Por favor actualice la medición existente.');
        }
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

  Future<double?> calculateADG(String animalId, double currentWeight,
      double? previousWeight, DateTime currentDate) async {
    if (previousWeight == null) return null;

    final lastMeasurement = await getLastMeasurement(animalId);
    if (lastMeasurement == null) return null;

    final daysDifference =
        currentDate.difference(lastMeasurement.createdAt).inDays;
    if (daysDifference == 0) return 0;

    final weightGain = currentWeight - previousWeight;
    return weightGain / daysDifference;
  }
}
