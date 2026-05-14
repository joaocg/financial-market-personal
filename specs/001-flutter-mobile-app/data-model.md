# Data Model: Flutter Finance and Market App

## Mobile Entities (Domain)

### User
- `id`: String
- `name`: String
- `email`: String
- `familyId`: String
- `role`: String
- `accessToken`: String (Sensitive)
- `refreshToken`: String (Sensitive)

### FamilyAccount
- `id`: String
- `bankName`: String
- `accountType`: String
- `balance`: Decimal
- `currency`: String

### Product
- `barcode`: String (Primary Key)
- `name`: String
- `brand`: String?
- `imageUrl`: String?
- `category`: String?

### PriceQuote (Offline-First)
- `localId`: Integer (Auto-increment)
- `productBarcode`: String
- `price`: Decimal
- `latitude`: Double
- `longitude`: Double
- `photoPath`: String (Local URI)
- `timestamp`: DateTime
- `syncStatus`: Enum (Pending, Syncing, Synced, Failed)
- `errorMessage`: String?

## Relationships
- **User** belongs to a **Family**.
- **Family** has many **FamilyAccounts**.
- **PriceQuote** references a **Product** by barcode.
- **PriceQuote** belongs to a **User** (the one who created it).

## Validation Rules
- `price` must be positive.
- `barcode` must be valid EAN/UPC format.
- `photoPath` must exist before sync.
- `latitude`/`longitude` must be captured (or prompted) for all quotes.
