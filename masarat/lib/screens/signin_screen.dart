import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../services/supabase_service.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  static const _authTimeout = Duration(seconds: 15);

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
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

      debugPrint('[SignIn] Attempting sign in for: $email');

      final response = await SupabaseService.client.auth
          .signInWithPassword(
            email: email,
            password: password,
          )
          .timeout(
            _authTimeout,
            onTimeout: () {
              throw TimeoutException(
                'Sign in request timed out after ${_authTimeout.inSeconds}s.',
              );
            },
          );

      if (response.user != null) {
        debugPrint('[SignIn] ✓ Sign in successful: ${response.user?.email}');

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } on TimeoutException catch (e) {
      debugPrint('[SignIn] ✗ Timeout: $e');
      _showError(
        'Connection timed out. Please check your internet connection and try again.',
      );
    } on AuthException catch (e) {
      debugPrint('[SignIn] ✗ Auth error: ${e.message} (status: ${e.statusCode})');
      final message = e.message.toLowerCase();
      if (message.contains('email') && message.contains('confirm') ||
          message.contains('not confirmed') ||
          message.contains('verify')) {
        _showEmailNotConfirmedDialog(email);
        return;
      }
      _showError(_getFriendlyAuthError(e));
    } catch (e) {
      debugPrint('[SignIn] ✗ Unexpected error: $e');
      _showError(
        'An unexpected error occurred. Please check your connection and try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getFriendlyAuthError(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid') && message.contains('login')) {
      return 'Invalid email or password. Please try again.';
    }
    if (message.contains('network') || message.contains('socket')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    if (message.contains('too many')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    return e.message;
  }

  void _showEmailNotConfirmedDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _EmailNotConfirmedDialog(email: email),
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
            Text('Welcome\nBack', style: MasaratTypography.headlineLarge),
            const SizedBox(height: 12),
            Text(
              'Sign in to coordinate your next shared trip.',
              style: MasaratTypography.bodyMedium.copyWith(
                color: MasaratColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@example.com',
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
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement password reset
                },
                child: Text(
                  'Forgot password?',
                  style: MasaratTypography.labelMedium.copyWith(
                    color: MasaratColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _GradientButton(
              label: 'Sign In',
              isLoading: _isLoading,
              onPressed: _handleSignIn,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or continue with',
                    style: MasaratTypography.labelSmall,
                  ),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    icon: Icons.g_mobiledata_rounded,
                    label: 'Google',
                    onPressed: () {
                      // TODO: Implement Google OAuth
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SocialButton(
                    icon: Icons.apple,
                    label: 'Apple',
                    onPressed: () {
                      // TODO: Implement Apple OAuth
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: RichText(
                  text: TextSpan(
                    style: MasaratTypography.bodyMedium,
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign Up',
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: MasaratColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: MasaratColors.onSurface, size: 22),
            const SizedBox(width: 8),
            Text(label, style: MasaratTypography.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _EmailNotConfirmedDialog extends StatefulWidget {
  final String email;
  const _EmailNotConfirmedDialog({required this.email});

  @override
  State<_EmailNotConfirmedDialog> createState() =>
      _EmailNotConfirmedDialogState();
}

class _EmailNotConfirmedDialogState extends State<_EmailNotConfirmedDialog> {
  bool _isResending = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Icon(
        Icons.mark_email_unread_rounded,
        size: 48,
        color: MasaratColors.primary,
      ),
      title: const Text('Email Not Confirmed'),
      content: Text(
        'Your email ${widget.email} has not been confirmed yet. Please check your inbox and spam folder for the confirmation link.',
        style: MasaratTypography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: _isResending
              ? null
              : () async {
                  setState(() => _isResending = true);
                  try {
                    await SupabaseService.client.auth.resend(
                      type: OtpType.signup,
                      email: widget.email,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Confirmation email resent to ${widget.email}'),
                          backgroundColor: MasaratColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Failed to resend. Please try again.'),
                          backgroundColor: MasaratColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  } finally {
                    if (mounted) setState(() => _isResending = false);
                  }
                },
          child: _isResending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Resend Email'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
