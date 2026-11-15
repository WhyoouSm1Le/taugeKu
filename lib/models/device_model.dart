import '../core/app_constants.dart';
import '../core/rtdb_utils.dart';

/// Satu perangkat Wemos D1 Mini.
///
/// Tersimpan di **Realtime Database** pada `users/{uid}/devices/{id}`:
///
/// ```
/// devices/{id}/config        -> name, location, wateringSeconds, autoWateringTimes
/// devices/{id}/sensor        -> temperature, humidity, light, updatedAt, isOnline
/// devices/{id}/lastWatering  -> at, durationSeconds, source
/// devices/{id}/command       -> perintah pompa (lihat WateringService)
/// ```
///
/// "Model" hanyalah wadah data. Tugasnya:
///   1. Menyimpan data perangkat dalam bentuk objek Dart yang rapi.
///   2. Mengubah data RTDB (Map) menjadi objek  -> [DeviceModel.fromRtdb]
///   3. Mengubah objek menjadi Map untuk disimpan -> [toNewDeviceMap], [toUpdateMap]
class DeviceModel {
  const DeviceModel({
    required this.id,
    required this.name,
    required this.location,
    required this.isOnline,
    this.temperature,
    this.humidity,
    this.light,
    this.lastSeen,
    this.lastWatering,
    this.wateringSeconds = AppConstants.wateringSeconds,
    this.autoWateringTimes = AppConstants.defaultAutoWateringTimes,
  });

  /// ID perangkat, contoh "WMS-001". Sekaligus menjadi nama node di RTDB.
  final String id;

  // ---- Dari node `config` ----
  final String name; // contoh "Tauge Utama"
  final String location; // contoh "Rak A · Dapur"
  final int wateringSeconds; // lama pompa menyala (detik)
  final String autoWateringTimes; // jadwal siram, contoh "06:30,18:30"

  // ---- Dari node `sensor` (diisi oleh Wemos) ----
  final bool isOnline; // true = perangkat aktif / terhubung
  final double? temperature; // derajat Celsius
  final double? humidity; // persen
  final double? light; // persen
  final DateTime? lastSeen; // kapan Wemos terakhir mengirim data

  // ---- Dari node `lastWatering` (diisi oleh Wemos) ----
  final DateTime? lastWatering; // kapan penyiraman terakhir

  // ---- Teks siap tampil di layar ----
  String get temperatureText =>
      (isOnline && temperature != null) ? '${temperature!.toStringAsFixed(1)}°C' : '--';

  String get humidityText =>
      (isOnline && humidity != null) ? '${humidity!.round()}%' : '--';

  /// Membuat objek dari data satu perangkat di RTDB.
  factory DeviceModel.fromRtdb(String id, Map<String, dynamic> data) {
    final config = asStringMap(data['config']);
    final sensor = asStringMap(data['sensor']);
    final watering = asStringMap(data['lastWatering']);

    return DeviceModel(
      id: id,
      name: asString(config['name'], fallback: 'Tanpa nama'),
      location: asString(config['location'], fallback: '-'),
      wateringSeconds: asInt(config['wateringSeconds']) ?? AppConstants.wateringSeconds,
      autoWateringTimes: asString(
        config['autoWateringTimes'],
        fallback: AppConstants.defaultAutoWateringTimes,
      ),
      isOnline: sensor['isOnline'] == true,
      temperature: asDouble(sensor['temperature']),
      humidity: asDouble(sensor['humidity']),
      light: asDouble(sensor['light']),
      lastSeen: asDateTime(sensor['updatedAt']),
      lastWatering: asDateTime(watering['at']),
    );
  }

  /// Data lengkap untuk perangkat BARU (ditulis sekali saat "Tambah").
  Map<String, Object?> toNewDeviceMap() {
    return {
      'config': {
        'name': name,
        'location': location,
        'wateringSeconds': wateringSeconds,
        'autoWateringTimes': autoWateringTimes,
      },
      'sensor': {'isOnline': isOnline},
    };
  }

  /// Hanya field yang boleh diubah dari form "Edit".
  /// Kunci berisi garis miring = jalur ke dalam node; field lain (suhu, dst.) tidak tersentuh.
  Map<String, Object?> toUpdateMap() {
    return {
      'config/name': name,
      'config/location': location,
      'sensor/isOnline': isOnline,
    };
  }
}
