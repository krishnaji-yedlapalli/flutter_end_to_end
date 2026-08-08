import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Certificate Pinning  (http_certificate_pinning package — Android/iOS only)
// ─────────────────────────────────────────────────────────────────────────────
/// Each Dio instance must have its own interceptor with fingerprints for its
/// specific host. Never share one interceptor across clients for different hosts.
///
/// To regenerate fingerprints:
/// openssl x509 -in certificate.pem -noout -fingerprint -sha256
CertificatePinningInterceptor? buildCertPinningInterceptor(
    List<String> fingerprints) {
  if (kIsWeb) return null;
  return CertificatePinningInterceptor(
    allowedSHAFingerprints: fingerprints,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Public Key Pinning / SPKI  (works on Android, iOS, macOS, desktop)
// ─────────────────────────────────────────────────────────────────────────────

/// Applies SPKI (public key) pinning to [dio] for the given [spkiHashes].
///
/// Unlike certificate pinning, SPKI hashes survive cert renewal as long as
/// the server reuses the same key pair — making them more rotation-friendly.
///
/// Works on all non-web platforms via [IOHttpClientAdapter].
/// On web this is a no-op — browser handles TLS.
///
/// To regenerate SPKI hashes:
///   echo | openssl s_client -connect <host>:443 -showcerts 2>/dev/null \
///     | awk 'BEGIN{n=0} /-----BEGIN CERTIFICATE-----/{n++; cert=""} \
///            {cert=cert $0 "\n"} /-----END CERTIFICATE-----/{if(n==1) print cert}' \
///     | openssl x509 -pubkey -noout \
///     | openssl pkey -pubin -outform der \
///     | openssl dgst -sha256 -binary \
///     | openssl enc -base64
///
/// Format: base64-encoded SHA-256 of the DER-encoded SubjectPublicKeyInfo.
void applySpkiPinning(Dio dio, List<String> spkiHashes) {
  if (kIsWeb) return;

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client =
        HttpClient(/*context: SecurityContext(withTrustedRoots: false)*/);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      final publicKeyHash = _computeSpkiHash(cert);
      return spkiHashes.contains(publicKeyHash);
    };
    return client;
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// SPKI helpers (internal)
// ─────────────────────────────────────────────────────────────────────────────

/// Computes SHA-256 of the certificate's SubjectPublicKeyInfo (SPKI) in base64.
String _computeSpkiHash(X509Certificate cert) {
  final derBytes = cert.der;
  final spkiBytes = _extractSpkiFromDer(derBytes);
  if (spkiBytes == null) return '';
  final digest = sha256.convert(spkiBytes);
  return base64Encode(digest.bytes);
}

/// Extracts SubjectPublicKeyInfo bytes from a DER-encoded X.509 certificate.
///
/// DER layout (simplified):
///   SEQUENCE (cert)
///     SEQUENCE (tbsCertificate)
///       [0] version
///       INTEGER serialNumber
///       SEQUENCE signatureAlgorithm
///       SEQUENCE issuer
///       SEQUENCE validity
///       SEQUENCE subject
///       SEQUENCE subjectPublicKeyInfo  ← we want this
///     ...
List<int>? _extractSpkiFromDer(List<int> der) {
  try {
    int pos = 0;

    // Skip outer SEQUENCE tag + length (certificate wrapper)
    if (der[pos++] != 0x30) return null;
    pos += _skipDerLength(der, pos);

    // Enter tbsCertificate SEQUENCE
    if (der[pos++] != 0x30) return null;
    pos += _skipDerLength(der, pos);

    // Skip version [0] EXPLICIT if present
    if (der[pos] == 0xA0) {
      pos++;
      final len = _readDerLength(der, pos);
      pos += _derLengthBytes(der, pos) + len;
    }

    // Skip serialNumber INTEGER
    pos += _skipTlv(der, pos);
    // Skip signature SEQUENCE
    pos += _skipTlv(der, pos);
    // Skip issuer SEQUENCE
    pos += _skipTlv(der, pos);
    // Skip validity SEQUENCE
    pos += _skipTlv(der, pos);
    // Skip subject SEQUENCE
    pos += _skipTlv(der, pos);

    // Now at subjectPublicKeyInfo SEQUENCE — capture tag + length + value
    final spkiStart = pos;
    pos += _skipTlv(der, pos);
    return der.sublist(spkiStart, pos);
  } catch (_) {
    return null;
  }
}

int _readDerLength(List<int> der, int pos) {
  if (der[pos] & 0x80 == 0) return der[pos];
  final numBytes = der[pos] & 0x7F;
  int len = 0;
  for (int i = 1; i <= numBytes; i++) {
    len = (len << 8) | der[pos + i];
  }
  return len;
}

int _derLengthBytes(List<int> der, int pos) {
  if (der[pos] & 0x80 == 0) return 1;
  return 1 + (der[pos] & 0x7F);
}

/// Returns total bytes consumed by a TLV (tag + length + value).
int _skipTlv(List<int> der, int pos) {
  const tagByte = 1;
  final lenBytes = _derLengthBytes(der, pos + tagByte);
  final valueLen = _readDerLength(der, pos + tagByte);
  return tagByte + lenBytes + valueLen;
}

/// Returns bytes consumed by just the length field (not including value).
int _skipDerLength(List<int> der, int pos) {
  return _derLengthBytes(der, pos);
}
