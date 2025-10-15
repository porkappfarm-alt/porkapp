import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/admin/models/user_profile.dart';
import 'package:porkapp/features/admin/repositories/admin_users_repository.dart';
import 'package:porkapp/supabase/providers/supabase_providers.dart';

final adminUsersRepositoryProvider = Provider<AdminUsersRepository>((ref) {
  // Use regular client initially, will be replaced when service client is available
  final regularClient = ref.watch(supabaseProvider);
  return AdminUsersRepository(regularClient, regularClient);
});

final usersProvider = FutureProvider<List<UserProfile>>((ref) async {
  final serviceClient = ref.watch(supabaseServiceClientProvider);
  // Create a repository instance using the service client for admin operations
  final repository = AdminUsersRepository(
    ref.watch(supabaseProvider),
    serviceClient,
  );
  return repository.getAllUsers();
});

class AdminUsersNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminUsersRepository repository;

  AdminUsersNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> createUser({required String email, required String role}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.createUser(email: email, role: role),
    );
  }

  Future<void> updateUser({
    required String userId,
    String? role,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.updateUser(userId: userId, role: role, status: status),
    );
  }

  Future<void> deleteUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.deleteUser(userId));
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.resetPassword(email));
  }

  Future<void> approveUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.updateUser(userId: userId, status: 'approved'),
    );
  }

  Future<void> blockUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.updateUser(userId: userId, status: 'blocked'),
    );
  }
}

final adminUsersNotifierProvider =
    StateNotifierProvider<AdminUsersNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(adminUsersRepositoryProvider);
      return AdminUsersNotifier(repository);
    });
