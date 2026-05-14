# Financeiro Familiar Mobile

Flutter mobile application for family finance management and market price quoting.

## Features
- **Secure Access**: JWT-based authentication with Biometric (FaceID/Fingerprint) unlock.
- **Financial Dashboard**: View consolidated family balance and individual bank accounts.
- **Market Scanning**: Scan product barcodes to retrieve info from OpenFoodFacts and register items.
- **Price Quoting**: Capture prices with geolocation and shelf photos.
- **Offline Sync**: Offline-first quoting with automatic background synchronization when online.
- **WhatsApp Mirroring**: View financial query history previously available only via WhatsApp.

## Prerequisites
- Flutter SDK (3.22+)
- Dart SDK (3.x)
- Android Studio / VS Code with Flutter extension
- Local Financeiro Backend running

## Setup
1. `cd mobile`
2. `flutter pub get`
3. Configure `lib/core/config/env.dart` with your backend URL.
4. `flutter run`

## Tech Stack
- **Framework**: Flutter
- **State Management**: BLoC (flutter_bloc)
- **Networking**: Dio
- **Local Database**: Sqflite
- **Security**: flutter_secure_storage, local_auth
- **Background Tasks**: workmanager
- **Device Features**: camera, geolocator, mobile_scanner, connectivity_plus
