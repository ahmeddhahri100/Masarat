import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import 'home_screen.dart';
import 'signin_screen.dart';
import 'onboarding_screen.dart';

/// Sign Up — 2-step flow ported from Stitch "Sign Up & Profile Setup (Updated)".
/// Step 1: Create your account (name / email / password / role).
/// Step 2: Complete your profile (avatar / hometown / phone).
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _step = 0;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  String _role = 'passenger'; // Stitch default: Passenger selected
  String? _hometown;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isVerifying = false;

  final _codeController = TextEditingController();
  String _verifyEmail = '';

  static const _cities = [
    'Tunis',
    'Sfax',
    'Sousse',
    'Hammamet',
    'Nabeul',
    'Monastir',
    'Bizerte',
    'Gabès',
    'Ariana',
    'Kairouan',
  ];

  void _goNext() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    setState(() => _step = 1);
  }

  Future<void> _handleFinalize() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);
    try {
      final auth = ClerkAuth.of(context, listen: false);
      final nameParts = name.split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.skip(1).join(' ') : null;

      await auth.attemptSignUp(
        strategy: clerk.Strategy.password,
        emailAddress: email,
        password: password,
        passwordConfirmation: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (!mounted) return;

      if (auth.isSignedIn) {
        // TODO: persist _role / _hometown / _phoneController.text to `profiles`.
        _goHome();
        return;
      }

      // Not signed in yet → Clerk wants email verification.
      // Request the one-time code, then show the code screen.
      await auth.attemptSignUp(strategy: clerk.Strategy.emailCode);
      if (!mounted) return;
      if (auth.isSignedIn) {
        _goHome();
        return;
      }
      setState(() {
        _verifyEmail = email;
        _step = 2;
      });
      _showInfo('We sent a 6-digit code to $email', isSuccess: true);
    } on clerk.ClerkError catch (e) {
      debugPrint('[SignUp] Clerk error: $e');
      if (mounted) _showError(_friendlyError(e.toString()));
    } catch (e) {
      debugPrint('[SignUp] Error: $e');
      if (mounted) _showError('Sign up failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleVerifyCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      _showError('Please enter the 6-digit code from your email');
      return;
    }
    setState(() => _isVerifying = true);
    try {
      final auth = ClerkAuth.of(context, listen: false);
      await auth.attemptSignUp(
        strategy: clerk.Strategy.emailCode,
        code: code,
      );
      if (!mounted) return;
      if (auth.isSignedIn) {
        _goHome();
      } else {
        _showError('That code did not work. Check it and try again.');
      }
    } on clerk.ClerkError catch (e) {
      debugPrint('[SignUp] Verify error: $e');
      if (mounted) _showError(_friendlyError(e.toString()));
    } catch (e) {
      debugPrint('[SignUp] Verify error: $e');
      if (mounted) _showError('Verification failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _handleResendCode() async {
    setState(() => _isVerifying = true);
    try {
      final auth = ClerkAuth.of(context, listen: false);
      await auth.attemptSignUp(strategy: clerk.Strategy.emailCode);
      if (mounted) _showInfo('Code resent to $_verifyEmail', isSuccess: true);
    } on clerk.ClerkError catch (e) {
      if (mounted) _showError(_friendlyError(e.toString()));
    } catch (e) {
      if (mounted) _showError('Could not resend code. Try again.');
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  /// Clerk server messages are verbose — keep the useful part.
  String _friendlyError(String raw) {
    var msg = raw.replaceFirst(RegExp(r'^\[.*?\] '), '').trim();
    if (msg.length > 160) msg = '${msg.substring(0, 157)}...';
    return msg.isEmpty ? 'Something went wrong. Please try again.' : msg;
  }

  /// Back arrow: step back through the flow; never pop an empty stack
  /// (that showed a black screen) — fall back to onboarding instead.
  void _goBack() {
    if (_step > 0) {
      setState(() => _step--);
      return;
    }
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

  void _showInfo(String message, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isSuccess ? MasaratColors.primary : MasaratColors.onSurfaceVariant,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // System back button: walk back through the steps instead of leaving
    // the flow (and never pop an empty stack → black screen).
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0 && mounted) setState(() => _step--);
      },
      child: Scaffold(
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

              // Editorial header (Stitch left side, stacked on mobile)
              RichText(
                text: TextSpan(
                  style: MasaratTypography.headlineLarge.copyWith(fontSize: 34),
                  children: const [
                    TextSpan(text: 'The Curated\n'),
                    TextSpan(
                      text: 'Journey Begins',
                      style: TextStyle(color: MasaratColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Join a community of professional commuters who value safety, reliability, and shared experiences.',
                style: MasaratTypography.bodyMedium.copyWith(
                  color: MasaratColors.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // Form card (Stitch right side)
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
                    // Progress indicator
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: MasaratColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: _step >= 1
                                  ? MasaratColors.primary
                                  : MasaratColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    if (_step == 0)
                      _buildAccountStep()
                    else if (_step == 1)
                      _buildProfileStep()
                    else
                      _buildVerifyStep(),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Trust badge (Stitch requirement)
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
                          child: _AvatarChip(label: 'A', color: Color(0xFF2D6A4F)),
                        ),
                        Positioned(
                          left: 24,
                          child: _AvatarChip(label: 'Y', color: Color(0xFF51625B)),
                        ),
                        Positioned(
                          left: 48,
                          child: _AvatarChip(label: 'S', color: Color(0xFF713638)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: MasaratTypography.bodyMedium.copyWith(fontSize: 13),
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
      ),
    );
  }

  // ── Step 1: account ──────────────────────────────────────────────
  Widget _buildAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create your account', style: MasaratTypography.headlineMedium.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          'Enter your details to get started.',
          style: MasaratTypography.bodyMedium.copyWith(
            color: MasaratColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 24),
        const _FieldLabel('Full Name'),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'John Doe'),
        ),
        const SizedBox(height: 20),
        const _FieldLabel('Email Address'),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'name@company.com'),
        ),
        const SizedBox(height: 20),
        const _FieldLabel('Password'),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
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
        const SizedBox(height: 24),
        const _FieldLabel('I want to join as a'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RoleCard(
                selected: _role == 'driver',
                icon: Icons.directions_car_outlined,
                title: 'Driver',
                subtitle: 'I want to offer rides and share commuting costs.',
                onTap: () => setState(() => _role = 'driver'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RoleCard(
                selected: _role == 'passenger',
                icon: Icons.person_outline_rounded,
                title: 'Passenger',
                subtitle: 'I want to find reliable rides for my commute.',
                onTap: () => setState(() => _role = 'passenger'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _GradientButton(label: 'Next Step', icon: Icons.arrow_forward_rounded, onPressed: _goNext),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "By clicking Next, you agree to Masarat's Terms of Service.",
            textAlign: TextAlign.center,
            style: MasaratTypography.bodyMedium.copyWith(
              fontSize: 12,
              color: MasaratColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            ),
            child: RichText(
              text: TextSpan(
                style: MasaratTypography.bodyMedium.copyWith(fontSize: 13),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Sign In',
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
    );
  }

  // ── Step 2: profile ──────────────────────────────────────────────
  Widget _buildProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Complete your profile', style: MasaratTypography.headlineMedium.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          'Let the community know you.',
          style: MasaratTypography.bodyMedium.copyWith(
            color: MasaratColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: MasaratColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: MasaratColors.secondaryFixed, width: 4),
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  size: 36,
                  color: MasaratColors.outlineVariant,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: MasaratColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _FieldLabel('Hometown'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _hometown,
          hint: Text(
            'Select City',
            style: MasaratTypography.bodyMedium.copyWith(
              color: MasaratColors.outlineVariant,
            ),
          ),
          items: _cities
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) => setState(() => _hometown = v),
        ),
        const SizedBox(height: 20),
        const _FieldLabel('Phone Number (Optional)'),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: '+216 -- --- ---'),
        ),
        const SizedBox(height: 24),
        _GradientButton(
          label: 'Finalize Profile',
          isLoading: _isLoading,
          onPressed: _handleFinalize,
        ),
      ],
    );
  }

  // ── Step 3: email verification ───────────────────────────────────
  Widget _buildVerifyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check your email',
            style:
                MasaratTypography.headlineMedium.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: MasaratTypography.bodyMedium.copyWith(
              color: MasaratColors.onSurfaceVariant,
              fontSize: 13,
            ),
            children: [
              const TextSpan(text: 'We sent a 6-digit code to '),
              TextSpan(
                text: _verifyEmail,
                style: const TextStyle(
                  color: MasaratColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _FieldLabel('Verification Code'),
        const SizedBox(height: 8),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: MasaratTypography.headlineMedium.copyWith(
            letterSpacing: 8,
            fontSize: 24,
          ),
          decoration: const InputDecoration(
            hintText: '••••••',
            counterText: '',
          ),
          onSubmitted: (_) => _handleVerifyCode(),
        ),
        const SizedBox(height: 24),
        _GradientButton(
          label: 'Verify & Continue',
          isLoading: _isVerifying,
          onPressed: _handleVerifyCode,
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: _isVerifying ? null : _handleResendCode,
            child: Text(
              'Didn\'t get the code? Resend',
              style: MasaratTypography.bodyMedium.copyWith(
                fontSize: 13,
                color: MasaratColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}

// ── Shared bits ────────────────────────────────────────────────────

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

class _RoleCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _RoleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? MasaratColors.primaryFixed.withOpacity(0.2)
              : MasaratColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? MasaratColors.primary : MasaratColors.outlineVariant,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: MasaratColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: MasaratTypography.headlineSmall.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: MasaratTypography.bodyMedium.copyWith(
                fontSize: 11,
                height: 1.4,
                color: MasaratColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
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
            begin: Alignment(0.86, -0.5), // ~150deg per Stitch spec
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
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: MasaratTypography.buttonText.copyWith(fontSize: 17),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(icon, color: Colors.white, size: 20),
                    ],
                  ],
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
