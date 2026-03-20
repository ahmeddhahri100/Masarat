import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../components/status_chip.dart';
import 'trip_requests_screen.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Trips'),
          bottom: TabBar(
            indicatorColor: MasaratColors.primary,
            labelColor: MasaratColors.primary,
            unselectedLabelColor: MasaratColors.onSurface.withOpacity(0.4),
            tabs: const [
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
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _TripItem(
        title: index == 0 ? 'Tunis → Sousse' : 'Ariana → Bizerte',
        date: '22 Mar, 08:30 AM',
        status: index == 0 ? TripStatus.pending : TripStatus.accepted,
        requestCount: isDriver ? (index == 0 ? 3 : 1) : 0,
      ),
    );
  }
}

class _TripItem extends StatelessWidget {
  final String title;
  final String date;
  final TripStatus status;
  final int requestCount;

  const _TripItem({required this.title, required this.date, required this.status, required this.requestCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (requestCount > 0) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TripRequestsScreen()));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MasaratColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MasaratColors.outlineVariant.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: MasaratTypography.labelMedium),
            if (requestCount > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: MasaratColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.people_outline, size: 16, color: MasaratColors.primary),
                    const SizedBox(width: 8),
                    Text('$requestCount new seat requests', style: MasaratTypography.labelMedium.copyWith(color: MasaratColors.primary, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Icon(Icons.chevron_right, size: 16, color: MasaratColors.primary),
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
