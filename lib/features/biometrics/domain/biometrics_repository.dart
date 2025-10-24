import '../data/biometrics_data_source.dart';
import '../domain/models/biometric_stats.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/batch_measurement.dart';

final biometricsRepositoryProvider = Provider<BiometricsRepository>((ref) {
  final dataSource = ref.watch(biometricsDataSourceProvider);
  return BiometricsRepository(dataSource);
});

class BiometricsRepository {
  final BiometricsDataSource _dataSource;

  BiometricsRepository(this._dataSource);

  Future<List<BatchMeasurement>> getBatchMeasurements({String? batchId}) async {
    final measurements = await _dataSource.getPesajesByBatch(batchId ?? '');
    return measurements.map((m) => BatchMeasurement.fromJson(m)).toList();
  }

  Future<void> saveBatchMeasurement(BatchMeasurement measurement) async {
    await _dataSource.savePesaje(measurement.toJson());
  }

  Future<BiometricStats> getBatchBiometrics(String batchId) async {
    final pesajes = await _dataSource.getPesajesByBatch(batchId);
    final alimentacion = await _dataSource.getAlimentacionByBatch(batchId);
    final mortalidad = await _dataSource.getMortalidadByBatch(batchId);

    // Calcular promedio de ganancia diaria (ADG)
    final weightTimeline = _calculateWeightTimeline(pesajes);
    final adg = _calculateADG(weightTimeline);

    // Calcular tasa de conversión alimenticia (FCR)
    final fcr = _calculateFCR(alimentacion, weightTimeline);

    // Calcular tasa de mortalidad y mortalidad por causa
    final mortalityRate = _calculateMortalityRate(mortalidad);
    final mortalityByCause = _calculateMortalityByCause(mortalidad);

    return BiometricStats(
      adg: adg,
      fcr: fcr,
      mortalityRate: mortalityRate,
      mortalityByCause: mortalityByCause,
      weightTimeline: weightTimeline,
    );
  }

  List<WeightPoint> _calculateWeightTimeline(
    List<Map<String, dynamic>> pesajes,
  ) {
    return pesajes.map((event) {
      return WeightPoint(
        date: DateTime.parse(event['created_at']),
        avgWeight: event['data']['weight'].toDouble(),
      );
    }).toList();
  }

  double _calculateADG(List<WeightPoint> weightTimeline) {
    if (weightTimeline.length < 2) return 0;

    final firstWeight = weightTimeline.first;
    final lastWeight = weightTimeline.last;

    final weightGain = lastWeight.avgWeight - firstWeight.avgWeight;
    final days = lastWeight.date.difference(firstWeight.date).inDays;

    return days > 0 ? weightGain / days : 0;
  }

  double _calculateFCR(
    List<Map<String, dynamic>> alimentacion,
    List<WeightPoint> weightTimeline,
  ) {
    if (weightTimeline.isEmpty || alimentacion.isEmpty) return 0;

    final totalFeed = alimentacion.fold<double>(
      0,
      (sum, event) => sum + event['data']['amount'].toDouble(),
    );

    final weightGain =
        weightTimeline.last.avgWeight - weightTimeline.first.avgWeight;

    return weightGain > 0 ? totalFeed / weightGain : 0;
  }

  double _calculateMortalityRate(List<Map<String, dynamic>> mortalidad) {
    final totalAnimals =
        100; // TODO: Obtener el total real de animales del lote
    final deaths = mortalidad.length;

    return (deaths / totalAnimals) * 100;
  }

  List<MortalityByCause> _calculateMortalityByCause(
    List<Map<String, dynamic>> mortalidad,
  ) {
    final causeMap = <String, int>{};

    for (final event in mortalidad) {
      final cause = event['data']['cause'] as String;
      causeMap[cause] = (causeMap[cause] ?? 0) + 1;
    }

    return causeMap.entries.map((entry) {
      return MortalityByCause(cause: entry.key, count: entry.value);
    }).toList();
  }
}
