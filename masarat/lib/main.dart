import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:masarat/core/theme/app_theme.dart';
import 'package:masarat/l10n/app_localizations.dart';
import 'package:masarat/routes/app_router.dart';
import 'package:masarat/services/storage_service.dart';
import 'package:masarat/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  await _initializeServices();

  runApp(
    const ProviderScope(
      child: MasaratApp(),
    ),
  );
}

Future<void> _initializeServices() async {
  // Initialize storage service
  await StorageService.instance.init();

  // Initialize Supabase
  await SupabaseService.instance.initialize();
}

class MasaratApp extends ConsumerStatefulWidget {
  const MasaratApp({super.key});

  @override
  ConsumerState<MasaratApp> createState() => _MasaratAppState();
}

class _MasaratAppState extends ConsumerState<MasaratApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    final storageService = StorageService.instance;

    // Get saved theme mode
    final savedThemeMode = storageService.getThemeMode();
    final themeMode = _getThemeMode(savedThemeMode);

    // Get saved language code
    final savedLanguageCode = storageService.getLanguageCode();
    final locale = savedLanguageCode != null
        ? Locale(savedLanguageCode)
        : const Locale('en', 'US');

    return MaterialApp.router(
      title: 'Masarat',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Localization Configuration
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: AppLocalizations.localeResolutionCallback,

      // Router Configuration
      routerConfig: router,

      // Builder for additional setup
      builder: (context, child) {
        // Set system UI overlay style based on theme
        final brightness = Theme.of(context).brightness;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                brightness == Brightness.light ? Brightness.dark : Brightness.light,
            systemNavigationBarColor:
                brightness == Brightness.light ? Colors.white : const Color(0xFF1E1E1E),
            systemNavigationBarIconBrightness:
                brightness == Brightness.light ? Brightness.dark : Brightness.light,
          ),
        );

        // Handle text direction for RTL languages
        final textDirection = AppLocalizations.of(context)?.textDirection ?? TextDirection.ltr;

        return Directionality(
          textDirection: textDirection,
          child: MediaQuery(
            // Ensure text scaling doesn't break the UI
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
