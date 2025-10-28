import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/biometrics_data_source.dart';
import '../domain/batch_measurement.dart';

final batchBiometricsProvider =
    FutureProvider.family<List<BatchMeasurement>, String>((ref, batchId) async {
  final dataSource = ref.watch(biometricsDataSourceProvider);
  final measurements = await dataSource.getPesajesByBatch(batchId);

  return measurements
      .map((json) => BatchMeasurement.fromJson({
            'id': json['id'],
            'batchId': json['batch_id'],
            'measurementDate': json['measurement_date'],
            'averageWeight': json['average_weight'].toDouble(),
            'animalCount': json['animal_count'],
            'notes': json['notes'],
            'createdBy': json['created_by'],
            'createdAt': json['created_at'],
            'updatedAt': json['updated_at'] ?? json['created_at'],
            'status': json['status'] ?? 'active',
            'batchName': json['batchName'],
            'measurementName': json['measurement_name'] ?? 'Medición semanal',
          }))
      .toList();
});
