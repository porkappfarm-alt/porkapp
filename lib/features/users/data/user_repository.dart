import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/users/domain/user_profile.dart';
import 'package:porkapp/supabase/supabase.dart';

class UserRepository {
  /// Obtiene todos los usuarios del sistema
  Future<List<UserProfile>> getAllUsers() async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => UserProfile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  /// Invita un nuevo usuario al sistema
  /// Usa Edge Function para manejar la operación de admin de forma segura
  /// Retorna la contraseña temporal generada para el nuevo usuario
  Future<String> inviteUser({
    required String email,
    required String fullName,
    required String role,
    required String identificationNumber,
    required String whatsappNumber,
  }) async {
    try {
      // Validar rol
      if (!['user', 'admin'].contains(role)) {
        throw Exception('Rol inválido. Debe ser "user" o "admin"');
      }

      // Obtener el token de acceso
      final session = supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No hay sesión activa');
      }

      // Llamar a la Edge Function que maneja la invitación
      final response = await supabase.functions.invoke(
        'invite-user',
        body: {
          'email': email,
          'fullName': fullName,
          'role': role,
          'identificationNumber': identificationNumber,
          'whatsappNumber': whatsappNumber,
        },
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
        },
      );

      if (response.status != 200) {
        final error = response.data['error'] ?? 'Error al invitar usuario';
        throw Exception(error);
      }

      if (response.data['success'] != true) {
        throw Exception('Error al crear usuario');
      }

      // Retornar la contraseña temporal (identification number)
      final temporaryPassword = response.data['temporaryPassword'] as String?;
      if (temporaryPassword == null) {
        throw Exception('No se recibió la contraseña temporal');
      }

      return temporaryPassword;
    } catch (e) {
      if (e.toString().contains('already exists')) {
        throw Exception('El email ya está registrado');
      }
      throw Exception('Error al invitar usuario: $e');
    }
  }

  /// Actualiza un usuario existente
  Future<void> updateUser({
    required String userId,
    String? fullName,
    String? role,
    String? status,
  }) async {
    try {
      print('UserRepository: Actualizando usuario $userId');
      print('UserRepository: fullName=$fullName, role=$role, status=$status');

      final result = await supabase.rpc('update_user_profile', params: {
        'p_user_id': userId,
        'p_full_name': fullName,
        'p_role': role,
        'p_status': status,
      });

      print('UserRepository: Resultado RPC: $result');

      if (result == null) {
        throw Exception('La función RPC no retornó resultado');
      }

      if (result is Map && result['success'] != true) {
        throw Exception(result['message'] ?? 'Error al actualizar usuario');
      }
    } catch (e) {
      print('UserRepository: Error en updateUser: $e');
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  /// Elimina un usuario del sistema
  /// Usa Edge Function para manejar la operación de admin de forma segura
  Future<void> deleteUser(String userId) async {
    try {
      // Obtener el token de acceso
      final session = supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No hay sesión activa');
      }

      // Llamar a la Edge Function que maneja la eliminación
      final response = await supabase.functions.invoke(
        'delete-user',
        body: {
          'userId': userId,
        },
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
        },
      );

      if (response.status != 200) {
        final error = response.data['error'] ?? 'Error al eliminar usuario';
        throw Exception(error);
      }

      if (response.data['success'] != true) {
        throw Exception('Error al eliminar usuario');
      }
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  /// Activa un usuario
  Future<void> activateUser(String userId) async {
    await updateUser(userId: userId, status: 'active');
  }

  /// Desactiva un usuario
  Future<void> deactivateUser(String userId) async {
    await updateUser(userId: userId, status: 'inactive');
  }

  /// Reenvía la invitación a un usuario pendiente
  /// Usa Edge Function para obtener la contraseña temporal
  /// Retorna la contraseña temporal para que el admin la comunique al usuario
  Future<String> resendInvitation(String userId) async {
    try {
      print('UserRepository: Reenviando invitación para usuario $userId');

      // Obtener la sesión actual con el token
      final session = supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No hay sesión activa');
      }

      final accessToken = session.accessToken;
      print(
          'UserRepository: Token obtenido: ${accessToken.substring(0, 20)}...');

      // Llamar a la Edge Function con el header de autorización explícito
      final response = await supabase.functions.invoke(
        'resend-invitation',
        body: {
          'userId': userId,
        },
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('UserRepository: Response status: ${response.status}');
      print('UserRepository: Response data: ${response.data}');

      if (response.status != 200) {
        final error = response.data['error'] ?? 'Error al reenviar invitación';
        throw Exception(error);
      }

      if (response.data['success'] != true) {
        throw Exception('Error al reenviar invitación');
      }

      // Retornar la contraseña temporal
      final temporaryPassword = response.data['temporaryPassword'] as String?;
      if (temporaryPassword == null) {
        throw Exception('No se recibió la contraseña temporal');
      }

      print('UserRepository: Invitación reenviada exitosamente');
      return temporaryPassword;
    } catch (e) {
      print('UserRepository: Error al reenviar invitación: $e');
      throw Exception('Error al reenviar invitación: ${e.toString()}');
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
