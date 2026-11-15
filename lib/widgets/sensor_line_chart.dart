import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/app_text.dart';

/// Grafik garis halus untuk satu jenis sensor.
///
/// Digambar manual dengan [CustomPainter] pada kanvas virtual 300 x 145,
/// lalu otomatis diskalakan mengikuti lebar layar. Logika kurva sama dengan
/// fungsi `smoothPath` pada kode web.
class SensorLineChart extends StatelessWidget {
  const SensorLineChart({
    super.key,
    required this.values,
    required this.labels,
    required this.color,
  });

  /// Nilai pada sumbu-Y, urut dari terlama ke terbaru.
  final List<double> values;

  /// Label sumbu-X (jam atau tanggal), jumlahnya sama dengan [values].
  final List<String> labels;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 300 / 145,
      child: CustomPaint(
        painter: _LineChartPainter(values: values, labels: labels, color: color),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.values, required this.labels, required this.color});

  final List<double> values;
  final List<String> labels;
  final Color color;

  // Ukuran kanvas virtual & area gambar.
  static const double _width = 300;
  static const double _height = 145;
  static const double _left = 18;
  static const double _right = 283;
  static const double _bottomLine = 122;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    canvas.save();
    canvas.scale(size.width / _width, size.height / _height);

    _drawGrid(canvas);

    final points = _calculatePoints();
    final path = _smoothPath(points);

    // 1) Area berwarna di bawah garis (memudar ke bawah)
    if (points.length > 1) {
      final area = Path.from(path)
        ..lineTo(points.last.dx, _bottomLine)
        ..lineTo(points.first.dx, _bottomLine)
        ..close();
      final areaPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
        ).createShader(const Rect.fromLTWH(0, 40, _width, 82));
      canvas.drawPath(area, areaPaint);
    }

    // 2) Cahaya lembut di belakang garis
    final glow = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, glow);

    // 3) Garis utama
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, line);

    // 4) Titik data + label sumbu-X
    for (var i = 0; i < points.length; i++) {
      final isLast = i == points.length - 1;
      final radius = isLast ? 5.0 : 3.0;
      canvas.drawCircle(points[i], radius, Paint()..color = Colors.white);
      canvas.drawCircle(
        points[i],
        radius,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = isLast ? 3 : 2,
      );

      if (i < labels.length) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: AppText.mono(size: 9, color: const Color(0xFFA2999E)),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(points[i].dx - textPainter.width / 2, 128));
      }
    }

    canvas.restore();
  }

  /// Garis bantu putus-putus (tiga garis horizontal).
  void _drawGrid(Canvas canvas) {
    final paint = Paint()
      ..color = const Color.fromRGBO(126, 101, 110, 0.18)
      ..strokeWidth = 1;
    for (final y in const [40.0, 76.0, 112.0]) {
      for (double x = _left; x < _right; x += 7) {
        canvas.drawLine(Offset(x, y), Offset(math.min(x + 2, _right), y), paint);
      }
    }
  }

  /// Mengubah nilai sensor menjadi koordinat (x, y) di kanvas.
  List<Offset> _calculatePoints() {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(maxValue - minValue, 1.0);
    final count = values.length;
    final step = count == 1 ? 0.0 : (_right - _left) / (count - 1);

    return [
      for (var i = 0; i < count; i++)
        Offset(
          count == 1 ? (_left + _right) / 2 : _left + step * i,
          112 - ((values[i] - minValue) / range) * 72,
        ),
    ];
  }

  /// Menyambung titik-titik dengan kurva Bezier yang halus.
  Path _smoothPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      path.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.color != color || !listEquals(old.values, values) || !listEquals(old.labels, labels);
}
