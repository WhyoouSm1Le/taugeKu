import 'package:flutter/foundation.dart';

/// Kelas dasar untuk provider yang datanya MILIK SATU PENGGUNA.
///
/// Hampir semua data di TaugeKu (perangkat, batch, aktivitas, dst.) tersimpan
/// di bawah `users/{uid}`. Artinya provider harus tahu siapa yang sedang login.
///
/// Alurnya:
///   * Saat pengguna login   -> [setUser] dipanggil dengan uid -> mulai mendengarkan Firestore.
///   * Saat pengguna logout  -> [setUser] dipanggil dengan null -> berhenti & kosongkan data.
///
/// Provider turunan cukup mengisi fungsi [onUserChanged].
abstract class UserScopedProvider extends ChangeNotifier {
  String? _userId;

  /// ID pengguna yang sedang login (null jika belum login).
  String? get userId => _userId;

  /// Dipanggil oleh ProxyProvider (lihat lib/app.dart).
  /// Jika uid sama dengan sebelumnya, tidak ada yang dilakukan.
  void setUser(String? newUserId) {
    if (newUserId == _userId) return;
    _userId = newUserId;
    onUserChanged(newUserId);
  }

  /// Isi fungsi ini: batalkan langganan lama, kosongkan data, lalu
  /// (jika [newUserId] tidak null) mulai langganan baru.
  ///
  /// PENTING: jangan memanggil `notifyListeners()` secara langsung di sini,
  /// karena fungsi ini bisa berjalan saat layar sedang digambar.
  /// Cukup panggil `notifyListeners()` di dalam callback stream (asinkron).
  @protected
  void onUserChanged(String? newUserId);
}
