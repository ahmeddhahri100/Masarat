/// String extensions for common string operations
/// Provides convenient methods for validation, formatting, and manipulation

extension StringExtensions on String {
  // ============================================================
  // Validation Extensions
  // ============================================================

  /// Check if the string is a valid email address
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if the string is a valid phone number (basic check)
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{6,14}$');
    return phoneRegex.hasMatch(removeAllSpaces);
  }

  /// Check if the string is a valid password (at least 8 characters,
  /// contains uppercase, lowercase, number, and special character)
  bool get isValidPassword {
    if (length < 8) return false;
    if (!contains(RegExp(r'[A-Z]'))) return false;
    if (!contains(RegExp(r'[a-z]'))) return false;
    if (!contains(RegExp(r'[0-9]'))) return false;
    if (!contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  /// Check if the string is a strong password (min 8 chars, uppercase, lowercase, number)
  bool get isStrongPassword {
    if (length < 8) return false;
    if (!contains(RegExp(r'[A-Z]'))) return false;
    if (!contains(RegExp(r'[a-z]'))) return false;
    if (!contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  /// Check if the string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Check if the string is a valid Saudi phone number
  bool get isValidSaudiPhone {
    final phoneRegex = RegExp(r'^(\+966|0)?5[0-9]{8}$');
    return phoneRegex.hasMatch(removeAllSpaces);
  }

  /// Check if the string is a valid Tunisian phone number
  bool get isValidTunisianPhone {
    final phoneRegex = RegExp(r'^(\+216|0)?[2-9][0-9]{7}$');
    return phoneRegex.hasMatch(removeAllSpaces);
  }

  /// Check if the string contains only letters
  bool get isAlpha {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Check if the string contains only letters and numbers
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Check if the string contains only numbers
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if the string is a valid hex color
  bool get isValidHexColor {
    return RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$').hasMatch(this);
  }

  // ============================================================
  // Formatting Extensions
  // ============================================================

  /// Capitalize the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize the first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Convert to title case
  String get toTitleCase {
    if (isEmpty) return this;
    return replaceAll(RegExp(r'([A-Z])'), ' $1')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word.capitalize)
        .join(' ');
  }

  /// Convert camelCase to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    ).replaceAll(RegExp(r'^_'), '');
  }

  /// Convert snake_case to camelCase
  String get toCamelCase {
    final words = split('_');
    if (words.isEmpty) return this;
    return words.first.toLowerCase() +
        words
            .skip(1)
            .map((word) => word.isEmpty ? '' : word.capitalize)
            .join('');
  }

  /// Remove all spaces from the string
  String get removeAllSpaces {
    return replaceAll(' ', '');
  }

  /// Remove all whitespace (spaces, tabs, newlines)
  String get removeAllWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncate the string to a maximum length with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Truncate the string from the middle
  String truncateMiddle(int maxLength, {String separator = '...'}) {
    if (length <= maxLength) return this;
    final front = (maxLength - separator.length) ~/ 2;
    final back = maxLength - separator.length - front;
    return '${substring(0, front)}$separator${substring(length - back)}';
  }

  /// Format phone number with spaces (e.g., +216 12 345 678)
  String get formatPhone {
    final cleanPhone = removeAllWhitespace;
    if (cleanPhone.length <= 4) return cleanPhone;
    final buffer = StringBuffer();
    for (var i = 0; i < cleanPhone.length; i++) {
      if (i > 0 && i % 3 == 0 && i < cleanPhone.length - 2) {
        buffer.write(' ');
      }
      buffer.write(cleanPhone[i]);
    }
    return buffer.toString();
  }

  /// Format credit card number with spaces
  String get formatCreditCard {
    final cleanNumber = removeAllWhitespace;
    if (cleanNumber.length <= 4) return cleanNumber;
    final buffer = StringBuffer();
    for (var i = 0; i < cleanNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleanNumber[i]);
    }
    return buffer.toString();
  }

  /// Mask email address (e.g., j***n@example.com)
  String get maskEmail {
    if (!isValidEmail) return this;
    final parts = split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '***@$domain';
    return '${name[0]}${'*' * (name.length - 2)}${name.last}@$domain';
  }

  /// Mask phone number (e.g., +216 *** *** 78)
  String get maskPhone {
    final cleanPhone = removeAllWhitespace;
    if (cleanPhone.length < 6) return '***';
    final visibleStart = cleanPhone.substring(0, 4);
    final visibleEnd = cleanPhone.substring(cleanPhone.length - 2);
    return '$visibleStart *** *** $visibleEnd';
  }

  // ============================================================
  // Manipulation Extensions
  // ============================================================

  /// Remove all occurrences of a pattern
  String removeAll(Pattern pattern) {
    return replaceAll(pattern, '');
  }

  /// Get the first n characters
  String first(int n) {
    if (isEmpty || n <= 0) return '';
    return substring(0, n.clamp(0, length));
  }

  /// Get the last n characters
  String last(int n) {
    if (isEmpty || n <= 0) return '';
    return substring((length - n).clamp(0, length));
  }

  /// Reverse the string
  String get reverse {
    return split('').reversed.join('');
  }

  /// Check if the string contains any of the given substrings
  bool containsAny(List<String> substrings) {
    return substrings.any(contains);
  }

  /// Check if the string contains all of the given substrings
  bool containsAll(List<String> substrings) {
    return substrings.every(contains);
  }

  /// Replace between two markers
  String replaceBetween(String start, String end, String replacement) {
    final startIndex = indexOf(start);
    if (startIndex == -1) return this;
    final endIndex = indexOf(end, startIndex + start.length);
    if (endIndex == -1) return this;
    return replaceRange(startIndex, endIndex + end.length, replacement);
  }

  /// Get text between two markers
  String? between(String start, String end) {
    final startIndex = indexOf(start);
    if (startIndex == -1) return null;
    final adjustedStart = startIndex + start.length;
    final endIndex = indexOf(end, adjustedStart);
    if (endIndex == -1) return null;
    return substring(adjustedStart, endIndex);
  }

  /// Split by length (split into chunks of given length)
  List<String> splitByLength(int length) {
    if (this.length < length) return [this];
    final result = <String>[];
    for (var i = 0; i < this.length; i += length) {
      result.add(substring(i, (i + length).clamp(0, this.length)));
    }
    return result;
  }

  // ============================================================
  // Nullable Check Extensions
  // ============================================================

  /// Check if the string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if the string is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Check if the string is null or blank (empty or only whitespace)
  bool get isNullOrBlank => trim().isEmpty;

  /// Check if the string is not null and not blank
  bool get isNotNullOrBlank => trim().isNotEmpty;

  /// Return null if empty, otherwise return the string
  String? get nullIfEmpty => isEmpty ? null : this;

  /// Return a default value if empty
  String orDefault(String defaultValue) => isEmpty ? defaultValue : this;

  // ============================================================
  // Conversion Extensions
  // ============================================================

  /// Try to parse as int, return null if failed
  int? toIntOrNull() => int.tryParse(this);

  /// Try to parse as double, return null if failed
  double? toDoubleOrNull() => double.tryParse(this);

  /// Try to parse as num, return null if failed
  num? toNumOrNull() => num.tryParse(this);

  /// Try to parse as bool
  bool? toBoolOrNull() {
    switch (toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
      case 'on':
        return true;
      case 'false':
      case '0':
      case 'no':
      case 'off':
        return false;
      default:
        return null;
    }
  }

  /// Try to parse as DateTime, return null if failed
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);

  /// Convert to int with default value
  int toIntOr(int defaultValue) => toIntOrNull() ?? defaultValue;

  /// Convert to double with default value
  double toDoubleOr(double defaultValue) => toDoubleOrNull() ?? defaultValue;

  // ============================================================
  // Security Extensions
  // ============================================================

  /// Check if the string is a valid JWT token (basic structure check)
  bool get isValidJwt {
    final parts = split('.');
    return parts.length == 3 && parts.every((part) => part.isNotEmpty);
  }

  /// Check if string contains potential SQL injection patterns
  bool get containsSqlInjection {
    final sqlPatterns = [
      RegExp(r"('|\")(;|--|\)|union|select|insert|delete|update|drop)", caseSensitive: false),
      RegExp(r'(or|and)\s+\d+\s*=\s*\d+', caseSensitive: false),
      RegExp(r'exec(\s|\+)+s(p|x)', caseSensitive: false),
    ];
    return sqlPatterns.any((pattern) => pattern.hasMatch(this));
  }

  /// Check if string contains potential XSS patterns
  bool get containsXss {
    final xssPatterns = [
      RegExp(r'<script\b[^>]*>(.*?)</script>', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'<iframe', caseSensitive: false),
    ];
    return xssPatterns.any((pattern) => pattern.hasMatch(this));
  }
}

/// Extension on nullable String
extension NullableStringExtensions on String? {
  /// Check if the string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if the string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Check if the string is null or blank (empty or only whitespace)
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Check if the string is not null and not blank
  bool get isNotNullOrBlank => this != null && this!.trim().isNotEmpty;

  /// Return an empty string if null
  String get orEmpty => this ?? '';

  /// Return a default value if null or empty
  String orDefault(String defaultValue) =>
      (this == null || this!.isEmpty) ? defaultValue : this!;

  /// Execute a function if the string is not null
  void ifNotEmpty(void Function(String value) action) {
    if (this != null && this!.isNotEmpty) {
      action(this!);
    }
  }
}
