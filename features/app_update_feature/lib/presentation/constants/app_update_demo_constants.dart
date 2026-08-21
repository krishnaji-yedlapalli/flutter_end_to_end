class AppUpdateDemoConstants {
  AppUpdateDemoConstants._();

  static List<String> osVersionOptions =
      List.generate(200, (index) => (index + 1).toString()).toList();

  static const List<String> appVersionOptions = [
    '1.0.0',
    '1.5.0',
    '2.0.0',
    '2.1.0',
    '2.5.0',
    '3.0.0',
  ];
}
