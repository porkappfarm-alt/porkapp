import 'package:supabase_flutter/supabase_flutter.dart';

// Get Supabase client instance to use throughout the app
final supabase = Supabase.instance.client;

// Constants for initialization
const supabaseUrl = 'https://xyqftjfnnqbudjhzfpvy.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5cWZ0amZubnFidWRqaHpmcHZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4MTY2NjgsImV4cCI6MjA3NDM5MjY2OH0.tCvIVuLRhoAyP3cFMw4vamtNRJSB7B6_AKFGma4-Oe0';

/// Initialize Supabase for the app
Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
}