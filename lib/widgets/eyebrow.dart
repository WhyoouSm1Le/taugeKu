import 'package:flutter/material.dart';
import 'package:taugeku_mobile03/core/app_colors.dart';
import 'package:taugeku_mobile03/core/app_text.dart';

class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  final bool light;

  const Eyebrow(
    this.text, {
    super.key,
    this.color = AppColors.pink600,
    this.light = false,
  });

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
        )
      ],
    );
  }
}