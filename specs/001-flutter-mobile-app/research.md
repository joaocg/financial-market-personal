# Research: Flutter Finance and Market App

## Decision: State Management - Bloc
- **Rationale**: Provides clear separation of concerns and is highly predictable for complex flows like the offline queue sync and biometric auth.
- **Alternatives considered**: Riverpod (Great, but Bloc is more prescriptive for "Modular Architecture" principle), Provider (Too simple for this complexity).

## Decision: Local Persistence - Sqflite
- **Rationale**: Necessary for complex relational data if the offline queue grows or requires queryable status. Standard for robust offline-first apps.
- **Alternatives considered**: Hive (Faster, but NoSQL can lead to data fragmentation in financial apps), Shared Preferences (Only for small key-value pairs).

## Decision: Barcode Scanning - mobile_scanner
- **Rationale**: Modern, fast, and supports both Android and iOS efficiently with a simple API.
- **Alternatives considered**: flutter_barcode_scanner (Deprecated/Maintenance issues).

## Decision: HTTP Client - Dio
- **Rationale**: Advanced features like interceptors are essential for JWT refresh logic and global error handling.
- **Alternatives considered**: http (Too basic for complex JWT flows).

## Decision: Offline Sync Strategy
- **Decision**: Background sync using `workmanager` combined with an app-level `SyncRepository`.
- **Rationale**: Ensures data is sent even if the app is closed, satisfying the "don't lose market quotes" requirement.
