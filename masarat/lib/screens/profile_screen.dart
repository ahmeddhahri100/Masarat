import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../services/supabase_service.dart';
import '../services/clerk_auth_service.dart';
import '../models/user_model.dart';
import 'premium_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = ClerkAuthService.userId;
    final userName = ClerkAuthService.userName;

    return Scaffold(
      backgroundColor: MasaratColors.surface,
      body: userId == null
          ? _buildGuestView(context)
          : FutureBuilder<UserModel?>(
              future: SupabaseService.getUserProfile(userId),
              builder: (context, snapshot) {
                final userProfile = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 72, 24, 40),
                        decoration: const BoxDecoration(
                          gradient: MasaratColors.primaryGradient,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Icon(Icons.person_rounded,
                                      color: Colors.white, size: 44),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: MasaratColors.primaryFixed,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: MasaratColors.primary, width: 2),
                                    ),
                                    child: const Icon(Icons.verified_rounded,
                                        color: MasaratColors.primary, size: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userName ?? userName ?? 'User',
                              style: MasaratTypography.headlineMedium
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            if (userProfile?.isPremium ?? true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'PREMIUM MEMBER',
                                  style: MasaratTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _StatBadge(
                                    label: 'Trips',
                                    value: '${userProfile?.tripsCount ?? 24}'),
                                Container(
                                    width: 1,
                                    height: 24,
                                    color: Colors.white.withOpacity(0.3),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24)),
                                _StatBadge(
                                    label: 'Rating',
                                    value: '${userProfile?.rating ?? 4.9} ★'),
                                Container(
                                    width: 1,
                                    height: 24,
                                    color: Colors.white.withOpacity(0.3),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24)),
                                _StatBadge(
                                    label: 'Reviews',
                                    value: '${userProfile?.reviewsCount ?? 18}'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _ProfileTile(
                                icon: Icons.edit_outlined,
                                title: 'Edit Profile',
                                subtitle: 'Update your info',
                                onTap: () {}),
                            _ProfileTile(
                                icon: Icons.history_rounded,
                                title: 'Journey History',
                                subtitle: 'View past trips',
                                onTap: () {}),
                            _ProfileTile(
                                icon: Icons.stars_rounded,
                                title: 'Premium Subscription',
                                subtitle: 'Manage your plan',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const PremiumScreen()),
                                  );
                                }),
                            _ProfileTile(
                                icon: Icons.settings_outlined,
                                title: 'Settings',
                                subtitle: 'Notifications & more',
                                onTap: () {}),
                            const SizedBox(height: 24),
                            _ProfileTile(
                                icon: Icons.logout_rounded,
                                title: 'Logout',
                                subtitle: '',
                                onTap: () async {
                                  await ClerkAuthService.signOut();
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (_) => const WelcomeScreen()),
                                      (route) => false,
                                    );
                                  }
                                },
                                isDestructive: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline_rounded,
                size: 72, color: MasaratColors.onSurfaceVariant.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Sign in to view your profile',
                style: MasaratTypography.bodyLarge),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('Go to Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: MasaratTypography.headlineSmall
                .copyWith(color: Colors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: MasaratTypography.labelSmall
                .copyWith(color: Colors.white70)),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? MasaratColors.tertiary : MasaratColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? MasaratColors.tertiaryFixed
                        : MasaratColors.primaryFixed,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: MasaratTypography.labelLarge.copyWith(
                          color: isDestructive
                              ? MasaratColors.tertiary
                              : MasaratColors.onSurface,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(subtitle, style: MasaratTypography.labelSmall),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: MasaratColors.outlineVariant, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
