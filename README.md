# 🚀 Flutter Template

This project is a scalable Flutter architecture template using **GetX**, **Dio**, and **Clean Architecture** best practices.

---

## 📦 Features

- Modular folder structure
- GetX State Management
- Dio for API calls
- Environment-based configs (`.env`)
- Shared UI components
- Global interceptors
- Secure storage support

---

### Prerequisites
- Flutter SDK (version 3.0.0 or higher)
- Dart (version 2.17.0 or higher)
- Android Studio/VSCode with Flutter plugins

### Installation
1. **Clone the repository**
   ```bash
   git clone https://dev.azure.com/Ablazelab/Internal/_git/flutter-template
   cd flutter-template
2. **Install dependencies**
   flutter pub get
3. **Setup environment variables**
   Create .env file in root directory
   Add required variables (see .env.example):
     BASE_URL=https://your-api-url.com
     API_KEY=your_api_key_here
     DEV=true

## 📲 How to Run the App

### 1. Connect Your Device
- **Android Physical Device**:
  1. Enable Developer Options (Tap Build Number 7 times in Settings > About Phone)
  2. Enable USB Debugging in Developer Options
  3. Connect via USB cable (ensure drivers are installed if on Windows)
  4. Run `flutter devices` in terminal to verify connection

- **iOS Physical Device**:
  1. Connect via Lightning cable
  2. Trust the computer when prompted
  3. Unlock your device during installation

- **Emulator**:
  ```bash
  flutter emulators --launch [emulator_name]
  # Or launch through Android Studio/VSCode
  
## Run the App ##
flutter run
# For specific device:
flutter run -d [device_id]  # Get ID from 'flutter devices'

