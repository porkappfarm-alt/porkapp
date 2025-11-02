import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRoleProvider = FutureProvider<String>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return 'guest';
  }

  try {
    final profile = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();
    final role = profile['role'] ?? 'user';
    print('[userRoleProvider] Resolved role for ${user.email}: $role');
    return role;
  } catch (e) {
    print('[userRoleProvider] Error fetching role: $e');
    return 'user';
  }
});
