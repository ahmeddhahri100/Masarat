import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/constants/app_strings.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(
        title: const Text('Trip Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver card
            Container(
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
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: MasaratColors.secondaryFixed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: MasaratColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sami Rebai',
                            style: MasaratTypography.headlineSmall),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text('4.9 · Community Member',
                                style: MasaratTypography.labelMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: MasaratColors.primaryFixed,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded,
                          color: MasaratColors.primary, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Route card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MasaratColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _RouteStop(city: 'Tunis', time: '08:00 AM', isStart: true),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.5),
                    child: Row(
                      children: [
                        Column(
                          children: List.generate(
                            4,
                            (_) => Container(
                              width: 1.5,
                              height: 6,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              color: MasaratColors.primary.withOpacity(0.4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Approx. 1h 00min',
                          style: MasaratTypography.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  _RouteStop(city: 'Hammamet', time: '09:00 AM', isStart: false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About
            Text('About this trip', style: MasaratTypography.titleMedium),
            const SizedBox(height: 12),
            Text(
              'I am driving to Hammamet for a business meeting. Have 3 seats available in my clean hybrid car. Happy to share the journey!',
              style: MasaratTypography.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),

            // Preference chips
            Text('Trip Preferences', style: MasaratTypography.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _PrefChip(icon: Icons.event_seat_rounded, label: '3 Seats'),
                _PrefChip(icon: Icons.smoke_free_rounded, label: 'No Smoking'),
                _PrefChip(icon: Icons.music_note_rounded, label: 'Music OK'),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: MasaratColors.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: MasaratColors.onSurface.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: GestureDetector(
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
              child: Text(AppStrings.joinTrip,
                  style: MasaratTypography.buttonText),
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteStop extends StatelessWidget {
  final String city;
  final String time;
  final bool isStart;
  const _RouteStop(
      {required this.city, required this.time, required this.isStart});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isStart ? MasaratColors.primary : Colors.transparent,
            border: Border.all(color: MasaratColors.primary, width: 2),
            shape: BoxShape.circle,
          ),
          child: isStart
              ? null
              : const Center(
                  child: Icon(Icons.location_on_rounded,
                      color: MasaratColors.primary, size: 10)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(city,
              style: MasaratTypography.bodyLarge
                  .copyWith(fontWeight: FontWeight.w600)),
        ),
        Text(time, style: MasaratTypography.labelLarge),
      ],
    );
  }
}

class _PrefChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PrefChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: MasaratColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MasaratColors.onSurface.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: MasaratColors.primary),
          const SizedBox(width: 8),
          Text(label,
              style: MasaratTypography.labelLarge
                  .copyWith(color: MasaratColors.onSurface)),
        ],
      ),
    );
  }
}
