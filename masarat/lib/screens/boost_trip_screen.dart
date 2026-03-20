import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class BoostTripScreen extends StatelessWidget {
  const BoostTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(title: const Text('Boost Visibility')),
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
                    child: const Icon(Icons.rocket_launch_rounded,
                        color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Get Noticed Faster',
                    style: MasaratTypography.headlineMedium
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Boosted trips appear at the top of search results and in a special carousel on the home screen.',
                    style: MasaratTypography.bodyMedium
                        .copyWith(color: Colors.white70, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('Select a boost duration', style: MasaratTypography.titleMedium),
            const SizedBox(height: 20),

            _BoostCard(
              title: '24H Flash Boost',
              duration: 'Expires in 24 hours',
              price: '2 TND',
              isSelected: true,
            ),
            const SizedBox(height: 16),
            _BoostCard(
              title: '72H Mega Boost',
              duration: 'Expires in 3 days',
              price: '5 TND',
              isSelected: false,
            ),

            const SizedBox(height: 48),
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
                  child: Text('Confirm & Boost',
                      style: MasaratTypography.buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoostCard extends StatelessWidget {
  final String title;
  final String duration;
  final String price;
  final bool isSelected;

  const _BoostCard({
    required this.title,
    required this.duration,
    required this.price,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected
            ? MasaratColors.primaryFixed.withOpacity(0.2)
            : MasaratColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? MasaratColors.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: MasaratColors.onSurface.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? MasaratColors.primary : MasaratColors.primaryFixed,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.bolt_rounded,
                color: isSelected ? Colors.white : MasaratColors.primary,
                size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: MasaratTypography.labelLarge),
                const SizedBox(height: 4),
                Text(duration, style: MasaratTypography.labelSmall),
              ],
            ),
          ),
          Text(
            price,
            style: MasaratTypography.headlineSmall.copyWith(
              color: MasaratColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
