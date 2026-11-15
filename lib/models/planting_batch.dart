import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_constants.dart';

/// Satu siklus tanam tauge (disebut "batch").
///
/// Tersimpan di: `users/{uid}/batches/{id}`
class PlantingBatch {
  const PlantingBatch({
    required this.id,
    required this.code,
    required this.name,
    required this.startDate,
    required this.isActive,
    this.endDate,
    this.wateringCount = 0,
    this.sensorCount = 0,
    this.avgTemperature,
    this.avgHumidity,
    this.cycleDays = AppConstants.defaultCycleDays,
  });

  final String id;

  /// Kode tampilan, contoh "TANAM-008".
  final String code;

  /// Nama batch, contoh "Tauge Batch 01".
  final String name;

  final DateTime startDate;
  final DateTime? endDate; // null jika masih berjalan
  final bool isActive;

  final int wateringCount; // berapa kali disiram
  final int sensorCount; // berapa data sensor terkumpul
  final double? avgTemperature; // rata-rata suhu (batch selesai)
  final double? avgHumidity; // rata-rata kelembapan (batch selesai)

  /// Total hari dalam satu siklus (default 4 hari).
  final int cycleDays;

  /// Hari ke berapa sekarang (1 .. cycleDays).
  int get currentDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final day = today.difference(start).inDays + 1;
    return day.clamp(1, cycleDays).toInt();
  }

  /// Progres 0.0 - 1.0 (contoh hari ke-3 dari 4 = 0.75).
  double get progress => currentDay / cycleDays;

  /// Teks perkiraan panen.
  String get harvestText {
    final remaining = cycleDays - currentDay;
    if (remaining <= 0) return 'Siap panen';
    if (remaining == 1) return 'Panen besok';
    return 'Panen $remaining hari lagi';
  }

  factory PlantingBatch.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return PlantingBatch(
      id: doc.id,
      code: data['code'] as String? ?? doc.id,
      name: data['name'] as String? ?? 'Tanpa nama',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] as bool? ?? false,
      wateringCount: (data['wateringCount'] as num?)?.toInt() ?? 0,
      sensorCount: (data['sensorCount'] as num?)?.toInt() ?? 0,
      avgTemperature: (data['avgTemperature'] as num?)?.toDouble(),
      avgHumidity: (data['avgHumidity'] as num?)?.toDouble(),
      cycleDays: (data['cycleDays'] as num?)?.toInt() ?? AppConstants.defaultCycleDays,
    );
  }
}
