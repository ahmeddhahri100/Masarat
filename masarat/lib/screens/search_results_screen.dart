import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../components/trip_card.dart';
import '../services/supabase_service.dart';
import '../models/trip_model.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(
        backgroundColor: MasaratColors.surface,
        elevation: 0,
        title: Text('Search: $query', style: MasaratTypography.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const _FilterChip(label: 'Today', isSelected: true),
                  const _FilterChip(label: 'Price: Low to High', isSelected: false),
                  const _FilterChip(label: 'Seats: 2+', isSelected: false),
                  const _FilterChip(label: 'Verified Only', isSelected: false),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<TripModel>>(
              future: SupabaseService.searchTrips(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trips = snapshot.data ?? [];
                if (trips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: MasaratColors.onSurfaceVariant.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('No results for "$query"', style: MasaratTypography.bodyLarge),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: trips.length,
                  itemBuilder: (context, index) => TripCard(trip: trips[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? MasaratColors.primary : MasaratColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.transparent : MasaratColors.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: MasaratTypography.labelSmall.copyWith(
          color: isSelected ? Colors.white : MasaratColors.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
