import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'biometric_local_models.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

final databaseCleanupProvider = Provider<DatabaseCleanup>((ref) {
  return DatabaseCleanup();
});

class DatabaseCleanup {
  Future<void> cleanDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = Isar.getInstance();

    if (isar != null) {
      await isar.close(deleteFromDisk: true);
    }

    await Isar.open(
      [LocalBatchMeasurementSchema, LocalAnimalMeasurementSchema],
      directory: dir.path,
      inspector: true,
    );
  }
}
