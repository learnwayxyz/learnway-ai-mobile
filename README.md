# LearnWay - Build & Run Guide

This guide covers how to run the LearnWay app in different environments and build release artifacts (APK/AAB/IPA).

## Prerequisites

- Flutter SDK (3.24.0 or higher)
- For Android: Android Studio with SDK
- For iOS: Xcode 15+ (macOS only)
- Java JDK 17

## Project Structure

The app has three flavors/environments:

| Flavor  | Purpose                | Package ID               |
| ------- | ---------------------- | ------------------------ |
| dev     | Development & testing  | xyz.learnway.app.dev     |
| staging | Pre-production testing | xyz.learnway.app.staging |
| prod    | Production release     | xyz.learnway.app         |

## Initial Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Required Code

The app uses envied for environment variables and build_runner for code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Environment Files

Ensure you have the following `.env` files in your project root:

- `.env.dev` - Development configuration
- `.env.staging` - Staging configuration
- `.env.prod` - Production configuration

## Running the App

### Run on Connected Device/Emulator

**Development :**

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

**Staging :**

```bash
flutter run --flavor staging -t lib/main_staging.dart
```

**Production :**

```bash
flutter run --flavor prod -t lib/main.dart
```

### Run on Specific Device

First, list available devices:

```bash
flutter devices
```

Then run on a specific device:

```bash
# Android emulator
flutter run --flavor dev -t lib/main_dev.dart -d emulator-5554

# iOS simulator
flutter run --flavor dev -t lib/main_dev.dart -d "iPhone 15 Pro"

# Physical device
flutter run --flavor dev -t lib/main_dev.dart -d <device-id>

# Chrome (web)
flutter run --flavor dev -t lib/main_dev.dart -d chrome
```

### Run with Hot Reload

Flutter's hot reload works with all flavors:

- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

## Building Release Artifacts

### Android APK

APKs are suitable for direct installation and testing.

**Development APK:**

```bash
flutter build apk --flavor dev -t lib/main_dev.dart --release
```

Output: `build/app/outputs/flutter-apk/app-dev-release.apk`

**Staging APK:**

```bash
flutter build apk --flavor staging -t lib/main_staging.dart --release
```

Output: `build/app/outputs/flutter-apk/app-staging-release.apk`

**Production APK:**

```bash
flutter build apk --flavor prod -t lib/main.dart --release
```

Output: `build/app/outputs/flutter-apk/app-prod-release.apk`

### Android App Bundle (AAB)

AAB is required for Google Play Store submissions. It provides smaller download sizes through dynamic delivery.

**Development AAB:**

```bash
flutter build appbundle --flavor dev -t lib/main_dev.dart --release
```

Output: `build/app/outputs/bundle/devRelease/app-dev-release.aab`

**Staging AAB:**

```bash
flutter build appbundle --flavor staging -t lib/main_staging.dart --release
```

Output: `build/app/outputs/bundle/stagingRelease/app-staging-release.aab`

**Production AAB (for Play Store):**

```bash
flutter build appbundle --flavor prod -t lib/main.dart --release
```

Output: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`

### iOS IPA

IPA files are used for App Store submissions and TestFlight distribution.

**Development IPA:**

```bash
flutter build ipa --flavor dev -t lib/main_dev.dart --release
```

Output: `build/ios/ipa/`

**Staging IPA:**

```bash
flutter build ipa --flavor staging -t lib/main_staging.dart --release
```

Output: `build/ios/ipa/`

**Production IPA (for App Store):**

```bash
flutter build ipa --flavor prod -t lib/main.dart --release
```

Output: `build/ios/ipa/`

## Advanced Build Options

### Build with Custom Version

Set custom version name and build number:

```bash
flutter build apk \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --build-name=1.2.0 \
  --build-number=42
```

### Build with Code Obfuscation (Recommended for Production)

Obfuscation makes reverse engineering more difficult:

```bash
# Android APK
flutter build apk \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# Android AAB
flutter build appbundle \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# iOS IPA
flutter build ipa \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --obfuscate \
  --split-debug-info=build/ios/symbols
```

**Important:** Keep the symbols directory for crash report symbolication in Firebase Crashlytics.

### Split APKs by CPU Architecture

Generate smaller APKs for each CPU architecture:

```bash
flutter build apk \
  --flavor prod \
  -t lib/main.dart \
  --release \
  --split-per-abi
```

This creates three APKs:

- `app-prod-armeabi-v7a-release.apk` (32-bit ARM - older devices)
- `app-prod-arm64-v8a-release.apk` (64-bit ARM - most modern devices)
- `app-prod-x86_64-release.apk` (64-bit Intel - emulators/tablets)

## Installing Built APKs

### Install via ADB

```bash
# Install dev APK
adb install build/app/outputs/flutter-apk/app-dev-release.apk

# Install staging APK
adb install build/app/outputs/flutter-apk/app-staging-release.apk

# Install production APK
adb install build/app/outputs/flutter-apk/app-prod-release.apk
```

### Install Directly with Flutter

```bash
# Build and install dev
flutter install --flavor dev -t lib/main_dev.dart

# Build and install staging
flutter install --flavor staging -t lib/main_staging.dart

# Build and install production
flutter install --flavor prod -t lib/main.dart
```

# Regenerate code

flutter pub run build_runner build --delete-conflicting-outputs

# Try building again

```
flutter build apk --flavor dev -t lib/main_dev.dart --release
```
