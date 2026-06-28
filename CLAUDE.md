# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# LearnWay V2 — Claude Instructions

## Code Style

### Class structure

Constructors must always come before class variables/fields.

```dart
// correct
class Foo {
  Foo({required this.bar});

  final String bar;
}

// wrong
class Foo {
  final String bar;

  Foo({required this.bar});
}
```

## Environment Variables

### Files

- `.env.dev` — dev/testnet values
- `.env.staging` — staging/mainnet values
- `.env.prod` — production/mainnet values

### Dart env class files

- `lib/config/env/env.dev.dart` — `EnvDev` (reads `.env.dev`)
- `lib/config/env/env.staging.dart` — `EnvStaging` (reads `.env.staging`)
- `lib/config/env/env.prod.dart` — `EnvProd` (reads `.env.prod`)
- `lib/config/env/env.dart` — `Env` class with `_getValue(dev, staging, prod)` getters consumed by the app

### Rules — follow every time an env var is added or changed

1. **Add the value to every `.env.*` file** that applies. If a value only changes for some flavors, still confirm the others are correct.

2. **Add or update the `@EnviedField` declaration** in the matching Dart env class file for each flavor. Follow the existing naming convention:
   - Dev: `dev*` prefix (e.g. `devpaymasterUrl`)
   - Staging: `stage*` prefix (e.g. `stagePaymasterUrl`)
   - Prod: `prod*` prefix (e.g. `prodPaymasterUrl`)

3. **Add or update the getter in `env.dart`** using `_getValue(EnvDev.*, EnvStaging.*, EnvProd.*)`. Never hardcode an empty string `''` as a flavor value — if a flavor was missing a field, add it properly.

4. **Verify the generated `.g.dart` files point to the correct URLs/credentials** — especially when replacing an existing value. The generated file caches the old value until rebuilt.

5. **When replacing an existing value** (not just adding a new one), run:

   ```flutter
   flutter clean && flutter pub get
   ```

   before running the build command, otherwise the old baked-in value may persist.

6. **Always regenerate** after any change to a `.env.*` file or `@EnviedField` declaration:

   ```flutter
   dart run build_runner build --delete-conflicting-outputs
   ```

### Paymaster URLs

- Dev: `https://learnway-backend-dev.up.railway.app/paymaster/rpc`
- Staging: `https://api.learnway.app/rpc`
- Prod: `https://api.learnway.app/rpc`

### Bundler URLs

- Dev: `https://alto-development.up.railway.app`
- Staging: `https://mainnet-bundler.up.railway.app/`
- Prod: `https://mainnet-bundler.up.railway.app/`

---

## Commands

### Run the app

```bash
flutter run --flavor dev -t lib/main_dev.dart        # development
flutter run --flavor staging -t lib/main_staging.dart # staging
flutter run --flavor prod -t lib/main.dart            # production
```

### Build

```bash
flutter build apk --flavor dev -t lib/main_dev.dart --release
flutter build appbundle --flavor prod -t lib/main.dart --release
flutter build ipa --flavor prod -t lib/main.dart --release
```

### Code generation

Required after any change to `.env.*` files, `@EnviedField` declarations, auto_route routes, or JSON-serializable models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Analyze & test

```bash
flutter analyze
flutter test                          # all tests
flutter test test/features/quiz/      # single directory
flutter test test/features/quiz/quiz_bloc_test.dart  # single file
```

---

## Architecture

### Flavors and entry points

Three flavors share `lib/main_common.dart` for initialization. Entry points:

- `lib/main_dev.dart` → sets `Flavor.dev`, calls `mainCommon()`
- `lib/main_staging.dart` → sets `Flavor.staging`
- `lib/main.dart` → sets `Flavor.prod`

`mainCommon()` initializes: `LocalStorageService` (Hive), `ConnectivityService`, GetIt DI via `setupLocator()`, then fetches remote API config.

### Feature structure

Every feature under `lib/features/<name>/` follows the same layering:

```script
data_source/   — raw HTTP calls, parses JSON into models
repository/    — wraps data source, returns Either<Failure, T> via dartz
bloc/ or cubit/ — consumes repository, drives UI state
view/          — screens and widgets
models/        — data models (some generated with json_serializable)
```

All repositories use `Either<Failure, T>` from `dartz`. Blocs call `.fold(left, right)` on the result.

### Dependency injection

Single `GetIt` instance at `lib/di/locator.dart` (`locator`). Everything is registered in `setupLocator()` at startup. Blocs/cubits are `registerLazySingleton` — they persist for the app lifetime. Use `locator<T>()` anywhere; prefer constructor injection in tests.

### Routing

`auto_route` with a generated router at `lib/router/app_router.gr.dart`. The singleton `appRouter` lives in `lib/app/app.dart`. Screens are annotated `@RoutePage()`. After adding or modifying a route, run code generation.

### State management

BLoC for complex multi-state flows (quiz, learn-and-earn, home), Cubit for simpler cases (profile, wallet, notifications). All blocs are singletons in GetIt.

### Networking

`BaseApiClients` in `lib/core/network/client.dart` wraps `http` with JWT injection and a base URL. Each feature data source gets `locator<BaseApiClients>()`. Separate named instances exist for Kotani Pay (`kotaniApiClient`) and DidIt KYC (`didItApiClient`).

### Local storage

- **Hive** (`LocalStorageService`): user profile, wallet address, exchange rates, JWT token. All boxes are opened at startup.
- **SharedPreferences** (`SharedPreferencesStore`): JWT token (also accessible via Hive `user` box), sound/notification settings.
- **In-memory `ValueNotifier`**: `LocalStorageService.dailyLessonsNotifier` holds the current daily lessons remaining count. Never persisted — resets to `null` on app restart.

### Daily lessons limit

Free users have a daily cap on new lesson completions. The count is tracked in `LocalStorageService.dailyLessonsNotifier` (in-memory `ValueNotifier<int?>`).

- **Initialization**: `HomeDataSource.fetchHomeData()` sets the notifier from `auth/profile` on the first home load.
- **Decrement**: `QuizRemoteDataSource.submitQuizResults()` decrements by 1 on every successful non-retake submission (the submit endpoint returns `dailyLessonsRemaining` pre-decrement, so the local decrement is applied immediately).
- **Dedicated endpoint**: `GET /api/v2/user-lesson/daily-remaining` returns the authoritative current count.
- **Lock logic**: `LessonBuilder._getLockState()` in `lib/features/learn_and_earn/view/lesson_screen.dart` reads the notifier. Retakes (already-completed lessons) bypass the check entirely.

### Crypto wallet (EIP-4337)

`AAServices` in `lib/services/eip_4337/account_abstraction.dart` wraps account abstraction via `variance_dart` (forked at `learnwayxyz/variance-dart-learnway`). Wallet private key shards are split via Shamir's Secret Sharing (`SecretSharingManager`) and stored in iCloud/Google Drive depending on platform. The paymaster and bundler URLs are flavor-gated through `Env`.
