import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:uuid/uuid.dart';

mixin HelperMethods {
  static const _uuid = Uuid();

  static K? enumFromString<K>(Iterable<K> values, String value) {
    return values
        .firstWhere((type) => type.toString().split(".").last == value);
  }

  static String get uuid {
    return _uuid.v1().replaceAll('-', '');
  }

  PartsOfDay getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return PartsOfDay.morning;
    } else if (hour >= 12 && hour < 16) {
      return PartsOfDay.afternoon;
    } else if (hour >= 16 && hour < 21) {
      return PartsOfDay.evening;
    } else {
      return PartsOfDay.night;
    }
  }
}
