import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/corrals/domain/corral.dart';
import 'package:porkapp/supabase/supabase.dart';

class CorralsRepository {
  Map<String, dynamic> _processCorralJson(Map<String, dynamic> json) {
    final activeBatchCount = json['active_batch_count'] as int? ?? 0;

    final hasActiveBatches = activeBatchCount > 0;
    final status = json['status'] == 'mantenimiento'
        ? CorralStatus.mantenimiento
        : hasActiveBatches
            ? CorralStatus.ocupado
            : CorralStatus.disponible;

    final createdAt = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now();

    final updatedAt = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : DateTime.now();

    return {
      'id': json['id'],
      'name': json['name'] ?? 'Corral sin nombre',
      'location': json['location'],
      'capacity': json['capacity'],
      'notes': json['notes'],
      'image_url': json['image_url'] ?? '',
      'active_batch_count': activeBatchCount,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': json['created_by'] ?? supabase.auth.currentUser?.id ?? '',
    };
  }

  Future<List<Corral>> getCorrals() async {
    // Obtener los corrales con su estado actual y conteo de lotes activos
    final response =
        await supabase.from('corral_batch_counts').select().order('name');

    print('Raw response: $response');

    try {
      print('Supabase response: $response');

      final corrals = response.map<Corral>((json) {
        print('Processing corral: $json');

        final mappedJson = _processCorralJson(json);
        print('Mapped JSON: $mappedJson');
        return Corral.fromJson(mappedJson);
      }).toList();

      print('Processed corrals: $corrals');
      return corrals;
    } catch (e, stack) {
      print('Error getting corrals: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  Future<Corral> getCorral(String id) async {
    try {
      final response = await supabase
          .from('corral_batch_counts')
          .select()
          .eq('id', id)
          .single();

      print('Raw response for single corral: $response');

      print('Getting single corral response: $response');

      if (response['name'] == null) {
        print('Warning: name is null for corral ${response['id']}');
        response['name'] = 'Corral sin nombre';
      }

      if (response['id'] == null) {
        print('Warning: id is null for corral');
        response['id'] = id;
      }

      final createdAt = response['created_at'] != null
          ? DateTime.parse(response['created_at'])
          : DateTime.now();

      final updatedAt = response['updated_at'] != null
          ? DateTime.parse(response['updated_at'])
          : DateTime.now();

      int activeBatchCount = 0;

      try {
        final rawCount = response['active_batch_count'];
        if (rawCount != null && rawCount is List && rawCount.isNotEmpty) {
          final count = rawCount[0]['count'];
          if (count != null) {
            activeBatchCount = int.parse(count.toString());
          }
        }
      } catch (e) {
        print('Error processing active_batch_count: $e');
        activeBatchCount = 0;
      }
      final hasActiveBatches = activeBatchCount > 0;

      // Si el estado no es mantenimiento y hay lotes activos, asegurarse de que esté ocupado
      final status = response['status'] == 'mantenimiento'
          ? CorralStatus.mantenimiento
          : hasActiveBatches
              ? CorralStatus.ocupado
              : CorralStatus.disponible;

      // Creamos un nuevo mapa sin los campos que no necesitamos
      final mappedJson = {
        'id': response['id'],
        'name': response['name'],
        'location': response['location'],
        'capacity': response['capacity'],
        'notes': response['notes'],
        'image_url': response['image_url'],
        'active_batch_count': activeBatchCount,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'created_by':
            response['created_by'] ?? supabase.auth.currentUser?.id ?? '',
      };

      print('Mapped single corral JSON: $mappedJson');
      return Corral.fromJson(mappedJson);
    } catch (e, stack) {
      print('Error getting single corral: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  Future<Corral> createCorral({
    required String name,
    String? location,
    int? capacity,
    String? notes,
    String? imageUrl,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await supabase.from('corrals').insert({
      'name': name,
      'location': location,
      'capacity': capacity,
      'notes': notes,
      'image_url': imageUrl,
      'created_by': userId,
      'status': CorralStatus.disponible
          .name, // Aseguramos que siempre tenga un estado por defecto
    }).select('''
          *,
          active_batch_count:batches!inner(count).eq(status, 'active')
        ''').single();

    return Corral.fromJson({
      ...response,
      'createdAt': response['created_at'],
      'updatedAt': response['updated_at'],
      'createdBy': response['created_by'],
      'activeBatchCount': response['active_batch_count']?[0]?['count'] ?? 0,
    });
  }

  Future<Corral> updateCorral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
    String? imageUrl,
    CorralStatus? status,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    // Validar que no se pueda cambiar manualmente a 'ocupado'
    if (status == CorralStatus.ocupado) {
      throw Exception(
          'El estado "ocupado" se maneja automáticamente basado en los lotes activos');
    }

    // Obtener el estado actual del corral si no se proporciona uno nuevo
    CorralStatus currentStatus = status ?? CorralStatus.disponible;
    if (status == null) {
      final currentCorral = await getCorral(id);
      currentStatus = currentCorral.status;
    }

    final response = await supabase
        .from('corrals')
        .update({
          'name': name,
          'location': location,
          'capacity': capacity,
          'notes': notes,
          'image_url': imageUrl,
          'status':
              currentStatus.name, // Aseguramos que siempre tenga un estado
          'updated_by': userId,
        })
        .eq('id', id)
        .select('''
          *,
          active_batch_count:batches!inner(count).eq(status, 'active')
        ''')
        .single();

    return Corral.fromJson({
      ...response,
      'createdAt': response['created_at'],
      'updatedAt': response['updated_at'],
      'createdBy': response['created_by'],
      'activeBatchCount': response['active_batch_count']?[0]?['count'] ?? 0,
    });
  }

  Future<void> deleteCorral(String id) async {
    await supabase.from('corrals').delete().eq('id', id);
  }

  Future<Corral> updateCorralStatus(String id, CorralStatus status) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    // Validar que no se pueda cambiar manualmente a 'ocupado'
    if (status == CorralStatus.ocupado) {
      throw Exception(
          'El estado "ocupado" se maneja automáticamente basado en los lotes activos');
    }

    final response = await supabase
        .from('corrals')
        .update({
          'status': status.name,
          'updated_by': userId,
        })
        .eq('id', id)
        .select('''
          *,
          active_batch_count:batches!inner(count).eq(status, 'active')
        ''')
        .single();

    return Corral.fromJson({
      ...response,
      'createdAt': response['created_at'],
      'updatedAt': response['updated_at'],
      'createdBy': response['created_by'],
      'activeBatchCount': response['active_batch_count']?[0]?['count'] ?? 0,
    });
  }
}

final corralsRepositoryProvider = Provider((ref) => CorralsRepository());
