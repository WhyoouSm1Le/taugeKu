import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import '../services/demo_data_service.dart';

/// State untuk PROFIL pengguna (nama, email, foto).
///
/// * Nama, email, dan tanggal bergabung diambil dari akun Firebase Authentication.
/// * **Foto profil hanya disimpan SEMENTARA di memori.** Foto hilang saat pengguna
///   logout atau aplikasi ditutup. Tidak ada yang dikirim ke server.
class ProfileProvider extends ChangeNotifier {
  ProfileProvider({DemoDataService? demoDataService})
      : _demoDataService = demoDataService ?? DemoDataService();

  final DemoDataService _demoDataService;
  final ImagePicker _picker = ImagePicker();

  String? _uid;
  UserProfile? _profile;
  Uint8List? _photoBytes; // isi foto (hanya di memori)

  UserProfile? get profile => _profile;
  Uint8List? get photoBytes => _photoBytes;

  /// Nama depan untuk sapaan; "Pengguna" jika profil belum ada.
  String get firstName => _profile?.firstName ?? 'Pengguna';

  /// Inisial untuk avatar kecil di header.
  String get initials => _profile?.initials ?? '?';

  /// Dipanggil ProxyProvider (lihat lib/app.dart) setiap status login berubah.
  /// Jika yang login berganti (atau logout), foto sementara ikut dibuang.
  void syncWithAuth(User? user) {
    if (user?.uid != _uid) {
      _uid = user?.uid;
      _photoBytes = null;
    }
    _profile = user == null ? null : UserProfile.fromAuthUser(user);
  }

  /// Memilih foto dari galeri. Mengembalikan pesan error, atau null jika sukses / dibatalkan.
  Future<String?> pickPhoto() async {
    if (_uid == null) return 'Anda belum login.';

    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // perkecil agar hemat memori
        imageQuality: 80,
      );
      if (picked == null) return null; // pengguna membatalkan

      _photoBytes = await picked.readAsBytes();
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Gagal memilih foto: $e');
      return 'Gagal memilih foto. Coba lagi.';
    }
  }

  /// Mengisi data contoh ke database (hanya untuk mode debug).
  Future<String?> seedDemoData() async {
    final uid = _uid;
    if (uid == null) return 'Anda belum login.';
    try {
      await _demoDataService.seed(uid);
      return null;
    } catch (e) {
      debugPrint('Gagal mengisi data contoh: $e');
      return 'Gagal mengisi data contoh. Periksa aturan database.';
    }
  }
}
