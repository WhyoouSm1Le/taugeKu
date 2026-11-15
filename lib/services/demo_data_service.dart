import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_paths.dart';
import 'rtdb_paths.dart';

/// Mengisi database dengan DATA CONTOH agar aplikasi bisa dicoba
/// tanpa perangkat Wemos. Hanya muncul di mode debug (lihat ProfileScreen).
///
/// Data contoh sama dengan desain web:
///  * Realtime Database : 2 perangkat (config, sensor, siram terakhir), 3 aktivitas, 2 notifikasi
///  * Cloud Firestore   : 3 batch tanam + 6 rekaman sensor untuk grafik
class DemoDataService {
  Future<void> seed(String uid) async {
    final now = DateTime.now();
    int ms(DateTime d) => d.millisecondsSinceEpoch;

    // ================== 1) Realtime Database ==================
    final root = RtdbPaths.user(uid);

    // Kunci "push id" dibuat berurutan dari yang PALING LAMA agar urutannya benar.
    final activityOld = root.child('activities').push().key!;
    final activityMid = root.child('activities').push().key!;
    final activityNew = root.child('activities').push().key!;
    final notifOld = root.child('notifications').push().key!;
    final notifNew = root.child('notifications').push().key!;

    await root.update(<String, Object?>{
      'devices/WMS-001': {
        'config': {
          'name': 'Tauge Utama',
          'location': 'Rak A · Dapur',
          'wateringSeconds': 10,
          'autoWateringTimes': '06:30,18:30',
        },
        'sensor': {
          'temperature': 29.8,
          'humidity': 78,
          'light': 24,
          'isOnline': true,
          'updatedAt': ms(now.subtract(const Duration(minutes: 1))),
        },
        'lastWatering': {
          'at': ms(now.subtract(const Duration(minutes: 12))),
          'durationSeconds': 10,
          'source': 'auto',
        },
      },
      'devices/WMS-002': {
        'config': {
          'name': 'Tauge Batch 02',
          'location': 'Rak B · Dapur',
          'wateringSeconds': 10,
          'autoWateringTimes': '06:30,18:30',
        },
        'sensor': {
          'isOnline': false,
          'updatedAt': ms(now.subtract(const Duration(hours: 2))),
        },
      },
      'activities/$activityOld': {
        'title': 'Cahaya stabil',
        'subtitle': '24%',
        'type': 'light',
        'at': ms(now.subtract(const Duration(hours: 2))),
      },
      'activities/$activityMid': {
        'title': 'Sensor tersimpan',
        'subtitle': 'Firestore',
        'type': 'saved',
        'at': ms(now.subtract(const Duration(minutes: 17))),
      },
      'activities/$activityNew': {
        'title': 'Penyiraman otomatis',
        'subtitle': '10 detik',
        'type': 'watering',
        'at': ms(now.subtract(const Duration(minutes: 12))),
      },
      'notifications/$notifOld': {
        'title': 'Cahaya sempat meningkat',
        'message': 'Kembali stabil',
        'type': 'warning',
        'isRead': false,
        'at': ms(now.subtract(const Duration(hours: 2))),
      },
      'notifications/$notifNew': {
        'title': 'Penyiraman selesai',
        'message': 'Batch 01 · 10 detik',
        'type': 'info',
        'isRead': false,
        'at': ms(now.subtract(const Duration(minutes: 12))),
      },
    });

    // ================== 2) Cloud Firestore ==================
    final db = FirebaseFirestore.instance;
    final batch = db.batch(); // satu permintaan untuk semua penulisan
    Timestamp ts(DateTime d) => Timestamp.fromDate(d);

    // ---- Rekaman sensor WMS-001 (6 titik, tiap 2 jam ke belakang) ----
    const temps = [29.2, 29.7, 30.4, 30.1, 29.8, 29.6];
    const hums = [76, 74, 71, 73, 75, 78];
    const lights = [18, 22, 31, 28, 26, 24];
    for (var i = 0; i < 6; i++) {
      final time = now.subtract(Duration(hours: (5 - i) * 2));
      // Agar muncul pada filter "Hari ini", batasi ke hari ini.
      final safeTime = time.isBefore(DateTime(now.year, now.month, now.day))
          ? DateTime(now.year, now.month, now.day, 0, i + 1)
          : time;
      batch.set(FirestorePaths.readings(uid, 'WMS-001').doc(), {
        'temperature': temps[i],
        'humidity': hums[i],
        'light': lights[i],
        'createdAt': ts(safeTime),
      });
    }

    // ---- Dokumentasi penanaman (batch) ----
    batch.set(FirestorePaths.batches(uid).doc('TANAM-008'), {
      'code': 'TANAM-008',
      'name': 'Tauge Batch 01',
      'startDate': ts(now.subtract(const Duration(days: 2))),
      'isActive': true,
      'cycleDays': 4,
      'wateringCount': 6,
      'sensorCount': 842,
    });
    batch.set(FirestorePaths.batches(uid).doc('TANAM-007'), {
      'code': 'TANAM-007',
      'name': 'Batch Percobaan 07',
      'startDate': ts(now.subtract(const Duration(days: 9))),
      'endDate': ts(now.subtract(const Duration(days: 9)).add(const Duration(days: 3, hours: 14))),
      'isActive': false,
      'cycleDays': 4,
      'wateringCount': 7,
      'sensorCount': 1021,
      'avgTemperature': 29.7,
      'avgHumidity': 76,
    });
    batch.set(FirestorePaths.batches(uid).doc('TANAM-006'), {
      'code': 'TANAM-006',
      'name': 'Batch Percobaan 06',
      'startDate': ts(now.subtract(const Duration(days: 16))),
      'endDate': ts(now.subtract(const Duration(days: 16)).add(const Duration(days: 2, hours: 13))),
      'isActive': false,
      'cycleDays': 4,
      'wateringCount': 5,
      'sensorCount': 730,
      'avgTemperature': 30.2,
      'avgHumidity': 72,
    });

    await batch.commit();
  }
}
