import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_format.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../models/notification_item.dart';
import '../providers/navigation_provider.dart';
import '../providers/notification_provider.dart';
import 'app_icon.dart';

/// Kotak daftar notifikasi yang muncul saat lonceng ditekan.
class NotificationsPopover extends StatelessWidget {
  const NotificationsPopover({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<NotificationProvider>().items;

    return Container(
      width: 300,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.97),
        borderRadius: AppRadius.leaf(25, 9),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(54, 38, 45, 0.2), blurRadius: 55, offset: Offset(0, 18)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Notifikasi', style: AppText.sans(size: 15, weight: FontWeight.w800)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Menutup popover sekaligus menandai semua sudah dibaca.
                  context.read<NavigationProvider>().closeNotifications();
                  context.read<NotificationProvider>().markAllAsRead();
                },
                child: Text(
                  'Tutup',
                  style: AppText.sans(size: 11, weight: FontWeight.w700, color: AppColors.pink600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text('Belum ada notifikasi', style: AppText.sans(size: 12, color: AppColors.muted)),
              ),
            )
          else
            // ConstrainedBox: batasi tinggi agar daftar panjang bisa di-scroll.
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [for (final item in items) _NotificationRow(item: item)],
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final isWarning = item.type == NotificationType.warning;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.line))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isWarning ? AppColors.lightSoft : AppColors.pink50,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: AppIcon(
              isWarning ? AppIcons.sun : AppIcons.water,
              size: 17,
              color: isWarning ? AppColors.light : AppColors.pink600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppText.sans(size: 12, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item.message, style: AppText.sans(size: 11, color: AppColors.muted)),
                const SizedBox(height: 2),
                Text(
                  AppFormat.timeAgo(item.createdAt),
                  style: AppText.sans(size: 10, color: const Color(0xFFA0979C)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
