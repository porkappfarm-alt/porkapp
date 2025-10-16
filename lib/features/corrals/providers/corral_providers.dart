import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/data/corrals_repository.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';

final corralsRepositoryProvider = Provider((ref) => CorralsRepository());

/// Provider que obtiene la lista de corrales
final corralsProvider = FutureProvider<List<Corral>>((ref) async {
  // El estado de los corrales se maneja automáticamente a través de
  // triggers en la base de datos
  return ref.read(corralsRepositoryProvider).getCorrals();
});
