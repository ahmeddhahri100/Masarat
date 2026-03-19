import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:masarat/core/constants/app_constants.dart';

/// App Router Configuration using go_router
/// Handles navigation with authentication guards and deep links

// ============================================================
// Router Provider
// ============================================================

/// Provider for the GoRouter instance
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    routerNeglect: true,
    refreshListenable: GoRouterRefreshStream(
      Stream.value(false), // TODO: Replace with auth state stream
    ),
    redirect: _handleRedirect,
    routes: _routes,
    errorBuilder: _errorBuilder,
  );
});

// ============================================================
// Redirect Logic
// ============================================================

String? _handleRedirect(BuildContext context, GoRouterState state) {
  // TODO: Implement auth state check
  // final isLoggedIn = ref.read(authStateProvider).isAuthenticated;
  // final isOnboardingCompleted = ref.read(onboardingProvider).isCompleted;

  final isAuthRoute = state.matchedLocation == AppRoutes.login ||
      state.matchedLocation == AppRoutes.register ||
      state.matchedLocation == AppRoutes.forgotPassword;

  final isOnboardingRoute = state.matchedLocation == AppRoutes.onboarding;
  final isSplashRoute = state.matchedLocation == AppRoutes.splash;

  // Allow splash and onboarding routes
  if (isSplashRoute) return null;

  // TODO: Uncomment when auth is implemented
  // // Check onboarding
  // if (!isOnboardingCompleted && !isOnboardingRoute) {
  //   return AppRoutes.onboarding;
  // }

  // // Check authentication
  // if (!isLoggedIn && !isAuthRoute && !isOnboardingRoute) {
  //   return AppRoutes.login;
  // }

  // // Redirect to home if logged in and trying to access auth routes
  // if (isLoggedIn && isAuthRoute) {
  //   return AppRoutes.home;
  // }

  return null;
}

// ============================================================
// Routes
// ============================================================

final List<RouteBase> _routes = [
  // Splash Screen
  GoRoute(
    path: AppRoutes.splash,
    name: 'splash',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const SplashScreen(),
    ),
  ),

  // Onboarding
  GoRoute(
    path: AppRoutes.onboarding,
    name: 'onboarding',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const OnboardingScreen(),
    ),
  ),

  // Auth Routes
  GoRoute(
    path: AppRoutes.login,
    name: 'login',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const LoginScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.register,
    name: 'register',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const RegisterScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.forgotPassword,
    name: 'forgot-password',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const ForgotPasswordScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.verifyOtp,
    name: 'verify-otp',
    pageBuilder: (context, state) {
      final email = state.uri.queryParameters['email'] ?? '';
      return _buildPageWithTransition(
        context: context,
        state: state,
        child: VerifyOtpScreen(email: email),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.resetPassword,
    name: 'reset-password',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const ResetPasswordScreen(),
    ),
  ),

  // Main App Shell with Bottom Navigation
  ShellRoute(
    builder: (context, state, child) => AppShell(
      currentIndex: _getCurrentNavIndex(state),
      child: child,
    ),
    routes: [
      // Home
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const HomeScreen(),
        ),
      ),

      // Explore/Search
      GoRoute(
        path: AppRoutes.explore,
        name: 'explore',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const ExploreScreen(),
        ),
      ),

      // Bookmarks/Favorites
      GoRoute(
        path: AppRoutes.bookmarks,
        name: 'bookmarks',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const BookmarksScreen(),
        ),
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const ProfileScreen(),
        ),
      ),
    ],
  ),

  // Settings
  GoRoute(
    path: AppRoutes.settings,
    name: 'settings',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const SettingsScreen(),
    ),
  ),

  // Edit Profile
  GoRoute(
    path: AppRoutes.editProfile,
    name: 'edit-profile',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const EditProfileScreen(),
    ),
  ),

  // Detail Routes with Parameters
  GoRoute(
    path: '${AppRoutes.itemDetail}/:id',
    name: 'item-detail',
    pageBuilder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      return _buildPageWithTransition(
        context: context,
        state: state,
        child: ItemDetailScreen(itemId: id),
      );
    },
  ),

  // Notifications
  GoRoute(
    path: AppRoutes.notifications,
    name: 'notifications',
    pageBuilder: (context, state) => _buildPageWithTransition(
      context: context,
      state: state,
      child: const NotificationsScreen(),
    ),
  ),

  // Deep Links
  GoRoute(
    path: AppRoutes.deepLinkResetPassword,
    name: 'deep-link-reset-password',
    pageBuilder: (context, state) {
      final token = state.uri.queryParameters['token'] ?? '';
      return _buildPageWithTransition(
        context: context,
        state: state,
        child: ResetPasswordScreen(token: token),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.deepLinkVerifyEmail,
    name: 'deep-link-verify-email',
    pageBuilder: (context, state) {
      final token = state.uri.queryParameters['token'] ?? '';
      return _buildPageWithTransition(
        context: context,
        state: state,
        child: EmailVerifiedScreen(token: token),
      );
    },
  ),
];

// ============================================================
// Page Transitions
// ============================================================

CustomTransitionPage<void> _buildPageWithTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

// ============================================================
// Error Builder
// ============================================================

Widget _errorBuilder(BuildContext context, GoRouterState state) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            state.error?.toString() ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  );
}

// ============================================================
// Navigation Index Helper
// ============================================================

int _getCurrentNavIndex(GoRouterState state) {
  if (state.matchedLocation == AppRoutes.home) return 0;
  if (state.matchedLocation == AppRoutes.explore) return 1;
  if (state.matchedLocation == AppRoutes.bookmarks) return 2;
  if (state.matchedLocation == AppRoutes.profile) return 3;
  return 0;
}

// ============================================================
// App Routes Constants
// ============================================================

class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';

  // Main
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookmarks = '/bookmarks';
  static const String profile = '/profile';

  // Settings
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';

  // Details
  static const String itemDetail = '/item';

  // Notifications
  static const String notifications = '/notifications';

  // Deep Links
  static const String deepLinkResetPassword = '/auth/reset-password';
  static const String deepLinkVerifyEmail = '/auth/verify-email';
  static const String deepLinkMagicLink = '/auth/magic-link';
}

// ============================================================
// Placeholder Screens
// ============================================================

// TODO: Replace these placeholder screens with actual implementations

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: const Center(child: Text('Onboarding Screen')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen')),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Register Screen')),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: const Center(child: Text('Forgot Password Screen')),
    );
  }
}

class VerifyOtpScreen extends StatelessWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Center(child: Text('Verify OTP for: $email')),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  final String? token;

  const ResetPasswordScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: const Center(child: Text('Reset Password Screen')),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Screen'));
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Explore Screen'));
  }
}

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Bookmarks Screen'));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Screen'));
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Center(child: Text('Item ID: $itemId')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Screen')),
    );
  }
}

class EmailVerifiedScreen extends StatelessWidget {
  final String? token;

  const EmailVerifiedScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verified')),
      body: const Center(child: Text('Email Verified Successfully!')),
    );
  }
}

// ============================================================
// App Shell with Bottom Navigation
// ============================================================

class AppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.explore);
        break;
      case 2:
        context.go(AppRoutes.bookmarks);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}

// ============================================================
// Refresh Stream for Auth
// ============================================================

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

import 'dart:async';
