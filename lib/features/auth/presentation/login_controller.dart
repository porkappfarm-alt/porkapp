import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/data/auth_repository.dart';

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    print('LoginController: Attempting login with email: $email');
    state = const AsyncValue.loading();
    
    try {
      await ref.read(authRepositoryProvider).signInWithEmail(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
      print('LoginController: Login successful');
    } catch (e, st) {
      print('LoginController: Login error: $e');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
  return LoginController(ref);
});