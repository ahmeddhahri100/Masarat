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

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: MasaratApp()));
}

class MasaratApp extends StatelessWidget {
  const MasaratApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ClerkAuth(
      config: ClerkAuthConfig(publishableKey: ClerkService.publishableKey),
      child: ClerkAuthBuilder(
        signedInBuilder: (context, state) => MaterialApp(
          title: 'Masarat',
          theme: MasaratTheme.lightTheme,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
        signedOutBuilder: (context, state) => MaterialApp(
          title: 'Masarat',
          theme: MasaratTheme.lightTheme,
          home: const OnboardingScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
