import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase before running the app
  try {
    debugPrint('Initializing Supabase...');
    await SupabaseService.initialize();
    debugPrint('✓ Supabase initialized successfully');
  } catch (e) {
    debugPrint('✗ Supabase initialization error: $e');
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
      home: const MainScreen(),
    );
  }
}

/// Main screen that handles navigation based on auth state
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    setState(() => _isLoading = true);

    try {
      final session = SupabaseService.client.auth.currentSession;

      setState(() {
        _isLoggedIn = session != null;
        _userName = session?.user?.email?.split('@').first ?? 'Partner';
        _isLoading = false;
      });

      debugPrint('Auth state: ${_isLoggedIn ? 'logged in' : 'guest'}');
    } catch (e) {
      debugPrint('Auth check error: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.deepPurple),
              const SizedBox(height: 16),
              Text(
                'Loading Masarat...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    return _isLoggedIn ? const HomeScreen() : const WelcomeScreen();
  }
}
