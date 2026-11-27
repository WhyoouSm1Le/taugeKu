import 'package:flutter/material.dart';
import 'package:taugeku_mobile03/core/app_colors.dart';
import 'package:taugeku_mobile03/core/app_text.dart';
import 'package:taugeku_mobile03/widgets/app_icon.dart';

class EmptyState extends StatelessWidget {
  final AppIcons icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,  
    required this.title,  
    required this.message,  
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
      child: Column(
        children: [
          AppIcon(
            icon, 
            size: 34, 
            color: const Color(0xFF958B91)
          ),
          const SizedBox(height: 10),
          Text(
            title, 
            style: AppText.sans(
              size: 15,
              weight: FontWeight.w800,
              color: const Color(0xFF554C52),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.sans(
              size: 12,
              color: AppColors.muted,
            ),
          )
        ],
      ),
    );
  }
}