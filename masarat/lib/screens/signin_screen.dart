import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';

/// Sign In — same Stitch "Sign Up & Profile Setup" design language:
/// editorial header + white form card + trust badge + social proof + footer.
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

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = ClerkAuth.of(context, listen: false);
      await auth.attemptSignIn(
        strategy: clerk.Strategy.password,
        identifier: email,
        password: password,
      );

      if (!mounted) return;

      if (auth.isSignedIn) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        if (mounted) {
          _showError(
              'Sign in needs one more step in Clerk (e.g. email verification). Check your inbox, then try again.');
        }
      }
    } on clerk.ClerkError catch (e) {
      debugPrint('[SignIn] Clerk error: $e');
      if (mounted) _showError(_friendlyError(e.toString()));
    } catch (e) {
      debugPrint('[SignIn] Error: $e');
      if (mounted) _showError('Sign in failed. Please check your credentials.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Clerk server messages are verbose — keep the useful part.
  String _friendlyError(String raw) {
    var msg = raw.replaceFirst(RegExp(r'^\[.*?\] '), '').trim();
    if (msg.length > 160) msg = '${msg.substring(0, 157)}...';
    return msg.isEmpty ? 'Something went wrong. Please try again.' : msg;
  }

  /// Never pop an empty stack (black screen) — fall back to onboarding.
  void _goBack() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      nav.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        (route) => false,
      );
    }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: _goBack,
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/masarat_logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Text(
                      'masarat',
                      style: MasaratTypography.headlineSmall.copyWith(
                        color: MasaratColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Editorial header
              RichText(
                text: TextSpan(
                  style: MasaratTypography.headlineLarge.copyWith(fontSize: 34),
                  children: const [
                    TextSpan(text: 'Welcome\n'),
                    TextSpan(
                      text: 'Back',
                      style: TextStyle(color: MasaratColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in to coordinate your next shared trip with the community.',
                style: MasaratTypography.bodyMedium.copyWith(
                  color: MasaratColors.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // Form card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MasaratColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A191C1D),
                      blurRadius: 32,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in to your account',
                      style: MasaratTypography.headlineMedium.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter your credentials to continue.',
                      style: MasaratTypography.bodyMedium.copyWith(
                        color: MasaratColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _FieldLabel('Email Address'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'name@company.com',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _FieldLabel('Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onSubmitted: (_) => _handleSignIn(),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: MasaratColors.onSurfaceVariant,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset coming soon'),
                          ),
                        ),
                        child: Text(
                          'Forgot password?',
                          style: MasaratTypography.bodyMedium.copyWith(
                            fontSize: 13,
                            color: MasaratColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _GradientButton(
                      label: 'Sign In',
                      isLoading: _isLoading,
                      onPressed: _handleSignIn,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: MasaratTypography.bodyMedium
                                .copyWith(fontSize: 13),
                            children: [
                              const TextSpan(
                                  text: "Don't have an account? "),
                              TextSpan(
                                text: 'Sign Up',
                                style: MasaratTypography.bodyMedium.copyWith(
                                  fontSize: 13,
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
              const SizedBox(height: 20),

              // Trust badge
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: MasaratColors.secondaryFixed.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                    left: BorderSide(color: MasaratColors.primary, width: 4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      color: MasaratColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trust & Community',
                            style: MasaratTypography.headlineSmall.copyWith(
                              fontSize: 16,
                              color: MasaratColors.onSecondaryFixed,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Every profile is manually verified to ensure a premium, safe environment for our Tunisian members.',
                            style: MasaratTypography.bodyMedium.copyWith(
                              fontSize: 13,
                              color: MasaratColors.onSecondaryFixed,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Social proof
              Row(
                children: [
                  SizedBox(
                    width: 88,
                    height: 40,
                    child: Stack(
                      children: const [
                        Positioned(
                          left: 0,
                          child:
                              _AvatarChip(label: 'A', color: Color(0xFF2D6A4F)),
                        ),
                        Positioned(
                          left: 24,
                          child:
                              _AvatarChip(label: 'Y', color: Color(0xFF51625B)),
                        ),
                        Positioned(
                          left: 48,
                          child:
                              _AvatarChip(label: 'S', color: Color(0xFF713638)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style:
                            MasaratTypography.bodyMedium.copyWith(fontSize: 13),
                        children: const [
                          TextSpan(text: 'Joined by '),
                          TextSpan(
                            text: '2,400+',
                            style: TextStyle(
                              color: MasaratColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' professionals in Tunis.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Footer utility
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: MasaratColors.onSurfaceVariant.withOpacity(0.4),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'SECURE DATA',
                    style: MasaratTypography.labelSmall.copyWith(
                      color: MasaratColors.onSurfaceVariant.withOpacity(0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Icon(
                    Icons.handshake_outlined,
                    size: 14,
                    color: MasaratColors.onSurfaceVariant.withOpacity(0.4),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'TUNISIAN NETWORK',
                    style: MasaratTypography.labelSmall.copyWith(
                      color: MasaratColors.onSurfaceVariant.withOpacity(0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
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

// ── Shared bits (mirrors signup_screen) ────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: MasaratTypography.labelSmall.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [MasaratColors.primary, MasaratColors.primaryContainer],
            begin: Alignment(0.86, -0.5),
            end: Alignment(-0.86, 0.5),
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x400F5238),
              blurRadius: 16,
              offset: Offset(0, 8),
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
              : Text(
                  label,
                  style: MasaratTypography.buttonText.copyWith(fontSize: 17),
                ),
        ),
      ),
    );
  }
}

class _AvatarChip extends StatelessWidget {
  final String label;
  final Color color;
  const _AvatarChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MasaratColors.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
