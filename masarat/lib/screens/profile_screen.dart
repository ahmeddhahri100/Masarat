import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import 'premium_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 64, bottom: 48),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: MasaratColors.primary,
                gradient: MasaratColors.primaryGradient,
              ),
              child: Column(
                children: [
                  const Stack(
                    children: [
                      CircleAvatar(radius: 50, backgroundColor: MasaratColors.secondaryFixed),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(Icons.verified, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Ahmed Dhahri', style: MasaratTypography.headlineMedium.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: Text('PREMIUM MEMBER', style: MasaratTypography.labelMedium.copyWith(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _ProfileTile(icon: Icons.edit_outlined, title: 'Edit Profile', onTap: () {}),
                  _ProfileTile(icon: Icons.history, title: 'Journey History', onTap: () {}),
                  _ProfileTile(icon: Icons.stars_outlined, title: 'Premium Subscription', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen()));
                  }),
                  _ProfileTile(icon: Icons.settings_outlined, title: 'Settings', onTap: () {}),
                  const SizedBox(height: 32),
                  _ProfileTile(icon: Icons.logout, title: 'Logout', isDestructive: true, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileTile({required this.icon, required this.title, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? Colors.red : MasaratColors.primary),
      title: Text(title, style: MasaratTypography.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: isDestructive ? Colors.red : MasaratColors.onSurface,
      )),
      trailing: const Icon(Icons.chevron_right, size: 16),
      contentPadding: EdgeInsets.zero,
    );
  }
}
