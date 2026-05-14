# Feature Specification: Flutter Finance and Market App

**Feature Branch**: `001-flutter-mobile-app`

**Created**: 2026-05-13

**Status**: Draft

**Input**: User description: "esse é o resumo do meu projeto atual: como agora acredito que ele ja entende meu projeto quero dizer para ele criar do 0 o aplicativo para esse softweare financeiro alem da pesquisa de mercado. Esse meu softwere tem o modulo financeiro familiar e tem a area de mercado onde cadastramos produtos com o codigo de barra que pucha as infromacoes do openfoodfac e depois de cadastrado podemos lancar cotacoes de preco atraves da geoloclizacao e da foto do item na prateleira ou pedlo codigo de berras. Temos integracao com um numero do whstapp atraves do waha api onde o numero habilitado para a amilia pode consultar salvo, entre varias outrs coisas pelo whstapp para qwuela familia.. Agora quero que voce faca o aplicativo em flutter para o meu projeto."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Secure Family Financial Access (Priority: P1)

As a family member, I want to authenticate into the mobile app and see our family's consolidated balances and account details so that I can stay updated on our financial status on the go.

**Why this priority**: Essential for the core "financeiro familiar" value proposition and serves as the entry point for all other features.

**Independent Test**: User can log in, see a summary of family accounts, and view the current balance of at least one account.

**Acceptance Scenarios**:

1. **Given** the user is on the login screen, **When** they enter valid family credentials, **Then** they are granted access to the family dashboard.
2. **Given** an authenticated user, **When** the dashboard loads, **Then** the consolidated family balance is displayed matching the current backend data.

---

### User Story 2 - Product Registration via Barcode (Priority: P1)

As a shopper, I want to scan a product's barcode and have its information automatically populated from OpenFoodFacts so that I can quickly register items in our market database.

**Why this priority**: Core functionality for the "área de mercado" and critical for data entry efficiency.

**Independent Test**: Scanning a known barcode successfully retrieves and displays product name and basic info before saving.

**Acceptance Scenarios**:

1. **Given** the product scan screen is open, **When** a barcode is successfully scanned, **Then** the app fetches and displays product details from the OpenFoodFacts integration.
2. **Given** retrieved product details, **When** the user confirms the registration, **Then** the item is persisted in the family's product list.

---

### User Story 3 - Geolocation-Aware Price Quoting (Priority: P2)

As a user at a physical store, I want to submit a price quote for a registered product including its current price, a photo of the shelf, and my current location so that the family can track price variations across different locations.

**Why this priority**: Differentiator for the market module, providing rich data for price comparison.

**Independent Test**: Submitting a quote with a barcode, price, and photo successfully attaches the current GPS coordinates.

**Acceptance Scenarios**:

1. **Given** a registered product, **When** I enter a price and take a shelf photo, **Then** the app captures the current geolocation and submits the quote to the backend.
2. **Given** a price quote submission, **When** the location services are disabled, **Then** the app prompts the user to enable GPS before allowing the submission.

---

### User Story 4 - WhatsApp Integration Mirroring (Priority: P3)

As a user, I want to access the same financial queries available via the WhatsApp (WAHA) integration directly in the app so that I have a rich visual alternative to the conversational interface.

**Why this priority**: Provides feature parity and a better UI for complex queries previously restricted to text-based WhatsApp interaction.

**Independent Test**: Performing a query (e.g., balance history) in the app returns the same data as the corresponding WhatsApp command.

**Acceptance Scenarios**:

1. **Given** the "WhatsApp Queries" section, **When** I select a common query (e.g., "Monthly Expenses"), **Then** the app displays the result in a structured visual format.

---

### Edge Cases

- **Connectivity**: Users in "dead zones" can still scan barcodes, take photos, and enter prices. These are saved to a local queue and automatically synchronized once internet access is restored.
- **Invalid Barcode**: How does the system handle barcodes not found in OpenFoodFacts or the internal database?
- **Permission Denial**: User denies camera or location permissions during the quoting flow.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support cross-platform mobile deployment using Flutter.
- **FR-002**: System MUST integrate with the existing Laravel backend for authentication and data persistence.
- **FR-003**: System MUST provide a barcode scanning interface using the device camera.
- **FR-004**: System MUST fetch product data from OpenFoodFacts API when a barcode is scanned.
- **FR-005**: System MUST capture and transmit GPS coordinates (latitude/longitude) with every price quote.
- **FR-006**: System MUST allow users to capture or upload one photo per price quote.
- **FR-007**: System MUST display family balances and account lists retrieved from the `Identity` and `Ledger` modules.
- **FR-008**: System MUST handle authentication via the existing backend JWT flow and MUST support local biometrics (FaceID/Fingerprint) for session re-entry.
- **FR-009**: System MUST support offline data entry (barcode, photo, price) via a local persistence layer.
- **FR-010**: System MUST automatically synchronize the local queue with the backend when an active internet connection is detected.

### Key Entities *(include if feature involves data)*

- **FamilyAccount**: Represents the financial account being viewed (Balance, Bank name, Account type).
- **Product**: Represents a market item (Barcode, Name, Brand, Category).
- **PriceQuote**: Represents a point-in-time price entry (Product ID, Price, Latitude, Longitude, Photo URL, Timestamp).
- **FamilyMember**: The authenticated user (Name, Role, WhatsApp link).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can register a new product via barcode scan in under 15 seconds (assuming network availability).
- **SC-002**: Price quote submission (scan, price entry, photo, geo) completes in under 30 seconds.
- **SC-003**: The app achieves 100% data consistency with the backend for family balances.
- **SC-004**: App successfully captures geolocation with a precision of at least 50 meters for 95% of submissions.

## Assumptions

- **Backend Ready**: Existing API endpoints for Ledger, Market, and WhatsApp integration are accessible and stable.
- **OpenFoodFacts Access**: The OpenFoodFacts API is available and permits the mobile app's traffic.
- **Device Support**: Targeting standard Android and iOS devices with functional cameras and GPS.
- **Auth Reuse**: Assuming the existing JWT-based authentication from the backend will be leveraged for the mobile app.
le app.
