import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase.dart';

/// Regular Supabase client provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Service role client provider for admin operations
final supabaseServiceClientProvider = Provider<SupabaseClient>((ref) {
  final serviceClient = SupabaseClient(
    supabaseUrl,
    String.fromEnvironment('SUPABASE_SERVICE_KEY'),
  );
  // Ensure headers are set consistently for admin operations
  final headers = {
    'apikey': String.fromEnvironment('SUPABASE_SERVICE_KEY'),
    'Authorization': 'Bearer ${String.fromEnvironment('SUPABASE_SERVICE_KEY')}',
    'Content-Type': 'application/json',
  };
  // Set headers for both client and auth
  serviceClient.headers.addAll(headers);
  serviceClient.auth.headers.addAll(headers);
  return serviceClient;
});
