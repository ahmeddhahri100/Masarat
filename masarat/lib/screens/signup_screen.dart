import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../services/supabase_service.dart';
import 'home_screen.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  static const _authTimeout = Duration(seconds: 15);

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (!SupabaseService.isInitialized) {
        _showError(
          'Connection error: Authentication service is not available. '
          'Please check your internet connection and try again.',
        );
        return;
      }

      debugPrint('[SignUp] Attempting signup for: $email');

      final response = await SupabaseService.client.auth
          .signUp(
            email: email,
            password: password,
            data: {'full_name': name},
          )
          .timeout(
            _authTimeout,
            onTimeout: () {
              throw TimeoutException(
                'Signup request timed out after ${_authTimeout.inSeconds}s. '
                'Please check your internet connection.',
              );
            },
          );

      if (response.user != null) {
        debugPrint('[SignUp] ✓ User created: ${response.user?.id}');

        if (response.user?.identities?.isEmpty ?? false) {
          _showError(
            'An account with this email already exists. '
            'Please sign in instead.',
          );
          return;
        }

        await _createUserProfile(response.user!.id, name, email);

        if (response.user?.emailConfirmedAt == null) {
          debugPrint('[SignUp] Email not confirmed - showing confirmation message');
          if (mounted) {
            _showEmailConfirmationDialog(email);
          }
          return;
        }

        debugPrint('[SignUp] ✓ Sign up complete, navigating to home');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account created! Welcome, $name'),
              backgroundColor: MasaratColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } on TimeoutException catch (e) {
      debugPrint('[SignUp] ✗ Timeout: $e');
      _showError(
        'Connection timed out. Please check your internet connection and try again.',
      );
    } on AuthException catch (e) {
      debugPrint('[SignUp] ✗ Auth error: ${e.message} (status: ${e.statusCode})');
      _showError(_getFriendlyAuthError(e));
    } catch (e) {
      debugPrint('[SignUp] ✗ Unexpected error: $e');
      _showError(
        'An unexpected error occurred. Please check your connection and try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createUserProfile(String userId, String name, String email) async {
    try {
      debugPrint('[SignUp] Creating profile for user: $userId');
      await SupabaseService.client.from('profiles').upsert({
        'id': userId,
        'name': name,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });
      debugPrint('[SignUp] ✓ Profile created/updated');
    } catch (e) {
      debugPrint('[SignUp] ⚠ Profile creation failed (non-critical): $e');
    }
  }

  String _getFriendlyAuthError(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('email') && message.contains('already')) {
      return 'An account with this email already exists. Please sign in instead.';
    }
    if (message.contains('password') && message.contains('6')) {
      return 'Password must be at least 6 characters long.';
    }
    if (message.contains('invalid') || message.contains('unable')) {
      return 'Unable to connect to the authentication service. Please check your internet connection.';
    }
    if (message.contains('network') || message.contains('socket')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    return e.message;
  }

  void _showEmailConfirmationDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Check Your Email'),
        content: Text(
          'We sent a confirmation link to $email. Please confirm your email, then sign in to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
            child: const Text('Go to Sign In'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: MasaratColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(
        backgroundColor: MasaratColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Join\nMasarat', style: MasaratTypography.headlineLarge),
            const SizedBox(height: 12),
            Text(
              'Create an account to join the carpooling community.',
              style: MasaratTypography.bodyMedium.copyWith(
                color: MasaratColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: MasaratColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'yourname@example.com',
                prefixIcon: Icon(
                  Icons.mail_outline_rounded,
                  color: MasaratColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: MasaratColors.onSurfaceVariant,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: MasaratColors.onSurfaceVariant,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'By creating an account, you agree to our Terms of Service and Privacy Policy.',
              style: MasaratTypography.labelSmall.copyWith(height: 1.5),
            ),
            const SizedBox(height: 40),
            _GradientButton(
              label: 'Create Account',
              isLoading: _isLoading,
              onPressed: _handleSignUp,
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                ),
                child: RichText(
                  text: TextSpan(
                    style: MasaratTypography.bodyMedium,
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Sign In',
                        style: MasaratTypography.bodyMedium.copyWith(
                          color: MasaratColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
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
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(label, style: MasaratTypography.buttonText),
        ),
      ),
    );
  }
}
