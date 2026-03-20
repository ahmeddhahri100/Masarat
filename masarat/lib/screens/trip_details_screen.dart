import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/constants/app_strings.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Profile
            Row(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: MasaratColors.secondaryFixed),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sami Rebai', style: MasaratTypography.headlineMedium.copyWith(fontSize: 20)),
                      Text('4.9 ★ Community Member', style: MasaratTypography.labelMedium),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: MasaratColors.primary),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Route Visualization (Editorial Style)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MasaratColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  _RoutePoint(city: 'Tunis', time: '08:00 AM', isStart: true),
                  const _RouteLine(),
                  _RoutePoint(city: 'Hammamet', time: '09:00 AM', isStart: false),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            Text('About this trip', style: MasaratTypography.headlineMedium.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            Text(
              'I am driving to Hammamet for a business meeting. Have 3 seats available in my clean hybrid car. Happy to share the journey!',
              style: MasaratTypography.bodyMedium.copyWith(height: 1.5),
            ),
            const SizedBox(height: 32),
            
            // Preferences / Info Chips
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _InfoChip(icon: Icons.event_seat, label: '3 Seats'),
                _InfoChip(icon: Icons.smoke_free, label: 'No Smoking'),
                _InfoChip(icon: Icons.music_note, label: 'Music OK'),
              ],
            ),
            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Join Request Logic
          },
          child: const Text(AppStrings.joinTrip),
        ),
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final String city;
  final String time;
  final bool isStart;

  const _RoutePoint({required this.city, required this.time, required this.isStart});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(isStart ? Icons.circle : Icons.location_on, color: MasaratColors.primary, size: 16),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(city, style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            Text(time, style: MasaratTypography.labelMedium),
          ],
        ),
      ],
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 7.5),
      width: 1,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: MasaratColors.outlineVariant, style: BorderStyle.solid, width: 1)),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: MasaratColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MasaratColors.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: MasaratColors.primary),
          const SizedBox(width: 8),
          Text(label, style: MasaratTypography.labelMedium.copyWith(color: MasaratColors.onSurface)),
        ],
      ),
    );
  }
}
