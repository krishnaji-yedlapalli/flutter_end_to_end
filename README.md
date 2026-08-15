# Flutter End to End

This repository is a monorepo that contains multiple packages, each responsible for a specific feature or functionality of the application.

The project uses Dart Pub Workspaces to manage dependencies and keep all packages in sync. This structure allows developers to work independently on individual packages while maintaining a consistent development environment across the entire codebase.

This monorepo approach is particularly well suited for large-scale and enterprise applications, where modularity, scalability, and independent development are important.

> **Flutter version:** **3.38**.

## Available Features:
🎨 **Theming** – Material 3 theming with dynamic light & dark modes.  
🧭 **Routing** – Declarative routing powered by `GoRouter`.  
🌐 **Localization** – Internationalization with LTR & RTL support.  
📱 **Responsiveness** – Adaptive UI for multiple screen sizes & orientations.  
💾 **Offline Storage** – Local persistence using `sqflite`.  
🧱 **Clean Architecture** – BLoC + Clean Architecture principles.  
🔗 **REST APIs** – Firebase Realtime Database examples.  
🌍 **Deep Linking** – Navigate directly to in-app screens via URLs.  
🔔 **Push Notifications** – Remote & local notifications using Firebase and `flutter_local_notifications`.  
🏷️ **Flavor Support** – Environment-based builds for Android, iOS & macOS.  
⚙️ **CI/CD Integration** – Automated pipelines for Android, iOS, Web, macOS, Windows & Linux using GitHub Actions.  
🚀 **Semantic Releases** – Automated versioning and publishing with conventional commits.  
🧪 **Test-Driven Development (TDD)** – Unit, Widget, Golden, Accessibility & Integration tests.  
🪝 **Git Hooks** – Pre-commit checks for formatting & code quality.  
📂 **Path Handling Scripts** – Safe path resolution & fallback handling for private or missing files.

## Supported Platforms:
![Platforms](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20macOS%20%7C%20Linux%20%7C%20Web%20%7C%20Windows-brightgreen)
- **Android** – [Install Android App](https://github.com/krishnaji-yedlapalli/flutter_end_to_end/tree/gh-pages)
- **iOS** – [Install on TestFlight](https://testflight.apple.com/join/UulGfVnn)
- **Web** – [Open Web App](https://flutter-end-to-end.web.app/)
- **macOS** – [Download macOS App](https://i.diawi.com/VeQECd)
- **Windows** – Build available locally (coming soon for public download)
- **Linux (Raspberry Pi)** – Runs on Raspberry Pi using Flutter Linux embedding

> [!NOTE]
> In this project, the **Schools** feature demonstrates responsiveness, clean architecture, SOLID principles, design patterns, and API integration. Please refer to its implementation at: [School Feature](https://github.com/krishnaji-yedlapalli/flutter_end_to_end/tree/main/features/schools)

## Project Structure

```text
flutter_end_to_end/
├── android/                 # Android application and build configuration
├── ios/                     # iOS application and build configuration
├── linux/                   # Linux desktop runner
├── macos/                   # macOS desktop runner
├── web/                     # Web application and hosting files
├── windows/                 # Windows desktop runner
├── lib/                     # Application source code
├── asset/                   # Images, icons, sounds, and flavor assets
├── features/                # Independently packaged feature modules
│   ├── daily_tracker_feature/
│   ├── deep_linking_feature/
│   ├── feature_discovery_module/
│   ├── feature_localization/
│   ├── isolates_feature/
│   ├── push_notifications/
│   ├── regular_widgets/
│   ├── responsive_showcase/
│   ├── routing_feature/
│   ├── schools/
│   ├── scrolling/
│   ├── shortcuts_feature/
│   ├── smart_control_iot/
│   └── smart_control_mqtt/
├── packages/                # Shared Dart/Flutter packages
│   ├── core/
│   └── ui_kit/
├── test/                    # Unit and widget tests
├── integration_test/        # End-to-end integration tests
├── test_driver/             # Web integration-test driver
├── scripts/                 # Development, release, and kiosk scripts
└── hardware_firmware/       # Smart-device firmware and shared hardware code
```

## Feature Modules

| Feature | Purpose | Documentation |
| --- | --- | --- |
| Schools | Clean Architecture, BLoC, Firebase CRUD, and offline-data example. | [README](features/schools/README.md) |
| Deep Linking | Builds and tests URLs that open specific app screens. | [README](features/deep_linking_feature/README.md) |
| Localization | Runtime locale switching and LTR/RTL localization examples. | [README](features/feature_localization/README.md) |
| Push Notifications | Firebase Cloud Messaging and local notification demonstrations. | [README](features/push_notifications/README.md) |
| Regular Widgets | Examples of commonly used Flutter widgets and UI patterns. | [README](features/regular_widgets/README.md) |
| Responsive Showcase | Adaptive layouts and responsive widget examples. | [README](features/responsive_showcase/README.md) |
| Routing | Declarative navigation and nested-route examples with `GoRouter`. | [README](features/routing_feature/README.md) |
| Scrolling | Flutter scrolling behavior and scrollable-widget examples. | — |
| Shortcuts | Keyboard shortcuts and actions examples. | — |
| Isolates | `compute()`, spawned isolates, and long-running worker-isolate examples. | [README](features/isolates_feature/README.md) |
| Feature Discovery | Guided onboarding overlays for the home and Schools screens. | [README](features/feature_discovery_module/README.md) |
| Daily Tracker | Private daily-activity tracking module for the Raspberry Pi setup. | — |
| Smart Control IoT | Raspberry Pi-based smart-device control with a local server. | [README](features/smart_control_iot/README.md) |
| Smart Control MQTT | MQTT-based smart-device control and broker integration. | [README](features/smart_control_mqtt/README.md) |

## Shared Packages

| Package | Purpose | Documentation |
| --- | --- | --- |
| `app_core` | Shared infrastructure for routing, networking, theming, localization, Firebase, and platform services. | [README](packages/core/README.md) |
| `ui_kit` | Reusable UI components, responsive widgets, presentation utilities, and mixins. | [README](packages/ui_kit/README.md) |

## Directory Guide

#### `features/`

Contains self-contained Flutter modules, each focused on a specific capability such as routing, localization, notifications, or smart-home control. These modules can be studied independently while still integrating with the main app.

#### `packages/`

Holds shared Dart and Flutter packages used across the project. `app_core` provides common infrastructure, while `ui_kit` supplies reusable UI components and presentation utilities.

#### `lib/`

Contains the main application source code. It connects feature modules, configures app-wide routing and services, and provides shared application behavior.

#### `asset/`

Stores images, icons, sounds, splash screens, and flavor-specific assets used by the application.

#### `scripts/`

Contains development and device-setup automation:

- `bump_version.sh` updates the app version from Conventional Commit history.
- Pre-commit and commit-message scripts format and analyze Dart code and enforce commit-message conventions.
- Raspberry Pi kiosk scripts configure permissions, while `kiosk-app.service` starts and restarts the Flutter kiosk application at boot.
- See the [scripts README](scripts/README.md) for commands, prerequisites, and installation details.

#### `test/`

Contains unit and widget tests that verify application logic and UI behavior in isolation.

#### `integration_test/`

Contains end-to-end tests that run the complete application on a device or browser and verify user flows across multiple components.

#### `test_driver/`

Provides the driver configuration needed to run integration tests in a web browser.

#### `hardware_firmware/`

Contains firmware and shared code for the smart-home hardware devices used by the IoT demonstrations.

---

### Daily Tracker (Private Sub-Repository)

This public repository integrates **Daily Tracker** as a private git submodule at `features/daily_tracker_feature`. The submodule supports all platforms. I personally use it on a Raspberry Pi connected to a touch display with a stand, as shown in the recordings below. I use this setup to track my daily activities.

Access to this sub-repository is restricted due to privacy and policy requirements. The public repo ships with a stub bridge in `lib/features/daily_tracker_stub/` so the app builds without the private package.

**Enable locally (requires submodule access):**
```bash
git submodule update --init features/daily_tracker_feature
lib/features/daily_tracker_stub/scripts/daily_tracker_prepare_path.sh enabled
flutter pub get
```

**Disable (default for public clones):**
```bash
lib/features/daily_tracker_stub/scripts/daily_tracker_prepare_path.sh disabled
flutter pub get
```

**Maintainers — publish package updates to the private repo:**
```bash
lib/features/daily_tracker_stub/scripts/sync_daily_tracker_to_private_repo.sh
```

**Hardware Used:**
- Raspberry Pi 5
- Active Cooler
- Raspberry Pi Touch Display 2
- Display Stand

https://github.com/user-attachments/assets/f2a30bf7-1b82-48f0-b3f5-f752e61a5b65 

https://github.com/user-attachments/assets/bf434daa-6be8-45d6-b5e0-6d539acd9420

---

### 🎨Theme:
   * In this application Material 3 themeing was implemented, in this appliacation can find different type of material components.
   * Implemented light and dark theme modes, these modes changes based on the system configurations as well.
   * For more information follow below links
   
   > **Medium post:** https://medium.com/@krishnajiyedlapalli60/creating-custom-theme-in-flutter-with-material-3-70e524a126d0  
   > **Web Reference:** https://flutter-end-to-end.web.app/#/home
  --- 
### 🧭 Localization:
   * This application Localization with bir directional support.
   * The application adapts to the system language if it is included in the localization list.
   * For more information follow below links
   
   > **Medium post:** https://medium.com/stackademic/flutter-localization-and-internationalization-with-ltr-and-rtl-support-3c70cb926ba5
   > **Web Reference:** https://flutter-end-to-end.web.app/#/home/localization
---
### 📱 Responsiveness:
   * The application UI is designed to adapt seamlessly across various screen sizes and orientations, including mobile, tablet, web, and desktop.
   * This is achieved through a combination of Flutter's built-in responsive widgets and techniques:
     - **`MediaQuery`**: Used to determine current screen size, orientation, and pixel density.
     - **`LayoutBuilder`**: Dynamically rebuilds parts of the UI based on the available constraints from its parent widget.
     - **`Expanded` and `Flexible`**: Utilized within `Row` and `Column` widgets to distribute space efficiently.
     - **Adaptive Widgets**: Leveraging Flutter's Material Design adaptive components and custom-built adaptive widgets to ensure a consistent user experience on all platforms.
     - **Breakpoints**: Custom breakpoints are defined to switch layouts and designs for different screen categories (e.g., compact, medium, expanded).
---
### 🌐 Routing:
   * This whole application navigations was implemented using **GoRouter** package.
   * It supports all the platforms which are supported by Flutter.
   * This application supports nested navigation.
   * Implemented Parent with mutiple children navigation but having some issue when tapping on device backbutton will sort out it soon.

   > **Web Reference:** https://flutter-end-to-end.web.app/#/home/route
---
### 🧱 Clean Architecture using Flutter Bloc pattern:
   * For brefiely explaining about bloc we created a module called **Schools**, using this module we can create a school,student and more about school, additionally added a delete option as well.
   * The entire process of creating, editing, and deleting entities is implemented using Bloc exclusively.
   * It will explain how to segregate the folders and how flow will be through them.
   * We are utilizing Firebase Realtime Database for implementing CRUD operations

![alt text](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*8KFA9NXx_YqjQUYNh6BfqA.png)

   > **Medium post:** https://medium.com/@krishnajiyedlapalli60/clean-architecture-using-flutter-bloc-43463e9110db  
   > **Web Reference:** [https://flutter-end-to-end.web.app/#/home/schools](https://flutter-end-to-end.web.app/#/home/schools)
 ---  
### 📡❌ Offline Support: 
   * School module which is developed by using flutter Bloc can stores the data in the local DB this was implemented by using SQLite data base.
   * It has three different type modes based on the selected mode data will be stored.
     - **Offline Mode:**
       Stores the data in Local db only when there was no internet. Once internet is back data will Sync automatically with server and delete the local data
     - **Online & Offline Mode:**
       Irrespective of Internet data will be stored in local db and data will be deleted based on the configured date
     - **Dumping Offline Data:**
       Data will be dumped into the local DB at the time login or Module loading. Later it is used making some operations    
  * Once internet is available it will automatically upload the data to server using Connectivity plus package.
  * Currently Offline supported platforms iOS, Android and macOS . 
---
### 🌍 Deep Linking:
  * This applications supports deep linking purely implemented by using flutter officials docs
    https://docs.flutter.dev/ui/navigation/deep-linking
  * Currently Deep linking supported platforms iOS, Android and macOS.
  * Added asset link for Android and site association for iOS
    
    **Android:** https://flutter-end-to-end.web.app/.well-known/assetslinks.json
    
    **iOS:** https://flutter-end-to-end.web.app/.well-known/apple-app-site-association
    
> **Reference Link:** [https://docs.flutter.dev/ui/navigation/deep-linking](https://docs.flutter.dev/ui/navigation/deep-linking)  
> **Web Reference:** https://flutter-end-to-end.web.app/#/home/deep-linking 
---
### 🔔 Push Notifications
- **📡 Remote Push Notifications**
    - Integrated using **Firebase Cloud Messaging (FCM)**
    - Supported on: **Android, iOS, macOS, Web**
    > **Reference:** https://firebase.google.com/docs/cloud-messaging/flutter/client  
    > **Web Demo:** https://flutter-end-to-end.web.app/#/home/push-notifications/remote-notifications

- **📱 Local Push Notifications**
    - Implemented using **flutter_local_notifications**
    - Supported on: **Android, iOS, macOS, Linux**
    > **Reference:** https://pub.dev/packages/flutter_local_notifications#-supported-platforms  
    > **Web Demo:** https://flutter-end-to-end.web.app/#/home/push-notifications/local-notifications    
---
### 🏷️ Product Flavors

#### Why Flavors Are Used
Product flavors help build applications for different requirements and environments, such as:

- Maintaining different environments (dev, stage, prod)
- Building apps for multiple customers while reusing the same codebase  
  (e.g., changing logos and app names)
- Changing configurations like colors, access controls, and feature toggles

#### Supported Build Flavors
This application currently supports **two** build flavors:

1. **Flutter**
2. **Dart**

> 💡 *These are just flavor names.*  
> Depending on the selected flavor, the launcher icons and app name change.

#### Running the App with Flavors

```bash
flutter run --flavor flutter

flutter run --flavor dart

flutter run   # Default flavor
```
<img width="700" alt="image" src="https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/97c77c15-aa35-4176-94d5-12672a589d14">
<img width="700" alt="image" src="https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/1b047413-3ed4-4f52-9632-a2e7331d851f">
<img width="700" alt="image" src="https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/55613a03-cb0f-452e-a166-b9bbb5b78967">

---

### ⚙️ CI/CD Integration:
   This project uses GitHub Actions for its Continuous Integration and Continuous Deployment (CI/CD) pipelines, automating the build and test processes across Android, iOS, Web, macOS, Windows, and Linux.

   - **Continuous Integration (CI)**: The `ci.yaml` workflow runs on every pull request to `main` and `develop`. It performs the following checks:
     - Lints and analyzes the Dart code to ensure code quality.
     - Builds the application for Android, iOS, and Web to verify that the project is in a buildable state.

   - **Continuous Deployment (CD)**:
     - **Firebase Hosting**: The `firebase-hosting-merge.yml` workflow automatically deploys the web build to Firebase Hosting on every push to `main`.
     - **Android Release**: The `ci.yaml` workflow also deploys the Android APK to the `gh-pages` branch for distribution.

   - **Automated Releases**: The `release.yaml` workflow, triggered on pushes to `main`, automates the release process by:
     - Bumping the version number based on conventional commit messages.
     - Creating a new Git tag.
     - Generating a GitHub Release with an automated changelog.
---
### 🚀 **Semantic Releases**
Semantic Releases ensure automated versioning, tagging, and changelog generation based on **Conventional Commits**.

Semantic versioning is driven by commit message types such as `feat`, `fix`, and `chore`, following the official specification:  
🔗 https://www.conventionalcommits.org/en/v1.0.0/

The `release.yaml` workflow, triggered on pushes to the `main` branch, automates the entire release process by:

- Analyzing commit messages to determine whether to bump **major**, **minor**, or **patch** versions  
- Automatically updating the version number  
- Creating and pushing a new Git tag  
- Generating a GitHub Release with an auto-generated changelog  
- Ensuring consistent and predictable release cycles        
---
### 🧪 Test Driven Devlopment(TDD):

**Integration Tests on Mobile**

`flutter test integration_test`

https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/62c1bffb-4381-4d3d-b8d9-95e0b2ce1e17

**Integration Tests on Web**

`flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome`

https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/4973956d-03f8-41f4-9d80-92b13f857aaa

**Unit Test and Widget Testing**

![Results of Unit and Widget Tests](https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/697b7a82-0c76-41a2-815f-d9898adf2417)
---
# Project Setup

This project supports Flutter **3.38** and is pinned to Flutter **3.38.7** through FVM. The current project version is **1.0.0+1**.

## Prerequisites

- Flutter SDK **3.38.x** (the repository pins **3.38.7** through FVM)
- [pre-commit](https://pre-commit.com/) (for running pre-commit checks)

## Setup Steps

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/krishnaji-yedlapalli/flutter_end_to_end.git
    cd flutter_end_to_end
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Install Git hooks:**
    This project uses `pre-commit` to run checks before each commit. To set it up, run the following commands:
    ```bash
    pip install pre-commit
    pre-commit install
    ```

4.  **Run the project:**
    You can run the project using the following command:
    ```bash
    flutter run
    ```
    This project supports flavors. You can run a specific flavor using:
    ```bash
    flutter run --flavor <flavor_name>
    ```
    (e.g., `flutter run --flavor flutter` or `flutter run --flavor dart`)

> **Note on the `daily_tracker` submodule:** Daily Tracker is a private submodule at `features/daily_tracker_feature`. Access to this repository is restricted due to privacy and policy considerations. If you require access, contact the project administrator. Without access, use `daily_tracker_prepare_path.sh disabled` (the default) and the app will compile using stub routes.

## 🧭 Roadmap (Upcoming Features)

- 🔗 **.NET Web API Integration**  
  Integrate backend services using ASP.NET Core Web APIs.

- 🔍 **GraphQL Integration**  
  Add GraphQL support for efficient querying and flexible data access.

- 📊 **Firebase Analytics Integration**  
  Track user behavior, events, and app engagement with Firebase Analytics.

- ⚠️ **Advanced Error Handling**  
  Implement global error tracking, exception logging, and UI-friendly error states.

- 🏠 **Home Automation (Smart Control)**  
  Control IoT devices using **Raspberry Pi** and **NodeMCU (ESP modules)**.  
  Build a smart automation control panel inside the app.

- 🤖 **Gen UI Integration**  
  Integrate AI-generated UI or UI automation via Gen UI frameworks/tools.

- 🧩 **FFI (Foreign Function Interface)**  
  Add native C/C++/Rust bindings for performance-critical features.
