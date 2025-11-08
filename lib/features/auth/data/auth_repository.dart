import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:porkapp/supabase/supabase.dart';

class AuthRepository {
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    print('AuthRepository: Iniciando intento de login...');
    print('AuthRepository: Email: $email');

    try {
      // Intentar iniciar sesión directamente
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        print('AuthRepository: Login falló - usuario es null');
        throw 'Credenciales inválidas';
      }

      print('AuthRepository: Login exitoso');
      print('AuthRepository: User ID: ${response.user?.id}');
      print('AuthRepository: Email: ${response.user?.email}');
      print(
        'AuthRepository: Sesión: ${response.session != null ? "Activa" : "Ninguna"}',
      );
    } catch (e) {
      print('AuthRepository: Error de login - $e');
      print('AuthRepository: Tipo de error - ${e.runtimeType}');

      if (e is AuthException) {
        // Manejo específico de errores de Supabase
        if (e.message.contains('Invalid login credentials') ||
            e.message.contains('invalid_credentials')) {
          throw 'Email o contraseña incorrectos';
        } else if (e.message.contains('Email not confirmed')) {
          throw 'Por favor confirme su email antes de iniciar sesión';
        } else {
          throw 'Error de autenticación: ${e.message}';
        }
      } else if (e.toString().contains('Invalid login credentials')) {
        throw 'Email o contraseña incorrectos';
      } else if (e.toString().contains('Email not confirmed')) {
        throw 'Por favor confirme su email antes de iniciar sesión';
      } else if (e.toString().contains('Network error') ||
          e.toString().contains('SocketException')) {
        throw 'Error de conexión. Por favor verifica tu conexión a internet.';
      } else {
        throw 'Error de autenticación: ${e.toString()}';
      }
    }
  }

  /// Verifica si el usuario actual necesita cambiar su contraseña
  Future<bool> needsPasswordChange() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      final needsChange = user.userMetadata?['needs_password_change'] as bool?;
      return needsChange ?? false;
    } catch (e) {
      print('AuthRepository: Error verificando needs_password_change - $e');
      return false;
    }
  }

  /// Cambia la contraseña del usuario actual
  Future<void> updatePassword({required String newPassword}) async {
    try {
      print('AuthRepository: Cambiando contraseña...');

      final user = supabase.auth.currentUser;
      if (user == null) {
        throw 'No hay sesión activa';
      }

      // Obtener el token de sesión
      final session = supabase.auth.currentSession;
      if (session == null) {
        throw 'No hay sesión válida';
      }

      // Llamar a la Edge Function change-password que usa admin.updateUserById
      // Esto es necesario porque usuarios creados con admin.createUser()
      // no pueden cambiar su contraseña usando updateUser() directamente
      print('AuthRepository: Llamando a Edge Function change-password...');

      final response = await supabase.functions.invoke(
        'change-password',
        body: {'newPassword': newPassword},
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      print(
        'AuthRepository: Respuesta de Edge Function: status=${response.status}',
      );

      if (response.status != 200) {
        final errorData = response.data;
        final errorMessage = errorData is Map
            ? (errorData['error'] ?? 'Error desconocido')
            : 'Error desconocido';
        print('AuthRepository: Error en Edge Function: $errorMessage');
        throw errorMessage;
      }

      print(
        'AuthRepository: Contraseña actualizada exitosamente via Edge Function',
      );
    } on FunctionException catch (e) {
      print('AuthRepository: FunctionException - ${e.details}');
      throw 'Error al cambiar la contraseña: ${e.details ?? e.toString()}';
    } on AuthException catch (e) {
      print('AuthRepository: AuthException - ${e.message}');
      throw 'Error de autenticación: ${e.message}';
    } catch (e) {
      print('AuthRepository: Error - $e');
      throw 'Error al cambiar la contraseña: ${e.toString()}';
    }
  }

  /// Cambia la contraseña del usuario autenticado
  /// Este método es para usuarios que desean cambiar su contraseña voluntariamente
  /// No requiere la contraseña actual ya que el usuario ya está autenticado
  Future<void> changePassword({required String newPassword}) async {
    try {
      print('AuthRepository: Cambiando contraseña...');
      print('AuthRepository: Nueva contraseña longitud: ${newPassword.length}');

      final user = supabase.auth.currentUser;
      if (user == null) {
        throw 'No hay sesión activa';
      }

      // Actualizar la contraseña directamente
      // Supabase maneja internamente la validación
      print('AuthRepository: Actualizando contraseña...');

      final updateResponse = await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (updateResponse.user == null) {
        throw 'Error al actualizar la contraseña';
      }

      print('AuthRepository: Contraseña actualizada exitosamente');
    } on AuthException catch (e) {
      print('AuthRepository: AuthException - ${e.message}');
      print('AuthRepository: AuthException statusCode - ${e.statusCode}');

      // Mensajes más específicos según el error
      if (e.message.toLowerCase().contains('same') ||
          e.message.toLowerCase().contains('identical')) {
        throw 'La nueva contraseña debe ser diferente a la anterior';
      } else if (e.message.toLowerCase().contains('weak') ||
          e.message.toLowerCase().contains('short') ||
          e.message.toLowerCase().contains('invalid')) {
        throw 'La contraseña no cumple con los requisitos de seguridad. Debe tener al menos 8 caracteres, una letra y un número.';
      } else if (e.statusCode == 422) {
        throw 'La contraseña no cumple con los requisitos del servidor. Intenta con una contraseña más segura.';
      } else if (e.message.contains('storage')) {
        throw 'Error del servidor al guardar la contraseña. Intenta con una contraseña diferente sin caracteres especiales.';
      }

      throw 'Error al cambiar la contraseña: ${e.message}';
    } catch (e) {
      print('AuthRepository: Error - $e');
      throw 'Error al cambiar la contraseña: ${e.toString()}';
    }
  }

  /// Inicia el proceso de recuperación de contraseña
  Future<void> resetPassword({required String email}) async {
    try {
      print('AuthRepository: Iniciando recuperación de contraseña para $email');

      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.porkapp://reset-password',
      );

      print('AuthRepository: Email de recuperación enviado');
    } catch (e) {
      print('AuthRepository: Error en resetPassword - $e');
      throw 'Error al enviar email de recuperación: ${e.toString()}';
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());
