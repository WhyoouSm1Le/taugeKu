/// Kumpulan fungsi pemformat teks (tanggal, jam, angka).
///
/// Kami menulisnya manual (tanpa paket `intl`) supaya mudah dibaca pemula
/// dan tidak perlu mengatur locale bahasa Indonesia.
class AppFormat {
  AppFormat._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  /// 5 -> "05"
  static String two(int n) => n.toString().padLeft(2, '0');

  /// Jam dengan titik, gaya Indonesia: "18.42". Null -> "--.--".
  static String time(DateTime? d) {
    if (d == null) return '--.--';
    return '${two(d.hour)}.${two(d.minute)}';
  }

  /// Hanya jam: "08".
  static String hour(DateTime d) => two(d.hour);

  /// "24 Mei"
  static String dayMonth(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  /// "24/05"
  static String dayMonthNumeric(DateTime d) => '${two(d.day)}/${two(d.month)}';

  /// Rentang tanggal: "18-22 Mei 2026" atau "28 Mei - 1 Jun 2026".
  static String dateRange(DateTime start, DateTime? end) {
    if (end == null) return '${dayMonth(start)} ${start.year}';
    final sameMonth = start.year == end.year && start.month == end.month;
    if (sameMonth) {
      return '${start.day}–${end.day} ${_months[end.month - 1]} ${end.year}';
    }
    return '${dayMonth(start)} – ${dayMonth(end)} ${end.year}';
  }

  /// Durasi: "3h 14j" (3 hari 14 jam).
  static String duration(DateTime start, DateTime end) {
    final diff = end.difference(start);
    return '${diff.inDays}h ${diff.inHours % 24}j';
  }

  /// Pemisah ribuan gaya Indonesia: 1021 -> "1.021".
  static String thousands(int n) {
    final digits = n.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Angka desimal 1 digit: 29.84 -> "29.8".
  static String decimal(double? v) => v == null ? '--' : v.toStringAsFixed(1);

  /// Waktu relatif panjang: "12 menit lalu".
  static String timeAgo(DateTime? d, {DateTime? now}) {
    if (d == null) return '-';
    final diff = (now ?? DateTime.now()).difference(d);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  /// Waktu relatif pendek untuk kartu perangkat: "1 mnt", "2 jam".
  static String shortAgo(DateTime? d, {DateTime? now}) {
    if (d == null) return '--';
    final diff = (now ?? DateTime.now()).difference(d);
    if (diff.inMinutes < 1) return 'Baru';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt';
    if (diff.inHours < 24) return '${diff.inHours} jam';
    return '${diff.inDays} hari';
  }

  /// Sapaan sesuai jam.
  static String greeting(DateTime now) {
    final h = now.hour;
    if (h >= 4 && h < 11) return 'Selamat pagi,';
    if (h >= 11 && h < 15) return 'Selamat siang,';
    if (h >= 15 && h < 18) return 'Selamat sore,';
    return 'Selamat malam,';
  }
}
