import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class BoostTripScreen extends StatelessWidget {
  const BoostTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boost Trip Visibility')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MasaratColors.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.rocket_launch, size: 60, color: MasaratColors.primary),
            ),
            const SizedBox(height: 32),
            Text('Get Noticed Faster', style: MasaratTypography.headlineLarge, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              'Featured trips are seen 5x more often. Boost your trip to find passengers in minutes.',
              style: MasaratTypography.bodyMedium.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            _BoostOption(title: 'Basic Boost', price: '2 TND', duration: '24 Hours', isSelected: true),
            const SizedBox(height: 16),
            _BoostOption(title: 'Mega Boost', price: '5 TND', duration: '72 Hours', isSelected: false),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Confirm Boost'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoostOption extends StatelessWidget {
  final String title;
  final String price;
  final String duration;
  final bool isSelected;

  const _BoostOption({required this.title, required this.price, required this.duration, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected ? MasaratColors.primary.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isSelected ? MasaratColors.primary : MasaratColors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              Text(duration, style: MasaratTypography.labelMedium),
            ],
          ),
          Text(price, style: MasaratTypography.headlineMedium.copyWith(fontSize: 18, color: MasaratColors.primary)),
        ],
      ),
    );
  }
}
