/// API Constants for the application
/// Contains all API-related constants including Supabase configuration
class ApiConstants {
  ApiConstants._();

  // ============================================================
  // Supabase Configuration
  // ============================================================

  /// Supabase project URL
  /// Replace with your actual Supabase project URL
  static const String supabaseUrl = 'https://your-project-id.supabase.co';

  /// Supabase anonymous key
  /// Replace with your actual Supabase anon key
  static const String supabaseAnonKey = 'your-anon-key-here';

  // ============================================================
  // API Endpoints
  // ============================================================

  /// Base API URL
  static const String baseUrl = '/rest/v1';

  // Auth endpoints
  static const String authSignup = '/auth/v1/signup';
  static const String authLogin = '/auth/v1/token';
  static const String authLogout = '/auth/v1/logout';
  static const String authUser = '/auth/v1/user';
  static const String authRefresh = '/auth/v1/token';
  static const String authResetPassword = '/auth/v1/recover';
  static const String authVerifyOtp = '/auth/v1/verify';

  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/profiles';

  // Storage buckets
  static const String storageAvatars = 'avatars';
  static const String storageImages = 'images';
  static const String storageDocuments = 'documents';

  // ============================================================
  // Request Configuration
  // ============================================================

  /// Default timeout for API requests in milliseconds
  static const int connectionTimeout = 30000;

  /// Default receive timeout in milliseconds
  static const int receiveTimeout = 30000;

  /// Maximum retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Delay between retry attempts in milliseconds
  static const int retryDelay = 1000;

  // ============================================================
  // Pagination
  // ============================================================

  /// Default page size for paginated requests
  static const int defaultPageSize = 20;

  /// Maximum page size allowed
  static const int maxPageSize = 100;

  // ============================================================
  // Headers
  // ============================================================

  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerApiKey = 'apikey';
  static const String headerBearer = 'Bearer';
  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormData = 'multipart/form-data';

  // ============================================================
  // Realtime Channels
  // ============================================================

  /// Realtime channel for presence
  static const String channelPresence = 'presence';

  /// Realtime channel for notifications
  static const String channelNotifications = 'notifications';

  /// Realtime channel for chat
  static const String channelChat = 'chat';

  // ============================================================
  // Deep Links
  // ============================================================

  /// Deep link scheme for password reset
  static const String deepLinkResetPassword = 'reset-password';

  /// Deep link scheme for email verification
  static const String deepLinkVerifyEmail = 'verify-email';

  /// Deep link scheme for magic link
  static const String deepLinkMagicLink = 'magic-link';
}
