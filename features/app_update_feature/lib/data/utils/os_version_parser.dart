import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class OsVersionParser {
  const OsVersionParser._();

  /// Returns the parsed numeric OS version for the current platform.
  static Future<num> getCurrentOsVersion() async {
    try{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      final info = await deviceInfo.webBrowserInfo;
      return getBrowserVersion(info);
    } else if (Platform.isIOS || Platform.isMacOS) {
      final info = await deviceInfo.iosInfo;
      final versionString = info.systemVersion; // e.g. "17.4"
      final major =
          double.tryParse(versionString.split('.').take(2).join('.')) ?? 0;
      return major;
    } else if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      final sdkInt = info.version.sdkInt; // int, e.g. 34
      return sdkInt;
    }

    return 0;
    }catch(_){
      return 0;
    }
  }

  static num getBrowserVersion(WebBrowserInfo info) {
  final ua = info.userAgent ?? info.appVersion ?? '';

  switch (info.browserName) {
    case BrowserName.chrome:
      return _extract(ua, r'Chrome/([\d.]+)');
    case BrowserName.edge:
      return _extract(ua, r'Edg/([\d.]+)');
    case BrowserName.opera:
      return _extract(ua, r'OPR/([\d.]+)');
    case BrowserName.firefox:
      return _extract(ua, r'Firefox/([\d.]+)');
    case BrowserName.safari:
      return _extract(ua, r'Version/([\d.]+)');
    default:
      return _extract(ua, r'Chrome/([\d.]+)'); // best-effort fallback
  }
}

static num _extract(String source, String pattern) {
  final match = RegExp(pattern).firstMatch(source);
  return num.parse(match?.group(1)?.split('.').first ?? '0');
}
}
