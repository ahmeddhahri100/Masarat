import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class LimitReachedModal extends StatelessWidget {
  const LimitReachedModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: MasaratColors.tertiaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_person_outlined, color: MasaratColors.onTertiaryFixed, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            'Weekly Limit Reached',
            style: MasaratTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Community members can post up to 3 trips per week for free. Upgrade to Premium for unlimited postings and better visibility.',
            style: MasaratTypography.bodyMedium.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to Premium Screen
            },
            child: const Text('Upgrade to Premium'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe Later', style: MasaratTypography.labelMedium),
          ),
        ],
      ),
    );
  }
}
