import 'package:porkapp/features/biometrics/data/animal_events_data_source.dart';
import 'package:porkapp/features/biometrics/domain/biometric_stats.dart';

class AnimalEventsRepository {
  final AnimalEventsDataSource _dataSource;

  AnimalEventsRepository(this._dataSource);

  Future<BiometricStats> getBatchStats(String batchId) async {
    // Obtener datos
    final weightTimeline = await _dataSource.getWeightTimeline(batchId);
    final feedData = await _dataSource.getFeedDataByBatch(batchId);
    final mortalityByCause = await _dataSource.getMortalityByBatch(batchId);

    // Validar ADG
    double adg = 0;
    if (weightTimeline.length >= 2) {
      final firstWeight = weightTimeline.first;
      final lastWeight = weightTimeline.last;
      final days = lastWeight.date.difference(firstWeight.date).inDays;
      if (days > 0) {
        adg = (lastWeight.avgWeight - firstWeight.avgWeight) / days;
      }
    } else {
      throw Exception('Se necesitan al menos 2 pesajes para calcular ADG');
    }

    // Validar FCR
    double fcr = 0;
    if (feedData.isNotEmpty) {
      final totalFeed = feedData.fold(0.0, (sum, feed) => sum + feed.amount);
      if (weightTimeline.length >= 2) {
        final weightGain =
            weightTimeline.last.avgWeight - weightTimeline.first.avgWeight;
        if (weightGain > 0) {
          fcr = totalFeed / weightGain;
        }
      }
    } else {
      throw Exception(
        'Se necesitan registros de alimentación para calcular FCR',
      );
    }

    // Calcular mortalidad
    final totalDeaths = mortalityByCause.fold(
      0,
      (sum, cause) => sum + cause.count,
    );
    final initialHeadcount = 100; // TODO: Obtener del lote
    final mortalityRate = (totalDeaths / initialHeadcount) * 100;

    return BiometricStats(
      adg: adg,
      fcr: fcr,
      mortalityRate: mortalityRate,
      mortalityByCause: mortalityByCause,
      weightTimeline: weightTimeline,
    );
  }
}
