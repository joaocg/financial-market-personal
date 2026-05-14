# API Contracts: Mobile to Backend

## Authentication (JWT Reuse)

### Login
- **Endpoint**: `POST /api/v1/auth/login`
- **Request**:
  ```json
  {
    "email": "user@family.com",
    "password": "password"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "access_token": "...",
    "refresh_token": "...",
    "expires_in": 3600
  }
  ```

## Market Module

### Product Lookup (Internal + OpenFoodFacts fallback)
- **Endpoint**: `GET /api/v1/market/products/{barcode}`
- **Response (200 OK)**:
  ```json
  {
    "barcode": "...",
    "name": "...",
    "brand": "...",
    "image_url": "..."
  }
  ```

### Price Quote Submission
- **Endpoint**: `POST /api/v1/market/quotes`
- **Request (Multipart/form-data)**:
  - `barcode`: String
  - `price`: Decimal
  - `lat`: Double
  - `lng`: Double
  - `photo`: File (image/jpeg)
- **Response (201 Created)**:
  ```json
  {
    "id": "...",
    "status": "persisted"
  }
  ```

## Finance Module

### Account Balances
- **Endpoint**: `GET /api/v1/balances`
- **Response (200 OK)**:
  ```json
  {
    "consolidated_balance": 1500.50,
    "accounts": [
      {
        "id": "...",
        "bank_name": "...",
        "balance": 500.00
      }
    ]
  }
  ```
