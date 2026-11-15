import 'package:flutter/material.dart';

import '../core/app_text.dart';
import 'eyebrow.dart';

/// Judul bagian: teks kecil [eyebrow], judul besar [title],
/// dan widget opsional di kanan [trailing] (tombol, dll).
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppText.sans(size: 17, weight: FontWeight.w800, letterSpacing: -0.35),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
