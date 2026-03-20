import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url:
          'postgresql://postgres.wuugnobbycfpnceuysov:ahmeddhahri123**@aws-1-eu-north-1.pooler.supabase.com:6543/postgres?pgbouncer=true',
      anonKey:
          'YOUR_SUPABASE_ANON_KEY',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
