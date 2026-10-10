import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../core/config/env.dart';

class ClerkAuthService {
  static const String _publishableKey = Env.clerkPublishableKey;
  static const String _placeholderKey = 'YOUR_CLERK_PUBLISHABLE_KEY';

  static bool get isConfigured =>
      _publishableKey.isNotEmpty && _publishableKey != _placeholderKey;

  static ClerkAuthState? _clerkAuthState;

  static Future<void> initialize() async {
    debugPrint('[Clerk] Initializing with publishable key');
  }

  static ClerkAuthConfig getConfig() {
    return ClerkAuthConfig(publishableKey: _publishableKey);
  }

  static bool get isSignedIn {
    return _clerkAuthState?.isSignedIn ?? false;
  }

  static String? get userId {
    return _clerkAuthState?.user?.id;
  }

  static String? get userEmail {
    final user = _clerkAuthState?.user;
    if (user == null) return null;
    return user.email;
  }

  static String? get userName {
    final user = _clerkAuthState?.user;
    if (user == null) return null;
    if (user.hasName) return user.name;
    return user.email?.split('@').first;
  }

  static Future<String?> getToken() async {
    final authState = _clerkAuthState;
    if (authState == null || !authState.isSignedIn) return null;
    try {
      final token = await authState.sessionToken();
      debugPrint('[Clerk] Token retrieved');
      return token.jwt;
    } catch (e) {
      debugPrint('[Clerk] Token retrieval failed: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _clerkAuthState?.signOut();
      debugPrint('[Clerk] Signed out');
    } catch (e) {
      debugPrint('[Clerk] Sign out failed: $e');
      rethrow;
    }
  }

  static void updateAuthState(ClerkAuthState state) {
    _clerkAuthState = state;
    debugPrint(
      '[Clerk] Auth state updated: isSignedIn=${state.isSignedIn}, userId=${state.user?.id}',
    );
  }

  static ClerkAuthState? get currentState => _clerkAuthState;
}
