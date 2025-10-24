import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/batch_measurement.dart';

final batchBiometricsProvider =
    FutureProvider.family<List<BatchMeasurement>, String>((ref, batchId) async {
  // TODO: Implementar carga desde Supabase
  await Future.delayed(const Duration(seconds: 1)); // Simular carga

  final now = DateTime.now();
  return [
    BatchMeasurement(
      id: 'mock-1',
      batchId: batchId,
      measurementDate: DateTime(2025, 10, 21),
      averageWeight: 54.3,
      animalCount: 125,
      notes: 'Cambio de alimento',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
      batchName: 'Lote $batchId',
      measurementName: 'Medición semanal',
    ),
    BatchMeasurement(
      id: 'mock-2',
      batchId: batchId,
      measurementDate: DateTime(2025, 10, 14),
      averageWeight: 50.8,
      animalCount: 125,
      notes: 'Pesaje semanal',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
      batchName: 'Lote $batchId',
      measurementName: 'Medición semanal',
    ),
  ];
});
