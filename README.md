# Ascent

A modern, efficient, and user-friendly task management application built with Flutter.

## Features

- 📝 Create, edit, and delete tasks
- 📅 Set due dates for tasks
- ✅ Mark tasks as complete/incomplete
- 📱 Beautiful and responsive UI
- 🌓 Light and dark theme support
- 🔄 Real-time task updates
- 📊 Task categorization (Today, Previous, Future, Completed)
- ⚡ Optimized performance with caching and debouncing
- 🔔 Task notifications (coming soon)

## Screenshots

[Add screenshots of your app here]

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- Git

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
├── visuals/          # UI components
│   ├── components/   # Reusable UI components
│   ├── screens/      # App screens
│   └── utils/        # Utility functions
└── main.dart         # App entry point
```

## Dependencies

- `drift`: SQLite database
- `gap`: Spacing utility
- `url_launcher`: URL handling
- [Add other dependencies]

## Development

### Database

The app uses Drift (SQLite) for local storage. To generate database code:

```bash
dart run build_runner build
```

### Code Style

This project follows the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style).

## Performance Optimizations

- Task categorization caching
- Efficient list rendering with ListView.builder
- Debounced task completion updates
- Optimized state management
- RepaintBoundary for UI components
- Memory leak prevention

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Drift team for the database solution
- [Add other acknowledgments]

## Contact

Project Link: [https://github.com/Gabbar-v7/Ascent](https://github.com/Gabbar-v7/Ascent)