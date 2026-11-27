import 'package:flutter/material.dart';
import 'package:taugeku_mobile03/core/app_text.dart';
import 'package:taugeku_mobile03/widgets/eyebrow.dart';

class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Widget? trailing;

  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.trailing,
  });

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
              )
            ],
          )
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}