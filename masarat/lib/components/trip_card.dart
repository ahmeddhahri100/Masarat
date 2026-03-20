import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MasaratColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MasaratColors.onSurface.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: MasaratColors.secondaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: MasaratColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sami R.',
                        style: MasaratTypography.labelLarge),
                    Text('4.9 ★ · Community Member',
                        style: MasaratTypography.labelSmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: MasaratColors.primaryFixed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '3 Seats',
                  style: MasaratTypography.labelMedium.copyWith(
                    color: MasaratColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Route timeline
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: MasaratColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 28,
                    color: MasaratColors.outlineVariant,
                  ),
                  const Icon(Icons.location_on, size: 12, color: MasaratColors.primary),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tunis',
                        style: MasaratTypography.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    Text('Sousse',
                        style: MasaratTypography.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Today',
                      style: MasaratTypography.labelSmall),
                  const SizedBox(height: 2),
                  Text('08:30 AM',
                      style: MasaratTypography.labelLarge),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
