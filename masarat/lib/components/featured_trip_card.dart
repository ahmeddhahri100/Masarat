import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class FeaturedTripCard extends StatelessWidget {
  const FeaturedTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasaratColors.primary,
        borderRadius: BorderRadius.circular(32),
        gradient: MasaratColors.primaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('FEATURED', style: MasaratTypography.labelMedium.copyWith(color: Colors.white)),
              ),
              const Spacer(),
              const Icon(Icons.verified, color: Colors.white, size: 20),
            ],
          ),
          const Spacer(),
          Text('Tunis → Hammamet', style: MasaratTypography.headlineMedium.copyWith(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 14),
              const SizedBox(width: 4),
              Text('Tomorrow, 09:00 AM', style: MasaratTypography.labelMedium.copyWith(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}
