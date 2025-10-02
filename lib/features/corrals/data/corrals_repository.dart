import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';
import 'package:porkapp/supabase/supabase.dart';

class CorralsRepository {
  Future<List<Corral>> getCorrals() async {
    final response = await supabase
        .from('corrals')
        .select('''
          *,
          active_batch_count:batches(count)
        ''')
        .order('name');

    return response
        .map(
          (json) => Corral.fromJson({
            ...json,
            'activeBatchCount': json['active_batch_count']?[0]?['count'] ?? 0,
          }),
        )
        .toList();
  }

  Future<Corral> getCorral(String id) async {
    final response = await supabase
        .from('corrals')
        .select()
        .eq('id', id)
        .single();

    return Corral.fromJson(response);
  }

  Future<Corral> createCorral({
    required String name,
    String? location,
    int? capacity,
    String? notes,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await supabase
        .from('corrals')
        .insert({
          'name': name,
          'location': location,
          'capacity': capacity,
          'notes': notes,
          'created_by': userId,
        })
        .select()
        .single();

    return Corral.fromJson(response);
  }

  Future<Corral> updateCorral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await supabase
        .from('corrals')
        .update({
          'name': name,
          'location': location,
          'capacity': capacity,
          'notes': notes,
          'updated_by': userId,
        })
        .eq('id', id)
        .select()
        .single();

    return Corral.fromJson(response);
  }

  Future<void> deleteCorral(String id) async {
    await supabase.from('corrals').delete().eq('id', id);
  }
}

final corralsRepositoryProvider = Provider((ref) => CorralsRepository());
