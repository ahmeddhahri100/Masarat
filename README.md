# Masarat — Shared Journeys, Trusted Community

> A cross-platform trip-sharing / carpooling community app built with **Flutter**, focused on Tunisia. Coordinate trips with your community — not a taxi app.

[![Flutter](https://img.shields.io/badge/Flutter-3.32-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Postgres-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Clerk](https://img.shields.io/badge/Auth-Clerk-6C47FF?logo=clerk&logoColor=white)](https://clerk.com)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-6524FF)](https://riverpod.dev)

Live demo: Flutter Web build served from `masarat/build/web` (see Deployment).
Repo: `git@github.com:ahmeddhahri100/Masarat.git`

## ✨ What it does

* **Create trips** — departure, destination, date/time, seats, price (`create_trip_screen.dart`, `TripModel`)
* **Search & discover** — search by departure/destination, recent trips, featured/boosted trips (`search_results_screen.dart`, `home_screen.dart`)
* **Join flow** — Join Trip / Request Seat / Available Seats (community coordination model, see `app_strings.dart`)
* **Trip details + requests** — driver view of join requests (`trip_details_screen.dart`, `trip_requests_screen.dart`)
* **Chat to coordinate** — per-trip realtime messaging + conversations list (`chat_screen.dart`, `conversations_screen.dart`, Supabase `messages` stream)
* **Profiles** — view/edit profile, my trips (`profile_screen.dart`, `edit_profile_screen.dart`, `my_trips_screen.dart`, Supabase `profiles` table)
* **Boost / Premium** — boosted trip listing + premium upsell screens (`boost_trip_screen.dart`, `premium_screen.dart`, `featured_trip_card.dart`)
* **Onboarding + Auth gate** — welcome → onboarding → sign-in/sign-up → home (`welcome_screen.dart`, `onboarding_screen.dart`, `main.dart:_AuthGate`)
* **Notifications / Settings** — notifications list, settings (`notifications_screen.dart`, `settings_screen.dart`)

## 🧰 Tech stack

| Layer | Choice | Notes |
|---|---|---|
| Framework | Flutter 3.32 / Dart `>=3.0.0 <4.0.0` | `masarat/pubspec.yaml`, `version: 1.0.0+1` |
| State | `flutter_riverpod ^3.3.1` | `ProviderScope` in `main.dart` |
| Backend / DB / Realtime | `supabase_flutter ^2.12.0` | `SupabaseService` — trips / profiles / messages streams |
| Auth | Clerk (`clerk_flutter`) + Supabase Auth | Active gate is Clerk in `main.dart`; `AuthService` + `clerk_auth_service.dart`; Supabase email/password path kept as fallback |
| UI | `google_fonts ^6.3.2`, `lucide_icons`, `flutter_svg ^2.0.10+1`, Material | Theme in `core/theme/` |
| Utils | `intl`, `uuid`, `path_provider`, `cupertino_icons` | Formatting, IDs, storage |
| Web preview | `serve.py` (Python `http.server`, port 5000) | Serves `masarat/build/web` |

## 📁 Project structure

```text
.
├── README.md                  # ← you are here (repo overview)
├── replit.md                  # Replit agent notes / dev setup history
├── serve.py                   # Static server for Flutter web build (port 5000)
├── .replit                    # Replit workflow config
└── masarat/                   # Flutter project root
    ├── lib/
    │   ├── main.dart          # Supabase init + Clerk gate → Home / Welcome
    │   ├── core/constants/app_strings.dart
    │   ├── core/theme/        # colors, typography, app_theme
    │   ├── components/        # trip_card, featured_trip_card, status_chip, limit_reached_modal
    │   ├── models/            # trip_model, user_model, message_model
    │   ├── screens/           # 17 screens (home, search, create, chat, profile, premium…)
    │   └── services/          # supabase_service, auth_service, clerk_auth_service
    ├── supabase_clerk_rls_policies.sql  # RLS policies for Clerk JWT (sub claim)
    ├── pubspec.yaml
    ├── web/                   # Flutter web entry
    └── build/web/             # Release build output (served, git-ignored ideally)
```

## 🚀 Getting started

### Prerequisites

* Flutter 3.32.0 (Dart 3.8.0) — `flutter --version`
* Supabase project + Clerk application

### 1. Clone & install

```bash
git clone git@github.com:ahmeddhahri100/Masarat.git
cd Masarat/masarat
flutter pub get
```

### 2. Configure backend

Supabase tables expected: `trips`, `profiles`, `messages` (see `supabase_service.dart` + `supabase_clerk_rls_policies.sql`).

Run the RLS script in Supabase SQL Editor:

```bash
# file: masarat/supabase_clerk_rls_policies.sql
# - enables RLS on profiles / trips
# - maps Clerk JWT sub → user id
# - public read on trips, owner-only write on profiles
```

> ⚠️ **Security — action required:** Supabase URL/anon-key are currently hardcoded in `masarat/lib/services/supabase_service.dart:9-12` and the Clerk publishable key in `masarat/lib/main.dart:11-12`. Rotate those keys and move them to `--dart-define` / `--dart-define-from-file` or a git-ignored `.env` before any public release. Never commit service-role keys.

Example (recommended):

```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=CLERK_KEY=...
```

### 3. Run

```bash
cd masarat
flutter run -d chrome        # web
flutter run                  # connected device / emulator
```

### 4. Web preview / deployment

```bash
cd masarat && flutter build web --release
cd .. && python3 serve.py
# → http://0.0.0.0:5000 serving masarat/build/web
```

Static hosts: publish `masarat/build/web` as-is (Replit static deployment uses build `flutter build web --release`, public dir `masarat/build/web`).

## 📸 Screenshots

No screenshots committed yet. Suggested: `docs/screenshots/home.png`, `search.png`, `trip-details.png`, `chat.png` (Flutter web @ 1280×800 + 1 Android shot), then embed here.

## 🗺️ Roadmap

* [ ] Move secrets to env / dart-define + rotate exposed keys
* [ ] Seat-request accept/decline flow + push notifications
* [ ] Trip ratings / trust badges
* [ ] Arabic + French localization (currently English strings in `app_strings.dart`)
* [ ] Widget + integration tests (`masarat/test/` is empty)
* [ ] CI: `flutter analyze`, `flutter test`, `flutter build web`

## 🤝 Contributing

PRs welcome. Run `flutter analyze` and `flutter test` before opening a PR. For large changes, open an issue first.

## 👤 Author

**Ahmed Dhahri** — DevSecOps / Cybersecurity Engineer
* GitHub: [@ahmeddhahri100](https://github.com/ahmeddhahri100)
* Blog: [ahmeddhahri100.github.io](https://ahmeddhahri100.github.io)
* LinkedIn: [ahmeddhahri100](https://www.linkedin.com/in/ahmeddhahri100)

## 📄 License

No license file yet — add `LICENSE` (MIT recommended) if you want open-source contributions. 
