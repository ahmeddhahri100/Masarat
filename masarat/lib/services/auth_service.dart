import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static SupabaseClient get _client => Supabase.instance.client;

  static User? get currentUser => _client.auth.currentUser;
  static bool get isSignedIn => currentUser != null;

  static String? get userId => currentUser?.id;
  static String? get userEmail => currentUser?.email;
  static String? get userName =>
      currentUser?.userMetadata?['full_name'] as String? ??
      currentUser?.email?.split('@').first;

  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    debugPrint('[Auth] Signing in: $email');
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    debugPrint('[Auth] Signing up: $email');
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    if (response.user != null) {
      try {
        await _client.from('profiles').upsert({
          'id': response.user!.id,
          'name': fullName,
        });
      } catch (e) {
        debugPrint('[Auth] Profile creation skipped: $e');
      }
    }

    return response;
  }

  static Future<void> signOut() async {
    debugPrint('[Auth] Signing out');
    await _client.auth.signOut();
  }
}
