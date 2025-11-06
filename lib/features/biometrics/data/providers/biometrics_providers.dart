import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/batch_measurement.dart';

final batchBiometricsProvider = FutureProvider.family<List<BatchMeasurement>, String>(
  (ref, batchId) async {
    try {
      final response = await Supabase.instance.client
          .from('batch_biometrics')
          .select()
          .eq('batch_id', batchId)
          .order('measurement_date', ascending: false);

      return (response as List)
          .map((data) => BatchMeasurement.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar las biometrías: $e');
    }
  },
);