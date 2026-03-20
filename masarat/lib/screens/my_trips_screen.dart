import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import 'trip_requests_screen.dart';
import 'trip_details_screen.dart';

enum TripStatus { pending, accepted, cancelled }

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: MasaratColors.surface,
        appBar: AppBar(
          title: const Text('My Trips'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'As Driver'),
              Tab(text: 'As Passenger'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TripsList(isDriver: true),
            _TripsList(isDriver: false),
          ],
        ),
      ),
    );
  }
}

class _TripsList extends StatelessWidget {
  final bool isDriver;
  const _TripsList({required this.isDriver});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _TripItem(
          origin: 'Tunis',
          destination: 'Sousse',
          date: 'Tomorrow, 08:30 AM',
          status: TripStatus.pending,
          requestCount: isDriver ? 3 : 0,
          onTap: () {
            if (isDriver && 3 > 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TripRequestsScreen()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TripDetailsScreen()));
            }
          },
        ),
        const SizedBox(height: 16),
        _TripItem(
          origin: 'Ariana',
          destination: 'Bizerte',
          date: '24 Mar, 07:00 AM',
          status: TripStatus.accepted,
          requestCount: isDriver ? 1 : 0,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TripDetailsScreen()),
          ),
        ),
      ],
    );
  }
}

class _TripItem extends StatelessWidget {
  final String origin;
  final String destination;
  final String date;
  final TripStatus status;
  final int requestCount;
  final VoidCallback onTap;

  const _TripItem({
    required this.origin,
    required this.destination,
    required this.date,
    required this.status,
    required this.requestCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$origin → $destination',
                  style: MasaratTypography.headlineSmall,
                ),
                _StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    size: 14, color: MasaratColors.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(date, style: MasaratTypography.labelSmall),
              ],
            ),
            if (requestCount > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MasaratColors.primaryFixed.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people_outline_rounded,
                        size: 16, color: MasaratColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$requestCount new seat request${requestCount > 1 ? 's' : ''}',
                        style: MasaratTypography.labelLarge.copyWith(
                          color: MasaratColors.primary,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 16, color: MasaratColors.primary),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TripStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;
    final String label;
    switch (status) {
      case TripStatus.pending:
        bgColor = MasaratColors.secondaryFixed;
        textColor = MasaratColors.onSecondaryFixed;
        label = 'Pending';
        break;
      case TripStatus.accepted:
        bgColor = MasaratColors.primaryFixed;
        textColor = MasaratColors.primary;
        label = 'Active';
        break;
      case TripStatus.cancelled:
        bgColor = MasaratColors.tertiaryFixed;
        textColor = MasaratColors.onTertiaryFixed;
        label = 'Cancelled';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: MasaratTypography.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
