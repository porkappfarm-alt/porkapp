import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';

final userRoleProvider = FutureProvider<String>((ref) async {
  // Escuchar cambios en el estado de autenticación para invalidar el cache
  ref.watch(authStateProvider);

  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    print('[userRoleProvider] No user authenticated');
    return 'guest';
  }

  print(
      '[userRoleProvider] Fetching role for user: ${user.email} (${user.id})');

  try {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();

    print('[userRoleProvider] Profile response: $response');
    final role = response['role'] ?? 'user';
    print('[userRoleProvider] ✅ Resolved role for ${user.email}: $role');
    return role;
  } catch (e) {
    print('[userRoleProvider] ❌ Error fetching role: $e');
    return 'user';
  }
});
