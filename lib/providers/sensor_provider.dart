import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/app_constants.dart';
import '../core/app_format.dart';
import '../models/sensor_reading.dart';
import '../services/sensor_service.dart';

/// Pilihan rentang waktu pada grafik Monitoring.
enum SensorRange {
  today('Hari ini'),
  week('7 hari'),
  month('30 hari');

  const SensorRange(this.label);

  /// Teks yang tampil di layar.
  final String label;

  /// Batas waktu paling awal untuk rentang ini.
  DateTime startFrom(DateTime now) {
    switch (this) {
      case SensorRange.today:
        return DateTime(now.year, now.month, now.day);
      case SensorRange.week:
        return now.subtract(const Duration(days: 7));
      case SensorRange.month:
        return now.subtract(const Duration(days: 30));
    }
  }
}

/// State untuk DATA SENSOR pada halaman Monitoring (grafik & daftar data).
///
/// Provider ini butuh dua hal: siapa penggunanya (uid) dan perangkat mana
/// yang dipantau (deviceId). Keduanya diberikan lewat [setTarget].
class SensorProvider extends ChangeNotifier {
  SensorProvider({SensorService? service}) : _service = service ?? SensorService();

  final SensorService _service;
  StreamSubscription<List<SensorReading>>? _subscription;

  String? _userId;
  String? _deviceId;
  SensorRange _range = SensorRange.today;

  List<SensorReading> _readings = []; // urut dari terlama ke terbaru
  bool _isLoading = false;
  bool _hasError = false;

  // ---- Data yang boleh dibaca layar ----
  SensorRange get range => _range;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasData => _readings.isNotEmpty;
  int get totalReadings => _readings.length;

  /// Data untuk grafik: diringkas agar maksimal [AppConstants.maxChartPoints] titik.
  List<SensorReading> get chartReadings =>
      _downsample(_readings, AppConstants.maxChartPoints);

  /// 4 data terbaru (terbaru paling atas) untuk daftar "Data sensor".
  List<SensorReading> get latestReadings => _readings.reversed.take(4).toList();

  /// Teks label sumbu-X grafik: jam untuk "Hari ini", tanggal untuk lainnya.
  String chartLabel(SensorReading reading) {
    return _range == SensorRange.today
        ? AppFormat.hour(reading.createdAt)
        : AppFormat.dayMonthNumeric(reading.createdAt);
  }

  /// Diatur otomatis oleh ProxyProvider (lihat lib/app.dart).
  void setTarget({required String? userId, required String? deviceId}) {
    if (userId == _userId && deviceId == _deviceId) return;
    _userId = userId;
    _deviceId = deviceId;
    _subscribe();
  }

  /// Dipanggil saat pengguna memilih "Hari ini / 7 hari / 30 hari".
  void setRange(SensorRange newRange) {
    if (newRange == _range) return;
    _range = newRange;
    _subscribe();
    notifyListeners();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = null;
    _readings = [];
    _hasError = false;

    final uid = _userId;
    final deviceId = _deviceId;
    if (uid == null || deviceId == null) {
      _isLoading = false;
      return;
    }

    _isLoading = true;
    _subscription = _service
        .watchReadings(
          uid: uid,
          deviceId: deviceId,
          since: _range.startFrom(DateTime.now()),
          limit: AppConstants.maxReadingsPerQuery,
        )
        .listen(
      (newestFirst) {
        // Firestore memberi data terbaru dulu; grafik butuh terlama -> terbaru.
        _readings = newestFirst.reversed.toList();
        _isLoading = false;
        _hasError = false;
        notifyListeners();
      },
      onError: (Object error) {
        debugPrint('Gagal membaca data sensor: $error');
        _hasError = true;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Meringkas data bila terlalu banyak, dengan mengambil titik yang
  /// tersebar merata dari awal sampai akhir.
  List<SensorReading> _downsample(List<SensorReading> source, int maxPoints) {
    if (source.length <= maxPoints) return source;
    final result = <SensorReading>[];
    for (var i = 0; i < maxPoints; i++) {
      final index = (i * (source.length - 1) / (maxPoints - 1)).round();
      result.add(source[index]);
    }
    return result;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
