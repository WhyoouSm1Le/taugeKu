import 'package:firebase_database/firebase_database.dart';

/// Alamat (path) di **Firebase Realtime Database** (RTDB).
///
/// RTDB menyimpan data seperti satu pohon JSON besar. Struktur TaugeKu:
///
/// ```
/// users/{uid}/
///   devices/{deviceId}/
///     config/           -> konfigurasi: name, location, wateringSeconds, autoWateringTimes
///     sensor/           -> sensor realtime: temperature, humidity, light, updatedAt, isOnline
///     command/          -> perintah pompa: action, durationSeconds, status, requestedAt
///     lastWatering/     -> waktu siram terakhir: at, durationSeconds, source
///   activities/{pushId}   -> daftar "Aktivitas"
///   notifications/{pushId}-> isi popover lonceng
/// ```
///
/// Semua waktu disimpan sebagai angka milidetik sejak 1 Jan 1970 (epoch ms).
class RtdbPaths {
  RtdbPaths._();

  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  static DatabaseReference user(String uid) => _db.ref('users/$uid');

  static DatabaseReference devices(String uid) => user(uid).child('devices');

  static DatabaseReference device(String uid, String deviceId) =>
      devices(uid).child(deviceId);

  static DatabaseReference command(String uid, String deviceId) =>
      device(uid, deviceId).child('command');

  static DatabaseReference activities(String uid) => user(uid).child('activities');

  static DatabaseReference notifications(String uid) =>
      user(uid).child('notifications');

  /// Node khusus bawaan Firebase: bernilai true bila aplikasi tersambung ke RTDB.
  static DatabaseReference connectionState() => _db.ref('.info/connected');
}
