import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(title: const Text('Masarat Premium')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: MasaratColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.stars_rounded,
                        color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Elevate Your Journey',
                    style: MasaratTypography.headlineMedium
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Unlock the full Masarat experience with unlimited features.',
                    style: MasaratTypography.bodyMedium
                        .copyWith(color: Colors.white70, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Benefits
            Text('What you get', style: MasaratTypography.titleMedium),
            const SizedBox(height: 20),
            _BenefitItem(
              icon: Icons.all_inclusive_rounded,
              title: 'Unlimited Trip Posts',
              subtitle: 'No weekly limits. Post whenever you travel.',
            ),
            _BenefitItem(
              icon: Icons.trending_up_rounded,
              title: 'Priority Visibility',
              subtitle: 'Your trips appear at the top of the feed.',
            ),
            _BenefitItem(
              icon: Icons.verified_user_rounded,
              title: 'Premium Badge',
              subtitle: 'Signal your commitment to the community.',
            ),
            _BenefitItem(
              icon: Icons.support_agent_rounded,
              title: 'Priority Support',
              subtitle: 'Get help faster when you need it.',
            ),
            const SizedBox(height: 32),

            // Pricing card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MasaratColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: MasaratColors.onSurface.withOpacity(0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text('5 TND',
                      style: MasaratTypography.displayMedium
                          .copyWith(color: MasaratColors.primary)),
                  Text('/month',
                      style: MasaratTypography.labelMedium
                          .copyWith(color: MasaratColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Text('Digital Membership',
                      style: MasaratTypography.labelSmall),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {},
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
                        child: Text('Upgrade Now',
                            style: MasaratTypography.buttonText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
  const _BenefitItem(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: MasaratColors.primaryFixed,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: MasaratColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: MasaratTypography.labelLarge),
                const SizedBox(height: 3),
                Text(subtitle, style: MasaratTypography.labelSmall.copyWith(height: 1.4)),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded,
              color: MasaratColors.primary, size: 20),
        ],
      ),
    );
  }
}
