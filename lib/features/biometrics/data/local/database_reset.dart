import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

final databaseResetProvider = Provider<DatabaseReset>((ref) {
  return DatabaseReset();
});

class DatabaseReset {
  Future<void> resetDatabase() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final isar = Isar.getInstance();
      if (isar != null) {
        await isar.close(deleteFromDisk: true);
      }
      print('Database reset successful');
    } catch (e) {
      print('Error resetting database: $e');
      rethrow;
    }
  }
}
