import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_colors.dart';

/// Daftar nama ikon yang tersedia di aplikasi.
///
/// Ikon-ikon ini SAMA PERSIS dengan ikon SVG pada desain web (Figma Make),
/// jadi tampilannya konsisten. Cara pakai:
///
/// ```dart
/// AppIcon(AppIcons.water, size: 20, color: Colors.white)
/// ```
enum AppIcons {
  home, pulse, chart, device, bell, leaf, wifi, water, temp, sun, clock, refresh, more, plus, back, edit, trash, location, check, calendar, settings, logout, info,
}

/// Widget ikon sederhana: cukup sebut nama ikon, ukuran, dan warnanya.
///
/// Di balik layar, widget ini membuat gambar SVG dari kode path di bawah.
/// Jika ingin menambah ikon baru:
///   1. Tambahkan nama baru di enum [AppIcons] di atas.
///   2. Tambahkan path SVG-nya di map [_paths] di bawah.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = 22,
    this.color,
    this.strokeWidth = 1.9,
  });

  /// Nama ikon yang ingin ditampilkan.
  final AppIcons icon;

  /// Ukuran ikon (lebar = tinggi), satuan logical pixel.
  final double size;

  /// Warna garis ikon. Jika kosong, memakai warna ikon dari tema.
  final Color? color;

  /// Ketebalan garis ikon.
  final double strokeWidth;

  /// Kumpulan path SVG (disalin otomatis dari desain web).
  static const Map<AppIcons, String> _paths = {
    AppIcons.home: r'<path d="m3 11 9-8 9 8" /> <path d="M5.5 9.5V21h13V9.5M9 21v-7h6v7" />',
    AppIcons.pulse: r'<path d="M3 12h4l2-6 4 12 2-6h6" />',
    AppIcons.chart: r'<path d="M4 20V10M10 20V4M16 20v-7M22 20H2" />',
    AppIcons.device: r'<rect x="5" y="2.5" width="14" height="19" rx="3" /> <path d="M9 6h6M10 18h4" />',
    AppIcons.bell: r'<path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9M10 21h4" />',
    AppIcons.leaf: r'<path d="M20 4C12 4 5 8 5 15c0 3 2 5 5 5 7 0 10-8 10-16Z" /> <path d="M4 21c3-6 8-9 13-12" />',
    AppIcons.wifi: r'<path d="M5 12.5a10 10 0 0 1 14 0M8.5 16a5 5 0 0 1 7 0" /> <path d="M12 20h.01" />',
    AppIcons.water: r'<path d="M12 2S5 10 5 15a7 7 0 0 0 14 0c0-5-7-13-7-13Z" /> <path d="M9 16c.5 1.4 1.5 2 3 2" />',
    AppIcons.temp: r'<path d="M14 14.7V5a4 4 0 0 0-8 0v9.7a6 6 0 1 0 8 0Z" /> <path d="M10 8v9" />',
    AppIcons.sun: r'<circle cx="12" cy="12" r="4" /> <path d="M12 2v2M12 20v2M4.93 4.93l1.42 1.42M17.65 17.65l1.42 1.42M2 12h2M20 12h2M4.93 19.07l1.42-1.42M17.65 6.35l1.42-1.42" />',
    AppIcons.clock: r'<circle cx="12" cy="12" r="9" /> <path d="M12 7v5l3.5 2" />',
    AppIcons.refresh: r'<path d="M20 7v5h-5M4 17v-5h5" /> <path d="M18.5 10A7 7 0 0 0 6 7.5L4 12M5.5 14A7 7 0 0 0 18 16.5l2-4.5" />',
    AppIcons.more: r'<circle cx="5" cy="12" r="1" fill="currentColor" stroke="none" /> <circle cx="12" cy="12" r="1" fill="currentColor" stroke="none" /> <circle cx="19" cy="12" r="1" fill="currentColor" stroke="none" />',
    AppIcons.plus: r'<path d="M12 5v14M5 12h14" />',
    AppIcons.back: r'<path d="m15 18-6-6 6-6" />',
    AppIcons.edit: r'<path d="m4 16-1 5 5-1L19 9l-4-4L4 16ZM13.5 6.5l4 4" />',
    AppIcons.trash: r'<path d="M4 7h16M9 3h6l1 4H8l1-4ZM6 7l1 14h10l1-14M10 11v6M14 11v6" />',
    AppIcons.location: r'<path d="M20 10c0 5-8 12-8 12S4 15 4 10a8 8 0 1 1 16 0Z" /> <circle cx="12" cy="10" r="2.5" />',
    AppIcons.check: r'<path d="m5 12 4 4L19 6" />',
    AppIcons.calendar: r'<rect x="3" y="5" width="18" height="16" rx="3" /> <path d="M8 3v4M16 3v4M3 10h18" />',
    AppIcons.settings: r'<circle cx="12" cy="12" r="3" /> <path d="M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1-2.8 2.8-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.6v.2h-4V21a1.7 1.7 0 0 0-1-1.6 1.7 1.7 0 0 0-1.9.3l-.1.1L4.2 17l.1-.1a1.7 1.7 0 0 0 .3-1.9A1.7 1.7 0 0 0 3 14H2.8v-4H3a1.7 1.7 0 0 0 1.6-1 1.7 1.7 0 0 0-.3-1.9L4.2 7 7 4.2l.1.1a1.7 1.7 0 0 0 1.9.3 1.7 1.7 0 0 0 1-1.6v-.2h4V3a1.7 1.7 0 0 0 1 1.6 1.7 1.7 0 0 0 1.9-.3l.1-.1L19.8 7l-.1.1a1.7 1.7 0 0 0-.3 1.9 1.7 1.7 0 0 0 1.6 1h.2v4H21a1.7 1.7 0 0 0-1.6 1Z" />',
    AppIcons.logout: r'<path d="M10 4H4v16h6M14 8l4 4-4 4M8 12h10" />',
    AppIcons.info: r'<circle cx="12" cy="12" r="9" /> <path d="M12 11v6M12 7h.01" />',
  };

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color ?? AppColors.ink;
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'fill="none" stroke="currentColor" stroke-width="$strokeWidth" '
        'stroke-linecap="round" stroke-linejoin="round">${_paths[icon]}</svg>';

    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      theme: SvgTheme(currentColor: iconColor),
    );
  }
}
