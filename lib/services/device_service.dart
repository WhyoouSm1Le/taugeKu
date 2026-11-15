import 'dart:async';

import '../core/rtdb_utils.dart';
import '../models/device_model.dart';
import 'rtdb_paths.dart';

/// Dilempar ketika pengguna menambah perangkat dengan ID yang sudah dipakai.
class DeviceAlreadyExistsException implements Exception {
  DeviceAlreadyExistsException(this.deviceId);
  final String deviceId;

  @override
  String toString() => 'Perangkat dengan ID $deviceId sudah ada.';
}

/// CRUD perangkat di **Realtime Database**: `users/{uid}/devices`.
/// (CRUD = Create, Read, Update, Delete)
///
/// Karena satu node perangkat berisi config + sensor + lastWatering,
/// membaca daftar perangkat sekaligus memberi data sensor realtime.
class DeviceService {
  /// READ (realtime): daftar perangkat, diurutkan berdasarkan ID.
  /// Dipanggil ulang otomatis setiap kali ada data yang berubah (mis. suhu baru).
  Stream<List<DeviceModel>> watchDevices(String uid) {
    return RtdbPaths.devices(uid).onValue.map((event) {
      final all = asStringMap(event.snapshot.value);
      final list = [
        for (final entry in all.entries)
          DeviceModel.fromRtdb(entry.key, asStringMap(entry.value)),
      ];
      list.sort((a, b) => a.id.compareTo(b.id));
      return list;
    });
  }

  /// Status sambungan aplikasi ke RTDB (true = tersambung).
  Stream<bool> watchConnection() {
    return RtdbPaths.connectionState().onValue.map((event) => event.snapshot.value == true);
  }

  /// CREATE: menambah perangkat baru. ID perangkat menjadi nama node.
  Future<void> addDevice(String uid, DeviceModel device) async {
    final ref = RtdbPaths.device(uid, device.id);

    // Cegah ID kembar supaya data lama tidak tertimpa.
    final existing = await ref.get();
    if (existing.exists) throw DeviceAlreadyExistsException(device.id);

    await ref.set(device.toNewDeviceMap());
  }

  /// UPDATE: mengubah nama, lokasi, dan status. Field lain tidak tersentuh.
  Future<void> updateDevice(String uid, DeviceModel device) {
    return RtdbPaths.device(uid, device.id).update(device.toUpdateMap());
  }

  /// DELETE: menghapus perangkat beserta config, sensor, dan command-nya.
  /// Catatan: rekaman historis di Firestore (`readings`) TIDAK ikut terhapus.
  /// Lihat docs/03-FIREBASE-DAN-DATABASE.md bagian "Menghapus perangkat".
  Future<void> deleteDevice(String uid, String deviceId) {
    return RtdbPaths.device(uid, deviceId).remove();
  }

  /// Memaksa membaca data dari SERVER. Dipakai tombol refresh.
  /// Melempar error bila tidak ada koneksi (batas tunggu 10 detik).
  Future<void> refreshFromServer(String uid) async {
    await RtdbPaths.devices(uid).get().timeout(const Duration(seconds: 10));
  }
}
