import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../components/trip_card.dart';
import '../components/featured_trip_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marhaba, Ahmed', style: MasaratTypography.labelMedium),
                        Text('Explore Trips', style: MasaratTypography.headlineMedium),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: MasaratColors.secondaryFixed,
                      child: Icon(Icons.person_outline, color: MasaratColors.primary),
                    ),
                  ],
                ),
              ),
              
              // Featured Trips (Horizontal)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Featured Trips', style: MasaratTypography.headlineMedium.copyWith(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 24),
                  itemCount: 3,
                  itemBuilder: (context, index) => const FeaturedTripCard(),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Active Feed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Shared Journeys', style: MasaratTypography.headlineMedium.copyWith(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 5,
                itemBuilder: (context, index) => const TripCard(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: MasaratColors.primary,
        unselectedItemColor: MasaratColors.onSurface.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
