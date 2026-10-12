import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/config/env.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

const _clerkPublishableKey = Env.clerkPublishableKey;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = true;

  try {
    debugPrint('[Main] Initializing Supabase...');
    await SupabaseService.initialize();
    debugPrint('[Main] Supabase initialized successfully');
  } catch (e) {
    debugPrint('[Main] Supabase initialization failed: $e');
  }

  runApp(const ProviderScope(child: MasaratApp()));
}

class MasaratApp extends StatelessWidget {
  const MasaratApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo mode: no backend keys (e.g. plain `flutter run` without
    // --dart-define). Skip Clerk wrapper — an empty publishable key throws
    // FormatException and red-screens. See .env.example / .dart-define.json.
    if (!Env.isConfigured) {
      return MaterialApp(
        title: 'Masarat',
        debugShowCheckedModeBanner: false,
        theme: MasaratTheme.lightTheme,
        builder: (context, child) => Banner(
          message: 'DEMO — no keys',
          location: BannerLocation.topEnd,
          child: child ?? const OnboardingScreen(),
        ),
        home: const OnboardingScreen(),
      );
    }
    return MaterialApp(
      title: 'Masarat',
      debugShowCheckedModeBanner: false,
      theme: MasaratTheme.lightTheme,
      builder: ClerkAuth.materialAppBuilder(
        config: ClerkAuthConfig(
          publishableKey: _clerkPublishableKey,
        ),
      ),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = ClerkAuth.of(context);
    AuthService.update(auth);
    return auth.isSignedIn ? const HomeScreen() : const OnboardingScreen();
  }
}
