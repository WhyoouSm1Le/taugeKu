import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text.dart';
import 'app_icon.dart';
import 'soft_card.dart';

/// Kartu berisi lingkaran (gauge) untuk satu nilai sensor di halaman Monitoring.
class GaugeCard extends StatelessWidget {
  const GaugeCard({
    super.key,
    required this.icon,
    required this.valueText,
    required this.label,
    required this.fraction,
    required this.color,
    required this.trackColor,
    required this.idealText,
    required this.radius,
    required this.tintColor,
  });

  final AppIcons icon;
  final String valueText; // "29.8°"
  final String label; // "SUHU"
  final double fraction; // 0.0 - 1.0 : seberapa penuh lingkarannya
  final Color color; // warna busur
  final Color trackColor; // warna lintasan di belakang busur
  final String idealText; // "28–30°C"
  final BorderRadius radius;
  final Color tintColor; // warna latar lembut

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      radius: radius,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 13),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, tintColor],
      ),
      child: Column(
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.14), blurRadius: 24, offset: const Offset(0, 9)),
              ],
            ),
            child: CustomPaint(
              painter: _RingPainter(fraction: fraction, color: color, trackColor: trackColor),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon(icon, size: 20, color: color),
                    const SizedBox(height: 1),
                    Text(valueText, style: AppText.mono(size: 19)),
                    Text(
                      label,
                      style: AppText.sans(size: 9, weight: FontWeight.w700, color: color, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('Rentang ideal', style: AppText.sans(size: 10, color: AppColors.muted)),
          Text(idealText, style: AppText.sans(size: 11, weight: FontWeight.w800, color: const Color(0xFF5B5258))),
        ],
      ),
    );
  }
}

/// Melukis lingkaran: lintasan abu + busur berwarna sesuai [fraction].
class _RingPainter extends CustomPainter {
  _RingPainter({required this.fraction, required this.color, required this.trackColor});

  final double fraction;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 9.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2 - 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, track);

    if (fraction <= 0) return;
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // mulai dari atas
      2 * math.pi * fraction.clamp(0.0, 1.0).toDouble(),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color || old.trackColor != trackColor;
}
