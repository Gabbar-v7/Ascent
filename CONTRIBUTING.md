# Contributing to Ascent

All contributions, including bug fixes, new features, documentation improvements, or translations, are welcome.

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
git checkout -b feat/<feature-name>
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
