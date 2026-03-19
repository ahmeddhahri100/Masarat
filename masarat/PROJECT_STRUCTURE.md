# Masarat Project Structure

## 📱 Overview

Masarat is a Flutter application built with modern architecture patterns and best practices. The project uses **Supabase** as a backend, **Riverpod** for state management, and **GoRouter** for navigation.

## 🚀 Tech Stack

### State Management
- **flutter_riverpod** - Reactive state management
- **riverpod_annotation** - Code generation for providers
- **riverpod_generator** - Generates provider code

### Backend & Database
- **supabase_flutter** - Backend as a Service (Auth, Database, Storage, Realtime)

### Navigation
- **go_router** - Declarative routing with deep linking support

### UI Components
- **google_fonts** - Custom fonts (Poppins)
- **flutter_svg** - SVG rendering
- **cached_network_image** - Image caching
- **shimmer** - Loading placeholders
- **lottie** - Animations
- **pinput** - OTP input
- **phone_form_field** - Phone number input

### Forms & Validation
- **intl** - Internationalization
- **flutter_localizations** - Localization support

### Storage
- **shared_preferences** - Local key-value storage
- **flutter_secure_storage** - Secure storage for sensitive data

### Utilities
- **uuid** - UUID generation
- **timeago** - Time formatting
- **url_launcher** - URL handling
- **fluttertoast** - Toast notifications
- **image_picker** - Image selection
- **permission_handler** - Permission management

### Code Generation (Dev Dependencies)
- **build_runner** - Code generation runner
- **json_serializable** - JSON serialization
- **freezed** - Immutable data classes
- **flutter_lints** - Linting rules

---

## 📁 Project Structure

```
lib/
├── core/                          # Core functionality shared across features
│   ├── config/                    # App configuration
│   │   ├── supabase_config.dart   # Supabase configuration
│   │   └── env_config.dart        # Environment variables
│   │
│   ├── constants/                 # App constants
│   │   ├── app_constants.dart     # General app constants
│   │   └── api_constants.dart     # API endpoints and config
│   │
│   ├── errors/                    # Error handling
│   │   ├── exceptions.dart        # Custom exception classes
│   │   └── failures.dart          # Failure classes for error handling
│   │
│   ├── extensions/                # Dart extensions
│   │   ├── string_extensions.dart # String utility extensions
│   │   └── context_extensions.dart # BuildContext extensions
│   │
│   ├── theme/                     # Theming
│   │   ├── app_theme.dart         # Light/Dark theme configuration
│   │   └── app_colors.dart        # Color palette
│   │
│   ├── utils/                     # Utility classes
│   │   └── validators.dart        # Form validation utilities
│   │
│   └── widgets/                   # Shared widgets
│       ├── app_button.dart        # Custom button widget
│       ├── app_text_field.dart    # Custom text field widget
│       └── loading_indicator.dart # Loading widgets
│
├── data/                          # Data layer
│   ├── models/                    # Data models
│   │   └── (feature models)
│   │
│   ├── repositories/              # Repository implementations
│   │   └── (feature repositories)
│   │
│   └── data_sources/              # Remote and local data sources
│       └── (data sources)
│
├── features/                      # Feature-based structure
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Auth data layer
│   │   │   ├── models/            # Auth models
│   │   │   ├── repositories/      # Auth repositories
│   │   │   └── data_sources/      # Auth data sources
│   │   ├── domain/                # Auth domain layer
│   │   │   ├── entities/          # Auth entities
│   │   │   └── repositories/      # Auth repository interfaces
│   │   └── presentation/          # Auth UI layer
│   │       ├── pages/             # Auth screens
│   │       ├── widgets/           # Auth widgets
│   │       └── providers/         # Auth providers
│   │
│   └── profile/                   # Profile feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── l10n/                          # Localization
│   └── app_localizations.dart     # App translations (EN, AR, FR)
│
├── routes/                        # Navigation
│   ├── app_router.dart            # GoRouter configuration
│   └── route_names.dart           # Route constants
│
├── services/                      # App services
│   ├── supabase_service.dart      # Supabase service
│   └── storage_service.dart       # Local storage service
│
└── main.dart                      # App entry point
```

---

## 🔧 Configuration

### 1. Supabase Setup

Update `lib/core/constants/app_constants.dart` with your Supabase credentials:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 2. Platform-Specific Setup

#### Android
Add to `android/app/build.gradle.kts`:
```kotlin
android {
    defaultConfig {
        minSdk = 21
    }
}
```

Add Internet permission to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

#### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for profile photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access</string>
```

### 3. Deep Links Configuration

For Supabase auth deep links, configure:

**Android** - `android/app/src/main/AndroidManifest.xml`:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="masarat" android:host="auth"/>
</intent-filter>
```

**iOS** - `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>masarat</string>
        </array>
    </dict>
</array>
```

---

## 🏗️ Architecture

### Clean Architecture Layers

1. **Presentation Layer** (`presentation/`)
   - Pages/Screens
   - Widgets
   - Providers (Riverpod)

2. **Domain Layer** (`domain/`)
   - Entities
   - Repository interfaces
   - Use cases

3. **Data Layer** (`data/`)
   - Models
   - Repository implementations
   - Data sources (Remote/Local)

### State Management (Riverpod)

#### Provider Types Used:
- `Provider` - Read-only values
- `StateProvider` - Simple state
- `StateNotifierProvider` - Complex state
- `FutureProvider` - Async data
- `StreamProvider` - Real-time data

#### Example Provider Pattern:
```dart
// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(supabaseServiceProvider));
});

// State
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;
  
  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });
}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseService _supabaseService;
  
  AuthNotifier(this._supabaseService) : super(const AuthState());
  
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );
      state = AuthState(user: response.user);
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }
}
```

---

## 🛠️ Code Generation

### Generate Code
Run the following command to generate code for freezed, json_serializable, and riverpod:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode
For continuous code generation during development:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Creating Models with Freezed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

---

## 📱 Features

### Authentication (Supabase Auth)
- Email/Password sign up and sign in
- Phone authentication
- OAuth providers (Google, Apple, etc.)
- Magic link / OTP
- Password reset
- Email verification

### Storage Services
- **SharedPreferences** - For non-sensitive data (settings, preferences)
- **FlutterSecureStorage** - For sensitive data (tokens, credentials)

### Routing (GoRouter)
- Declarative routing
- Deep linking support
- Authentication guards
- Shell routes for bottom navigation
- Page transitions

### Localization
Supported languages:
- English (en)
- Arabic (ar) - RTL support
- French (fr)

To add a new language, update `lib/l10n/app_localizations.dart` and add translations to the appropriate map.

### Theming
- Material Design 3
- Light and Dark themes
- Custom color schemes
- Google Fonts (Poppins)

---

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Test Directory Structure
```
test/
├── unit/              # Unit tests
├── widget/            # Widget tests
└── integration/       # Integration tests
```

---

## 📦 Build & Deploy

### Build APK
```bash
flutter build apk --release
```

### Build iOS
```bash
flutter build ios --release
```

### Build Web
```bash
flutter build web --release
```

---

## 🔐 Security Best Practices

1. **Never commit sensitive data** - Use environment variables
2. **Secure storage** - Always use FlutterSecureStorage for tokens
3. **Input validation** - Use validators for all user inputs
4. **Error handling** - Use custom exceptions and failures
5. **Deep links** - Validate all deep link parameters

---

## 📝 Code Style

### Naming Conventions
- **Files**: snake_case (`user_model.dart`)
- **Classes**: PascalCase (`UserModel`)
- **Variables**: camelCase (`userName`)
- **Constants**: camelCase (`apiBaseUrl`) or SCREAMING_SNAKE_CASE for compile-time constants

### Import Order
1. Dart SDK imports
2. Flutter SDK imports
3. Package imports
4. Relative imports

### Documentation
- Use dartdoc comments (`///`) for public APIs
- Include examples in documentation

---

## 🐛 Debugging

### Enable Debug Logging
In `lib/core/constants/app_constants.dart`:
```dart
static const bool enableDebugLogging = true;
```

### Supabase Debug Mode
In `lib/services/supabase_service.dart`:
```dart
await Supabase.initialize(
  url: AppConstants.supabaseUrl,
  anonKey: AppConstants.supabaseAnonKey,
  debug: true, // Enable debug mode
);
```

---

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [Freezed Documentation](https://pub.dev/packages/freezed)

---

## 🤝 Contributing

1. Create a feature branch from `main`
2. Follow the existing code structure
3. Write tests for new features
4. Submit a pull request

---

## 📄 License

This project is proprietary and confidential.

---

## 👥 Contact

For questions or support, contact the development team.