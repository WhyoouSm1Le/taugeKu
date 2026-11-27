import 'package:firebase_auth/firebase_auth.dart';

/// Bicara dengan **Firebase Authentication**.
///
/// Aturan penting pada file-file `service`:
/// hanya berisi kode Firebase. Tidak ada kode tampilan (UI) di sini.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Domain yang ditambahkan jika pengguna mengetik username saja.
  /// Contoh: "admin" -> "admin@taugeku.id".
  static const String usernameDomain = 'taugeku.id';

  /// Aliran (stream) yang memberi tahu setiap kali status login berubah.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Firebase Auth memakai email. Desain aplikasi memakai "Username",
  /// jadi kita ubah username menjadi email: "admin" -> "admin@taugeku.id".
  /// Jika pengguna sudah mengetik email lengkap, dipakai apa adanya.
  static String usernameToEmail(String input) {
    final text = input.trim().toLowerCase();
    return text.contains('@') ? text : '$text@$usernameDomain';
  }

  Future<void> signIn({required String username, required String password}) async {
    await _auth.signInWithEmailAndPassword(
      email: usernameToEmail(username),
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();
}
