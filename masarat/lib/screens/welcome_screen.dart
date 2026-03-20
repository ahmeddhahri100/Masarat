import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/constants/app_strings.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            // App Logo or Icon
            const Icon(Icons.location_on, size: 60, color: MasaratColors.primary),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: MasaratColors.primary,
                    letterSpacing: 2,
                  ),
            ),
            const Spacer(),
            Text(
              'Your community journey starts here.',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const SignInScreen())
              ),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const SignUpScreen())
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: const BorderSide(color: MasaratColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Create Account'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
