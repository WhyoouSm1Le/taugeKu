import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_text.dart';
import 'app_icon.dart';

/// Dialog konfirmasi sebelum menghapus perangkat.
/// Mengembalikan true jika pengguna menekan "Hapus".
Future<bool> showConfirmDeleteDialog(BuildContext context, {required String deviceName}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(color: AppColors.dangerBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const AppIcon(AppIcons.trash, size: 23, color: AppColors.danger),
            ),
            const SizedBox(height: 14),
            Text('Hapus perangkat?', style: AppText.sans(size: 17, weight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: deviceName, style: AppText.sans(size: 13, weight: FontWeight.w800)),
                  TextSpan(text: ' akan dihapus dari TaugeKu.', style: AppText.sans(size: 13, color: AppColors.muted)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      side: const BorderSide(color: AppColors.line),
                      foregroundColor: AppColors.ink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Batal', style: AppText.sans(size: 13, weight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Hapus', style: AppText.sans(size: 13, weight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  // Jika dialog ditutup dengan cara lain (tap di luar), hasilnya null -> dianggap false.
  return result ?? false;
}
