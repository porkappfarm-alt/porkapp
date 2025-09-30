import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/supabase/supabase.dart';

class AuthRepository {
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    print('Attempting login with email: $email');
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        print('Login failed: User is null');
        throw 'Credenciales inválidas';
      }
      
      print('Login successful: ${response.user?.email}');
      print('User ID: ${response.user?.id}');
      print('User role: ${response.user?.userMetadata?['role']}');
      
    } catch (e) {
      print('Login error details: $e');
      if (e.toString().contains('Invalid login credentials')) {
        throw 'Email o contraseña incorrectos';
      } else if (e.toString().contains('Email not confirmed')) {
        throw 'Por favor confirme su email antes de iniciar sesión';
      } else {
        throw 'Error de autenticación: ${e.toString()}';
      }
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());