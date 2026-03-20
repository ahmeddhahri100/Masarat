import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: MasaratColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.route_rounded, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 24),
              // App name
              Text(
                'MASARAT',
                style: MasaratTypography.displayMedium.copyWith(
                  color: MasaratColors.primary,
                  letterSpacing: 6,
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'مسارات',
                style: MasaratTypography.headlineMedium.copyWith(
                  color: MasaratColors.primaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'Your community\njourney starts here.',
                style: MasaratTypography.headlineMedium.copyWith(
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Beyond just travel, we\'re building a community of trust across Tunisia.',
                style: MasaratTypography.bodyMedium.copyWith(
                  color: MasaratColors.onSurfaceVariant,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Sign In gradient button
              _GradientButton(
                label: 'Sign In',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                ),
              ),
              const SizedBox(height: 16),
              // Create Account outlined button
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                ),
                child: Text(
                  'Create Account',
                  style: MasaratTypography.buttonText.copyWith(
                    color: MasaratColors.primary,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: MasaratColors.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: MasaratColors.primary.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(label, style: MasaratTypography.buttonText),
        ),
      ),
    );
  }
}
