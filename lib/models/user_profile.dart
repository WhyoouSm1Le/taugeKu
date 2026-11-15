import 'package:firebase_auth/firebase_auth.dart';

/// Profil pengguna, diambil LANGSUNG dari akun Firebase Authentication.
///
/// Tidak ada database khusus untuk profil, jadi tidak ada yang perlu disimpan
/// di Firestore/RTDB. Foto profil juga tidak disimpan (hanya sementara di
/// memori; lihat ProfileProvider).
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.createdAt,
  });

  final String uid;
  final String displayName; // contoh "Admin"
  final String email; // contoh "admin@taugeku.id"
  final DateTime? createdAt; // kapan akun dibuat ("Bergabung")

  /// Inisial untuk avatar, contoh "Admin TaugeKu" -> "AT".
  String get initials {
    final parts = _words(displayName);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  /// Nama depan untuk sapaan, contoh "Halo, Admin".
  String get firstName {
    final parts = _words(displayName);
    return parts.isEmpty ? 'Pengguna' : parts.first;
  }

  /// Membuat profil dari akun yang sedang login.
  factory UserProfile.fromAuthUser(User user) {
    final email = user.email ?? '';
    final name = user.displayName;
    return UserProfile(
      uid: user.uid,
      displayName: (name != null && name.trim().isNotEmpty) ? name : _nameFromEmail(email),
      email: email,
      createdAt: user.metadata.creationTime,
    );
  }

  static List<String> _words(String text) =>
      text.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();

  /// "admin@taugeku.id" -> "Admin"
  static String _nameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return 'Pengguna';
    return local[0].toUpperCase() + local.substring(1);
  }
}
