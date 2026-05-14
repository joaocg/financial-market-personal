# Quickstart: Flutter Finance and Market App

## Local Development Setup

1. **Prerequisites**:
   - Flutter SDK (3.22+)
   - Android Studio / VS Code with Flutter extension
   - Backend running (Laravel Stack)

2. **Clone and Initialize**:
   ```bash
   cd mobile
   flutter pub get
   ```

3. **Configure Environment**:
   Create `lib/core/config/env.dart`:
   ```dart
   class Env {
     static const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1'; // Android Emulator
   }
   ```

4. **Run the App**:
   ```bash
   flutter run
   ```

## Primary Test Scenarios (Manual)

### 1. Authentication
- Login with family credentials.
- Close app, reopen, and verify biometric prompt.
- Logout and verify token cleared.

### 2. Market Workflow (Online)
- Open scanner.
- Scan barcode `789...`.
- Verify product info displays from OpenFoodFacts.
- Submit quote with photo and GPS.

### 3. Market Workflow (Offline Sync)
- Turn off internet (Airplane mode).
- Submit a price quote.
- Verify quote appears in "Pending" status in the app.
- Turn on internet.
- Verify quote status changes to "Synced".

### 4. Financial Dashboard
- Verify consolidated balance matches `http://localhost:8000/api/v1/balances`.
