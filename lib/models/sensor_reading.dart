import 'package:cloud_firestore/cloud_firestore.dart';

/// Jenis data sensor yang bisa ditampilkan di grafik.
enum SensorMetric { temperature, humidity, light }

/// Satu catatan pembacaan sensor pada satu waktu.
///
/// Tersimpan di: `users/{uid}/devices/{deviceId}/readings/{autoId}`
class SensorReading {
  const SensorReading({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.createdAt,
  });

  final String id;
  final double temperature; // °C
  final double humidity; // %
  final double light; // %
  final DateTime createdAt;

  /// Mengambil nilai sesuai jenis sensor. Memudahkan grafik memilih data.
  double valueOf(SensorMetric metric) {
    switch (metric) {
      case SensorMetric.temperature:
        return temperature;
      case SensorMetric.humidity:
        return humidity;
      case SensorMetric.light:
        return light;
    }
  }

  factory SensorReading.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return SensorReading(
      id: doc.id,
      temperature: (data['temperature'] as num?)?.toDouble() ?? 0,
      humidity: (data['humidity'] as num?)?.toDouble() ?? 0,
      light: (data['light'] as num?)?.toDouble() ?? 0,
      // createdAt bisa null sesaat setelah data ditulis (menunggu jam server).
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
