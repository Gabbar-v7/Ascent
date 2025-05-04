import "package:ascent/visuals/components/app_styles.dart";
import "package:ascent/visuals/screens/notes/enhanced_markdown.dart";
import "package:flutter/material.dart";

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar("Notes", context),
      body: EnhancedMarkdown(
        data: """
# Ascent

A blazing-fast Flutter mobile app for managing tasks, notes, and focus sessions with intuitive gestures and smooth performance. 

Built for **speed** and **efficiency**. Perfect for productivity on the go!  

### 📌 Why Ascent?
- **Gesture-driven** (swipe, hold, tap shortcuts)  
- **Lightweight & optimized** (no lag, fast startup)  
- **Clean UI** with dark/light mode  

Try it now and boost your workflow! Contributions welcome.  

## Stats
<div align="center">
    <a href="#"><img src="https://img.shields.io/github/stars/gabbar-v7/ascent?style=for-the-badge&labelColor=grey&color=grey" alt="Stars"></a>&nbsp;
    <a href="#"><img src="https://img.shields.io/github/forks/gabbar-v7/ascent?style=for-the-badge&labelColor=grey&color=grey" alt="Forks"></a>&nbsp;
    <a href="#"><img src="https://img.shields.io/github/issues/gabbar-v7/ascent?style=for-the-badge&labelColor=grey&color=grey" alt="Active Issues"></a>&nbsp;
    <a href="#"><img src="https://img.shields.io/github/issues-pr/gabbar-v7/ascent?style=for-the-badge&labelColor=grey&color=grey" alt="Active PRs"></a>
    <br>
    <a href="#"><img src="https://img.shields.io/github/release/gabbar-v7/ascent?style=for-the-badge&labelColor=grey&color=grey" alt="Release"></a>&nbsp;
    <a href="#"><img src="https://img.shields.io/github/repo-size/gabbar-v7/ascent?style=for-the-badge&labelColor=grey&color=grey" alt="Repo Size"></a>
    <br>
    <a href="#"><img src="https://img.shields.io/github/license/gabbar-v7/ascent?style=for-the-badge&label=license&labelColor=grey&color=grey" alt="License"></a>&nbsp;
</div>

## Features

✔ **To-Do List** – Quick-add, swipe gestures, smart sorting  
✔ **Pomodoro Timer** – Focus sessions with stats tracking  
✔ **Notes** – Lightweight & markdown-ready  
✔ **Optimized UX** – Instant actions, minimal taps, silky animations  

## Screenshots

[Add screenshots of your app here]

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
```bash
git clone https://github.com/Gabbar-v7/Ascent.git
```

2. Navigate to the project directory
```bash
cd Ascent
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── database/          # Database related code
├── visuals/           # UI components
│   ├── components/    # Reusable UI components
│   ├── screens/       # App screens
│   └── utils/         # Utility functions
└── main.dart          # App entry point
```

## Development

### Database

The app uses Drift (SQLite) for local storage. To generate database code:

```bash
dart run build_runner build
```

For more information refer [Drift Documentation](https://drift.simonbinder.eu/setup/).

### Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

## Contributing

1. **Fork the Repository:**

   ```bash
   git fork https://github.com/Gabbar-v7/Ascent.git
   ```

2. **Create a Feature Branch:**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Commit Your Changes:**

   ```bash
   git commit -m "Your concise commit message"
   ```

4. **Push the Branch:**

   ```bash
   git push origin feature/your-feature-name
   ```

5. **Submit a Pull Request on GitHub.**

## Support

<div align="center">
    <a href="https://github.com/sponsors/Gabbar-v7"><img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white" alt="GitHub Sponsors" height=30></a>&nbsp;
    <a href="https://buymeacoffee.com/gabbar_v7"><img src="https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me a Coffee" height=30></a>&nbsp;
    <a href="https://www.paypal.me/GabbarShall"><img src="https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white" alt="PayPal" height=30></a>
</div>
""",
      ),
    );
  }
}
