// App secrets — never hardcode keys here.
// Pass values at build/run time with --dart-define:
//
//   flutter run -d chrome \
//     --dart-define=SUPABASE_URL=https://xyz.supabase.co \
//     --dart-define=SUPABASE_ANON_KEY=eyJ... \
//     --dart-define=CLERK_PUBLISHABLE_KEY=pk_test_...
//
// For Replit / CI, set the same keys as environment variables
// that get forwarded to --dart-define in the build command.
// See .env.example (committed) — never commit a real .env.

class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );
  static const clerkPublishableKey = String.fromEnvironment(
    'CLERK_PUBLISHABLE_KEY',
    defaultValue: '',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      clerkPublishableKey.isNotEmpty;
}
