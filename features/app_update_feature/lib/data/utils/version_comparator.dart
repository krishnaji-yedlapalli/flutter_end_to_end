/// Utility for comparing semantic version strings.
///
/// Returns:
///  -1 if version1 < version2
///   0 if version1 == version2
///   1 if version1 > version2
class VersionComparator {
  const VersionComparator._();

  static int compare(String version1, String version2) {
    final v1Parts = _parseVersion(version1);
    final v2Parts = _parseVersion(version2);

    final maxLength =
        v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

    for (int i = 0; i < maxLength; i++) {
      final v1 = i < v1Parts.length ? v1Parts[i] : 0;
      final v2 = i < v2Parts.length ? v2Parts[i] : 0;

      if (v1 < v2) return -1;
      if (v1 > v2) return 1;
    }

    return 0;
  }

  /// Returns true if [version] is less than [other].
  static bool isLessThan(String version, String other) =>
      compare(version, other) < 0;

  /// Returns true if [version] is greater than or equal to [other].
  static bool isGreaterOrEqual(String version, String other) =>
      compare(version, other) >= 0;

  static List<int> _parseVersion(String version) {
    return version.split('.').map((part) => int.tryParse(part) ?? 0).toList();
  }
}
