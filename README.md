# NEOLA — Neonatal Healthcare Mobile App

> **Research Phase** · A mobile companion app for real-time neonatal health monitoring via BLE-connected wristband and phototherapy devices.

---

## About

**NEOLA** is a medical healthcare mobile application currently in the **research phase**. It is designed for hospital staff and related personnel working in newborn care units, providing real-time monitoring of critical neonatal health indicators through Bluetooth Low Energy (BLE) connected devices.

> **Disclaimer** — This project is a customer-commissioned project from [Fastwork.co](https://fastwork.co). All ideas, concepts, and UI/UX designs are provided by the customer. The developer's role is limited to implementing the customer's requirements into a functional mobile application.

---

## Features

### Baby Profile Onboarding
- Collect and store baby information (age, weight, gender, gestational age)
- Input validation with appropriate keyboard types (numeric, decimal)
- Profile data persisted via Riverpod state management

### Health Dashboard
- Real-time display of key neonatal health indicators:
  - **Bilirubin** (mg/dl)
  - **Glucose** (mg/dl)
  - **Hemoglobin** (mg/dl)
  - **Oxygen** (%)
- Color-coded status indicators (Safe / Warning / Critical)
- Swipeable device cards showing connection status and live data

### BLE Device Connectivity
- Scan and connect to **NEOLA Wristband** and **Phototherapy** devices via Bluetooth Low Energy
- Live data streaming from connected hardware (UART over BLE — Nordic UART Service)
- Connection status management with connect/disconnect workflows
- **Simulator mode** — mock connections for development and testing on non-BLE environments (e.g., iOS Simulator)

### Alert & Notification System
- Configurable test alerts for each health metric (Bilirubin, Glucose, Hemoglobin, Oxygen)
- Countdown overlay before alert navigation
- Full-screen caution alert pages with metric-specific gradient themes
- Notification history grouped by date

### History
- Historical health records displayed in card-based layout
- Color-coded health evaluation per metric using a rule engine
- Stage classification: Normal → Stage 1 → Stage 2 → Stage 3

### Settings
- App information and sharing options
- Debug tools for clearing user data and test notifications

---

## Tech Stack

| Layer              | Technology                                                       |
| ------------------ | ---------------------------------------------------------------- |
| **Framework**      | Flutter 3.41.7 (Dart 3.11.5)                                    |
| **State Management** | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) v3.3.1 |
| **BLE**            | [flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus) v1.30.0 |
| **Permissions**    | [permission_handler](https://pub.dev/packages/permission_handler) v11.3.0 |
| **Date Formatting**| [intl](https://pub.dev/packages/intl) v0.20.2                   |
| **Design**         | Material Design 3                                                |

---

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   └── theme/
│       └── app_colors.dart            # Color constants
├── data/
│   ├── model/                         # Data models (placeholder)
│   └── services/                      # Services (placeholder)
├── state/
│   ├── bluetooth_state.dart           # BLE connection state & notifier
│   ├── notification_state.dart        # Notification state & mock data
│   ├── profile_state.dart             # Baby profile state
│   └── test_alert_configs.dart        # Alert gradient/message configs
└── ui/
    ├── main_navigation.dart           # Bottom navigation (Home, History, Settings)
    ├── home/
    │   ├── home_page.dart             # Main dashboard
    │   ├── bluetooth_connection_page.dart  # BLE scan & connect page
    │   └── widgets/
    │       ├── device_card.dart        # Swipeable device card widget
    │       └── data_row_card.dart      # Health metric row widget
    ├── history/
    │   └── history_page.dart          # Historical records view
    ├── notifications/
    │   ├── notification_page.dart      # Notification list page
    │   └── generic_alert_page.dart    # Full-screen caution alert
    ├── onboarding/
    │   └── setup_profile_page.dart    # Baby profile setup form
    ├── settings/
    │   └── settings_page.dart         # App settings & debug tools
    └── shared_widgets/                # Reusable widgets (placeholder)
```

---

## Getting Started

### Prerequisites

- **Flutter SDK** `3.41.7` or compatible (stable channel)
- **Dart SDK** `^3.11.5`
- **Xcode** (for iOS) or **Android Studio** (for Android)
- A physical device is recommended for BLE functionality (Bluetooth is not available on simulators/emulators, but the app provides a mock mode)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/<your-username>/children_healthcare_mobile.git
   cd children_healthcare_mobile
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Verify your Flutter environment**

   ```bash
   flutter doctor
   ```

   Make sure there are no critical issues for your target platform (iOS / Android).

4. **Run the app**

   ```bash
   # List available devices
   flutter devices

   # Run on a connected device or simulator
   flutter run
   ```

### iOS Setup

If running on iOS for the first time:

```bash
cd ios
pod install
cd ..
flutter run
```

> **Note:** Add the following keys to `ios/Runner/Info.plist` if not already present for Bluetooth and location permissions:
> ```xml
> <key>NSBluetoothAlwaysUsageDescription</key>
> <string>This app uses Bluetooth to connect to NEOLA healthcare devices.</string>
> <key>NSBluetoothPeripheralUsageDescription</key>
> <string>This app uses Bluetooth to connect to NEOLA healthcare devices.</string>
> ```

### Android Setup

Ensure the following permissions are declared in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

---

## App Flow

```
SetupProfilePage (Onboarding)
        │
        ▼
  MainNavigation
   ┌────┼────────┐
   │    │        │
   ▼    ▼        ▼
History Home  Settings
        │
   ┌────┼────┐
   │         │
   ▼         ▼
 BLE      Notifications
Connect    └─► Alert Page
 Page
```

---

## Development Notes

- **Simulator / Emulator:** The app detects when BLE is unsupported and automatically offers a **Mock Connect** button for testing the full UI flow without hardware.
- **BLE Protocol:** Devices communicate over Nordic UART Service (NUS) — UUID `6E400001-B5A3-F393-E0A9-E50E24DCCA9E`. Data is received on the TX characteristic (`6E400003`) as comma-separated values.
- **State Management:** All app state (profile, Bluetooth connections, notifications) is managed through Riverpod `Notifier` providers for clean, reactive UI updates.

---

## License

This is a private project. All rights reserved by the project owner.
