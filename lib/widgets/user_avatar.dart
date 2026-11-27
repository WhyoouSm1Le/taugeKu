import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:taugeku_mobile03/core/app_colors.dart';
import 'package:taugeku_mobile03/core/app_text.dart';

class UserAvatar extends StatelessWidget {
  final String initials;
  final Uint8List? photoBytes;
  final double size;
  final double radius;
  final Color background;
  final Color textColor;
  final double fontSize;

  const UserAvatar({
    super.key,
    required this.initials,
    this.photoBytes,
    this.size = 36,
    this.radius = 12,
    this.background = Colors.white,
    this.textColor = AppColors.pink600,
    this.fontSize = 12,  
  });

  @override
  Widget build(BuildContext context) {
    final initialsWidget = Text(
      initials,
      style: AppText.sans(
        size: fontSize,
        weight: FontWeight.w800, 
        color: textColor,
      ),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const[
          BoxShadow(
            color: Color.fromRGBO(65, 43, 52, 0.08),
            blurRadius: 10,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: photoBytes == null
          ? initialsWidget
          : Image.memory(
            photoBytes!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => initialsWidget,
          ),
    );
  }
}