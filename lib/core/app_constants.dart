/// Angka-angka tetap yang dipakai di banyak tempat.
/// Ubah di sini kalau aturan budidaya tauge Anda berbeda.
class AppConstants {
  AppConstants._();

  // ---- Rentang kondisi ideal (dipakai kartu sensor & kartu insight) ----
  static const double idealTempMin = 28;
  static const double idealTempMax = 30;
  static const double idealHumidityMin = 70;
  static const double idealHumidityMax = 80;

  /// Batas bawah cahaya (%) untuk dianggap "rendah" -> tauge butuh gelap.
  static const double lightLowMax = 30;

  /// Skala maksimal untuk lingkaran gauge suhu (0 - 40 derajat Celsius).
  static const double gaugeTempScale = 40;

  // ---- Siklus tanam ----
  /// Lama satu siklus tauge (hari) bila batch tidak menyebut lain.
  static const int defaultCycleDays = 4;

  // ---- Penyiraman ----
  /// Lama pompa menyala ketika tombol "Siram" ditekan (detik).
  /// Nilai ini hanya cadangan: yang dipakai adalah `config/wateringSeconds`
  /// milik perangkat di Realtime Database (jika ada).
  static const int wateringSeconds = 10;

  /// Berapa lama aplikasi menunggu jawaban Wemos sebelum menyerah (detik).
  static const int wateringTimeoutSeconds = 30;

  /// Jadwal penyiraman otomatis bawaan (format "JJ:MM" dipisah koma).
  /// Hanya cadangan untuk teks "Berikutnya": yang dipakai adalah
  /// `config/autoWateringTimes` milik perangkat di Realtime Database.
  /// Jadwal sebenarnya dijalankan oleh program di Wemos.
  static const String defaultAutoWateringTimes = '06:30,18:30';

  // ---- Grafik & data ----
  /// Jumlah titik maksimal di grafik (data lebih banyak diringkas).
  static const int maxChartPoints = 8;

  /// Batas dokumen rekaman sensor yang diambil dari Firestore per permintaan.
  static const int maxReadingsPerQuery = 500;

  /// Berapa notifikasi terakhir yang ditampilkan.
  static const int maxNotifications = 20;
}
