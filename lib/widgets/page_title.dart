import 'package:flutter/material.dart';
import 'package:taugeku_mobile03/core/app_colors.dart';
import 'package:taugeku_mobile03/core/app_text.dart';
import 'package:taugeku_mobile03/widgets/eyebrow.dart';

class PageTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const PageTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 6, 2, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(eyebrow),
                const SizedBox(height: 4),
                Text(
                  title, 
                  style: AppText.sans(
                    size: 27, 
                    weight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!, 
                    style: AppText.sans(
                      size: 12,
                      color: AppColors.muted,
                    )
                  )
                ]
              ],
            )
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}