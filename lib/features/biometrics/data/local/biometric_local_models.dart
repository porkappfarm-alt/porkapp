import 'package:isar/isar.dart';

part 'biometric_local_models.g.dart';

@Name('BiometricSyncStatus')
enum SyncStatus { synced, pending, error }

@Collection()
class LocalBatchMeasurement {
  Id id = Isar.autoIncrement;
  String? remoteId;

  @Index(type: IndexType.hash)
  late String batchId;

  late DateTime measurementDate;
  late double averageWeight;
  late int animalCount;
  String? notes;
  late String createdBy;
  late DateTime createdAt;
  late DateTime updatedAt;

  @Enumerated(EnumType.name)
  late SyncStatus syncStatus;
  late String status;
}

@Collection()
class LocalAnimalMeasurement {
  Id id = Isar.autoIncrement;
  String? remoteId;

  @Index(type: IndexType.hash)
  late String animalId;

  late String batchMeasurementId;
  late double weight;
  double? previousWeight;
  double? weightGain;
  int? daysSinceLast;
  double? adg;
  String? notes;
  late DateTime createdAt;

  @Enumerated(EnumType.name)
  late SyncStatus syncStatus;
}
