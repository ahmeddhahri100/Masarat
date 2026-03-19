/// Custom exceptions for the application
/// Provides a unified way to handle errors across the app

/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Server-related exceptions (API errors, Supabase errors, etc.)
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode, code: $code)';
}

/// Cache-related exceptions (local storage errors)
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Network-related exceptions (connectivity issues)
class NetworkException extends AppException {
  final NetworkExceptionType type;

  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    required this.type,
  });

  @override
  String toString() => 'NetworkException: $message (type: $type)';
}

/// Types of network exceptions
enum NetworkExceptionType {
  noConnection,
  timeout,
  badResponse,
  connectionRefused,
  unknown,
}

/// Authentication-related exceptions (Supabase Auth errors)
class AuthException extends AppException {
  final AuthExceptionType type;

  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    required this.type,
  });

  @override
  String toString() => 'AuthException: $message (type: $type)';
}

/// Types of authentication exceptions
enum AuthExceptionType {
  invalidCredentials,
  userNotFound,
  userAlreadyExists,
  emailNotConfirmed,
  invalidEmail,
  invalidPassword,
  weakPassword,
  sessionExpired,
  unauthorized,
  tooManyRequests,
  unknown,
}

/// Validation-related exceptions (form validation, input validation)
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    this.fieldErrors,
  });

  @override
  String toString() => 'ValidationException: $message ${fieldErrors != null ? '(fields: $fieldErrors)' : ''}';
}

/// Permission-related exceptions (camera, storage, location, etc.)
class PermissionException extends AppException {
  final PermissionType permissionType;

  const PermissionException({
    required super.message,
    super.code,
    super.originalError,
    required this.permissionType,
  });

  @override
  String toString() => 'PermissionException: $message (permission: $permissionType)';
}

/// Types of permissions
enum PermissionType {
  camera,
  gallery,
  storage,
  location,
  microphone,
  contacts,
  notification,
  unknown,
}

/// Database-related exceptions (local database errors)
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'DatabaseException: $message';
}

/// File-related exceptions (file picker, file operations)
class FileException extends AppException {
  final FileExceptionType type;

  const FileException({
    required super.message,
    super.code,
    super.originalError,
    required this.type,
  });

  @override
  String toString() => 'FileException: $message (type: $type)';
}

/// Types of file exceptions
enum FileExceptionType {
  notFound,
  tooLarge,
  invalidFormat,
  uploadFailed,
  downloadFailed,
  deleteFailed,
  unknown,
}

/// Parsing-related exceptions (JSON parsing, data conversion)
class ParsingException extends AppException {
  const ParsingException({
    required super.message,
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'ParsingException: $message';
}

/// Unknown/Unexpected exceptions
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred',
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'UnknownException: $message';
}

/// Extension to convert errors to user-friendly messages
extension AppExceptionExtension on AppException {
  /// Get user-friendly error message
  String get userMessage {
    if (this is NetworkException) {
      final networkException = this as NetworkException;
      switch (networkException.type) {
        case NetworkExceptionType.noConnection:
          return 'No internet connection. Please check your network settings.';
        case NetworkExceptionType.timeout:
          return 'Connection timeout. Please try again.';
        case NetworkExceptionType.connectionRefused:
          return 'Unable to connect to server. Please try again later.';
        case NetworkExceptionType.badResponse:
          return 'Server returned an invalid response.';
        case NetworkExceptionType.unknown:
          return 'A network error occurred. Please try again.';
      }
    }

    if (this is AuthException) {
      final authException = this as AuthException;
      switch (authException.type) {
        case AuthExceptionType.invalidCredentials:
          return 'Invalid email or password. Please try again.';
        case AuthExceptionType.userNotFound:
          return 'No account found with this email.';
        case AuthExceptionType.userAlreadyExists:
          return 'An account with this email already exists.';
        case AuthExceptionType.emailNotConfirmed:
          return 'Please verify your email address.';
        case AuthExceptionType.invalidEmail:
          return 'Please enter a valid email address.';
        case AuthExceptionType.invalidPassword:
          return 'Invalid password format.';
        case AuthExceptionType.weakPassword:
          return 'Password is too weak. Please use a stronger password.';
        case AuthExceptionType.sessionExpired:
          return 'Your session has expired. Please log in again.';
        case AuthExceptionType.unauthorized:
          return 'You are not authorized to perform this action.';
        case AuthExceptionType.tooManyRequests:
          return 'Too many attempts. Please try again later.';
        case AuthExceptionType.unknown:
          return 'An authentication error occurred.';
      }
    }

    if (this is PermissionException) {
      return 'Permission denied. Please grant the required permission in settings.';
    }

    if (this is ValidationException) {
      return message;
    }

    if (this is FileException) {
      final fileException = this as FileException;
      switch (fileException.type) {
        case FileExceptionType.notFound:
          return 'File not found.';
        case FileExceptionType.tooLarge:
          return 'File is too large. Please choose a smaller file.';
        case FileExceptionType.invalidFormat:
          return 'Invalid file format.';
        case FileExceptionType.uploadFailed:
          return 'Failed to upload file. Please try again.';
        case FileExceptionType.downloadFailed:
          return 'Failed to download file. Please try again.';
        case FileExceptionType.deleteFailed:
          return 'Failed to delete file. Please try again.';
        case FileExceptionType.unknown:
          return 'A file operation error occurred.';
      }
    }

    return message;
  }
}
