
mixin HelperMethods {

  static K? enumFromString<K>(Iterable<K> values, String value) {
    return values.firstWhere((type) => type.toString().split(".").last == value);
  }

}