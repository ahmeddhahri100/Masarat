import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

// ── Exact Stitch "Obsidian Emerald Mobility" color tokens ─────────────────
class _C {
  static const bg           = Color(0xFF0F1512); // background
  static const surface      = Color(0xFF0F1512);
  static const surfaceCL    = Color(0xFF090F0C); // surface-container-lowest
  static const surfaceC     = Color(0xFF1B211E); // surface-container
  static const surfaceDim   = Color(0xFF0F1512); // surface-dim
  static const onSurface    = Color(0xFFDEE4DE);
  static const onSurfaceVar = Color(0xFFBFC9C1);
  static const outlineVar   = Color(0xFF404943);
  static const outline      = Color(0xFF8A938C);
  static const primary      = Color(0xFF95D4B2);
  static const primaryCont  = Color(0xFF0F5238); // primary-container
  static const secondary    = Color(0xFF75DAA8);
  static const secondaryCont= Color(0xFF008056); // secondary-container
  static const tertiary     = Color(0xFF4DE082);
  static const tertiaryCont = Color(0xFF005428); // tertiary-container
  static const onPrimary    = Color(0xFF003824);
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.35, end: 0.6).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Make status bar transparent so our background shows through
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _C.surfaceCL,
      body: Stack(
        children: [
          // ── 1. Full-screen hero background image ──────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/welcome_bg.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.05),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // ── 2. Main vignette gradient (from-#080E0B/85 via-transparent to-#080E0B/95) ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xD9080E0B), // /85
                    Color(0x4D080E0B), // /30
                    Color(0xF2080E0B), // /95
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── 3. Top header gradient ─────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            height: 160,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF060B08), Color(0xB308100C), Colors.transparent],
                ),
              ),
            ),
          ),

          // ── 4. Ambient emerald glow spots ─────────────────────────────
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (_, __) => Stack(
              children: [
                // Center glow (secondary-container/20)
                Positioned(
                  top: size.height * 0.25 - 144,
                  left: size.width / 2 - 144,
                  child: Opacity(
                    opacity: _glowAnim.value,
                    child: Container(
                      width: 288, height: 288,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _C.secondaryCont.withOpacity(0.20),
                      ),
                    ),
                  ),
                ),
                // Bottom-right glow (tertiary-container/25)
                Positioned(
                  bottom: size.height / 3 - 112,
                  right: 16,
                  child: Container(
                    width: 224, height: 224,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.tertiaryCont.withOpacity(0.25),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── 5. Main UI layout ──────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Status bar row (simulated) ───────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('9:41',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, fontWeight: FontWeight.w500,
                              color: _C.onSurfaceVar, letterSpacing: -0.2)),
                      Row(
                        children: const [
                          Icon(Icons.signal_cellular_alt, size: 13, color: _C.onSurfaceVar),
                          SizedBox(width: 6),
                          Icon(Icons.wifi, size: 13, color: _C.onSurfaceVar),
                          SizedBox(width: 6),
                          Icon(Icons.battery_full, size: 13, color: _C.onSurfaceVar),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── App bar row ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location pill
                      _GlassPill(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language, size: 16, color: _C.primary),
                            const SizedBox(width: 6),
                            Text('Tunisia • تونس',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10, fontWeight: FontWeight.w700,
                                    color: _C.onSurfaceVar, letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                      // Language switcher
                      _GlassPill(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('عربي',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12, fontWeight: FontWeight.w700,
                                    color: _C.primary)),
                            Text(' / ',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10, color: _C.outline)),
                            Text('FR',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11, color: _C.onSurfaceVar)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Main content (bottom-anchored like Stitch) ───────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo badge ─────────────────────────────────────
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Glow halo
                          Positioned(
                            left: -4, top: -4, right: -4, bottom: -4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    _C.secondaryCont.withOpacity(0.40),
                                    _C.tertiaryCont.withOpacity(0.30),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Badge itself
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xE611201A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _C.secondary.withOpacity(0.30), width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1F000000),
                                  blurRadius: 12, offset: Offset(0, 4)),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/masarat_logo.png',
                              fit: BoxFit.contain,
                              color: const Color(0xFF4ADE80),
                              colorBlendMode: BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── MASARAT + مسارات inline ─────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('MASARAT',
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 26, fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5)),
                          const SizedBox(width: 12),
                          Text('مسارات',
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18, fontWeight: FontWeight.w700,
                                  color: _C.primary, letterSpacing: 0.5)),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // ── Tagline (h2) ─────────────────────────────────────
                      Text(
                        'Your community journey starts here.',
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 18, fontWeight: FontWeight.w600,
                            color: _C.onSurface, height: 1.35),
                      ),

                      const SizedBox(height: 8),

                      // ── Mission statement ────────────────────────────────
                      Text(
                        'Beyond just travel, we are building a network of trust, reliability, and comfort across Tunisia.',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14, fontWeight: FontWeight.w400,
                            color: _C.onSurfaceVar, height: 1.6),
                      ),

                      const SizedBox(height: 24),

                      // ── Proof pills ──────────────────────────────────────
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: const [
                          _ProofPill(
                            icon: Icons.verified_user,
                            label: 'Verified Drivers',
                            iconColor: _C.secondary,
                          ),
                          _ProofPill(
                            icon: Icons.route,
                            label: 'Intercity & Urban',
                            iconColor: _C.primary,
                          ),
                          _ProofPill(
                            icon: Icons.location_on,
                            label: 'Tunis • Sousse • Sfax',
                            iconColor: _C.outline,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Glassmorphic action card ─────────────────────────
                      _ActionCard(
                        onSignIn: () => Navigator.push(
                            context, _fade(const SignInScreen())),
                        onCreateAccount: () => Navigator.push(
                            context, _fade(const SignUpScreen())),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Home indicator line ──────────────────────────────────
                Center(
                  child: Container(
                    width: 128, height: 4,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: _C.outlineVar.withOpacity(0.40),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      );
}

// ── Glass pill chip (top bar) ─────────────────────────────────────────────────
class _GlassPill extends StatelessWidget {
  final Widget child;
  const _GlassPill({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _C.surfaceDim.withOpacity(0.60),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _C.outlineVar.withOpacity(0.30), width: 1),
        ),
        child: child,
      );
}

// ── Proof pill ────────────────────────────────────────────────────────────────
class _ProofPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  const _ProofPill({required this.icon, required this.label, required this.iconColor});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xCC11201A),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _C.outlineVar.withOpacity(0.30), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: _C.onSurface)),
          ],
        ),
      );
}

// ── Glassmorphic action card ──────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;
  const _ActionCard({required this.onSignIn, required this.onCreateAccount});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xBF11201A),  // /75
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.primaryCont.withOpacity(0.20), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0xB3000000),
              blurRadius: 32, spreadRadius: -4,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // Primary: Sign In
            _SignInButton(onPressed: onSignIn),
            const SizedBox(height: 12),
            // Secondary: Create Account
            _CreateAccountButton(onPressed: onCreateAccount),
            const SizedBox(height: 12),
            // Legal
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: _C.outlineVar.withOpacity(0.90),
                    height: 1.4),
                children: [
                  const TextSpan(text: "By continuing, you agree to MASARAT's "),
                  TextSpan(text: 'Terms',
                      style: TextStyle(color: _C.primary, fontWeight: FontWeight.w500)),
                  const TextSpan(text: ' & '),
                  TextSpan(text: 'Privacy Policy',
                      style: TextStyle(color: _C.primary, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      );
}

// Sign In — gradient from tertiary to secondary, dark text
class _SignInButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _SignInButton({required this.onPressed});
  @override
  State<_SignInButton> createState() => _SignInButtonState();
}
class _SignInButtonState extends State<_SignInButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onPressed(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: double.infinity, height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [_C.tertiary, _C.secondary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ADE80).withOpacity(0.30),
                  blurRadius: 20, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign In',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: _C.onPrimary, letterSpacing: 0.3)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 20, color: _C.onPrimary),
              ],
            ),
          ),
        ),
      );
}

// Create Account — ghost outlined
class _CreateAccountButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _CreateAccountButton({required this.onPressed});
  @override
  State<_CreateAccountButton> createState() => _CreateAccountButtonState();
}
class _CreateAccountButtonState extends State<_CreateAccountButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onPressed(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: double.infinity, height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _pressed
                  ? const Color(0x2652B788)
                  : const Color(0x1A52B788),
              border: Border.all(
                color: const Color(0x4D52B788), width: 1),
            ),
            child: Center(
              child: Text('Create Account',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: _C.onSurface, letterSpacing: 0.3)),
            ),
          ),
        ),
      );
}

