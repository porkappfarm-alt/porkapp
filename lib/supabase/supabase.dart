import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Get Supabase client instance to use throughout the app
final supabase = Supabase.instance.client;

// Provider for Supabase client
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Constants for initialization
const supabaseUrl = 'https://xyqftjfnnqbudjhzfpvy.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5cWZ0amZubnFidWRqaHpmcHZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MTY2NjgsImV4cCI6MjA3NDM5MjY2OH0.tCvIVuLRhoAyP3cFMw4vamtNRJSB7B6_AKFGma4-Oe0';

/// Initialize Supabase for the app
Future<void> initializeSupabase() async {
  try {
    print('Initializing Supabase...');
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // Enable debug mode
      authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
    );
    print('Supabase initialized successfully');

    // Verificar la configuración
    final client = Supabase.instance.client;
    print('Current user: ${client.auth.currentUser?.email}');
    print('Has session: ${client.auth.currentSession != null}');
  } catch (e) {
    print('Error initializing Supabase: $e');
    rethrow;
  }
}
