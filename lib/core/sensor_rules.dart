import 'app_constants.dart';

/// Aturan sederhana untuk menerjemahkan angka sensor menjadi kata-kata
/// ("Ideal", "Optimal", "Rendah", dst). Semua fungsi bersifat static,
/// jadi cukup dipanggil seperti `SensorRules.temperatureNote(29.8)`.
class SensorRules {
  SensorRules._();

  static bool isTemperatureIdeal(double? t) =>
      t != null &&
      t >= AppConstants.idealTempMin &&
      t <= AppConstants.idealTempMax;

  static bool isHumidityIdeal(double? h) =>
      h != null &&
      h >= AppConstants.idealHumidityMin &&
      h <= AppConstants.idealHumidityMax;

  static String temperatureNote(double? t) {
    if (t == null) return 'Tidak ada data';
    if (t < AppConstants.idealTempMin) return 'Dingin';
    if (t > AppConstants.idealTempMax) return 'Panas';
    return 'Ideal';
  }

  static String humidityNote(double? h) {
    if (h == null) return 'Tidak ada data';
    if (h < AppConstants.idealHumidityMin) return 'Kering';
    if (h > AppConstants.idealHumidityMax) return 'Lembap';
    return 'Optimal';
  }

  static String lightNote(double? l) {
    if (l == null) return 'Tidak ada data';
    if (l <= AppConstants.lightLowMax) return 'Rendah';
    if (l <= 60) return 'Sedang';
    return 'Tinggi';
  }
}
