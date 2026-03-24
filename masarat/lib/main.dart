import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'services/clerk_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MasaratApp()));
}

class MasaratApp extends StatefulWidget {
  const MasaratApp({super.key});

  @override
  State<MasaratApp> createState() => _MasaratAppState();
}

class _MasaratAppState extends State<MasaratApp> {
  bool _isSupabaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSupabase();
  }

  Future<void> _initSupabase() async {
    try {
      debugPrint('DEBUG: Initializing Supabase...');
      await SupabaseService.initialize();
      setState(() => _isSupabaseInitialized = true);
      debugPrint('DEBUG: Supabase initialized.');
    } catch (e) {
      debugPrint('DEBUG: Supabase error: $e');
      setState(() => _isSupabaseInitialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupabaseInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Connecting to Masarat Services...'),
              ],
            ),
          ),
        ),
      );
    }

    return ClerkAuth(
      config: ClerkAuthConfig(publishableKey: ClerkService.publishableKey),
      child: Builder(
        builder: (context) {
          try {
            final auth = ClerkAuth.of(context);
            debugPrint('DEBUG: Auth State - Session: ${auth.session}');
            
            if (auth.session != null) {
              return MaterialApp(
                title: 'Masarat',
                theme: MasaratTheme.lightTheme,
                home: const HomeScreen(),
                debugShowCheckedModeBanner: false,
              );
            } else {
              return MaterialApp(
                title: 'Masarat',
                theme: MasaratTheme.lightTheme,
                home: const OnboardingScreen(),
                debugShowCheckedModeBanner: false,
              );
            }
          } catch (e) {
             debugPrint('DEBUG: Auth Error: $e');
             return MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Auth Syncing...\n$e')),
              ),
            );
          }
        },
      ),
    );
  }
}
