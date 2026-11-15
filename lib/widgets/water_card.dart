import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import 'app_icon.dart';
import 'eyebrow.dart';

/// Kartu merah muda tua berisi jadwal penyiraman dan tombol "Siram".
class WaterCard extends StatelessWidget {
  const WaterCard({
    super.key,
    required this.isWatering,
    required this.nextText,
    required this.lastText,
    required this.durationSeconds,
    required this.onWater,
  });

  final bool isWatering; // true = pompa sedang bekerja
  final String nextText; // "06.30"
  final String lastText; // "18.30" atau "Belum ada"
  final int durationSeconds; // lama pompa menyala (dari config perangkat)
  final VoidCallback onWater;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 77),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: AppRadius.leafRight(26, 10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.waterStart, AppColors.waterEnd],
        ),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(166, 40, 80, 0.22), blurRadius: 33, offset: Offset(0, 17)),
        ],
      ),
      child: Row(
        children: [
          // Ikon tetesan
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.16),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(23),
                topRight: const Radius.circular(23),
                bottomRight: const Radius.circular(8),
                bottomLeft: const Radius.circular(21),
              ),
              border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.22)),
            ),
            alignment: Alignment.center,
            child: const AppIcon(AppIcons.water, size: 23, color: Colors.white),
          ),
          const SizedBox(width: 12),

          // Teks jadwal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('PENYIRAMAN', color: Color(0xFFFFD4DF), light: true),
                const SizedBox(height: 3),
                Text(
                  isWatering ? 'Sedang menyiram...' : 'Berikutnya $nextText',
                  style: AppText.sans(size: 15, weight: FontWeight.w800, letterSpacing: -0.3, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  isWatering
                      ? 'Pompa aktif · $durationSeconds dtk'
                      : 'Terakhir · $lastText',
                  style: AppText.sans(size: 11, color: const Color.fromRGBO(255, 255, 255, 0.75)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Tombol Siram
          ElevatedButton(
            onPressed: isWatering ? null : onWater,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.pink700,
              disabledBackgroundColor: const Color.fromRGBO(255, 255, 255, 0.8),
              elevation: 0,
              minimumSize: const Size(72, 38),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.leaf(13, 5)),
            ),
            child: isWatering
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.pink700),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppIcon(AppIcons.water, size: 16, color: AppColors.pink700),
                      const SizedBox(width: 5),
                      Text('Siram', style: AppText.sans(size: 12, weight: FontWeight.w800, color: AppColors.pink700)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
