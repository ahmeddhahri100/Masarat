import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://wuugnobbycfpnceuysov.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind1dWdub2JieWNmcG5jZXV5c292Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MzM1MTAsImV4cCI6MjA4OTQwOTUxMH0.FHzJNuBgfXqMV664xtPLUZYjkgy5FXdTjk1ZVYlmYNY',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
