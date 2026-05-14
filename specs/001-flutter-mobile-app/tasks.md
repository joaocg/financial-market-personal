# Tasks: Flutter Finance and Market App

**Input**: Design documents from `specs/001-flutter-mobile-app/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Manual validation scenarios are defined in `quickstart.md`. Automated unit/widget tests are included for core business logic.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile**: `mobile/lib/`, `mobile/test/`
- Paths shown below assume `mobile/` as the project root.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Initialize Flutter project in `mobile/`
- [x] T002 [P] Configure `pubspec.yaml` with dependencies (Dio, BLoC, MobileScanner, Sqflite, etc.)
- [x] T003 [P] Configure linting rules in `mobile/analysis_options.yaml`
- [x] T004 Setup core folder structure (core, data, domain, presentation) in `mobile/lib/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 Implement SQLite database helper in `mobile/lib/data/local/db_helper.dart`
- [x] T006 [P] Implement Dio client and interceptors for JWT in `mobile/lib/core/api/api_client.dart`
- [x] T007 [P] Setup environment configuration (API URLs) in `mobile/lib/core/config/env.dart`
- [x] T008 [P] Implement secure storage helper for JWT in `mobile/lib/core/auth/token_storage.dart`
- [x] T009 [P] Implement Biometric authentication helper in `mobile/lib/core/auth/biometric_helper.dart`
- [x] T010 Implement base Bloc for Connectivity monitoring in `mobile/lib/presentation/bloc/connectivity/connectivity_bloc.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Secure Family Financial Access (Priority: P1) 🎯 MVP

**Goal**: Authenticate and view family balances and accounts.

**Independent Test**: Login successfully and see the financial dashboard with real data from `/api/v1/balances`.

### Implementation for User Story 1

- [x] T011 [P] [US1] Create User and FamilyAccount models in `mobile/lib/domain/models/`
- [x] T012 [US1] Implement AuthRepository in `mobile/lib/data/repositories/auth_repository.dart`
- [x] T013 [US1] Implement FinanceRepository in `mobile/lib/data/repositories/finance_repository.dart`
- [x] T014 [US1] Create AuthBloc for login and biometric unlock in `mobile/lib/presentation/bloc/auth/auth_bloc.dart`
- [x] T015 [US1] Create FinanceBloc for balance retrieval in `mobile/lib/presentation/bloc/finance/finance_bloc.dart`
- [x] T016 [US1] Build Login screen UI in `mobile/lib/presentation/pages/auth/login_page.dart`
- [x] T017 [US1] Build Financial Dashboard UI in `mobile/lib/presentation/pages/finance/dashboard_page.dart`

**Checkpoint**: User Story 1 (Authentication + Dashboard) is fully functional.

---

## Phase 4: User Story 2 - Product Registration via Barcode (Priority: P1)

**Goal**: Scan barcode and fetch product info from OpenFoodFacts.

**Independent Test**: Scan a barcode and see product details fetched via API.

### Implementation for User Story 2

- [x] T018 [P] [US2] Create Product model in `mobile/lib/domain/models/product.dart`
- [x] T019 [US2] Implement MarketRepository for product lookup in `mobile/lib/data/repositories/market_repository.dart`
- [x] T020 [US2] Create MarketBloc for product registration in `mobile/lib/presentation/bloc/market/market_bloc.dart`
- [x] T021 [US2] Build Barcode Scanner UI in `mobile/lib/presentation/pages/market/scanner_page.dart`
- [x] T022 [US2] Build Product Confirmation screen in `mobile/lib/presentation/pages/market/product_details_page.dart`

**Checkpoint**: User Story 2 (Scanning + Registration) is functional.

---

## Phase 5: User Story 3 - Geolocation-Aware Price Quoting (Priority: P2)

**Goal**: Submit price quotes with location and photo, supporting offline queuing.

**Independent Test**: Submit a quote while offline, then see it sync automatically when online.

### Implementation for User Story 3

- [x] T023 [P] [US3] Create PriceQuote model in `mobile/lib/domain/models/price_quote.dart`
- [x] T024 [US3] Implement LocalQuoteDataSource for SQLite persistence in `mobile/lib/data/datasources/local_quote_data_source.dart`
- [x] T025 [US3] Implement SyncRepository for background uploads in `mobile/lib/data/repositories/sync_repository.dart`
- [x] T026 [US3] Create SyncBloc to manage the offline queue in `mobile/lib/presentation/bloc/sync/sync_bloc.dart`
- [x] T027 [US3] Build Price Quote form (Price, Photo, GPS) in `mobile/lib/presentation/pages/market/quote_form_page.dart`
- [x] T028 [US3] Integrate WorkManager for background sync in `mobile/lib/core/sync/sync_worker.dart`

**Checkpoint**: User Story 3 (Price Quoting + Offline Sync) is functional.

---

## Phase 6: User Story 4 - WhatsApp Integration Mirroring (Priority: P3)

**Goal**: Access WAHA queries (e.g., Monthly Expenses) via visual UI.

**Independent Test**: View monthly expense history in the app.

### Implementation for User Story 4

- [x] T029 [P] [US4] Create QueryResult model in `mobile/lib/domain/models/query_result.dart`
- [x] T030 [US4] Implement MessagingRepository for WhatsApp queries in `mobile/lib/data/repositories/messaging_repository.dart`
- [x] T031 [US4] Create MessagingBloc for history visualization in `mobile/lib/presentation/bloc/messaging/messaging_bloc.dart`
- [x] T032 [US4] Build WhatsApp Queries Page in `mobile/lib/presentation/pages/messaging/query_list_page.dart`

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements and validation

- [x] T033 [P] Update `mobile/README.md` with build and run instructions
- [x] T034 Code cleanup and refactor redundant widget logic
- [x] T035 [P] Unit tests for Bloc logic in `mobile/test/unit/`
- [x] T036 Final run of `quickstart.md` manual validation scenarios

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Can start immediately.
- **Foundational (Phase 2)**: Blocks all user stories.
- **User Stories (Phase 3+)**: Depend on Foundational completion. US1 (Auth) should be first to enable data access for others.
- **Polish (Final Phase)**: Depends on all stories completion.

### Parallel Opportunities

- T002-T004 (Setup)
- T006-T009 (Foundational)
- User Stories can proceed in parallel once T011-T015 are stable, but sequential P1->P2->P3 is recommended for a single developer.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup + Foundational.
2. Complete User Story 1 (Auth + Dashboard).
3. Validate against `quickstart.md`.

### Incremental Delivery

1. Foundation ready.
2. Add US1 (Financial Dashboard) -> MVP.
3. Add US2 (Market Scanning).
4. Add US3 (Offline Quoting) -> Core value differentiation.
5. Add US4 (WhatsApp parity).
