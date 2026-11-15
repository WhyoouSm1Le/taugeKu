import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Gaya teks siap pakai.
///
/// * [sans]  -> font "Plus Jakarta Sans" untuk teks biasa.
/// * [mono]  -> font "DM Mono" untuk angka sensor dan ID perangkat.
///
/// Contoh: `Text('Halo', style: AppText.sans(size: 16, weight: FontWeight.w700))`
class AppText {
  AppText._();

  static TextStyle sans({
    double size = 13,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.ink,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle mono({
    double size = 12,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.ink,
    double? letterSpacing,
  }) {
    return GoogleFonts.dmMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
