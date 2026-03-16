# 🛒 Spazafy: The SuperApp Ecosystem
**Digitizing and Empowering Micro-Entrepreneurs in Emerging Markets**

Spazafy is a high-performance, hyper-local SuperApp ecosystem designed to digitize the spaza shop economy. It unifies Customer, Store, Driver, and Manager roles into a single high-performance Flutter core, enabling seamless commerce, real-time logistics tracking, and AI-driven demand forecasting.

![Spazafy Banner](assets/image/background.png)

## 🎯 Project Vision
Spazafy solves the critical pain points of fragmented logistics, lack of financial inclusion, and digital invisibility for small-scale vendors. It operates as a "SuperApp-in-a-Box" architecture, allowing rapid deployment of localized services with a premium, ultra-fast experience even on low-bandwidth devices.

### Core Pillars:
- **Unified SuperApp Architecture**: One codebase, multiple roles (User/Store/Driver) activated via compile-time feature flags.
- **Offline-First Reliability**: Powered by `Drift (SQLite)` for robust localized database persistence. Operation continues undisturbed during network drops.
- **AI-Driven Logistics**: Real-time synchronization service with idempotency support, ready for ModelArts demand forecasting.
- **B2B Resupply Engine**: Automated inventory management, weighted average cost (WAC) valuation, and multi-wholesaler routing logic.

## 🛠 Tech Stack
Built leveraging modern architectural principles to ensure scalability and extreme performance.

- **Framework**: [Flutter](https://flutter.dev/) (SDK 3.24.4)
- **State Management**: `Riverpod` (Functional Providers)
- **Routing**: `AutoRoute` (Strongly-typed routing)
- **Local Database**: `Drift` (Reactive SQLite)
- **API Client**: `Dio` (with background sync & idempotency headers)
- **UI System**: Unified Theme System with support for Admin, Store, Driver, and User modes.

## 📁 Architecture Overiew
Spazafy utilizes a **Flattened Feature Architecture** designed for the SuperApp model:

```text
lib/
├── application/                # Riverpod Notifiers (Business Logic)
├── domain/                     # Interfaces and Data Models (Pure Dart)
├── infrastructure/             # API Implementation and DB Services (Drift)
└── presentation/               # UI Layer
    ├── components/             # Shared & Role-specific UI components
    ├── pages/                  # Screen implementations
    ├── routes/                 # AutoRoute definitions
    └── theme/                  # Unified Design System (Assets, Styles, Widgets)
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `3.24.x`
- Dart SDK `3.5.x`

### Installation
1. Clone the repository:
   ```bash
   git clone <repository_url>
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation (required for Drift and AutoRoute):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Running with Flavours
Spazafy uses compile-time defines to activate different flavours:

- **B2B Mode (Manager/POS/Driver)**:
  ```bash
  flutter run --dart-define=FLAVOUR=b2b
  ```
- **Marketplace Mode (Customer)**:
  ```bash
  flutter run --dart-define=FLAVOUR=marketplace
  ```

## 🛡️ Architectural Principles
1. **Source of Truth**: The local Drift database is the primary source of truth for the UI; the backend is a sync target.
2. **Idempotent Sync**: Every outbound request uses `X-Idempotency-Key` to ensure reliable background synchronization.
3. **Unified Assets**: Role-specific assets are merged into a central registry to minimize binary size and overhead.

---
*Spazafy — Technical Architecture — Rokct Holdings*
