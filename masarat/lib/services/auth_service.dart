import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static ClerkAuthState? _state;

  static void update(ClerkAuthState state) {
    _state = state;
  }

  static bool get isSignedIn => _state?.isSignedIn ?? false;

  static String? get userId => _state?.user?.id;

  static String? get userEmail => _state?.user?.email;

  static String? get userName {
    final user = _state?.user;
    if (user == null) return null;
    if (user.hasName) return user.name;
    return user.email?.split('@').first;
  }

  static Future<void> signOut() async {
    try {
      await _state?.signOut();
    } catch (e) {
      debugPrint('[Auth] Sign out error: $e');
    }
  }

  static Future<String?> sessionToken({String? templateName}) async {
    if (_state == null || !isSignedIn) return null;
    try {
      final token = await _state!.sessionToken(templateName: templateName);
      return token.jwt;
    } catch (e) {
      debugPrint('[Auth] Session token error: $e');
      return null;
    }
  }
}
