# MedAlert Mobile App - Setup Guide

## Quick Start

1. **Install Flutter** (if not already installed):
   - Visit https://flutter.dev/docs/get-started/install
   - Follow the installation instructions for your platform

2. **Get dependencies**:
   ```bash
   cd mobile_app
   flutter pub get
   ```

3. **Configure API endpoint**:
   - Open `lib/services/api_service.dart`
   - Update `_host` variable:
     - For Android emulator: Keep as `'10.0.2.2'`
     - For iOS simulator: The code will use `localhost` automatically
     - For physical device: Change to your computer's local IP (e.g., `'192.168.1.100'`)

4. **Start the Django backend**:
   ```bash
   cd ../backend
   python manage.py runserver
   ```

5. **Run the mobile app**:
   ```bash
   cd mobile_app
   flutter run
   ```

## Finding Your Computer's IP Address

### Windows:
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network adapter.

### macOS/Linux:
```bash
ifconfig | grep "inet "
```
Or:
```bash
ip addr show
```

## Testing

1. **Login/Signup**: Test user authentication
2. **Add Medicine**: Create a new medicine entry
3. **Mark as Taken**: Mark a medicine time as taken
4. **Contraindications**: Search for drug safety information
5. **Remove Medicine**: Delete a medicine entry

## Troubleshooting

### "Connection refused" error:
- Ensure Django backend is running on port 8000
- Check that the IP address/host is correct in `api_service.dart`
- For Android emulator, ensure you're using `10.0.2.2`
- For physical device, ensure your phone and computer are on the same network

### Images not loading:
- Ensure images are in `assets/images/` directory
- Run `flutter clean` and `flutter pub get`
- Restart the app

### Build errors:
- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter doctor` to check for issues

## Features Matching Web App

✅ User authentication (login/signup)
✅ Medicine CRUD operations
✅ Mark medicine as taken
✅ Medicine list display
✅ Contraindications lookup (FDA API)
✅ Same backend database
✅ Similar UI/UX design

