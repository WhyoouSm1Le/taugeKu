import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';
import '../providers/toast_provider.dart';
import '../widgets/app_icon.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/device_card.dart';
import '../widgets/device_form_sheet.dart';
import '../widgets/empty_state.dart';
import '../widgets/icon_bubble.dart';
import '../widgets/page_title.dart';

/// Halaman PERANGKAT: daftar Wemos + tambah / edit / hapus.
class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  /// Membuka form lalu menyimpan hasilnya ke Firebase.
  Future<void> _openForm(BuildContext context, {DeviceModel? existing}) async {
    final provider = context.read<DeviceProvider>();
    final toast = context.read<ToastProvider>();

    final result = await showDeviceFormSheet(
      context,
      existing: existing,
      suggestedId: provider.nextDeviceId(),
    );
    if (result == null) return; // dibatalkan

    final error = existing == null
        ? await provider.addDevice(result)
        : await provider.updateDevice(result);

    toast.show(error ?? (existing == null ? 'Perangkat ditambahkan' : 'Perangkat diperbarui'));
  }

  Future<void> _confirmDelete(BuildContext context, DeviceModel device) async {
    final provider = context.read<DeviceProvider>();
    final toast = context.read<ToastProvider>();

    final confirmed = await showConfirmDeleteDialog(context, deviceName: device.name);
    if (!confirmed) return;

    final error = await provider.deleteDevice(device.id);
    toast.show(error ?? 'Perangkat dihapus');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceProvider>();
    final devices = provider.devices;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final summary = devices.isEmpty
        ? 'Belum ada perangkat'
        : (provider.offlineCount > 0 ? 'Ada perangkat offline' : 'Sistem normal');

    return ListView(
      padding: EdgeInsets.fromLTRB(17, 0, 17, 110 + bottomInset),
      children: [
        PageTitle(
          eyebrow: 'WEMOS D1 MINI',
          title: 'Perangkat',
          subtitle: '${devices.length} perangkat terdaftar',
          trailing: GestureDetector(
            onTap: () => _openForm(context),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: AppColors.pink600,
                borderRadius: AppRadius.leaf(14, 5),
                boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(189, 49, 94, 0.28), blurRadius: 18, offset: Offset(0, 8)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppIcon(AppIcons.plus, size: 17, color: Colors.white),
                  const SizedBox(width: 5),
                  Text('Tambah', style: AppText.sans(size: 12, weight: FontWeight.w800, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),

        // ---- Ringkasan ----
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.leaf(22, 8),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF1F4), Color(0xFFF6FAEE)],
            ),
          ),
          child: Row(
            children: [
              IconBubble(
                icon: AppIcons.wifi,
                iconColor: provider.hasError ? AppColors.danger : AppColors.pink600,
                background: Colors.white,
                size: 42,
                iconSize: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(summary, style: AppText.sans(size: 13, weight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      '${provider.onlineCount} online · ${provider.offlineCount} offline',
                      style: AppText.sans(size: 11, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              // Status koneksi ke Realtime Database yang SEBENARNYA (bukan teks tetap).
              _ConnectionChip(hasError: provider.hasError, isConnected: provider.isConnected),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ---- Daftar perangkat ----
        if (provider.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.pink500)),
          )
        else if (devices.isEmpty)
          const EmptyState(
            icon: AppIcons.device,
            title: 'Belum ada perangkat',
            message: 'Tekan "Tambah" untuk mendaftarkan\nperangkat Wemos pertama Anda.',
          )
        else
          for (final device in devices)
            DeviceCard(
              device: device,
              onEdit: () => _openForm(context, existing: device),
              onDelete: () => _confirmDelete(context, device),
              onDetail: () => context.read<ToastProvider>().show('Fitur ini akan segera hadir'),
            ),
      ],
    );
  }
}

/// Label kecil status koneksi Firebase di kartu ringkasan.
class _ConnectionChip extends StatelessWidget {
  const _ConnectionChip({required this.hasError, required this.isConnected});

  final bool hasError;
  final bool? isConnected; // null = masih memeriksa

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;
    final Color background;

    if (hasError) {
      text = 'Firebase • Error';
      color = AppColors.danger;
      background = AppColors.dangerBg;
    } else if (isConnected == null) {
      text = 'Firebase • Memeriksa';
      color = AppColors.offlineText;
      background = AppColors.offlineBg;
    } else if (isConnected!) {
      text = 'Firebase • Online';
      color = AppColors.successText;
      background = AppColors.successBg;
    } else {
      text = 'Firebase • Offline';
      color = AppColors.offlineText;
      background = AppColors.offlineBg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(99)),
      child: Text(text, style: AppText.sans(size: 9.5, weight: FontWeight.w800, color: color)),
    );
  }
}
