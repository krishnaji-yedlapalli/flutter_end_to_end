// ─────────────────────────────────────────────────────────────────────────────
// Pinned values — Firebase
// ─────────────────────────────────────────────────────────────────────────────

/// Certificate fingerprints for Firebase Realtime Database.
/// Host   : *.us-central1.firebasedatabase.app
/// Issuer : Google Trust Services WR1
/// Format : colon-separated uppercase hex — e.g. 'A1:02:E7:B5:...'
/// Last verified: 2026-07-26
const List<String> firebaseCertFingerprints = [
  '57:61:A9:78:99:5B:58:9C:07:0E:A7:35:6D:F2:15:61:04:30:65:64:DE:95:DE:58:1C:6C:D1:BC:97:92:93:61',
  'B1:0B:6F:00:E6:09:50:9E:87:00:F6:D3:46:87:A2:BF:CE:38:EA:05:A8:FD:F1:CD:C4:0C:3A:2A:0D:0D:0E:45',
];

/// SPKI hashes for Firebase Realtime Database.
/// Format : base64-encoded SHA-256 of SubjectPublicKeyInfo DER
/// Last verified: 2026-07-26
const List<String> firebaseSpkiHashes = [
  'fTYPg6HQBmTeILOghnjsRj1QxZ4gjqvapgKZv0NFgb4=', // leaf
  'yDu9og255NN5GEf+Bwa9rTrqFQ0EydZ0r1FCh9TdAW4=', // intermediate (rotation backup)
];

// ─────────────────────────────────────────────────────────────────────────────
// Pinned values — Azure
// ─────────────────────────────────────────────────────────────────────────────

/// Certificate fingerprints for the Azure App Service (.NET API).
/// Host    : flutter-end-to-end-hjgph8asb4bsajgn.canadaeast-01.azurewebsites.net
/// Issuer  : Microsoft TLS G2 RSA CA OCSP 16
/// Expires : Jan 10, 2027 (leaf) — refresh by mid-Dec 2026
/// Format  : colon-separated uppercase hex — e.g. 'A1:02:E7:B5:...'
/// Last verified: 2026-07-26
const List<String> azureCertFingerprints = [
  'A1:02:E7:B5:A6:FD:00:97:AD:14:FC:6C:7D:87:69:D5:98:11:44:D6:3B:14:72:88:82:73:26:F2:37:35:FB:C7',
];

/// SPKI hashes for the Azure App Service (.NET API).
/// Format : base64-encoded SHA-256 of SubjectPublicKeyInfo DER
/// Last verified: 2026-07-26
const List<String> azureSpkiHashes = [
  'B1prTVOVbmcbxoD4/QfLVGi+aZQazEtJce55jU0WbH8=', // leaf
  'k8hnGa94Ch68AfKVLqnpxVyUQg+KzClS6foKRac9HI8=', // intermediate (rotation backup)
];
