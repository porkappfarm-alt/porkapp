import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/data/animal_data_source.dart';
import 'package:porkapp/features/animals/data/animal_repository.dart';
import 'package:porkapp/supabase/supabase.dart';

final animalRepositoryProvider = Provider<AnimalRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final dataSource = SupabaseAnimalDataSource(supabase);
  return AnimalRepositoryImpl(dataSource);
});
