import 'package:cloud_firestore/cloud_firestore.dart';

/// Alamat (path) koleksi **Cloud Firestore**.
///
/// Firestore di TaugeKu hanya dipakai untuk dua hal:
///
/// ```
/// users/{uid}/batches/{batchId}                  -> dokumentasi tiap penanaman
/// users/{uid}/devices/{deviceId}/readings/{id}   -> rekaman sensor terjadwal (grafik historis)
/// ```
///
/// (Data realtime, konfigurasi, dan perintah ada di Realtime Database:
/// lihat `rtdb_paths.dart`.)
///
/// Catatan: dokumen `devices/{deviceId}` di Firestore TIDAK perlu dibuat.
/// Firestore mengizinkan sub-koleksi di bawah dokumen yang "belum ada".
class FirestorePaths {
  FirestorePaths._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> user(String uid) =>
      _db.collection('users').doc(uid);

  static CollectionReference<Map<String, dynamic>> batches(String uid) =>
      user(uid).collection('batches');

  static CollectionReference<Map<String, dynamic>> readings(
    String uid,
    String deviceId,
  ) =>
      user(uid).collection('devices').doc(deviceId).collection('readings');
}
