# ☕ CoffEcon: Coffee Processing & Planning App

CoffEcon is a scalable Flutter application designed to streamline and digitize coffee processing workflows (dried or washed), unit conversion, site registration, planning, and calculation for coffee businesses. The app supports multilingual use (Amharic and English) and is built with modern Flutter best practices for maintainability and extensibility.

---

## 1. Project Overview and Purpose

CoffEcon aims to empower coffee producers, processors, and planners by providing a digital platform for:
- Managing coffee processing (dried/washed methods)
- Registering and managing multiple sites
- Planning and calculation of operational activities
- Performing unit conversions relevant to coffee production
- Supporting users in both Amharic and English

The app is modular, scalable, and ready for production deployment on Android, iOS, and other Flutter-supported platforms.

---

## 2. Folder and File Structure

```
lib/
  app/
    core/         # Core configs, constants, error handling, localization, network, and services
    data/         # Data models and providers (API, local storage, etc.)
    init/         # App initialization and dependency injection
    Pages/        # Feature modules (auth, calculator, converter, onboarding, plan, stock, wetMill, etc.)
    routes/       # App routing and navigation
    shared/       # Shared controllers and widgets (UI components)
    utils/        # Utility functions and helpers
  main.dart       # App entry point
assets/
  animations/     # GIFs and animation files
  fonts/          # Custom fonts
  icon/           # App icon
  icons/          # SVG and PNG icons
  images/         # App images (add screenshots here)
  lang/           # Localization files (am.json, en.json)
test/             # Automated tests (unit, integration, e2e)
android/          # Android native project files
ios/              # iOS native project files
web/              # Web support files
macos/            # macOS support files
windows/          # Windows support files
```

**Key Files:**
- `pubspec.yaml`: Project dependencies and assets
- `.env`: Environment variables (API keys, base URLs, etc.)
- `README.md`: Project documentation

---

## 3. Key Features and Technologies Used

- **Coffee Processing Workflows:** Dried and washed process support
- **Site Registration:** Register and manage multiple coffee sites
- **Planning & Calculation:** Operational planning and calculation modules
- **Unit Conversion:** Built-in unit conversion tools for coffee industry needs
- **Multilingual Support:** Amharic and English (see `assets/lang/`)
- **GetX:** State management, dependency injection, and navigation
- **Dio:** HTTP client for API calls with interceptors
- **Clean Architecture:** Modular, testable, and scalable codebase
- **Environment Configs:** `.env` file support for different environments
- **Reusable UI Components:** Shared widgets for consistent design
- **Secure Storage:** For sensitive data (tokens, credentials)
- **Cross-Platform:** Android, iOS, Web, macOS, Windows, Linux

---

## 4. State Management Approach

CoffEcon uses **GetX** for state management, which provides:
- Reactive controllers for each feature (e.g., `auth_controller.dart`, `calculator_controller.dart`, `site_controller.dart`)
- Dependency injection via bindings (e.g., `bindings.dart` in each module)
- Navigation and route management with GetX's routing system

**Why GetX?**
- Minimal boilerplate
- High performance
- Integrated navigation and dependency management

---

## 5. Setup and Run Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart (>=2.17.0)
- Android Studio or VSCode with Flutter plugins

### Installation

```bash
# 1. Clone the repository
git clone https://dev.azure.com/Ablazelab/Internal/_git/flutter-template
cd flutter-template

# 2. Install dependencies
flutter pub get

# 3. Setup environment variables
cp .env.example .env
# Edit .env and set BASE_URL, API_KEY, etc.
```

### Running the App

#### Android
- Connect a device or start an emulator:
  - Physical device: Enable Developer Options & USB Debugging
  - Emulator: `flutter emulators --launch [emulator_name]`
- Run:
  ```bash
  flutter run
  # Or specify device:
  flutter run -d [device_id]
  ```

#### iOS
- Connect a device or use Simulator
- Run:
  ```bash
  flutter run
  # Or specify device:
  flutter run -d [device_id]
  ```

#### Web, macOS, Windows, Linux
- Run:
  ```bash
  flutter run -d chrome   # For web
  flutter run -d macos    # For macOS
  flutter run -d windows  # For Windows
  flutter run -d linux    # For Linux
  ```

---

## 6. How to Run Tests

- **Unit and Widget Tests:**
  ```bash
  flutter test
  ```

- **Integration/E2E Tests:**
  ```bash
  flutter drive --target=test/e2e/app_test.dart
  # Or for JS-based e2e (if using):
  node run/test.e2e.js
  ```

- **Test Files Location:**
  - Dart tests: `test/`
  - JS e2e tests: `run/`, `test/specs/`

---

## 7. Important Classes and Architecture

### Clean Architecture Layers

- **Presentation:** UI widgets, GetX controllers (e.g., `Pages/`, `controllers/`)
- **Domain:** Business logic, services (e.g., `core/services/`)
- **Data:** Models, providers, API clients (e.g., `data/models/`, `data/providers/`, `core/network/`)

### Key Classes

- `main.dart`: App entry, initializes bindings and routes
- `app_binding.dart`: Sets up dependency injection for the app
- `api_client.dart`: Handles HTTP requests via Dio
- `auth_check_service.dart`: Manages authentication state
- `site_controller.dart`: Handles site registration and management
- `calculation_service.dart`: Business logic for coffee calculations
- `app_pages.dart` & `app_routes.dart`: Define navigation structure
- `translations.dart`: Loads and manages localization

---

## 8. APIs and Services

- **REST APIs:** All network calls are handled via Dio in `core/network/api_client.dart`
- **Environment Variables:** API URLs and keys are loaded from `.env`
- **Secure Storage:** Used for sensitive data (tokens, etc.)
- **No Firebase or local DB** by default, but can be integrated as needed

---

## 9. Example Screenshots

> _Add screenshots to the `assets/images/` folder and reference them below:_

```markdown
### Login Screen
![Login](assets/images/login_screen.png)

### Calculator Feature
![Calculator](assets/images/calculator_view.png)

### Site Registration
![Site Registration](assets/images/site_registration.png)
```

---

## 10. Contribution and License

### Contribution

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a Pull Request

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**For more details, refer to the inline code comments and the folder structure.**
Feel free to open issues or contribute to improve this template!
