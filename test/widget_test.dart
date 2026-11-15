import 'package:flutter_test/flutter_test.dart';
import 'package:taugeku_mobile03/core/app_format.dart';
import 'package:taugeku_mobile03/core/sensor_rules.dart';
import 'package:taugeku_mobile03/core/watering_schedule.dart';
import 'package:taugeku_mobile03/models/device_model.dart';


/// Unit test untuk logika murni (tanpa Firebase, tanpa tampilan).
/// Jalankan dengan:  flutter test
void main() {
  group('AppFormat', () {
    test('thousands memakai titik sebagai pemisah ribuan', () {
      expect(AppFormat.thousands(1021), '1.021');
      expect(AppFormat.thousands(842), '842');
      expect(AppFormat.thousands(1234567), '1.234.567');
    });

    test('time memakai titik dan menangani null', () {
      expect(AppFormat.time(DateTime(2026, 5, 24, 18, 42)), '18.42');
      expect(AppFormat.time(DateTime(2026, 5, 24, 6, 5)), '06.05');
      expect(AppFormat.time(null), '--.--');
    });

    test('dateRange pada bulan yang sama', () {
      expect(
        AppFormat.dateRange(DateTime(2026, 5, 18), DateTime(2026, 5, 22)),
        '18–22 Mei 2026',
      );
    });

    test('duration dalam hari dan jam', () {
      expect(
        AppFormat.duration(DateTime(2026, 5, 18), DateTime(2026, 5, 21, 14)),
        '3h 14j',
      );
    });

    test('timeAgo', () {
      final now = DateTime(2026, 5, 24, 12, 0);
      expect(AppFormat.timeAgo(now.subtract(const Duration(seconds: 10)), now: now), 'Baru saja');
      expect(AppFormat.timeAgo(now.subtract(const Duration(minutes: 12)), now: now), '12 menit lalu');
      expect(AppFormat.timeAgo(now.subtract(const Duration(hours: 2)), now: now), '2 jam lalu');
    });

    test('greeting sesuai jam', () {
      expect(AppFormat.greeting(DateTime(2026, 1, 1, 8)), 'Selamat pagi,');
      expect(AppFormat.greeting(DateTime(2026, 1, 1, 16)), 'Selamat sore,');
      expect(AppFormat.greeting(DateTime(2026, 1, 1, 21)), 'Selamat malam,');
    });
  });

  group('SensorRules', () {
    test('catatan sensor', () {
      expect(SensorRules.temperatureNote(29.8), 'Ideal');
      expect(SensorRules.temperatureNote(32), 'Panas');
      expect(SensorRules.humidityNote(78), 'Optimal');
      expect(SensorRules.humidityNote(60), 'Kering');
      expect(SensorRules.lightNote(24), 'Rendah');
      expect(SensorRules.lightNote(null), 'Tidak ada data');
    });
  });

  group('WateringSchedule', () {
    test('jadwal berikutnya (bawaan)', () {
      expect(WateringSchedule.nextTimeText(DateTime(2026, 5, 24, 7, 0)), '18.30');
      expect(WateringSchedule.nextTimeText(DateTime(2026, 5, 24, 18, 42)), '06.30');
    });

    test('jadwal dari config perangkat', () {
      final now = DateTime(2026, 5, 24, 6, 0);
      expect(WateringSchedule.nextTimeText(now, schedule: '05:00,12:00'), '12.00');
    });

    test('jadwal tidak valid memakai jadwal bawaan', () {
      final now = DateTime(2026, 5, 24, 7, 0);
      expect(WateringSchedule.nextTimeText(now, schedule: 'abc'), '18.30');
    });
  });

  group('DeviceModel.fromRtdb', () {
    test('membaca config, sensor, dan siram terakhir', () {
      final device = DeviceModel.fromRtdb('WMS-001', {
        'config': {'name': 'Tauge Utama', 'location': 'Rak A · Dapur', 'wateringSeconds': 12},
        'sensor': {
          'temperature': 29.8,
          'humidity': 78,
          'light': 24,
          'isOnline': true,
          'updatedAt': 1700000000000,
        },
        'lastWatering': {'at': 1700000600000},
      });

      expect(device.id, 'WMS-001');
      expect(device.name, 'Tauge Utama');
      expect(device.wateringSeconds, 12);
      expect(device.isOnline, true);
      expect(device.temperatureText, '29.8°C');
      expect(device.humidityText, '78%');
      expect(device.lastWatering, DateTime.fromMillisecondsSinceEpoch(1700000600000));
    });

    test('data kosong tidak menimbulkan error dan memakai nilai bawaan', () {
      final device = DeviceModel.fromRtdb('WMS-002', {});

      expect(device.name, 'Tanpa nama');
      expect(device.isOnline, false);
      expect(device.temperatureText, '--');
      expect(device.wateringSeconds, 10);
      expect(device.autoWateringTimes, '06:30,18:30');
      expect(device.lastWatering, isNull);
    });
  });
}
