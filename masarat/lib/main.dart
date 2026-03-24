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
      debugPrint('Initializing Supabase...');
      await SupabaseService.initialize();
      if (mounted) {
        setState(() => _isSupabaseInitialized = true);
      }
      debugPrint('Supabase initialized.');
    } catch (e) {
      debugPrint('Supabase error: $e');
      if (mounted) {
        setState(() => _isSupabaseInitialized = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupabaseInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.deepPurple),
                const SizedBox(height: 16),
                const Text('Masarat: Initializing Database...', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
            debugPrint('Auth Session: ${auth.session}');
            
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
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text('Syncing Identity...'),
                      if (e.toString().contains('null'))
                        const Text('(Waiting for Auth Service)')
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
