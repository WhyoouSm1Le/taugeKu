import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../core/app_format.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../core/sensor_rules.dart';
import '../core/watering_schedule.dart';
import '../models/activity_item.dart';
import '../providers/activity_provider.dart';
import '../providers/batch_provider.dart';
import '../providers/device_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/toast_provider.dart';
import '../providers/watering_provider.dart';
import '../widgets/app_icon.dart';
import '../widgets/hero_card.dart';
import '../widgets/icon_bubble.dart';
import '../widgets/refresh_button.dart';
import '../widgets/section_heading.dart';
import '../widgets/sensor_card.dart';
import '../widgets/water_card.dart';

/// Halaman BERANDA: ringkasan siklus, sensor terkini, tombol siram, aktivitas.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _refresh(BuildContext context) async {
    final ok = await context.read<DeviceProvider>().refresh();
    if (!context.mounted) return; // layar sudah ditutup
    context.read<ToastProvider>().show(
          ok ? 'Data sensor berhasil diperbarui' : 'Gagal memperbarui. Periksa koneksi internet.',
        );
  }

  Future<void> _water(BuildContext context) async {
    // Lama siram diambil dari config perangkat (cadangan: AppConstants).
    final seconds = context.read<DeviceProvider>().selectedDevice?.wateringSeconds ??
        AppConstants.wateringSeconds;

    final result = await context.read<WateringProvider>().startWatering();
    if (!context.mounted) return;

    final message = switch (result) {
      WateringResult.success => 'Penyiraman selesai · $seconds detik',
      WateringResult.failed => 'Penyiraman gagal dijalankan',
      WateringResult.timeout => 'Wemos belum merespons. Cek koneksi perangkat.',
      WateringResult.deviceOffline => 'Perangkat sedang offline',
      WateringResult.noConnection => 'Tidak ada koneksi internet',
      WateringResult.notReady => 'Belum ada perangkat yang bisa disiram',
    };
    context.read<ToastProvider>().show(message);
  }

  @override
  Widget build(BuildContext context) {
    final device = context.watch<DeviceProvider>().selectedDevice;
    final batch = context.watch<BatchProvider>().currentBatch;
    final activity = context.watch<ActivityProvider>();
    final isWatering = context.watch<WateringProvider>().isWatering;
    final nav = context.read<NavigationProvider>();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final lastWatering = device?.lastWatering; // dari Realtime Database
    final recent = activity.recent;

    return ListView(
      padding: EdgeInsets.fromLTRB(17, 0, 17, 110 + bottomInset),
      children: [
        HeroCard(batch: batch, device: device),
        const SizedBox(height: 24),

        // ---- Kondisi terkini ----
        SectionHeading(
          eyebrow: 'KONDISI TERKINI',
          title: 'Lingkungan tumbuh',
          trailing: RefreshButton(onRefresh: () => _refresh(context)),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SensorCard(
                type: 'Suhu',
                icon: AppIcons.temp,
                value: AppFormat.decimal(device?.temperature),
                unit: '°C',
                note: SensorRules.temperatureNote(device?.temperature),
                noteIsGood: SensorRules.isTemperatureIdeal(device?.temperature),
                color: AppColors.temperature,
                softColor: AppColors.temperatureSoft,
                onTap: () => nav.setTab(AppTab.monitor),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              // Kartu tengah sedikit turun, mengikuti desain.
              child: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: SensorCard(
                  type: 'Kelembapan',
                  icon: AppIcons.water,
                  value: device?.humidity == null ? '--' : device!.humidity!.round().toString(),
                  unit: '%',
                  note: SensorRules.humidityNote(device?.humidity),
                  noteIsGood: SensorRules.isHumidityIdeal(device?.humidity),
                  color: AppColors.humidity,
                  softColor: AppColors.humiditySoft,
                  onTap: () => nav.setTab(AppTab.monitor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SensorCard(
                type: 'Cahaya',
                icon: AppIcons.sun,
                value: device?.light == null ? '--' : device!.light!.round().toString(),
                unit: '%',
                note: SensorRules.lightNote(device?.light),
                color: AppColors.light,
                softColor: AppColors.lightSoft,
                onTap: () => nav.setTab(AppTab.monitor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.7),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              'Sinkron · ${AppFormat.time(device?.lastSeen)}',
              style: AppText.sans(size: 10, color: const Color(0xFF9C9299)),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ---- Kartu penyiraman ----
        WaterCard(
          isWatering: isWatering,
          nextText: WateringSchedule.nextTimeText(
            DateTime.now(),
            schedule: device?.autoWateringTimes,
          ),
          lastText: lastWatering == null ? 'Belum ada' : AppFormat.time(lastWatering),
          durationSeconds: device?.wateringSeconds ?? AppConstants.wateringSeconds,
          onWater: () => _water(context),
        ),
        const SizedBox(height: 24),

        // ---- Aktivitas ----
        SectionHeading(
          eyebrow: 'AKTIVITAS HARI INI',
          title: 'Aktivitas',
          trailing: GestureDetector(
            onTap: () => nav.setTab(AppTab.history),
            child: Text(
              'Lihat semua',
              style: AppText.sans(size: 12, weight: FontWeight.w700, color: AppColors.pink600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.9),
            borderRadius: AppRadius.leaf(25, 10),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(79, 43, 58, 0.09), blurRadius: 35, offset: Offset(0, 12)),
            ],
          ),
          child: recent.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Center(
                    child: Text('Belum ada aktivitas', style: AppText.sans(size: 12, color: AppColors.muted)),
                  ),
                )
              : Stack(
                  children: [
                    // Garis vertikal gradasi yang menghubungkan ikon (sesuai desain).
                    if (recent.length > 1)
                      Positioned(
                        left: 17,
                        top: 28,
                        bottom: 28,
                        child: Container(
                          width: 1,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFFFC1D2), Color(0xFFCCE3D7), Color(0xFFF1DBA6)],
                            ),
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        for (var i = 0; i < recent.length; i++)
                          _ActivityRow(item: recent[i], showDivider: i < recent.length - 1),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Satu baris aktivitas: ikon, judul, keterangan, jam.
class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item, required this.showDivider});

  final ActivityItem item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    // Ikon & warna ditentukan oleh jenis aktivitas.
    final (AppIcons icon, Color fg, Color bg) = switch (item.type) {
      ActivityType.watering => (AppIcons.water, const Color(0xFFBD4267), const Color(0xFFFFEDF2)),
      ActivityType.saved => (AppIcons.check, const Color(0xFF37775D), const Color(0xFFEDF7F2)),
      ActivityType.light => (AppIcons.sun, const Color(0xFF9B7439), const Color(0xFFFFF5DF)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: showDivider ? const Border(bottom: BorderSide(color: Color(0xFFF2EDEF))) : null,
      ),
      child: Row(
        children: [
          IconBubble(icon: icon, iconColor: fg, background: bg, size: 34, iconSize: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppText.sans(size: 12, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item.subtitle, style: AppText.sans(size: 10.5, color: AppColors.muted)),
              ],
            ),
          ),
          Text(
            AppFormat.time(item.createdAt),
            style: AppText.mono(size: 11, color: const Color(0xFF9B9197)),
          ),
        ],
      ),
    );
  }
}
