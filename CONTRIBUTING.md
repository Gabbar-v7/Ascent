# Contributing to Ascent

Thank you for taking the time to contribute! This guide will help you get up to speed with the codebase conventions, workflow, and quality standards expected for Ascent.

All contributions are welcome, including bug fixes, features, documentation improvements, and translations.

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Fork** the repository on GitHub.

2. **Clone** your fork locally:

   ```bash
   git clone https://github.com/<username>/Ascent.git
   cd Ascent
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the app** to confirm everything works:
   ```bash
   flutter run
   ```

## Branching Strategy (Recommended)

| Branch pattern | Purpose                          |
| -------------- | -------------------------------- |
| `master`       | Stable, release-ready code       |
| `feat/<name>`  | New features                     |
| `fix/<name>`   | Bug fixes                        |
| `chore/<name>` | Tooling, dependencies, refactors |
| `docs/<name>`  | Documentation only               |

Always branch off `master`:

```bash
git checkout -b feat/<name>
```

## Commit Specification

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(optional scope): <description>

[optional body]

[optional footer(s)]
```

**Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

**Examples:**

```
feat(timer): add session history to Pomodoro screen
fix(tasks): patch broken filter conditions in task query
docs(readme): update screenshots section
chore(deps): upgrade drift to 2.x
```

- Use the **imperative mood** in the summary ("add", not "added" or "adds").

## Code Style

Ascent follows the official [Effective Dart: Style Guide](https://dart.dev/effective-dart/style) and general Flutter best practices. Please keep contributions consistent with the existing codebase.

### Formatting

- Run `dart format .` before every commit. The project follows an **80-character line length** convention.
- Use `flutter analyze` to catch lint issues before opening a PR.
- Do not suppress lint warnings with `// ignore:` comments unless absolutely necessary; if you do, always explain why.

```bash
dart format .
flutter analyze
```

### Comments & Documentation

- Write [documentation comments](https://dart.dev/language/comments#documentation-comments) (`///`) for all public APIs such as classes, methods, and top-level functions.
- Use plain `//` comments for inline implementation notes.
- Documentation comments should explain **what** the code does and **why** it exists, rather than describing **how** it works.
- Prefer self-documenting code instead of excessive comments.
- Omit obvious doc comments such as `/// The title of the task.` on a field named `taskTitle`.
- Start doc comments with a **brief, single-sentence summary** ending with a period. Add further detail after a blank line if needed.
