# Flutter End to End

A Flutter project aimed at learning app development across multiple platforms using a unified codebase.

# Reference link to access the project on Web
 https://flutter-end-to-end.web.app

# Currently Available Features:
1. **Theme**
2. **Routing** - Declarative Routing using GoRouter
3. **Localization** - Bidirectional Support
4. **Offline support** - using the Sqflite plugin
5. **Bloc Architecture** - by applying principles of Clean Architecture
6. **Integrated REST Api's** - using Firebase Realtime Database.
7. **Deep Linking** - Using flutter deep-linking
8. **Remote Push Notifications** - using Firebase
9. **Flavor Support** - Android, IOS & macOS
10.**Automate Tests** - Unit, Widget and Integration
11. **CI/CD Pipeline integration** - for Android, ios, Web and MacOs.

# Currently Supported Platforms:
- Android - [Install Android App](https://github.com/krishnaji-yedlapalli/flutter_end_to_end/tree/gh-pages)
- IOS - [Install IOS](https://i.diawi.com/VeQECd)
- Web - [Open Web App](https://flutter-end-to-end.web.app/)
- MacOS - [Install IOS](https://i.diawi.com/VeQECd)

# Theme:
   * In this application Material 3 themeing was implemented, in this appliacation can find different type of material components.
   * Implemented light and dark theme modes, these modes changes based on the system configurations as well.
   * For more information follow below links
   
   **Medium post:** https://medium.com/@krishnajiyedlapalli60/creating-custom-theme-in-flutter-with-material-3-70e524a126d0  
   **Web Reference:** https://flutter-end-to-end.web.app/#/home/localization

# Routing:
   * This whole application navigations was implemented using **GoRouter** package.
   * It supports all the platforms which are supported by Flutter.
   * This application supports nested navigation.
   * Implemented Parent with mutiple children navigation but having some issue when tapping on device backbutton will sort out it soon.

   **Web Reference:** https://flutter-end-to-end.web.app/#/home/route

# Clean Architecture using Flutter Bloc pattern:
   * For brefiely explaining about bloc we created a module called **Schools**, using this module we can create a school,student and more about school, additionally added a delete option as well.
   * The entire process of creating, editing, and deleting entities is implemented using Bloc exclusively.
   * It will explain how to segregate the folders and how flow will be through them.
   * We are utilizing Firebase Realtime Database for implementing CRUD operations

![alt text](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*8KFA9NXx_YqjQUYNh6BfqA.png)

   **Medium post:** https://medium.com/@krishnajiyedlapalli60/clean-architecture-using-flutter-bloc-43463e9110db  
   **Web Reference:** [https://flutter-end-to-end.web.app/#/home/schools](https://flutter-end-to-end.web.app/#/home/schools)
   
# Offline Support: 
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

# Deep Linking:
  * This applications supports deep linking purely implemented by using flutter officials docs
    https://docs.flutter.dev/ui/navigation/deep-linking
  * Currently Deep linking supported platforms iOS, Android and macOS.
  * Added asset link for Android and site association for iOS
    
    **Android:** https://flutter-end-to-end.web.app/.well-known/assetslinks.json
    
    **iOS:** https://flutter-end-to-end.web.app/.well-known/apple-app-site-association
    
**Reference Link:** [https://docs.flutter.dev/ui/navigation/deep-linking](https://docs.flutter.dev/ui/navigation/deep-linking)  
**Web Reference:** https://flutter-end-to-end.web.app/#/home/deep-linking 

# Push Notification - Remote & Local:
  ## Remote Push Notication:
  * Push Notifications are integrated by using Firebase.
  * Currently Push Notifcations supported platforms Android,iOS,macOS,and Web.   

**Reference Link:** https://firebase.google.com/docs/cloud-messaging/flutter/client    
**Web Reference:** https://flutter-end-to-end.web.app/#/home/push-notifications/remote-notifications 

 ## Local Push Notification:
 * Local notifications are integrated by using **flutter_local_notifications**.
 * Currently Local Push Notifcations supported platforms Android,iOS,macOS,and Linux.

**Reference Link:** https://pub.dev/packages/flutter_local_notifications#-supported-platforms    
**Web Reference:** https://flutter-end-to-end.web.app/#/home/push-notifications/local-notifications      

## Product Flavors:

  ####  Flavors are used to build applications on different aspects like

 * Maintaining different environment.
 * Buidling application on same code base for different customers by changning logos and App name.
 * Changning Configurations like colors,acess,etc.

#### This application supports two build flavors 
1. Flutter 
2. Dart
#### Don't be confused they are flavor name only, Based on the flavor launcher icons and App name is changed

`flutter run --flavor flutter`

`flutter run --flavor dart`

`flutter run`

<img width="1440" alt="image" src="https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/97c77c15-aa35-4176-94d5-12672a589d14">
<img width="1440" alt="image" src="https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/1b047413-3ed4-4f52-9632-a2e7331d851f">
<img width="1434" alt="image" src="https://github.com/krishnaji-yedlapalli/flutter_end_to_end/assets/49545948/55613a03-cb0f-452e-a166-b9bbb5b78967">

## Automate Tests:

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
