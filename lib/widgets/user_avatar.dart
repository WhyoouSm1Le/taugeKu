import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text.dart';

/// Avatar pengguna: menampilkan foto (dari memori) jika ada, jika tidak menampilkan inisial.
class UserAvatar extends StatelessWidget {
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

  final String initials;
  final Uint8List? photoBytes; // foto sementara di memori (boleh kosong)
  final double size;
  final double radius;
  final Color background;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final initialsWidget = Text(
      initials,
      style: AppText.sans(size: fontSize, weight: FontWeight.w800, color: textColor),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(65, 43, 52, 0.08), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: photoBytes == null
          ? initialsWidget
          : Image.memory(
              photoBytes!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              // Jika gambar rusak, tampilkan inisial.
              errorBuilder: (_, __, ___) => initialsWidget,
            ),
    );
  }
}
