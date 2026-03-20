import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: MasaratColors.secondaryFixed),
                  const SizedBox(width: 12),
                  Text('Sami R.', style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: MasaratColors.primaryFixed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('3 Seats', style: MasaratTypography.labelMedium.copyWith(color: MasaratColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.circle, size: 8, color: MasaratColors.primary),
                  Container(width: 1, height: 20, color: MasaratColors.outlineVariant),
                  const Icon(Icons.location_on, size: 12, color: MasaratColors.primary),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tunis', style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Text('Sousse', style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Today', style: MasaratTypography.labelMedium),
                  Text('08:30 AM', style: MasaratTypography.bodyMedium),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
