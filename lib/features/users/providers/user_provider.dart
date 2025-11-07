import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/users/data/user_repository.dart';
import 'package:porkapp/features/users/domain/user_profile.dart';

/// Provider para la lista de usuarios
final usersListProvider = FutureProvider<List<UserProfile>>((ref) async {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAllUsers();
});

/// Provider para filtros de usuarios
final userRoleFilterProvider = StateProvider<String?>((ref) => null);
final userStatusFilterProvider = StateProvider<String?>((ref) => null);

/// Provider para usuarios filtrados
final filteredUsersProvider = Provider<AsyncValue<List<UserProfile>>>((ref) {
  final usersAsync = ref.watch(usersListProvider);
  final roleFilter = ref.watch(userRoleFilterProvider);
  final statusFilter = ref.watch(userStatusFilterProvider);

  return usersAsync.when(
    data: (users) {
      var filtered = users;

      if (roleFilter != null) {
        filtered = filtered.where((u) => u.role == roleFilter).toList();
      }

      if (statusFilter != null) {
        filtered = filtered.where((u) => u.status == statusFilter).toList();
      }

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

/// Notifier para operaciones CRUD de usuarios
class UserNotifier extends StateNotifier<AsyncValue<void>> {
  UserNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  UserRepository get _repository => ref.read(userRepositoryProvider);

  /// Invita un nuevo usuario
  /// Retorna la contraseña temporal generada
  Future<String> inviteUser({
    required String email,
    required String fullName,
    required String role,
    required String identificationNumber,
    required String whatsappNumber,
  }) async {
    state = const AsyncValue.loading();

    String? temporaryPassword;
    state = await AsyncValue.guard(() async {
      temporaryPassword = await _repository.inviteUser(
        email: email,
        fullName: fullName,
        role: role,
        identificationNumber: identificationNumber,
        whatsappNumber: whatsappNumber,
      );
      // Refrescar la lista
      ref.invalidate(usersListProvider);
    });

    if (temporaryPassword == null) {
      throw Exception('No se pudo obtener la contraseña temporal');
    }

    return temporaryPassword!;
  }

  /// Actualiza un usuario
  Future<void> updateUser({
    required String userId,
    String? fullName,
    String? role,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateUser(
        userId: userId,
        fullName: fullName,
        role: role,
        status: status,
      );
      // Refrescar la lista
      ref.invalidate(usersListProvider);
    });
  }

  /// Elimina un usuario
  Future<void> deleteUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteUser(userId);
      // Refrescar la lista
      ref.invalidate(usersListProvider);
    });
  }

  /// Activa un usuario
  Future<void> activateUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.activateUser(userId);
      // Refrescar la lista
      ref.invalidate(usersListProvider);
    });
  }

  /// Desactiva un usuario
  Future<void> deactivateUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deactivateUser(userId);
      // Refrescar la lista
      ref.invalidate(usersListProvider);
    });
  }

  /// Reenvía la invitación a un usuario pendiente
  /// Retorna la contraseña temporal
  Future<String> resendInvitation(String userId) async {
    state = const AsyncValue.loading();

    String? temporaryPassword;
    state = await AsyncValue.guard(() async {
      temporaryPassword = await _repository.resendInvitation(userId);
      // Refrescar la lista
      ref.invalidate(usersListProvider);
    });

    if (temporaryPassword == null) {
      throw Exception('No se pudo obtener la contraseña temporal');
    }

    return temporaryPassword!;
  }
}

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<void>>((ref) {
  return UserNotifier(ref);
});

/// Provider para el usuario seleccionado en edición
final selectedUserProvider = StateProvider<UserProfile?>((ref) => null);
