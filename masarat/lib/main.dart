import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'services/clerk_auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  try {
    debugPrint('[Main] Initializing Supabase...');
    await SupabaseService.initialize();
    debugPrint('[Main] Supabase initialized successfully');
  } catch (e) {
    debugPrint('[Main] Supabase initialization failed: $e');
    debugPrint(
      '[Main] App will continue in limited mode. Auth features will be unavailable.',
    );
  }

  runApp(const ProviderScope(child: MasaratApp()));
}

class MasaratApp extends StatelessWidget {
  const MasaratApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masarat',
      debugShowCheckedModeBanner: false,
      theme: MasaratTheme.lightTheme,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  Widget build(BuildContext context) {
    return ClerkAuth(
      config: ClerkAuthService.getConfig(),
      child: ClerkAuthBuilder(
        signedInBuilder: (context, authState) {
          ClerkAuthService.updateAuthState(authState);
          return const HomeScreen();
        },
        signedOutBuilder: (context, authState) {
          ClerkAuthService.updateAuthState(authState);
          return const WelcomeScreen();
        },
      ),
    );
  }
}
