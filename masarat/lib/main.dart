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
      debugPrint('Initializing Supabase from MasaratApp...');
      await SupabaseService.initialize();
      setState(() => _isSupabaseInitialized = true);
      debugPrint('Supabase initialized.');
    } catch (e) {
      debugPrint('Supabase init error: $e');
      setState(() => _isSupabaseInitialized = true); // Proceed anyway to show something
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
                Text('Checking Database Connection...', style: TextStyle(color: Colors.black)),
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
            debugPrint('ClerkAuth session: ${auth.session}');
            
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
              home: Scaffold(
                body: Center(child: Text('Auth Syncing... $e')),
              ),
            );
          }
        },
      ),
    );
  }
}
