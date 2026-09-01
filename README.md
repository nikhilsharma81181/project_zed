# Project Zed

A mobile esports app: tournament arenas, leaderboards, a social feed, and an in-app wallet. Built with Flutter and Firebase.

> **Status: archived work in progress.** Development stopped in May 2024. The codebase is public as a reference for the architecture, not as a shipping product.

## Features

- **Arena** — browse and enter tournaments
- **Leaderboard** — player rankings
- **Feed** — social activity feed
- **Wallet** — in-app balance and transactions
- **Profile** — player identity and stats
- **Auth** — Firebase email, phone OTP, and Google Sign-In

## Architecture

Clean Architecture with a feature-first layout. Each feature under `lib/features/` carries its own data, domain, and presentation layers, so business logic stays independent of Flutter.

Two decisions worth calling out:

**Functional error handling.** Instead of throwing exceptions across layers, use cases return `Either<Failure, T>` via [fpdart](https://pub.dev/packages/fpdart). Callers have to handle the failure case explicitly, which removes a whole class of uncaught runtime errors.

**Hooks with Riverpod.** `hooks_riverpod` combines Riverpod's dependency graph with `flutter_hooks` for local widget state, which keeps widgets small without a separate controller class for every screen.

```
lib/
  core/
    server_config/   API configuration
    constant/        App-wide constants
    usecase/         Base use case contracts
    error/           Failure types
    services/        Shared services
  features/
    arena/           Tournaments
    leaderboard/     Rankings
    feed/            Social feed
    wallet/          Balance and transactions
    profile/         Player profile
    authentication/  Sign in and sign up
```

## Stack

| Concern | Package |
|---|---|
| State management | hooks_riverpod, flutter_hooks |
| Routing | go_router |
| Networking | dio |
| Auth and data | firebase_auth, cloud_firestore, google_sign_in |
| Error handling | fpdart |
| Models | freezed, json_serializable |
| Env secrets | envied |
| Local storage | shared_preferences |

Typography: Lato for headings, Open Sans for body text, Exo 2 for numerals.

## Backend

The API lives in a separate repository: [project_zed_server](https://github.com/nikhilsharma81181/project_zed_server).

## Running locally

Requires the Flutter SDK.

```bash
git clone https://github.com/nikhilsharma81181/project_zed.git
cd project_zed
flutter pub get
flutter run
```

The repository ships with a Firebase configuration for the original development project. To point it at your own Firebase project, replace `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, and `lib/firebase_options.dart` with your own via `flutterfire configure`.
