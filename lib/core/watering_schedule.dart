import 'app_constants.dart';
import 'app_format.dart';

/// Menghitung teks "Berikutnya 06.30" dari jadwal penyiraman.
///
/// Jadwal berbentuk teks "JJ:MM" dipisah koma, contoh `"06:30,18:30"`.
/// Teks ini disimpan di Realtime Database pada `config/autoWateringTimes`.
class WateringSchedule {
  WateringSchedule._();

  /// Jam penyiraman otomatis berikutnya setelah [now], contoh "06.30".
  /// [schedule] kosong/tidak valid -> memakai jadwal bawaan di [AppConstants].
  static String nextTimeText(DateTime now, {String? schedule}) {
    var times = _parse(schedule ?? AppConstants.defaultAutoWateringTimes);
    if (times.isEmpty) times = _parse(AppConstants.defaultAutoWateringTimes);

    for (final t in times) {
      final candidate = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      if (candidate.isAfter(now)) return _format(t);
    }
    // Semua jadwal hari ini sudah lewat -> besok pagi (jadwal pertama).
    return _format(times.first);
  }

  static String _format(({int hour, int minute}) t) =>
      '${AppFormat.two(t.hour)}.${AppFormat.two(t.minute)}';

  /// "06:30,18:30" -> [(6, 30), (18, 30)] (terurut; yang salah format diabaikan).
  static List<({int hour, int minute})> _parse(String text) {
    final result = <({int hour, int minute})>[];
    for (final part in text.split(',')) {
      final pieces = part.trim().split(':');
      if (pieces.length != 2) continue;
      final hour = int.tryParse(pieces[0]);
      final minute = int.tryParse(pieces[1]);
      if (hour == null || minute == null) continue;
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) continue;
      result.add((hour: hour, minute: minute));
    }
    result.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    return result;
  }
}
