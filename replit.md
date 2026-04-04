# Masarat - Flutter Travel/Trip Sharing App

## Project Overview
Masarat is a cross-platform travel/trip-sharing platform built with Flutter. Users can create, search for, and manage trips, with social features like messaging and user profiles.

## Tech Stack
- **Framework:** Flutter (Dart) - web target
- **State Management:** Riverpod (flutter_riverpod)
- **Backend/Database:** Supabase (supabase_flutter)
- **Authentication:** Clerk (clerk_flutter)
- **UI:** Google Fonts, Lucide Icons, flutter_svg

## Project Structure
```
masarat/           # Flutter project root
  lib/
    core/          # Theme (colors, typography)
    components/    # Reusable widgets (trip_card, status_chip, etc.)
    models/        # Data models (User, Trip, Message)
    screens/       # UI pages (home, chat, onboarding, welcome, etc.)
    services/      # Supabase and Clerk service integrations
  web/             # Flutter web entry point
  build/web/       # Built web output (served by Python server)
serve.py           # Python static file server (port 5000)
```

## Development Setup
- Flutter 3.32.0 (Dart 3.8.0) installed via system dependencies
- Dependencies managed via `pubspec.yaml` (pub package manager)
- SDK constraint relaxed to `>=3.0.0 <4.0.0` for Dart 3.8.0 compatibility
- `google_fonts` pinned to `^6.3.2` and `flutter_svg` to `^2.0.10+1` for Dart 3.8.0 compat

## Running the App
The workflow uses a Python static file server (`serve.py`) to serve the pre-built Flutter web release build from `masarat/build/web/` on port 5000.

To rebuild after code changes:
```bash
cd masarat && flutter build web --release
```
Then restart the workflow.

## Authentication
Authentication is handled by **Supabase Auth** (email/password). Clerk integration is present in the codebase but not used — `AuthService` in `lib/services/auth_service.dart` is the active auth layer.

- Sign up creates a Supabase user and a profile row in the `profiles` table
- If Supabase requires email confirmation, users will be prompted to check their inbox before signing in
- Sign out clears the Supabase session and returns to WelcomeScreen

## Configuration
- **Supabase URL/Key:** Hardcoded in `lib/services/supabase_service.dart`

## Deployment
Configured as a static deployment with:
- Build: `cd masarat && flutter build web --release`
- Public dir: `masarat/build/web`
