# SKILL.md — AI Context for Future Sessions

## Project Summary

Flutter app: User Profile (Lab 2). 3-tab layout with glassmorphism design from EAM system.

## Design Tokens

| Token | Dark | Light |
|---|---|---|
| Background | `#080A11` | `#F4F7FF` |
| Surface | `#0E121F` | `#FFFFFF` |
| Accent | `#50C8FF` | `#173EAC` |
| Body text | `#EFF3FF` | `#4F607F` |
| Heading | `#F7F9FF` | `#253654` |
| Border | `rgba(125,151,199,0.18)` | `rgba(101,119,162,0.16)` |
| NavBar | `#0D1020` | `#FFFFFF` |
| Font | Nunito (Google Fonts) | same |

## Critical Files

| File | Purpose |
|---|---|
| `lib/core/constants/app_colors.dart` | All color constants |
| `lib/core/constants/app_strings.dart` | All strings, URLs, asset paths |
| `lib/core/theme/app_theme.dart` | ThemeData dark + light |
| `lib/core/theme/theme_notifier.dart` | ValueNotifier<ThemeMode> + SharedPreferences |
| `lib/widgets/glass_card.dart` | Reusable glassmorphism card widget |
| `lib/app.dart` | App root: StatefulWidget → MaterialApp + _MainScaffold |
| `lib/main.dart` | async main → SharedPreferences.getInstance() → runApp |
| `android/app/build.gradle` | Signing config via key.properties |
| `.github/workflows/release.yml` | CI: flutter create → sign → build → release |

## Key Patterns

**Theme switching:**
```dart
// In App._AppState (StatefulWidget):
late final ThemeNotifier _themeNotifier; // = ThemeNotifier(prefs) in initState
// ValueListenableBuilder wraps MaterialApp, passes themeMode: notifier.value
```

**GlassCard:**
```dart
// isDark → BackdropFilter(blur(12,12)) + darkGlass color + darkBorder
// isLight → plain white + lightBorder + subtle boxShadow
```

**Asset paths:** all assets in `user-files/` declared in pubspec.yaml as `- user-files/`

**Age calculation:** `DateTime(2004, 10, 6)` → computed on every build

**Like button:** `SharedPreferences` keys `profile_likes` (int) + `profile_liked` (bool)

**PDF open:** `rootBundle.load()` → write to `getTemporaryDirectory()` → `OpenFilex.open()`

**Gallery:** `CachedNetworkImage` from `picsum.photos/seed/{i}/400/400`, seeds 1–30

## CI/CD Architecture

- Trigger: push to `main`
- Runner: `ubuntu-latest`
- Steps: checkout → JDK17 → Flutter 3.24.5 → `flutter create . --platforms android` → decode keystore → key.properties → pub get → analyze → test → `flutter build apk --release` → GitHub Release
- Secrets: `KEYSTORE_BASE64`, `KEY_STORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`
- Stable URL: `releases/latest/download/app-release.apk`

## Packages

```yaml
google_fonts: ^6.2.1
cached_network_image: ^3.3.1
url_launcher: ^6.3.0
open_filex: ^4.4.1
path_provider: ^2.1.3
shared_preferences: ^2.2.3
photo_view: ^0.14.0
```

## Android Config

- namespace: `com.example.flatter_lab_2`
- minSdk: `flutter.minSdkVersion` (21)
- compileSdk: `flutter.compileSdkVersion`
- Gradle 8.6, AGP 8.3.1, Kotlin 1.9.22
- Signing: `key.properties` → `signingConfigs.release` in `buildTypes.release`
