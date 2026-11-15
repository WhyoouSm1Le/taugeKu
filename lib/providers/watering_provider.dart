import 'package:flutter/foundation.dart';

import '../core/app_constants.dart';
import '../services/watering_service.dart';

/// Hasil dari satu kali penyiraman, dipakai layar untuk memilih pesan toast.
enum WateringResult { success, failed, timeout, deviceOffline, noConnection, notReady }

/// State untuk TOMBOL "SIRAM" di Beranda.
class WateringProvider extends ChangeNotifier {
  WateringProvider({WateringService? service}) : _service = service ?? WateringService();

  final WateringService _service;

  String? _userId;
  String? _deviceId;
  bool _deviceOnline = false;
  bool _isConnected = false;
  int _durationSeconds = AppConstants.wateringSeconds;
  bool _isWatering = false;

  /// true = sedang menunggu pompa selesai (tombol dikunci).
  bool get isWatering => _isWatering;

  /// Diatur otomatis oleh ProxyProvider (lihat lib/app.dart).
  void setTarget({
    required String? userId,
    required String? deviceId,
    required bool deviceOnline,
    required bool isConnected,
    required int durationSeconds,
  }) {
    // Hanya menyimpan nilai; tidak perlu memberi tahu layar.
    _userId = userId;
    _deviceId = deviceId;
    _deviceOnline = deviceOnline;
    _isConnected = isConnected;
    _durationSeconds = durationSeconds;
  }

  /// Menyalakan pompa selama `config/wateringSeconds` milik perangkat.
  Future<WateringResult> startWatering() async {
    final uid = _userId;
    final deviceId = _deviceId;
    if (_isWatering) return WateringResult.notReady;
    if (uid == null || deviceId == null) return WateringResult.notReady;
    if (!_deviceOnline) return WateringResult.deviceOffline;

    // PENTING: jika aplikasi offline, perintah akan DIANTREKAN lalu terkirim
    // belakangan -> pompa menyala tiba-tiba. Karena itu kita tolak lebih awal.
    if (!_isConnected) return WateringResult.noConnection;

    _isWatering = true;
    notifyListeners();

    try {
      await _service.requestWatering(
        uid: uid,
        deviceId: deviceId,
        durationSeconds: _durationSeconds,
      );
      final status = await _service.waitForResult(
        uid: uid,
        deviceId: deviceId,
        timeout: const Duration(seconds: AppConstants.wateringTimeoutSeconds),
      );

      switch (status) {
        case WateringService.statusDone:
          return WateringResult.success;
        case WateringService.statusTimeout:
          return WateringResult.timeout;
        default:
          return WateringResult.failed;
      }
    } catch (e) {
      debugPrint('Penyiraman gagal: $e');
      return WateringResult.failed;
    } finally {
      // `finally` selalu dijalankan, apa pun hasilnya.
      _isWatering = false;
      notifyListeners();
    }
  }
}
