# word > translation > picture

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features

- [x] Add EN translation to word;
- [x] Add RU manual translation to word;
- [x] Add picture to word;
- [ ] Ability to work without server configuration
- [x] Create sync input validation;
- [x] Word card;
- [x] Word change picture;
- [x] Save words to DB;
- [x] Store key-value settings;
- [x] Search by word/translation;
- [x] Layout and colors;
- [x] Two render list variations;
- [x] Long list high performance;
- Animations;
  - [x] AnimatedOpacity;
  - [x] AnimatedContainer;
  - [x] Hero Animation;
- [ ] Some tests;
- [ ] Readme:
  - how its work;
  - architecture scheme;

## Settings

- for Android Studio: Run -> Edit Configuration -> Addition Run Args -> `--no-sound-null-safety`
- add keys to `secret.env` in root directory.

## State management and architecture:

- [bloc - a predictable state management library for Dart](https://bloclibrary.dev/#/)
- [About separation of responsibility and architecture](https://bloclibrary.dev/#/architecture)
- [Todos tutorial, that was used as foundation for data flow](https://bloclibrary.dev/#/fluttertodostutorial)
