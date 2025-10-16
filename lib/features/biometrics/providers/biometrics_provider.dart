import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/biometrics/data/animal_events_repository.dart';
import 'package:porkapp/features/biometrics/data/animal_events_data_source.dart';
// import 'package:porkapp/features/biometrics/data/biometrics_cache.dart'; // Removed: Drift dependency
import 'package:porkapp/features/biometrics/domain/biometric_stats.dart';
import 'package:porkapp/supabase/providers/supabase_provider.dart';

/// Provider para el caché local de biometrías
// final biometricsCacheProvider = Provider<BiometricsCache>((ref) {
//   return BiometricsCache();
// }); // Removed: Drift dependency

/// Provider del repositorio de eventos de animales
final animalEventsRepositoryProvider = Provider<AnimalEventsRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final dataSource = AnimalEventsDataSource(supabase);
  return AnimalEventsRepository(dataSource);
});

/// Provider principal de estadísticas biométricas
/// Retorna un [AsyncValue] con las estadísticas completas del lote
final biometricsProvider = FutureProvider.family<BiometricStats, String>((
  ref,
  batchId,
) async {
  // final cache = ref.watch(biometricsCacheProvider); // Removed: Drift dependency

  try {
    // Obtener datos online
    final stats =
        await ref.watch(animalEventsRepositoryProvider).getBatchStats(batchId);

    // Guardar en caché (disabled)
    // await cache.saveBiometricStats(batchId, stats);
    return stats;
  } catch (error) {
    // Si falla, intentar obtener del caché (disabled)
    // final cachedStats = await cache.getBiometricStats(batchId);
    // if (cachedStats != null) {
    //   return cachedStats;
    // }
    throw Exception(
      'Error al obtener estadísticas: ${error.toString()}',
    );
  }
});

/// Provider para la ganancia diaria de peso (ADG)
final adgProvider = Provider.family<AsyncValue<double>, String>((ref, batchId) {
  return ref.watch(biometricsProvider(batchId)).whenData((stats) => stats.adg);
});

/// Provider para el ratio de conversión alimenticia (FCR)
final fcrProvider = Provider.family<AsyncValue<double>, String>((ref, batchId) {
  return ref.watch(biometricsProvider(batchId)).whenData((stats) => stats.fcr);
});

/// Provider para el porcentaje de mortalidad
final mortalityRateProvider = Provider.family<AsyncValue<double>, String>((
  ref,
  batchId,
) {
  return ref
      .watch(biometricsProvider(batchId))
      .whenData((stats) => stats.mortalityRate);
});

/// Provider para las causas de mortalidad
final mortalityByCauseProvider =
    Provider.family<AsyncValue<List<MortalityByCause>>, String>((ref, batchId) {
  return ref
      .watch(biometricsProvider(batchId))
      .whenData((stats) => stats.mortalityByCause);
});

/// Provider para la línea de tiempo de pesos
final weightTimelineProvider =
    Provider.family<AsyncValue<List<WeightPoint>>, String>((ref, batchId) {
  return ref
      .watch(biometricsProvider(batchId))
      .whenData((stats) => stats.weightTimeline);
});
