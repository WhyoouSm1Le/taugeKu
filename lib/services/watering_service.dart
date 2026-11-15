import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'rtdb_paths.dart';

/// Mengirim perintah penyiraman ke Wemos lewat **Realtime Database**.
///
/// Cara kerjanya (aplikasi TIDAK terhubung langsung ke Wemos):
///   1. Aplikasi menulis node `command` dengan status `pending`.
///   2. Wemos memantau node itu, melihat perintah baru, menyalakan pompa,
///      lalu mengubah status menjadi `done` (atau `failed`) dan mengisi `lastWatering`.
///   3. Aplikasi memantau status itu dan menampilkan hasilnya.
///
/// Node `command` hanya menyimpan perintah TERAKHIR (perintah baru menimpa yang lama).
class WateringService {
  /// Status akhir yang diterima: 'done', 'failed', atau 'timeout'.
  static const String statusDone = 'done';
  static const String statusFailed = 'failed';
  static const String statusTimeout = 'timeout';

  /// Menulis perintah siram. `ServerValue.timestamp` = jam server Firebase.
  Future<void> requestWatering({
    required String uid,
    required String deviceId,
    required int durationSeconds,
  }) {
    return RtdbPaths.command(uid, deviceId).set({
      'action': 'water',
      'durationSeconds': durationSeconds,
      'status': 'pending',
      'requestedAt': ServerValue.timestamp,
    });
  }

  /// Menunggu sampai Wemos mengubah status menjadi `done` atau `failed`.
  /// Jika melewati [timeout], status ditandai `timeout`.
  Future<String> waitForResult({
    required String uid,
    required String deviceId,
    required Duration timeout,
  }) async {
    final statusRef = RtdbPaths.command(uid, deviceId).child('status');

    try {
      return await statusRef.onValue
          .map((event) {
            final value = event.snapshot.value;
            return value is String ? value : 'pending';
          })
          .firstWhere((status) => status == statusDone || status == statusFailed)
          .timeout(timeout);
    } on TimeoutException {
      // Periksa sekali lagi: mungkin Wemos menjawab tepat di detik terakhir.
      final latest = (await statusRef.get()).value;
      if (latest == statusDone) return statusDone;
      if (latest == statusFailed) return statusFailed;

      await statusRef.set(statusTimeout);
      return statusTimeout;
    }
  }
}
