import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../providers/navigation_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/profile_provider.dart';
import 'app_icon.dart';
import 'user_avatar.dart';

/// Bagian atas aplikasi: logo TaugeKu, lonceng notifikasi, dan avatar.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // `select` = hanya digambar ulang bila nilai yang dipilih berubah.
    final hasUnread = context.select<NotificationProvider, bool>((p) => p.hasUnread);
    final profile = context.select<ProfileProvider, ({String initials, Uint8List? photo})>(
      (p) => (initials: p.initials, photo: p.photoBytes),
    );
    // `read` = hanya mengambil objek (untuk dipanggil fungsinya), tanpa menggambar ulang.
    final nav = context.read<NavigationProvider>();

    return SizedBox(
      height: 66,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Row(
          children: [
            // ---- Logo ----
            Transform.rotate(
              angle: -0.052, // sekitar -3 derajat
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.pink500,
                  borderRadius: AppRadius.leaf(12, 5),
                ),
                alignment: Alignment.center,
                child: const AppIcon(AppIcons.leaf, size: 19, color: Colors.white),
              ),
            ),
            const SizedBox(width: 9),
            Text('TaugeKu', style: AppText.sans(size: 18, weight: FontWeight.w800, letterSpacing: -0.5)),
            const Spacer(),

            // ---- Lonceng notifikasi ----
            GestureDetector(
              onTap: nav.toggleNotifications,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Color.fromRGBO(65, 43, 52, 0.08), blurRadius: 10, offset: Offset(0, 2)),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const AppIcon(AppIcons.bell, size: 20, color: Color(0xFF5D535B)),
                    if (hasUnread)
                      Positioned(
                        top: 8,
                        right: 9,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.pink500,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            // ---- Avatar (membuka halaman Profil) ----
            GestureDetector(
              onTap: () => nav.setTab(AppTab.profile),
              child: UserAvatar(initials: profile.initials, photoBytes: profile.photo),
            ),
          ],
        ),
      ),
    );
  }
}
