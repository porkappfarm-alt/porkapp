import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        final signUpResponse = await supabase.auth.signUp(
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
      print('AuthRepository: Sesión: ${response.session != null ? "Activa" : "Ninguna"}');
      
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
}

final authRepositoryProvider = Provider((ref) => AuthRepository());