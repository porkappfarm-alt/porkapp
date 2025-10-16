import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../domain/biometric_stats.dart';

part 'biometrics_cache.g.dart';

class CachedBiometricStats extends Table {
  TextColumn get batchId => text()();
  RealColumn get adg => real()();
  RealColumn get fcr => real()();
  RealColumn get mortalityRate => real()();
  TextColumn get rawData => text()(); // JSON string
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {batchId};
}

@DriftDatabase(tables: [CachedBiometricStats])
class BiometricsCache extends _$BiometricsCache {
  BiometricsCache() : super(_openConnection());

  Future<void> saveBiometricStats(String batchId, BiometricStats stats) async {
    await into(cachedBiometricStats).insertOnConflictUpdate(
      CachedBiometricStatsCompanion.insert(
        batchId: batchId,
        adg: stats.adg,
        fcr: stats.fcr,
        mortalityRate: stats.mortalityRate,
        rawData: stats.toJson().toString(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<BiometricStats?> getBiometricStats(String batchId) async {
    final result = await (select(
      cachedBiometricStats,
    )..where((t) => t.batchId.equals(batchId))).getSingleOrNull();

    if (result == null) return null;

    // TODO: Implementar deserialización del JSON
    return null;
  }

  Future<void> clearOldCache() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    await (delete(
      cachedBiometricStats,
    )..where((t) => t.updatedAt.isSmallerThanValue(thirtyDaysAgo))).go();
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'biometrics.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
