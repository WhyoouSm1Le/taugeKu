import 'package:flutter/material.dart';

/// Semua warna aplikasi ada di sini (disalin dari desain web TaugeKu).
///
/// Kenapa dikumpulkan dalam satu file?
/// Supaya kalau ingin mengganti warna, cukup ubah di SATU tempat
/// dan seluruh aplikasi ikut berubah.
class AppColors {
  AppColors._(); // Constructor private: class ini hanya untuk menyimpan konstanta.

  // ---- Warna utama (pink) ----
  static const Color pink50 = Color(0xFFFFF1F4);
  static const Color pink100 = Color(0xFFFFE0E8);
  static const Color pink200 = Color(0xFFFFC1D2);
  static const Color pink500 = Color(0xFFD94873);
  static const Color pink600 = Color(0xFFBD315E);
  static const Color pink700 = Color(0xFF98234C);

  // ---- Teks & garis ----
  static const Color ink = Color(0xFF252027); // teks utama
  static const Color muted = Color(0xFF756C74); // teks pendukung
  static const Color line = Color(0xFFEEE7EA); // garis pemisah
  static const Color cream = Color(0xFFFBF8F5); // latar belakang aplikasi

  // ---- Hijau (tema tauge / tanaman) ----
  static const Color green = Color(0xFF397A62);
  static const Color forest900 = Color(0xFF173F34);
  static const Color forest700 = Color(0xFF2F6A57);
  static const Color lime300 = Color(0xFFB9D886);
  static const Color peach200 = Color(0xFFFFC7BD);

  // ---- Warna per jenis sensor ----
  static const Color temperature = Color(0xFFC33E67); // suhu (merah muda tua)
  static const Color temperatureSoft = Color(0xFFFFF0F4);
  static const Color humidity = Color(0xFF3B8199); // kelembapan (biru)
  static const Color humiditySoft = Color(0xFFEAF7F9);
  static const Color light = Color(0xFFA77A34); // cahaya (kuning cokelat)
  static const Color lightSoft = Color(0xFFFFF4DA);

  // ---- Status ----
  static const Color successText = Color(0xFF36785B);
  static const Color successBg = Color(0xFFEAF6EF);
  static const Color successDot = Color(0xFF58A17D);
  static const Color offlineText = Color(0xFF8C8187);
  static const Color offlineBg = Color(0xFFF1EDEF);
  static const Color danger = Color(0xFFB23E5F);
  static const Color dangerBg = Color(0xFFFFF4F6);

  // ---- Lain-lain ----
  static const Color field = Color(0xFFFBF9F9); // latar kolom input
  static const Color fieldBorder = Color(0xFFE9E1E4);
  static const Color toast = Color(0xFF1D4437);
  static const Color waterStart = Color(0xFFCC3F6A);
  static const Color waterEnd = Color(0xFF9F2651);
}
