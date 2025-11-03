import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:porkapp/supabase/supabase.dart';

class AuthRepository {
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    print('AuthRepository: Iniciando intento de login...');
    print('AuthRepository: URL de Supabase: $supabaseUrl');
    print('AuthRepository: Email: $email');

    try {
      // Primero intentamos registrar al usuario si no existe
      try {
        print('AuthRepository: Intentando registrar usuario...');
        await supabase.auth.signUp(
          email: email,
          password: password,
        );
        print('AuthRepository: Registro exitoso o usuario ya existe');
      } catch (signUpError) {
        print('AuthRepository: Error o usuario ya existe: $signUpError');
      }

      // Luego intentamos iniciar sesión
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
          'AuthRepository: Sesión: ${response.session != null ? "Activa" : "Ninguna"}');
    } catch (e) {
      print('AuthRepository: Error de login - $e');
      print('AuthRepository: Tipo de error - ${e.runtimeType}');

      if (e.toString().contains('Invalid login credentials')) {
        throw 'Email o contraseña incorrectos';
      } else if (e.toString().contains('Email not confirmed')) {
        throw 'Por favor confirme su email antes de iniciar sesión';
      } else if (e.toString().contains('Network error')) {
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
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      print('AuthRepository: Cambiando contraseña...');

      final user = supabase.auth.currentUser;
      if (user == null) {
        throw 'No hay sesión activa';
      }

      // Actualizar la contraseña
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      print('AuthRepository: Contraseña actualizada exitosamente');

      // Actualizar el metadata para marcar que ya no necesita cambiar contraseña
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'needs_password_change': false,
          },
        ),
      );

      print('AuthRepository: Metadata actualizado');

      // Actualizar el estado del perfil a "active"
      await supabase.from('profiles').update({
        'status': 'active',
        'temporary_password': null, // Limpiar contraseña temporal
      }).eq('id', user.id);

      print('AuthRepository: Estado del perfil actualizado a active');
    } catch (e) {
      print('AuthRepository: Error cambiando contraseña - $e');
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
