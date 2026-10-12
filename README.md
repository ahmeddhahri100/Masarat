# 🇹🇳 Masarat — Tunisia's First Community Trip-Sharing Mobile App

> Shared Journeys, Trusted Community.

> A cross-platform trip-sharing / carpooling community app built with **Flutter**, focused on Tunisia. Coordinate trips with your community — not a taxi app.

[![Flutter](https://img.shields.io/badge/Flutter-3.32-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Postgres-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Clerk](https://img.shields.io/badge/Auth-Clerk-6C47FF?logo=clerk&logoColor=white)](https://clerk.com)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-6524FF)](https://riverpod.dev)

Repo: `git@github.com:ahmeddhahri100/Masarat.git`

## ✨ What it does

* **Create trips** — departure, destination, date/time, seats, price (`create_trip_screen.dart`, `TripModel`)
* **Search & discover** — search by departure/destination, recent trips, featured/boosted trips (`search_results_screen.dart`, `home_screen.dart`)
* **Join flow** — Join Trip / Request Seat / Available Seats (community coordination model, see `app_strings.dart`)
* **Trip details + requests** — driver view of join requests (`trip_details_screen.dart`, `trip_requests_screen.dart`)
* **Chat to coordinate** — per-trip realtime messaging + conversations list (`chat_screen.dart`, `conversations_screen.dart`, Supabase `messages` stream)
* **Profiles** — view/edit profile, my trips (`profile_screen.dart`, `edit_profile_screen.dart`, `my_trips_screen.dart`, Supabase `profiles` table)
* **Boost / Premium** — boosted trip listing + premium upsell screens (`boost_trip_screen.dart`, `premium_screen.dart`, `featured_trip_card.dart`)
* **Onboarding + Auth** — 3-slide animated onboarding → 2-step sign-up (account + profile setup + email-code verification) / sign-in → home (`onboarding_screen.dart`, `signup_screen.dart`, `signin_screen.dart`, `main.dart:_AuthGate`)
* **Notifications / Settings** — notifications list, settings (`notifications_screen.dart`, `settings_screen.dart`)

## 🧰 Tech stack

| Layer | Choice | Notes |
|---|---|---|
| Framework | Flutter 3.32+ / Dart `>=3.0.0 <4.0.0` | `masarat/pubspec.yaml`, `version: 1.0.0+1` |
| State | `flutter_riverpod ^3.3.1` | `ProviderScope` in `main.dart` |
| Backend / DB / Realtime | `supabase_flutter ^2.12.0` | `SupabaseService` — trips / profiles / messages streams |
| Auth | Clerk (`clerk_flutter`) | Active gate is Clerk in `main.dart`; `AuthService` + `clerk_auth_service.dart`; password sign-up with email-code verification |
| UI | `google_fonts ^6.3.2`, `lucide_icons`, `flutter_svg ^2.0.10+1`, Material | Editorial "Curated Journey" design system in `core/theme/` (Stitch) |
| Utils | `intl`, `uuid`, `path_provider`, `cupertino_icons` | Formatting, IDs, storage |

## 📁 Project structure

```text
.
├── README.md                  # ← you are here (repo overview)
└── masarat/                   # Flutter project root
    ├── lib/
    │   ├── main.dart          # Supabase init + Clerk gate → Home / Onboarding
    │   ├── core/config/env.dart       # --dart-define keys (never hardcoded)
    │   ├── core/constants/app_strings.dart
    │   ├── core/theme/        # colors, typography, app_theme
    │   ├── components/        # trip_card, featured_trip_card, status_chip, limit_reached_modal
    │   ├── models/            # trip_model, user_model, message_model
    │   ├── screens/           # 18 screens (onboarding, signup, signin, home, search, create, chat, profile…)
    │   └── services/          # supabase_service, auth_service, clerk_auth_service
    ├── supabase_clerk_rls_policies.sql  # RLS policies for Clerk JWT (sub claim)
    ├── .env.example           # Key names template (no real values)
    ├── .dart-define.json      # Local keys (git-ignored, never committed)
    ├── pubspec.yaml
    ├── web/                   # Flutter web entry
    └── build/web/             # Release build output (git-ignored)
```

## 🚀 Getting started

### Prerequisites

* Flutter stable (tested with 3.47, Dart 3.13) — `flutter --version`
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

Keys are passed at build/run time with `--dart-define` (see `core/config/env.dart`, never hardcoded). Copy the template and fill in your values:

```bash
# masarat/.dart-define.json (git-ignored — never commit real keys)
{
  "SUPABASE_URL": "https://xyzcompany.supabase.co",
  "SUPABASE_ANON_KEY": "eyJ...",
  "CLERK_PUBLISHABLE_KEY": "pk_test_..."
}
```

> ⚠️ **Security:** never commit real keys. Past keys visible in git history should be rotated in the Supabase/Clerk dashboards. Never commit service-role keys.

### 3. Run

```bash
cd masarat
flutter run -d emulator-5554 --dart-define-from-file=.dart-define.json  # Android emulator
flutter run -d chrome --dart-define-from-file=.dart-define.json         # web
```

Without keys the app starts in demo mode (onboarding UI with a "DEMO — no keys" banner); Clerk sign-up/sign-in requires the keys above.

Auth flow: onboarding → sign-up (Step 1 account + role → Step 2 profile → email-code verification) or sign-in → home. Back navigation always returns to onboarding (no dead-ends).

### 4. Web deployment

```bash
cd masarat && flutter build web --release \
  --dart-define-from-file=.dart-define.json
```

Publish `masarat/build/web` as-is on any static host.

## 📸 Screenshots

No screenshots committed yet. Suggested: `docs/screenshots/home.png`, `search.png`, `trip-details.png`, `chat.png` (Flutter web @ 1280×800 + 1 Android shot), then embed here.

## 🗺️ Roadmap

* [x] Move secrets to env / dart-define (keys no longer hardcoded)
* [ ] Rotate keys exposed in git history
* [ ] Persist sign-up profile data (role / hometown / phone) to Supabase `profiles`
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
