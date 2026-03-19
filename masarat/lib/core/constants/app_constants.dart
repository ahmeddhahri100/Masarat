/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Masarat';
  static const String appVersion = '1.0.0';

  // Supabase Configuration
  // TODO: Replace with your Supabase credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Timeout Durations (in milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Cache
  static const int cacheMaxAge = 7; // days
  static const int cacheMaxObjects = 100;

  // Pagination
  static const int defaultPageSize = 20;
  static const int initialPage = 1;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int otpLength = 6;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String serverDateFormat = 'yyyy-MM-dd';

  // Phone
  static const String defaultCountryCode = '+216';
  static const String defaultCountryIso = 'TN';

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String sessionExpiredMessage = 'Your session has expired. Please login again.';
}
