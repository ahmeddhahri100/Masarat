import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

/// Onboarding — exact port of Stitch "Onboarding with Animated Welcome".
/// 3 slides (Welcome / Shared Trips / Trust & Safety) + fixed footer actions.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goTo(int page) => _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      body: Stack(
        children: [
          // Background accents (Stitch blur blobs)
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 240,
              height: 200,
              decoration: BoxDecoration(
                color: MasaratColors.primaryFixed.withOpacity(0.20),
                borderRadius: BorderRadius.circular(120),
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            left: -40,
            child: Container(
              width: 160,
              height: 140,
              decoration: BoxDecoration(
                color: MasaratColors.secondaryFixed.withOpacity(0.30),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Logo header (Stitch: fixed top, branding only)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/masarat_logo.png',
                        height: 48,
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
                ),
                // Slides
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) =>
                        setState(() => _currentPage = i),
                    children: const [
                      _WelcomeSlide(),
                      _SharedTripsSlide(),
                      _TrustSlide(),
                    ],
                  ),
                ),
                // Dots (Stitch: left-aligned above footer)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 32, right: 32, bottom: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () => _goTo(0),
                          child: _Dot(active: _currentPage == 0)),
                      const SizedBox(width: 6),
                      GestureDetector(
                          onTap: () => _goTo(1),
                          child: _Dot(active: _currentPage == 1)),
                      const SizedBox(width: 6),
                      GestureDetector(
                          onTap: () => _goTo(2),
                          child: _Dot(active: _currentPage == 2)),
                    ],
                  ),
                ),
                // Fixed action controls (Stitch footer)
                _ActionFooter(currentPage: _currentPage, onNext: () {
                  if (_currentPage < 2) {
                    _goTo(_currentPage + 1);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: active ? 32 : 6,
      decoration: BoxDecoration(
        color: active
            ? MasaratColors.primary
            : MasaratColors.outlineVariant,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String text;
  const _Eyebrow(this.text);

  @override
  Widget build(BuildContext context) {
    return _FadeUp(
      delayMs: 0,
      child: Text(
        text.toUpperCase(),
        style: MasaratTypography.labelSmall.copyWith(
          color: MasaratColors.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SlideTitle extends StatelessWidget {
  final String text;
  const _SlideTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return _FadeUp(
      delayMs: 200,
      child: Text(
        text,
        style: MasaratTypography.headlineLarge.copyWith(fontSize: 32),
      ),
    );
  }
}

/// Staggered fade+slide-up (Stitch animate-scroll-up-fade).
class _FadeUp extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _FadeUp({required this.child, this.delayMs = 0});

  @override
  State<_FadeUp> createState() => _FadeUpState();
}

class _FadeUpState extends State<_FadeUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _ctrl, curve: const Cubic(0.16, 1, 0.3, 1)));
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

// ── Slide 1: Welcome ──────────────────────────────────────────────
class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Eyebrow('The Heart of Tunisian Carpooling'),
          const SizedBox(height: 8),
          const _SlideTitle('Welcome to Masarat'),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _PhotoTile(
                      height: 190,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: MasaratColors.secondaryFixed,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.groups_rounded,
                          size: 36,
                          color: MasaratColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: const [
                      _PhotoTile(
                        height: 190,
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(height: 12),
                      _PhotoTile(
                        height: 130,
                        alignment: Alignment.center,
                        opacity: 0.85,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final double height;
  final Alignment alignment;
  final double opacity;
  const _PhotoTile({
    required this.height,
    required this.alignment,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
          image: const DecorationImage(
            image: AssetImage('assets/welcome_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(alignment: alignment),
      ),
    );
  }
}

// ── Slide 2: Shared Trips ─────────────────────────────────────────
class _SharedTripsSlide extends StatelessWidget {
  const _SharedTripsSlide();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MasaratColors.surfaceContainerLow,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/welcome_bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: MasaratColors.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Verified Members',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: MasaratColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const _Eyebrow('Journey Together'),
            const SizedBox(height: 8),
            const _SlideTitle('Shared Trips'),
            const SizedBox(height: 12),
            Text(
              'Join existing journeys and share costs with verified members. Sustainable travel for the modern commuter.',
              style: MasaratTypography.bodyLarge.copyWith(
                color: MasaratColors.onSurfaceVariant,
                fontSize: 17,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Slide 3: Trust & Safety ───────────────────────────────────────
class _TrustSlide extends StatelessWidget {
  const _TrustSlide();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _PhotoTile(
                  height: 220,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 220,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: MasaratColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.chat_bubble_rounded,
                              size: 44,
                              color: MasaratColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: MasaratColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Private &\nSecure',
                            style: MasaratTypography.headlineSmall.copyWith(
                              color: Colors.white,
                              fontSize: 19,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const _Eyebrow('Human Centric'),
          const SizedBox(height: 8),
          const _SlideTitle('Trust & Safety'),
          const SizedBox(height: 12),
          Text(
            'Coordinated coordination through private chat. No taxi-style booking, just real people making real plans.',
            style: MasaratTypography.bodyLarge.copyWith(
              color: MasaratColors.onSurfaceVariant,
              fontSize: 17,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Fixed footer (Stitch) ─────────────────────────────────────────
class _ActionFooter extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNext;
  const _ActionFooter({required this.currentPage, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 12, 32, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MasaratColors.surface.withOpacity(0.0),
            MasaratColors.surface,
            MasaratColors.surface,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Pressable(
            onTap: () {
              if (currentPage < 2) {
                onNext();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                );
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: MasaratColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: MasaratColors.primary.withOpacity(0.20),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                currentPage < 2 ? 'Get Started' : 'Get Started',
                style: MasaratTypography.headlineSmall.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _Pressable(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: MasaratColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                'Sign In',
                style: MasaratTypography.headlineSmall.copyWith(
                  color: MasaratColors.primary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _Pressable(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Google sign-in coming soon')),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: MasaratColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: MasaratColors.outlineVariant.withOpacity(0.4),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: MasaratColors.outlineVariant),
                    ),
                    child: const Text(
                      'G',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4285F4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: MasaratTypography.headlineSmall.copyWith(
                      fontSize: 17,
                      color: MasaratColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _Pressable(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Facebook sign-in coming soon')),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1877F2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1877F2).withOpacity(0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.facebook_rounded,
                      size: 22, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Continue with Facebook',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Pressable({required this.child, required this.onTap});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: widget.child,
      ),
    );
  }
}
