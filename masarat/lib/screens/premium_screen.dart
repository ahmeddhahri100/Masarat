import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masarat Premium')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.stars, size: 80, color: MasaratColors.primary),
            const SizedBox(height: 24),
            Text('Elevate Your Journey', style: MasaratTypography.headlineLarge, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              'Join the premium community for exclusive benefits and unlimited coordination.',
              style: MasaratTypography.bodyMedium.copyWith(color: MasaratColors.onSurface.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _BenefitItem(icon: Icons.all_inclusive, title: 'Unlimited Trip Posts', subtitle: 'No weekly limits on shared trips.'),
            _BenefitItem(icon: Icons.trending_up, title: 'Priority Visibility', subtitle: 'Your trips appear higher in the feed.'),
            _BenefitItem(icon: Icons.verified_user, title: 'Premium Badge', subtitle: 'Show your commitment to the community.'),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MasaratColors.primary,
                borderRadius: BorderRadius.circular(24),
                gradient: MasaratColors.primaryGradient,
              ),
              child: Column(
                children: [
                  Text('5 TND / Month', style: MasaratTypography.headlineLarge.copyWith(color: Colors.white, fontSize: 28)),
                  const SizedBox(height: 8),
                  Text('Digital Membership', style: MasaratTypography.labelMedium.copyWith(color: Colors.white70)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: MasaratColors.primary),
                    child: const Text('Upgrade Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _BenefitItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Icon(icon, color: MasaratColors.primary, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: MasaratTypography.labelMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
