# MedAlert Mobile App

A Flutter mobile application for the MedAlert medicine reminder system. This app provides the same functionality as the web application, including user authentication, medicine management, and contraindications lookup.

## Features

- **User Authentication**: Login and signup functionality
- **Medicine Management**: Add, view, and remove medicines
- **Reminder Tracking**: Mark medicines as taken at specific times
- **Contraindications**: Look up drug safety information from FDA API
- **Same Database**: Connects to the same Django backend and MySQL database

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development
- The Django backend must be running (see backend README)

## Setup

1. **Install Flutter dependencies**:
   ```bash
   cd mobile_app
   flutter pub get
   ```

2. **Configure API endpoint**:
   - For Android emulator: The app uses `10.0.2.2` instead of `localhost` by default
   - For iOS simulator: Uses `localhost`
   - For physical devices: Update `lib/services/api_service.dart` with your computer's IP address

3. **Copy images**:
   Ensure the background images are in `assets/images/`:
   - `Login_background.jpg`
   - `AppPage-image.jpg`

4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
mobile_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── medicine.dart            # Medicine data model
│   ├── providers/
│   │   ├── auth_provider.dart       # Authentication state management
│   │   └── medicine_provider.dart   # Medicine state management
│   ├── screens/
│   │   ├── auth_screen.dart         # Login/Signup screen
│   │   ├── app_screen.dart          # Main app screen
│   │   └── contra_indications_screen.dart  # Drug info screen
│   ├── widgets/
│   │   ├── login_form.dart          # Login form widget
│   │   ├── signup_form.dart         # Signup form widget
│   │   ├── medicine_form.dart       # Medicine input form
│   │   ├── medicine_list.dart       # Medicine list display
│   │   └── snackbar_widget.dart     # Notification widget
│   ├── services/
│   │   └── api_service.dart         # API communication layer
│   └── hooks/
│       └── use_contraindications.dart  # FDA API integration
├── assets/
│   └── images/                      # Background images
└── pubspec.yaml                     # Flutter dependencies
```

## API Configuration

The app connects to the Django backend API. Update the base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://YOUR_IP:8000/api';
```

For Android emulator, use `10.0.2.2` instead of `localhost`.
For iOS simulator, use `localhost`.
For physical devices, use your computer's local IP address.

## Backend Connection

This app uses the same Django backend and MySQL database as the web application:
- Database: `MedAlert`
- User: `myuser`
- Host: `localhost:3306`

Make sure the Django backend is running before using the mobile app.

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Dependencies

- `http`: For API calls
- `provider`: State management
- `shared_preferences`: Local storage for auth state
- `intl`: Date/time formatting

## Notes

- The app uses the same authentication and medicine endpoints as the web app
- Contraindications data is fetched from the FDA API (same as web app)
- All medicine data is synchronized with the backend database

