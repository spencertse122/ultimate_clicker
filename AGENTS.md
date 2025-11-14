# Repository Guidelines

## Project Structure & Module Organization
`lib/` holds the Dart source (entry point in `lib/main.dart`) and should remain the only place where UI, business logic, and shared widgets live. Platform shells for Android, iOS, macOS, Windows, Linux, and Web stay in their respective folders, and you only touch them when you need native integrations. Keep reusable assets referenced in `pubspec.yaml`, and add integration- or golden-test fixtures under `test/` so CI can discover them automatically.

## Build, Test, and Development Commands
- `flutter pub get` — install Dart/Flutter dependencies defined in `pubspec.yaml`.
- `flutter run -d <device>` — launch the app on a connected device or simulator during development.
- `flutter test` — execute the Dart unit and widget tests under `test/`.
- `flutter build apk` / `flutter build ipa` / `flutter build web` — produce release artifacts for Android, iOS, or the web respectively; ensure `flutter clean` when switching targets.

## Coding Style & Naming Conventions
Follow `flutter format` defaults (2-space indentation, trailing commas in widget trees) and avoid mixing tabs/spaces. Widgets and classes use PascalCase (`HomeScreen`, `AppTheme`), methods and local variables use lowerCamelCase, and constant identifiers prefixed with `k` when global (`kPrimaryColor`). Keep files focused: one top-level class per file, file names snake_case. Prefer `const` constructors where possible and extract shared UI into `lib/widgets/`.

## Testing Guidelines
Write a matching `*_test.dart` file for every new class that contains logic. Use `testWidgets` for UI behavior, mock asynchronous services with `package:mocktail`, and keep golden images under `test/goldens/`. Tests should cover edge cases (null/empty inputs, slow network) and maintain ≥80% meaningful coverage before requesting review. Run `flutter test --coverage` locally; upload the resulting `coverage/lcov.info` if CI requests it.

## Commit & Pull Request Guidelines
Commits should be scoped and written using imperative sentences (`Add login bloc`, `Fix layout overflow`). Reference the module touched and include issue IDs when available. Pull requests must include: summary of changes, screenshots or GIFs for UI tweaks (Android + iOS), testing notes (`flutter test`, manual flows), and any migration steps. Request review from the platform owner when platform folders change, and mention breaking changes prominently in the PR description.
