import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text.dart';

/// Teks kecil huruf kapital di atas judul (contoh: "KONDISI TERKINI"),
/// diawali garis kecil berwarna.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = AppColors.pink600, this.light = false});

  final String text;
  final Color color;

  /// true = untuk latar gelap (garis menjadi putih transparan).
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 13,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: light ? const Color.fromRGBO(255, 255, 255, 0.55) : null,
            gradient: light
                ? null
                : const LinearGradient(colors: [AppColors.pink500, AppColors.peach200]),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppText.sans(
            size: 10,
            weight: FontWeight.w800,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
