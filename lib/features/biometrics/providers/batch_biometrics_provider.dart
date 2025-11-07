import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/biometrics_data_source.dart';
import '../domain/batch_measurement.dart';

final batchBiometricsProvider =
    FutureProvider.family<List<BatchMeasurement>, String>((ref, batchId) async {
  try {
    print('🔍 BatchBiometricsProvider: Starting for batch: $batchId');

    final dataSource = ref.watch(biometricsDataSourceProvider);
    print('🔍 BatchBiometricsProvider: DataSource obtained');

    final measurements = await dataSource.getPesajesByBatch(batchId);
    print(
        '🔍 BatchBiometricsProvider: Got ${measurements.length} measurements');

    if (measurements.isNotEmpty) {
      print(
          '🔍 BatchBiometricsProvider: First measurement: ${measurements.first}');
    }

    final result = measurements.map((json) {
      print(
          '🔍 BatchBiometricsProvider: Mapping measurement id: ${json['id']}');
      print(
          '🔍 BatchBiometricsProvider: avg_weight value: ${json['avg_weight']} (type: ${json['avg_weight']?.runtimeType})');
      print(
          '🔍 BatchBiometricsProvider: animals_measured value: ${json['animals_measured']}');

      try {
        // El modelo generado espera los nombres en snake_case tal como vienen de la DB
        return BatchMeasurement.fromJson({
          'id': json['id'],
          'batch_id': json['batch_id'],
          'measurement_date': json['measurement_date'],
          'average_weight': (json['avg_weight'] ?? 0).toDouble(),
          'animal_count': json['animals_measured'] ?? 0,
          'notes': json['notes'],
          'created_by': json['created_by'],
          'created_at': json['created_at'],
          'updated_at': json['updated_at'] ?? json['created_at'],
          'status': json['status'] ?? 'active',
          'batch_name': json['batchName'],
          'measurement_name': json['measurement_name'] ?? 'Medición semanal',
        });
      } catch (e, stack) {
        print('❌ BatchBiometricsProvider: Error mapping measurement: $e');
        print('❌ Stack: $stack');
        print('❌ JSON data: $json');
        rethrow;
      }
    }).toList();

    print(
        '✅ BatchBiometricsProvider: Successfully mapped ${result.length} measurements');
    return result;
  } catch (e, stackTrace) {
    print('❌ BatchBiometricsProvider ERROR: $e');
    print('❌ StackTrace: $stackTrace');
    rethrow;
  }
});
