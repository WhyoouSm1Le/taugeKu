import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import 'app_icon.dart';
import 'icon_bubble.dart';

/// Kartu kecil satu sensor di Beranda (Suhu / Kelembapan / Cahaya).
class SensorCard extends StatelessWidget {
  const SensorCard({
    super.key,
    required this.type,
    required this.icon,
    required this.value,
    required this.unit,
    required this.note,
    required this.color,
    required this.softColor,
    this.noteIsGood = true,
    this.onTap,
  });

  final String type; // "Suhu"
  final AppIcons icon;
  final String value; // "29.8"
  final String unit; // "°C"
  final String note; // "Ideal"
  final Color color; // warna utama sensor
  final Color softColor; // warna lembut untuk latar
  final bool noteIsGood; // true = label hijau, false = label kuning
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 142),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: AppRadius.leaf(24, 8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, softColor],
          ),
          border: Border.all(color: const Color.fromRGBO(89, 59, 70, 0.07)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBubble(
                  icon: icon,
                  iconColor: Colors.white,
                  size: 36,
                  iconSize: 19,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color.lerp(color, Colors.white, 0.28)!, color],
                  ),
                  shadowColor: color.withValues(alpha: 0.25),
                ),
                const Spacer(),
                // Tiga batang kecil penghias (spark).
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final h in const [10.0, 15.0, 8.0])
                      Container(
                        width: 3,
                        height: h,
                        margin: const EdgeInsets.only(left: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.30),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(type, style: AppText.sans(size: 12, weight: FontWeight.w600, color: AppColors.muted)),
            const SizedBox(height: 2),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: value, style: AppText.mono(size: 23, letterSpacing: -1)),
                  TextSpan(text: unit, style: AppText.sans(size: 11, color: AppColors.muted)),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 3, 8, 3),
              decoration: BoxDecoration(
                color: noteIsGood
                    ? const Color.fromRGBO(235, 247, 240, 0.9)
                    : const Color.fromRGBO(255, 244, 218, 0.95),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: noteIsGood ? AppColors.successDot : AppColors.light,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      note,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(
                        size: 10,
                        weight: FontWeight.w600,
                        color: noteIsGood ? const Color(0xFF5E806E) : AppColors.light,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
