import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/data/auth_repository.dart';

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() => 
      ref.read(authRepositoryProvider).signInWithEmail(
        email: email,
        password: password,
      )
    );
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
  return LoginController(ref);
});