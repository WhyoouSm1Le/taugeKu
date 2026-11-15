import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_format.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../models/device_model.dart';
import 'app_icon.dart';
import 'soft_card.dart';

/// Kartu satu perangkat Wemos di halaman Perangkat.
class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.device,
    required this.onEdit,
    required this.onDelete,
    required this.onDetail,
  });

  final DeviceModel device;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    final online = device.isOnline;

    return SoftCard(
      margin: const EdgeInsets.only(bottom: 12),
      radius: BorderRadius.circular(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Baris atas: simbol, nama, status ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: online ? const Color(0xFFFFEAF0) : AppColors.offlineBg,
                      borderRadius: AppRadius.blob(44),
                    ),
                    alignment: Alignment.center,
                    child: AppIcon(
                      AppIcons.device,
                      size: 24,
                      color: online ? AppColors.pink600 : const Color(0xFF9D9499),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: online ? const Color(0xFF55A078) : const Color(0xFFA9A2A6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.id, style: AppText.mono(size: 10, color: AppColors.pink600)),
                    const SizedBox(height: 2),
                    Text(device.name, style: AppText.sans(size: 15, weight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const AppIcon(AppIcons.location, size: 13, color: AppColors.muted),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            device.location,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.sans(size: 11, color: AppColors.muted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: online ? AppColors.successBg : AppColors.offlineBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  online ? 'ONLINE' : 'OFFLINE',
                  style: AppText.sans(
                    size: 9,
                    weight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: online ? AppColors.successText : AppColors.offlineText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),

          // ---- Data sensor ringkas ----
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  _DataCell(label: 'SUHU', value: device.temperatureText, first: true),
                  _DataCell(label: 'KELEMBAPAN', value: device.humidityText),
                  _DataCell(
                    label: 'UPDATE',
                    value: AppFormat.shortAgo(device.lastSeen),
                    last: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ---- Tombol aksi ----
          Row(
            children: [
              _ActionButton(icon: AppIcons.edit, label: 'Edit', color: const Color(0xFF786E75), onTap: onEdit),
              const SizedBox(width: 4),
              _ActionButton(icon: AppIcons.trash, label: 'Hapus', color: const Color(0xFFB15168), onTap: onDelete),
              const Spacer(),
              GestureDetector(
                onTap: onDetail,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    'Detail  ›',
                    style: AppText.sans(size: 12, weight: FontWeight.w700, color: AppColors.pink600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({required this.label, required this.value, this.first = false, this.last = false});

  final String label;
  final String value;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: first ? 0 : 10),
        decoration: BoxDecoration(
          border: last ? null : const Border(right: BorderSide(color: AppColors.line)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppText.sans(size: 8.5, weight: FontWeight.w700, color: const Color(0xFF9B9197))),
            const SizedBox(height: 2),
            Text(value, style: AppText.mono(size: 13, color: const Color(0xFF554C51))),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final AppIcons icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            AppIcon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppText.sans(size: 12, weight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
