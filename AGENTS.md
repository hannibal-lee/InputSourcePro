# Repository Guidelines

## Project Structure & Module Organization
- `Input Source Pro.xcodeproj` is the Xcode project; open it to build and run.
- `Input Source Pro/` holds the app source code.
  - `Controllers/`, `Models/`, `Persistence/`, `System/`, `UI/`, `Utilities/`, `Window/` group the core logic and UI.
  - `Resources/` contains `Info.plist`, `Signing.entitlements`, localized strings (`*.lproj`), and assets in `Resources/Assets.xcassets`.
  - `Preview Content/` includes SwiftUI preview assets.
- `imgs/` is used for README media.

## Build, Test, and Development Commands
- This fork targets macOS 10.15 Catalina. Prefer Xcode 12.x and avoid adopting APIs outside the Catalina SDK baseline unless every use is runtime-gated and has a Catalina fallback.
- Keep Swift Package Manager dependencies pinned for Catalina builds. `Package.resolved` must remain in Xcode 12-compatible v1 format.
- Open `Input Source Pro.xcodeproj` in Xcode and use:
  - `Cmd+B` to build and `Cmd+R` to run.
- CLI builds use the shared scheme name:
  - `xcodebuild -scheme "Input Source Pro" -configuration Debug build`

## Coding Style & Naming Conventions
- Swift-only codebase; follow Swift API Design Guidelines and existing conventions.
- Indentation is 4 spaces; keep declarations and SwiftUI views formatted like nearby files.
- Naming:
  - Types use `UpperCamelCase` (e.g., `IndicatorWindowController`).
  - Files follow type names, and extensions use `Type+Feature.swift` (e.g., `IndicatorWindowController+Activation.swift`).
- No repo-wide formatter or linter config is present; do not introduce reformatting-only diffs.

## Testing Guidelines
- This fork currently has no dedicated test target in the Xcode project.
- Validate changes with a local build and, for UI/input-source behavior, a manual run on macOS 10.15.

## Commit & Pull Request Guidelines
- Commit messages follow conventional commits with optional scopes, e.g., `feat(UI): add indicator toggle` or `fix: handle nil input source`.
- Branch names are descriptive and prefixed (e.g., `feature/add-xyz-support`, `fix/indicator-crash`).
- PRs should include: purpose, linked issues (e.g., `Closes #123`), summary of changes, and testing notes. Add screenshots or screen recordings for UI changes.
