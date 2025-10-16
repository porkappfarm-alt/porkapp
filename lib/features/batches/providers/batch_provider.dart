import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/batches/domain/batch.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/supabase/providers/supabase_provider.dart';

/// Provider para obtener un lote específico con sus animales
final batchProvider = FutureProvider.family<Batch, String>(
  (ref, batchId) async {
    try {
      // Obtener el lote con sus animales en una sola consulta
      final batchData =
          await ref.read(supabaseClientProvider).from('batches').select('''
            *,
            animals(
              id,
              batch_id,
              identifier,
              birth_date,
              weight_at_entry,
              status,
              created_at,
              updated_at,
              notes,
              entry_date,
              breed,
              animal_type,
              sex
            )
          ''').eq('id', batchId).single();

      try {
        // Verificar que los datos del lote estén completos
        if (!batchData.containsKey('id') || !batchData.containsKey('name')) {
          throw Exception('Datos del lote incompletos o inválidos.');
        }

        print('Procesando datos del lote ID: $batchId');
        print('Datos recibidos: $batchData');

        final animalsList = (batchData['animals'] as List?)
                ?.map((animal) {
                  if (animal == null) {
                    print('Animal nulo encontrado');
                    return null;
                  }

                  try {
                    final animalData = Map<String, dynamic>.from(animal);
                    print('Procesando animal con ID: ${animalData['id']}');
                    print('Datos del animal: $animalData');

                    // Verificar campos requeridos
                    if (!animalData.containsKey('batch_id') ||
                        !animalData.containsKey('identifier') ||
                        !animalData.containsKey('breed') ||
                        !animalData.containsKey('animal_type')) {
                      print('Animal con datos faltantes: $animalData');
                      return null;
                    }

                    // Asignar tipo de animal
                    animalData['type'] =
                        animalData['animal_type'] ?? 'fattening';

                    // Procesar peso
                    if (animalData['weight_at_entry'] != null) {
                      animalData['weight'] = double.parse(
                          animalData['weight_at_entry'].toString());
                    }

                    // Procesar fechas
                    DateTime? birthDate;
                    if (animalData['birth_date'] != null) {
                      birthDate =
                          DateTime.parse(animalData['birth_date'].toString());
                    } else {
                      final entryDate = DateTime.parse(
                          animalData['entry_date'] ?? animalData['created_at']);
                      birthDate = entryDate.subtract(const Duration(days: 60));
                    }
                    animalData['birth_date'] = birthDate.toIso8601String();

                    final entryDate = DateTime.parse(
                        animalData['entry_date'] ?? animalData['created_at']);
                    animalData['entry_date'] = entryDate.toIso8601String();

                    final createdAt = DateTime.parse(animalData['created_at']);
                    animalData['created_at'] = createdAt.toIso8601String();

                    print('Animal procesado exitosamente: $animalData');
                    return Animal.fromJson(animalData);
                  } catch (e, stack) {
                    print('Error procesando animal: $e');
                    print('Stack trace: $stack');
                    return null;
                  }
                })
                .whereType<Animal>()
                .toList() ??
            [];

        // Crear una copia limpia de los datos del lote
        final batchDataCopy = Map<String, dynamic>.from(batchData)
          ..remove('animals');

        // Crear el batch con los datos validados
        return Batch.fromJson(batchDataCopy).copyWith(animals: animalsList);
      } catch (e) {
        print('Error al mapear los datos del lote: $e');
        throw Exception(
            'Error al procesar los datos del lote. Por favor verifica el formato de los datos.');
      }
    } catch (e, stackTrace) {
      // Log detallado del error
      print('Error al cargar el lote $batchId:');
      print('Tipo de error: ${e.runtimeType}');
      print('Mensaje: $e');
      print('Stack trace:');
      print(stackTrace);

      // Manejar tipos específicos de errores
      if (e.toString().contains('JSON')) {
        throw Exception(
            'Error de formato en los datos del lote. Por favor contacta al soporte técnico.');
      } else if (e.toString().contains('No row found')) {
        throw Exception('No se encontró el lote especificado.');
      } else if (e.toString().contains('Authentication')) {
        throw Exception(
            'Error de autenticación. Por favor inicia sesión nuevamente.');
      }

      // Error general
      throw Exception(
          'Error al cargar el lote. Por favor intenta nuevamente más tarde.');
    }
  },
);
