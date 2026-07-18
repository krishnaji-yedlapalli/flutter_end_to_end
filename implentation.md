## Implementation Plan — Migrate `lib/features` to Pub Workspace Packages
    
    **Problem Statement:**
    Extract all features from `lib/features/` (except `dashboard` and `daily_tracker`) into standalone `pub workspace` packages under
    `features/`, following the existing `schools` pattern. Delete `plugins` and `generative_ai` as they are no longer needed.
    
    **Requirements:**
    - 12 features become workspace packages under `features/<name>/`
    - `dashboard` stays in `lib/features/`
    - `daily_tracker` is a hybrid: private submodule workspace package at `features/daily_tracker_feature` plus a public stub bridge in `lib/features/daily_tracker_stub/`
    - `lib/core`, `lib/shared`, `lib/l10n` stay in root app — packages depend on `sample_latest`
    - `plugins` and `generative_ai` are deleted
    - Goals: independent development/testing, CI/CD per-feature, eventual reusability
    
    **Key facts from codebase analysis:**
    - Root app package name: `sample_latest`
    - Root pubspec already has `workspace:` list with `features/schools`
    - Schools package is the template: uses `resolution: workspace`, depends on `sample_latest: path: ../..`
    - All features import core/shared via `package:sample_latest/core/...` and `package:sample_latest/shared/...`
    - No cross-feature imports exist (features only import within themselves or from sample_latest)
    - `lib/core/routing/routing.dart` is the central file that imports all feature entry points
    - `lib/features/push_notifcations/push_notification_service.dart` imports `package:sample_latest/core/routing/routing.dart` — this
    is fine since routing stays in core
    - `lib/features/regular_widgets/regular_widgets_dashboard.dart` imports `package:sample_latest/core/routing/routing.dart` — fine
    for same reason
    
    **IMPORTANT - Import rewriting rules:**
    - When a file moves from `lib/features/foo/bar.dart` to `features/foo_pkg/lib/bar.dart`, its package changes from `sample_latest`
    to `foo_pkg`
    - Internal imports within the same feature package must change from `package:sample_latest/features/foo/...` to
    `package:foo_pkg/...`
    - The root routing.dart imports must change from `package:sample_latest/features/foo/...` to `package:foo_pkg/...`
    - Imports of `sample_latest` core/shared stay as-is since those files don't move
    
    ---
    
    **Task 1: Delete `plugins` and `generative_ai` features**
    - Remove `lib/features/plugins/` directory entirely
    - Remove `lib/features/generative_ai/` directory entirely  
    - Remove all their import references from `lib/core/routing/routing.dart`
    - Remove corresponding route entries from `lib/core/routing/routing.dart`
    - Remove references from `lib/features/dashboard/constants/home_screen_items.dart`
    - Run `flutter analyze` to confirm no broken references remain
    - Demo: App compiles and runs cleanly; home grid no longer shows plugin/AI tiles
    
    **Task 2: Create `feature_localization` workspace package**
    - Create `features/feature_localization/` directory
    - Create `features/feature_localization/pubspec.yaml`:
      ```yaml
      name: feature_localization
      description: Localization feature module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        provider:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/feature_localization/lib/` directory
    - Move `lib/features/localization.dart` → `features/feature_localization/lib/localization.dart`
    - Add `feature_localization` to root `pubspec.yaml` `workspace:` list
    - Add to root `pubspec.yaml` `dependencies:`: `feature_localization:\n    path: features/feature_localization`
    - Update import in `lib/core/routing/routing.dart`: change `package:sample_latest/features/localization.dart` →
    `package:feature_localization/localization.dart`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: App runs, localization screen opens and locale switching works
    
    **Task 3: Create `routing_feature` workspace package**
    - Create `features/routing_feature/` directory
    - Create `features/routing_feature/pubspec.yaml`:
      ```yaml
      name: routing_feature
      description: Routing feature showcase module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        go_router:
        provider:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/routing_feature/lib/` directory
    - Copy entire `lib/features/routing_features/` contents into `features/routing_feature/lib/`
    - Rewrite all imports in moved files: `package:sample_latest/features/routing_features/` → `package:routing_feature/`
    - Delete `lib/features/routing_features/` directory
    - Add `routing_feature` to root pubspec `workspace:` list
    - Add `routing_feature: path: features/routing_feature` to root pubspec dependencies
    - Update all imports in `lib/core/routing/routing.dart`: `package:sample_latest/features/routing_features/` →
    `package:routing_feature/`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Shell route demos and stateful shell navigation work
    
    **Task 4: Create `scrolling` workspace package**
    - Create `features/scrolling/` directory
    - Create `features/scrolling/pubspec.yaml`:
      ```yaml
      name: scrolling
      description: Scrolling feature showcase module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        go_router:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/scrolling/lib/` directory
    - Move entire `lib/features/scrolling/` contents into `features/scrolling/lib/`
    - No internal cross-imports between scrolling files need rewriting (they don't import each other with package: prefix)
    - Delete `lib/features/scrolling/` directory
    - Add `scrolling` to root pubspec `workspace:` list
    - Add `scrolling: path: features/scrolling` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: `package:sample_latest/features/scrolling/` → `package:scrolling/`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: All scrolling demos (ListView, GridView, Slivers, PageView, etc.) work
    
    **Task 5: Create `regular_widgets` workspace package**
    - Create `features/regular_widgets/` directory
    - Create `features/regular_widgets/pubspec.yaml`:
      ```yaml
      name: regular_widgets
      description: Regular widgets and animations showcase module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        go_router:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/regular_widgets/lib/` directory
    - Move entire `lib/features/regular_widgets/` contents into `features/regular_widgets/lib/`
    - Move `lib/features/automatic_keep_alive.dart` → `features/regular_widgets/lib/automatic_keep_alive.dart`
    - Move `lib/features/life_cycle_of_widget.dart` → `features/regular_widgets/lib/life_cycle_of_widget.dart`
    - Rewrite all internal imports in moved files: `package:sample_latest/features/regular_widgets/` → `package:regular_widgets/`
    - Delete `lib/features/regular_widgets/` directory
    - Add `regular_widgets` to root pubspec `workspace:` list
    - Add `regular_widgets: path: features/regular_widgets` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: change all `package:sample_latest/features/regular_widgets/` →
    `package:regular_widgets/`, and `package:sample_latest/features/automatic_keep_alive.dart` →
    `package:regular_widgets/automatic_keep_alive.dart`, `package:sample_latest/features/life_cycle_of_widget.dart` →
    `package:regular_widgets/life_cycle_of_widget.dart`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: All widget demos work including animations, dialogs, tables, Cupertino, keep-alive, lifecycle
    
    **Task 6: Create `shortcuts_feature` workspace package**
    - Create `features/shortcuts_feature/` directory
    - Create `features/shortcuts_feature/pubspec.yaml`:
      ```yaml
      name: shortcuts_feature
      description: Keyboard shortcuts showcase module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/shortcuts_feature/lib/` directory
    - Move `lib/features/shortcuts/` contents into `features/shortcuts_feature/lib/`
    - Rewrite internal imports in moved files: `package:sample_latest/features/shortcuts/` → `package:shortcuts_feature/`
    - Delete `lib/features/shortcuts/` directory
    - Add `shortcuts_feature` to root pubspec `workspace:` list
    - Add `shortcuts_feature: path: features/shortcuts_feature` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: `package:sample_latest/features/shortcuts/` → `package:shortcuts_feature/`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Shortcuts screen works on desktop/web
    
    **Task 7: Create `deep_linking_feature` workspace package**
    - Create `features/deep_linking_feature/` directory
    - Create `features/deep_linking_feature/pubspec.yaml`:
      ```yaml
      name: deep_linking_feature
      description: Deep linking showcase module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/deep_linking_feature/lib/` directory
    - Move `lib/features/deep_linking/deep_linking.dart` → `features/deep_linking_feature/lib/deep_linking.dart`
    - Delete `lib/features/deep_linking/` directory
    - Add `deep_linking_feature` to root pubspec `workspace:` list
    - Add `deep_linking_feature: path: features/deep_linking_feature` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: `package:sample_latest/features/deep_linking/deep_linking.dart` →
    `package:deep_linking_feature/deep_linking.dart`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Deep linking screen renders with correct URL display
    
    **Task 8: Create `responsive_showcase` workspace package**
    - Create `features/responsive_showcase/` directory
    - Create `features/responsive_showcase/pubspec.yaml`:
      ```yaml
      name: responsive_showcase
      description: Responsive UI showcase module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/responsive_showcase/lib/` directory
    - Move `lib/features/responsive_showcase/` contents into `features/responsive_showcase/lib/`
    - No internal package imports to rewrite in this feature (only uses `sample_latest` and `flutter`)
    - Delete `lib/features/responsive_showcase/` directory
    - Add `responsive_showcase` to root pubspec `workspace:` list
    - Add `responsive_showcase: path: features/responsive_showcase` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: `package:sample_latest/features/responsive_showcase/` →
    `package:responsive_showcase/`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Responsive showcase page renders correctly
    
    **Task 9: Create `feature_discovery_module` workspace package**
    - Create `features/feature_discovery_module/` directory
    - Create `features/feature_discovery_module/pubspec.yaml`:
      ```yaml
      name: feature_discovery_module
      description: Feature discovery overlays module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        feature_discovery:
          git:
            url: https://github.com/maheshmnj/feature_discovery.git
            ref: master
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/feature_discovery_module/lib/` directory
    - Move `lib/features/feature_discovery/` contents into `features/feature_discovery_module/lib/`
    - Check where `home_feature_discovery` and `school_feature_discovery` are imported and update those references
    - Delete `lib/features/feature_discovery/` directory
    - Add `feature_discovery_module` to root pubspec `workspace:` list
    - Add `feature_discovery_module: path: features/feature_discovery_module` to root pubspec dependencies
    - Update any imports of these files in `lib/core/routing/routing.dart` and `lib/core/mixins/feature_discovery_mixin.dart`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Feature discovery overlays trigger correctly on home and schools screens
    
    **Task 10: Create `push_notifications` workspace package**
    - Create `features/push_notifications/` directory
    - Create `features/push_notifications/pubspec.yaml`:
      ```yaml
      name: push_notifications
      description: Push notifications feature module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        firebase_core:
        firebase_messaging:
        flutter_local_notifications:
        googleapis_auth:
        go_router:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/push_notifications/lib/` directory
    - Move ALL files from `lib/features/push_notifcations/` into `features/push_notifications/lib/` (this also fixes the typo)
    - Rewrite internal import in moved files: `package:sample_latest/features/push_notifcations/` → `package:push_notifications/`
    - Delete `lib/features/push_notifcations/` directory
    - Add `push_notifications` to root pubspec `workspace:` list
    - Add `push_notifications: path: features/push_notifications` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: all `package:sample_latest/features/push_notifcations/` →
    `package:push_notifications/`
    - Update import in `lib/features/dashboard/home_screen.dart`:
    `package:sample_latest/features/push_notifcations/push_notification_service.dart` →
    `package:push_notifications/push_notification_service.dart`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Remote and local push notification screens accessible and functional
    
    **Task 11: Create `isolates_feature` workspace package**
    - Create `features/isolates_feature/` directory
    - Create `features/isolates_feature/pubspec.yaml`:
      ```yaml
      name: isolates_feature
      description: Isolates showcase module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        flutter_bloc:
        get_it:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/isolates_feature/lib/` directory
    - Move entire `lib/features/isolates/` contents into `features/isolates_feature/lib/`
    - Rewrite ALL internal imports in moved files: `package:sample_latest/features/isolates/` → `package:isolates_feature/`
    - Delete `lib/features/isolates/` directory
    - Add `isolates_feature` to root pubspec `workspace:` list
    - Add `isolates_feature: path: features/isolates_feature` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: all `package:sample_latest/features/isolates/` → `package:isolates_feature/`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Isolate compute and spawn demos function correctly with BLoC state management
    
    **Task 12: Create `smart_control_iot` workspace package**
    - Create `features/smart_control_iot/` directory
    - Create `features/smart_control_iot/pubspec.yaml`:
      ```yaml
      name: smart_control_iot
      description: Smart control IoT feature module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        flutter_bloc:
        get_it:
        fpdart:
        equatable:
        shelf:
        shelf_router:
        flutter_staggered_grid_view:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/smart_control_iot/lib/` directory
    - Move entire `lib/features/smart_control_iot/` contents into `features/smart_control_iot/lib/`
    - Rewrite ALL internal imports: `package:sample_latest/features/smart_control_iot/` → `package:smart_control_iot/`
    - Delete `lib/features/smart_control_iot/` directory
    - Add `smart_control_iot` to root pubspec `workspace:` list
    - Add `smart_control_iot: path: features/smart_control_iot` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: `package:sample_latest/features/smart_control_iot/` →
    `package:smart_control_iot/`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: Smart control IoT dashboard loads and device tiles render
    
    **Task 13: Create `smart_control_mqtt` workspace package**
    - Create `features/smart_control_mqtt/` directory
    - Create `features/smart_control_mqtt/pubspec.yaml`:
      ```yaml
      name: smart_control_mqtt
      description: Smart control MQTT IoT feature module.
      publish_to: none
      environment:
        sdk: ^3.6.0
      resolution: workspace
      dependencies:
        flutter:
          sdk: flutter
        flutter_bloc:
        get_it:
        equatable:
        mqtt_client:
        flutter_staggered_grid_view:
        sample_latest:
          path: ../..
      flutter:
        uses-material-design: true
      ```
    - Create `features/smart_control_mqtt/lib/` directory
    - Move entire `lib/features/smart_control_mqtt_iot_/` contents into `features/smart_control_mqtt/lib/`
    - Rewrite ALL internal imports: `package:sample_latest/features/smart_control_mqtt_iot_/` → `package:smart_control_mqtt/`
    - Delete `lib/features/smart_control_mqtt_iot_/` directory
    - Add `smart_control_mqtt` to root pubspec `workspace:` list
    - Add `smart_control_mqtt: path: features/smart_control_mqtt` to root pubspec dependencies
    - Update imports in `lib/core/routing/routing.dart`: `package:sample_latest/features/smart_control_mqtt_iot_/` →
    `package:smart_control_mqtt/`
    - Run `flutter pub get` and `flutter analyze`
    - Demo: MQTT smart control dashboard loads and on/off controls work
    
    **Task 14: Final cleanup and full build verification**
    - Objective: Ensure `lib/features/` is clean and the whole workspace resolves and compiles
    - Confirm `lib/features/` only contains `dashboard/` and `daily_tracker_stub/`
    - Remove any remaining empty directories under `lib/features/`
    - Run `flutter pub get` at workspace root to verify all packages resolve
    - Run `flutter analyze` across root and all feature packages
    - Run `flutter test` on any package that has tests
    - Demo: Full app builds and runs with `flutter run`; all features reachable from home grid; `flutter analyze` reports no issues