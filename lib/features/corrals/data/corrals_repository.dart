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

    // Procesar capacity de forma segura
    int? capacity;
    if (json['capacity'] != null) {
      final rawCapacity = json['capacity'];
      if (rawCapacity is int) {
        capacity = rawCapacity;
      } else if (rawCapacity is num) {
        // Verificar que no sea infinito o NaN
        if (rawCapacity.isFinite && !rawCapacity.isNaN) {
          capacity = rawCapacity.toInt();
        }
      }
    }

    return {
      'id': json['id'],
      'name': json['name'] ?? 'Corral sin nombre',
      'location': json['location'],
      'capacity': capacity,
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
    // Obtener los corrales directamente de la tabla corrals
    final response = await supabase.from('corrals').select().order('name');

    print('Raw response: $response');

    try {
      print('Supabase response: $response');

      final corrals = response.map<Corral>((json) {
        print('Processing corral: $json');

        // Para corrals directamente, no tenemos active_batch_count
        // así que lo establecemos en 0
        final mappedJson = _processCorralJson({
          ...json,
          'active_batch_count': 0,
        });
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
      final response =
          await supabase.from('corrals').select().eq('id', id).single();

      print('Raw response for single corral: $response');

      // Para corrals directamente, no tenemos active_batch_count en la respuesta
      // así que lo establecemos en 0
      final mappedJson = _processCorralJson({
        ...response,
        'active_batch_count': 0,
      });

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

    final response = await supabase
        .from('corrals')
        .insert({
          'name': name,
          'location': location,
          'capacity': capacity,
          'notes': notes,
          'image_url': imageUrl,
          'created_by': userId,
          'status': CorralStatus.disponible
              .name, // Aseguramos que siempre tenga un estado por defecto
        })
        .select()
        .single();

    // Procesar el resultado igual que en getCorral
    final mappedJson = _processCorralJson({
      ...response,
      'active_batch_count': 0, // Un corral nuevo no tiene lotes activos
    });

    return Corral.fromJson(mappedJson);
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
        .select()
        .single();

    // Procesar la respuesta usando el método helper
    final processedData = _processCorralJson(response);

    return Corral.fromJson({
      ...processedData,
      'createdAt': processedData['created_at'],
      'updatedAt': processedData['updated_at'],
      'createdBy': processedData['created_by'],
      'activeBatchCount': processedData['active_batch_count'],
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
