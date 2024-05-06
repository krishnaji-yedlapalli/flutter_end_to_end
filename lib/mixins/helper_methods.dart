
import 'package:uuid/uuid.dart';

mixin HelperMethods {

  static const _uuid = Uuid();

  static K? enumFromString<K>(Iterable<K> values, String value) {
    return values.firstWhere((type) => type.toString().split(".").last == value);
  }

  static String get uuid {
    return _uuid.v1().replaceAll('-', '');
  }

}