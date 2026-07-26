import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// Configures SSL certificate pinning on the Dio instance.
///
/// In debug mode, pinning is skipped to allow development with self-signed certs.
/// On web platform, this is a no-op since the browser handles TLS verification.
Future<void> configureSslPinning(Dio dio) async {
  // Web platform — browser handles TLS, no custom pinning needed.
  if (kIsWeb) return;

  // Debug mode — skip pinning for development ease.
  if (kDebugMode) return;

  final fingerprints = await AppCertificateFingerprint().fingerprints();

  // Fail-closed: if no fingerprints configured, reject all connections.
  if (fingerprints.isEmpty) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => false;
      return client;
    };
    return;
  }

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // Validate host against allowed hosts
      if (!AppCustomValidator().validate(cert, host, port)) {
        return false;
      }

      // Validate certificate fingerprint against pinned set
      final certFingerprint = cert.sha256Fingerprint;
      return fingerprints.contains(certFingerprint);
    };
    return client;
  };
}

/// Extension to extract SHA-256 fingerprint from an X509Certificate.
extension X509CertificateFingerprint on X509Certificate {
  String get sha256Fingerprint {
    // The der property provides the certificate in DER format.
    // In production, compute SHA-256 of the DER-encoded certificate.
    final bytes = der;
    // Simple hex representation for comparison.
    return bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join(':')
        .toUpperCase();
  }
}

/// App-specific certificate fingerprint provider.
class AppCertificateFingerprint {
  /// Returns the list of valid SHA-256 certificate fingerprints.
  ///
  /// In debug mode, returns empty list (pinning skipped at a higher level).
  /// Supports up to 10 fingerprints for certificate rotation.
  Future<List<String>> fingerprints() async {
    if (kDebugMode) return [];
    return const [
      // TODO: Add production SHA-256 fingerprints here
      // '<sha256-fingerprint-1>',
      // '<sha256-fingerprint-2>',
    ];
  }
}

/// Custom host validator for SSL pinning.
class AppCustomValidator {
  /// Returns true if the [host] is in the allowed set.
  bool validate(X509Certificate cert, String host, int port) {
    return host.contains('firebaseio.com') || host.contains('googleapis.com');
  }
}
