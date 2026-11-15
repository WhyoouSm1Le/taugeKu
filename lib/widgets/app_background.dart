import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// Latar belakang aplikasi: warna krem dengan dua cahaya lembut (pink & hijau).
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: AppColors.cream)),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(1.1, -1.0),
                radius: 0.9,
                colors: [
                  const Color.fromRGBO(255, 190, 207, 0.25),
                  const Color.fromRGBO(255, 190, 207, 0),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-1.2, 0.2),
                radius: 0.8,
                colors: [
                  const Color.fromRGBO(185, 216, 134, 0.14),
                  const Color.fromRGBO(185, 216, 134, 0),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
