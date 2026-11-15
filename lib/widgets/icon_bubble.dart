import 'package:flutter/material.dart';

import '../core/app_radius.dart';
import 'app_icon.dart';

/// Kotak ikon berbentuk "tetesan" (dipakai di banyak kartu).
class IconBubble extends StatelessWidget {
  const IconBubble({
    super.key,
    required this.icon,
    required this.iconColor,
    this.size = 36,
    this.iconSize = 18,
    this.background,
    this.gradient,
    this.shadowColor,
    this.borderRadius,
  });

  final AppIcons icon;
  final Color iconColor;
  final double size;
  final double iconSize;
  final Color? background;
  final Gradient? gradient;
  final Color? shadowColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gradient == null ? background : null,
        gradient: gradient,
        borderRadius: borderRadius ?? AppRadius.blob(size),
        boxShadow: shadowColor == null
            ? null
            : [BoxShadow(color: shadowColor!, blurRadius: 14, offset: const Offset(0, 7))],
      ),
      alignment: Alignment.center,
      child: AppIcon(icon, size: iconSize, color: iconColor),
    );
  }
}
