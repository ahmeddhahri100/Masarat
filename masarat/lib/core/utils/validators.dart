import 'package:flutter/material.dart';

/// Utility class for form validation
/// Provides common validation methods for forms throughout the app
class Validators {
  Validators._();

  // ============================================================
  // Required Field Validation
  // ============================================================

  /// Validates that a field is not empty
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates that a field is not empty with custom message
  static String? requiredWithMessage(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  // ============================================================
  // Email Validation
  // ============================================================

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates email with custom required message
  static String? emailWithMessage(String? value, {String? requiredMessage}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage ?? 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // ============================================================
  // Password Validation
  // ============================================================

  /// Validates password with minimum requirements
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (value.length > 32) {
      return 'Password must not exceed 32 characters';
    }

    return null;
  }

  /// Validates password strength
  /// Requires: min length, uppercase, lowercase, number, special char
  static String? strongPassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (value.length > 32) {
      return 'Password must not exceed 32 characters';
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigits = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasUppercase) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!hasDigits) {
      return 'Password must contain at least one number';
    }

    if (!hasSpecialChars) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validates confirm password matches password
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Get password strength score (0-4)
  static int getPasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      strength++;
    }
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    return strength.clamp(0, 4);
  }

  /// Get password strength label
  static String getPasswordStrengthLabel(String password) {
    final strength = getPasswordStrength(password);

    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  // ============================================================
  // Name Validation
  // ============================================================

  /// Validates name field
  static String? name(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    if (value.trim().length > 50) {
      return '$fieldName must not exceed 50 characters';
    }

    // Only allow letters, spaces, hyphens, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  /// Validates first name
  static String? firstName(String? value) {
    return name(value, fieldName: 'First name');
  }

  /// Validates last name
  static String? lastName(String? value) {
    return name(value, fieldName: 'Last name');
  }

  /// Validates full name
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    // Check if at least two words (first and last name)
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return 'Please enter your full name (first and last name)';
    }

    return name(value, fieldName: 'Full name');
  }

  // ============================================================
  // Username Validation
  // ============================================================

  /// Validates username
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.trim().length > 20) {
      return 'Username must not exceed 20 characters';
    }

    // Only allow letters, numbers, and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value.trim())) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    // Must start with a letter
    if (!RegExp(r'^[a-zA-Z]').hasMatch(value.trim())) {
      return 'Username must start with a letter';
    }

    return null;
  }

  // ============================================================
  // Phone Validation
  // ============================================================

  /// Validates phone number
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 8 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validates phone number with country code
  static String? phoneWithCountryCode(String? value, {String? countryCode}) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check length based on country or general
    if (digitsOnly.length < 8 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // ============================================================
  // OTP Validation
  // ============================================================

  /// Validates OTP code
  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != length) {
      return 'OTP must be $length digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }

    return null;
  }

  /// Validates OTP with custom message
  static String? otpWithMessage(String? value, {int length = 6, String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'OTP is required';
    }

    if (value.length != length) {
      return 'OTP must be $length digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }

    return null;
  }

  // ============================================================
  // URL Validation
  // ============================================================

  /// Validates URL format
  static String? url(String? value, {bool required = true}) {
    if (value == null || value.trim().isEmpty) {
      if (required) {
        return 'URL is required';
      }
      return null;
    }

    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) {
      return 'Please enter a valid URL';
    }

    if (!['http', 'https'].contains(uri.scheme)) {
      return 'URL must start with http:// or https://';
    }

    return null;
  }

  /// Validates website URL (optional)
  static String? website(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    // Add https:// if missing
    String url = value.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) {
      return 'Please enter a valid website URL';
    }

    return null;
  }

  // ============================================================
  // Number Validation
  // ============================================================

  /// Validates numeric input
  static String? numeric(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value.trim()) == null) {
      return '$fieldName must be a valid number';
    }

    return null;
  }

  /// Validates integer input
  static String? integer(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (int.tryParse(value.trim()) == null) {
      return '$fieldName must be a valid integer';
    }

    return null;
  }

  /// Validates number is within range
  static String? range(
    String? value, {
    required num min,
    required num max,
    String fieldName = 'Value',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }

    return null;
  }

  /// Validates positive number
  static String? positiveNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    if (number <= 0) {
      return '$fieldName must be greater than zero';
    }

    return null;
  }

  // ============================================================
  // Date Validation
  // ============================================================

  /// Validates date of birth (must be at least minAge years old)
  static String? dateOfBirth(String? value, {int minAge = 13, int maxAge = 120}) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }

    DateTime? date;
    try {
      date = DateTime.parse(value.trim());
    } catch (_) {
      return 'Please enter a valid date';
    }

    final now = DateTime.now();
    final age = now.year - date.year;

    if (age < minAge) {
      return 'You must be at least $minAge years old';
    }

    if (age > maxAge) {
      return 'Please enter a valid date of birth';
    }

    if (date.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }

    return null;
  }

  /// Validates date is not in the past
  static String? futureDate(String? value, {String fieldName = 'Date'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    DateTime? date;
    try {
      date = DateTime.parse(value.trim());
    } catch (_) {
      return 'Please enter a valid date';
    }

    if (date.isBefore(DateTime.now())) {
      return '$fieldName cannot be in the past';
    }

    return null;
  }

  /// Validates date is not in the future
  static String? pastDate(String? value, {String fieldName = 'Date'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    DateTime? date;
    try {
      date = DateTime.parse(value.trim());
    } catch (_) {
      return 'Please enter a valid date';
    }

    if (date.isAfter(DateTime.now())) {
      return '$fieldName cannot be in the future';
    }

    return null;
  }

  // ============================================================
  // Text Length Validation
  // ============================================================

  /// Validates minimum length
  static String? minLength(String? value, int min, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < min) {
      return '$fieldName must be at least $min characters';
    }

    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int max, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return null; // Optional if only checking max
    }

    if (value.length > max) {
      return '$fieldName must not exceed $max characters';
    }

    return null;
  }

  /// Validates length range
  static String? lengthRange(
    String? value, {
    required int min,
    required int max,
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < min || value.length > max) {
      return '$fieldName must be between $min and $max characters';
    }

    return null;
  }

  // ============================================================
  // Special Validations
  // ============================================================

  /// Validates bio/description text
  static String? bio(String? value, {int maxLength = 500}) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    if (value.length > maxLength) {
      return 'Bio must not exceed $maxLength characters';
    }

    return null;
  }

  /// Validates search query
  static String? searchQuery(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a search term';
    }

    if (value.trim().length < minLength) {
      return 'Search term must be at least $minLength characters';
    }

    return null;
  }

  /// Validates address
  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }

    if (value.trim().length < 10) {
      return 'Please enter a complete address';
    }

    if (value.trim().length > 200) {
      return 'Address is too long';
    }

    return null;
  }

  /// Validates postal/zip code
  static String? postalCode(String? value, {String countryCode = 'US'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }

    // Generic validation (adjust based on country)
    final postalRegex = RegExp(r'^[a-zA-Z0-9\s\-]{3,10}$');
    if (!postalRegex.hasMatch(value.trim())) {
      return 'Please enter a valid postal code';
    }

    return null;
  }

  // ============================================================
  // Combined Validators
  // ============================================================

  /// Combines multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Creates a validator that runs multiple validators
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (String? value) => combine(value, validators);
  }
}

/// Extension on String to check if it's a valid email
extension StringValidationExtension on String {
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }

  bool get isValidPhone {
    final digitsOnly = replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length >= 8 && digitsOnly.length <= 15;
  }

  bool get isValidUrl {
    final uri = Uri.tryParse(this);
    return uri != null && uri.hasScheme && ['http', 'https'].contains(uri.scheme);
  }

  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  bool get isInteger {
    return int.tryParse(this) != null;
  }
}
