import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/device_model.dart';
import '../services/device_service.dart';
import 'user_scoped_provider.dart';

/// State untuk DAFTAR PERANGKAT (Beranda, Monitor, dan halaman Perangkat).
///
/// Data berasal dari Realtime Database, jadi suhu/kelembapan/cahaya di
/// objek perangkat ikut berubah secara realtime.
class DeviceProvider extends UserScopedProvider {
  DeviceProvider({DeviceService? service}) : _service = service ?? DeviceService();

  final DeviceService _service;
  StreamSubscription<List<DeviceModel>>? _subscription;
  StreamSubscription<bool>? _connectionSubscription;

  List<DeviceModel> _devices = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool? _isConnected; // null = belum diketahui

  // ---- Data yang boleh dibaca layar ----
  List<DeviceModel> get devices => List.unmodifiable(_devices);
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  /// Status sambungan ke Realtime Database (null = masih memeriksa).
  bool? get isConnected => _isConnected;
  int get onlineCount => _devices.where((d) => d.isOnline).length;
  int get offlineCount => _devices.length - onlineCount;

  /// Perangkat utama yang ditampilkan di Beranda & Monitor:
  /// perangkat online pertama, atau perangkat pertama jika semuanya offline.
  DeviceModel? get selectedDevice {
    if (_devices.isEmpty) return null;
    for (final device in _devices) {
      if (device.isOnline) return device;
    }
    return _devices.first;
  }

  @override
  void onUserChanged(String? newUserId) {
    _subscription?.cancel();
    _subscription = null;
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _devices = [];
    _hasError = false;
    _isConnected = null;
    _isLoading = newUserId != null;
    if (newUserId == null) return;

    // Pantau status sambungan (untuk label "Firebase • Online" dan tombol Siram).
    _connectionSubscription = _service.watchConnection().listen(
      (connected) {
        _isConnected = connected;
        notifyListeners();
      },
      onError: (Object error) => debugPrint('Gagal membaca status koneksi: $error'),
    );

    // Setiap kali data perangkat di Realtime Database berubah, blok ini dipanggil.
    _subscription = _service.watchDevices(newUserId).listen(
      (list) {
        _devices = list;
        _isLoading = false;
        _hasError = false;
        notifyListeners();
      },
      onError: (Object error) {
        debugPrint('Gagal membaca perangkat: $error');
        _hasError = true;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Menambah perangkat. Mengembalikan pesan error, atau null jika sukses.
  Future<String?> addDevice(DeviceModel device) async {
    final uid = userId;
    if (uid == null) return 'Anda belum login.';
    try {
      await _service.addDevice(uid, device);
      return null;
    } on DeviceAlreadyExistsException {
      return 'ID ${device.id} sudah dipakai. Gunakan ID lain.';
    } catch (e) {
      debugPrint('Gagal menambah perangkat: $e');
      return 'Gagal menambah perangkat. Periksa koneksi internet.';
    }
  }

  /// Mengubah perangkat. Mengembalikan pesan error, atau null jika sukses.
  Future<String?> updateDevice(DeviceModel device) async {
    final uid = userId;
    if (uid == null) return 'Anda belum login.';
    try {
      await _service.updateDevice(uid, device);
      return null;
    } catch (e) {
      debugPrint('Gagal mengubah perangkat: $e');
      return 'Gagal menyimpan perubahan. Periksa koneksi internet.';
    }
  }

  /// Menghapus perangkat. Mengembalikan pesan error, atau null jika sukses.
  Future<String?> deleteDevice(String deviceId) async {
    final uid = userId;
    if (uid == null) return 'Anda belum login.';
    try {
      await _service.deleteDevice(uid, deviceId);
      return null;
    } catch (e) {
      debugPrint('Gagal menghapus perangkat: $e');
      return 'Gagal menghapus perangkat. Periksa koneksi internet.';
    }
  }

  /// Tombol refresh: paksa baca dari server. Mengembalikan true jika berhasil.
  Future<bool> refresh() async {
    final uid = userId;
    if (uid == null) return false;
    try {
      await _service.refreshFromServer(uid);
      return true;
    } catch (e) {
      debugPrint('Refresh gagal: $e');
      return false;
    }
  }

  /// Membuat ID perangkat berikutnya, contoh "WMS-003".
  String nextDeviceId() {
    var number = _devices.length + 1;
    String candidate;
    do {
      candidate = 'WMS-${number.toString().padLeft(3, '0')}';
      number++;
    } while (_devices.any((d) => d.id == candidate));
    return candidate;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
