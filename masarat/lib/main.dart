import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

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
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _isSignedIn = AuthService.isSignedIn;

    AuthService.authStateChanges.listen((AuthState state) {
      if (mounted) {
        setState(() {
          _isSignedIn = state.session != null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return const HomeScreen();
    }
    return const WelcomeScreen();
  }
}
