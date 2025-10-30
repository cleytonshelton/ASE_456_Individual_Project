# Box Tracker 📦

A Flutter mobile application for organizing and tracking storage boxes with automatic numbering and photo documentation.

## Overview

Box Tracker is a simple yet effective solution for managing storage boxes, whether you're moving, organizing your home, or managing inventory. Instead of relying on QR codes, this app uses a straightforward number-based system where you can write numbers on physical boxes that correspond to entries in the app.

## Features

### 🏷️ **Automatic Box Numbering**
- Automatically assigns sequential box numbers (001, 002, 003, etc.)
- No manual number entry required
- Smart numbering system that continues from the highest existing number

### 📝 **Custom Descriptions**
- Add detailed descriptions for each box's contents
- Multi-line text input for comprehensive descriptions
- Examples: "Winter clothes", "Kitchen utensils", "Books and documents"

### 📸 **Photo Documentation**
- Take photos of box contents for visual reference
- Images are stored locally on your device
- Photos help identify boxes without opening them

### 🎨 **Modern UI**
- Clean 2-column grid layout for easy browsing
- Card-based design with rounded corners and shadows
- Responsive layout that works on different screen sizes
- Intuitive navigation with Home and Add Box tabs

### 💾 **Local Storage**
- Uses Hive database for fast, local data storage
- No internet connection required
- Data persists between app sessions
- Lightweight and efficient storage solution

## Screenshots

*Add screenshots of your app here*

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/box-tracker.git
   cd box-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS (requires macOS):**
```bash
flutter build ios --release
```

## Usage

### Adding a New Box

1. Tap the "Add Box" button in the bottom navigation
2. Enter a description of the box contents
3. Take a photo of the box or its contents
4. The app automatically assigns the next available box number

### Viewing Your Boxes

- All boxes are displayed in a 2-column grid on the home screen
- Each box shows its number, description, and photo
- Tap on boxes to view more details (future feature)

### Physical Box Organization

1. Write the corresponding number on your physical box (001, 002, etc.)
2. Use the app to quickly find what's inside each numbered box
3. Perfect for moving, storage units, or home organization

## Technical Details

### Architecture
- **Framework**: Flutter
- **Language**: Dart
- **Database**: Hive (local NoSQL database)
- **State Management**: StatefulWidget with ValueListenableBuilder
- **Image Handling**: ImagePicker plugin

### Dependencies
- `flutter`: SDK
- `hive`: Local database
- `hive_flutter`: Flutter integration for Hive
- `image_picker`: Camera and gallery access
- `path_provider`: File system access

### Project Structure
```
lib/
├── main.dart              # App entry point and Hive initialization
├── home_screen.dart       # Main screen with grid view and navigation
├── models/
│   ├── box_item.dart     # Box data model
│   └── box_item.g.dart   # Generated Hive adapter
└── widgets/               # Custom widgets (future)
```

## Future Enhancements

- [ ] Search functionality for boxes
- [ ] Edit box descriptions and photos
- [x] Delete boxes
- [ ] Categories and tags
- [x] Dark mode support

## Acknowledgments

- Built with Flutter
- Icons from Material Design
- Inspired by the need for simple, effective storage organization

---
