import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/sensor_reading.dart';
import 'firestore_paths.dart';

/// Membaca riwayat data sensor dari **Cloud Firestore**.
/// (Data ini DITULIS oleh Wemos, aplikasi hanya membaca.)
class SensorService {
  /// Mengikuti data sensor sejak waktu [since], terbaru lebih dulu.
  /// [limit] membatasi jumlah dokumen agar hemat kuota baca Firestore.
  Stream<List<SensorReading>> watchReadings({
    required String uid,
    required String deviceId,
    required DateTime since,
    required int limit,
  }) {
    return FirestorePaths.readings(uid, deviceId)
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(SensorReading.fromFirestore).toList());
  }
}
