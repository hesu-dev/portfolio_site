# Nell Weather - Project Structure & Architecture

## Overview
This document outlines the folder structure and architectural decisions for the Nell Weather Flutter application.

## Directory Structure
```
lib/
├── config/                 # Global configuration
│   ├── router.dart         # GoRouter definitions
│   └── theme.dart          # AppTheme & ColorScheme
├── core/                   # Core utilities shared across features
│   ├── constants/          # Static constants (Colors, Integers, Strings)
│   ├── services/           # Global services (Network, LocalStorage)
│   └── utils/              # Helper functions
├── data/                   # Data Layer (Repositories, Models, APIs)
│   ├── models/             # Data classes (JSON serialization)
│   ├── repositories/       # Data access interfaces & implementations
│   └── sources/            # Remote/Local data sources
├── features/               # Feature-based modularization
│   ├── memo/               # Weather Memo Feature
│   ├── onboarding/         # Onboarding Feature
│   ├── settings/           # Settings Feature
│   └── weather/            # Main Weather Feature (Dashboard)
│       ├── presentation/   # UI Layer (Screens, Widgets)
│       └── provider/       # State Management (Riverpod)
├── shared/                 # Shared UI Components (Buttons, Dialogs)
└── main.dart               # App Entry Point
```

## Architecture Pattern
We follow a **Feature-First + Layered Architecture** with **Riverpod** for state management.

### Layers
1.  **Presentation Layer (`features/*/presentation`)**:
    *   Widgets and Screens.
    *   No business logic here.
    *   Listens to Providers.
2.  **Application/Domain Layer (Providers)**:
    *   Connects UI to Data.
    *   Holds application state.
3.  **Data Layer (`data/`)**:
    *   **Models**: Pure Dart classes.
    *   **Repositories**: Abstract interfaces for data fetching.
    *   **Sources**: Actual API calls or DB access.

## Key Decisions
*   **State Management**: `hooks_riverpod` / `flutter_riverpod` for dependency injection and state management.
*   **Navigation**: `go_router` for deep linking and declarative routing.
*   **Styling**: `flutter_screenutil` for responsive sizing, centralized in `AppTheme`.
