import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../components/trip_card.dart';
import '../components/featured_trip_card.dart';
import 'conversations_screen.dart';
import 'profile_screen.dart';
import 'create_trip_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeBody(),
    const SearchResultsScreen(query: 'Nearby'),
    const CreateTripScreen(),
    const ConversationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      body: _screens[_currentIndex],
      bottomNavigationBar: _MasaratBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marhaba, Ahmed 👋',
                          style: MasaratTypography.labelMedium.copyWith(
                            color: MasaratColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Explore Trips',
                            style: MasaratTypography.headlineMedium),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: MasaratColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: MasaratColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search_rounded,
                        color: MasaratColors.onSurfaceVariant, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Search trips...',
                      style: MasaratTypography.bodyMedium.copyWith(
                        color: MasaratColors.onSurfaceVariant.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Featured / Boosted Trips section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Boosted Trips',
                      style: MasaratTypography.titleMedium),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: MasaratTypography.labelMedium.copyWith(
                        color: MasaratColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24, top: 12),
                itemCount: 3,
                itemBuilder: (context, index) => const FeaturedTripCard(),
              ),
            ),
          ),

          // Recent / Shared Journeys
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Trips',
                      style: MasaratTypography.titleMedium),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: MasaratTypography.labelMedium.copyWith(
                        color: MasaratColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const TripCard(),
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MasaratBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _MasaratBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_rounded), label: 'Create'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
