# Repository Guidelines

## Project Structure & Module Organization
- Flutter plugin exposing native iOS/macOS widgets via platform channels.
- Dart widgets live in `lib/components/` (one class per file).
- Native code: iOS in `ios/Classes/`, macOS in `macos/Classes/`.
- Example app and demos in `example/` (demos under `example/lib/demos/`).
- Tests in `test/` and `example/test/` or `example/integration_test/`.
- Config: `pubspec.yaml`, `analysis_options.yaml`, and platform podspecs.

## Build, Test, and Development Commands
- Install deps: `flutter pub get`
- Static analysis: `flutter analyze`
- Format: `dart format .` (respect `analysis_options.yaml`)
- Unit/widget tests: `flutter test`
- Run example: `flutter run -t example/lib/main.dart`
- Build iOS (no codesign): `flutter build ios --no-codesign`

## Coding Style & Naming Conventions
- Follow Flutter/Dart style; 2-space indent; null-safety required.
- File names use `snake_case.dart`; class names are `UpperCamelCase`.
- Widgets in this plugin use the `CN` prefix (e.g., `CNPopupMenuButton`).
- One widget per file and class; keep public APIs documented with `///`.
- Mirror widget names across Dart and Swift where practical.

## Testing Guidelines
- Place tests in `test/` with `_test.dart` suffix.
- Add demo pages for new widgets under `example/lib/demos/` and verify on device/simulator.
- Prefer widget tests for public behavior; guard platform channel args/edge cases.
- Run `flutter analyze` and `flutter test` before pushing.

## Commit & Pull Request Guidelines
- Use clear, imperative commit messages (e.g., "Add CNFoo widget").
- PRs must include: description, linked issues, screenshots/GIFs for UI, and notes on platform changes.
- Update example demos and README where relevant.
- Ensure CI green: run analyze/tests locally first.

## Widget Development Rules (Important)
- Every widget must have:
  - A dedicated Dart file/class in `lib/components/`.
  - A demo page in `example/lib/demos/`.
  - Corresponding Swift implementations for iOS and macOS.
- Follow existing component patterns; review similar widgets before adding new ones.
- Always run `flutter analyze` after changes.
