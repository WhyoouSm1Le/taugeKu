import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_format.dart';
import '../core/app_text.dart';
import '../models/planting_batch.dart';
import 'app_icon.dart';

/// Kartu batch yang SEDANG BERJALAN (ada foto, statistik, dan progres).
class ActiveBatchCard extends StatelessWidget {
  const ActiveBatchCard({super.key, required this.batch, this.onMore});

  final PlantingBatch batch;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final percent = (batch.progress * 100).round();

    return _BatchCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto + label AKTIF
          SizedBox(
            height: 145,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/tauge.jpg', fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Color.fromRGBO(20, 33, 25, 0), Color.fromRGBO(20, 33, 25, 0.35)],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      'AKTIF',
                      style: AppText.sans(
                        size: 9,
                        weight: FontWeight.w800,
                        letterSpacing: 0.7,
                        color: const Color(0xFF3B755C),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(batch.code, style: AppText.mono(size: 10, color: AppColors.pink600)),
                          const SizedBox(height: 3),
                          Text(batch.name, style: AppText.sans(size: 16, weight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onMore,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: AppIcon(AppIcons.more, size: 20, color: Color(0xFF887E85)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      _Stat(
                        icon: AppIcons.calendar,
                        title: 'Hari ke-${batch.currentDay}',
                        subtitle: 'Mulai ${AppFormat.dayMonth(batch.startDate)}',
                      ),
                      _Stat(
                        icon: AppIcons.water,
                        title: '${batch.wateringCount} kali',
                        subtitle: 'Penyiraman',
                      ),
                      _Stat(
                        icon: AppIcons.pulse,
                        title: AppFormat.thousands(batch.sensorCount),
                        subtitle: 'Data sensor',
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text('Progres tanam', style: AppText.sans(size: 11, color: AppColors.muted)),
                    const Spacer(),
                    Text('$percent%', style: AppText.sans(size: 11, weight: FontWeight.w800, color: AppColors.pink600)),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: batch.progress.clamp(0.0, 1.0).toDouble(),
                    minHeight: 5,
                    backgroundColor: const Color(0xFFF0E7EA),
                    valueColor: const AlwaysStoppedAnimation(AppColors.pink500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu batch yang SUDAH SELESAI (ringkas, tanpa foto).
class FinishedBatchCard extends StatelessWidget {
  const FinishedBatchCard({super.key, required this.batch});

  final PlantingBatch batch;

  @override
  Widget build(BuildContext context) {
    final end = batch.endDate;

    return _BatchCardShell(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${batch.code} · SELESAI',
                        style: AppText.mono(size: 10, color: AppColors.pink600),
                      ),
                      const SizedBox(height: 3),
                      Text(batch.name, style: AppText.sans(size: 15, weight: FontWeight.w800)),
                    ],
                  ),
                ),
                if (end != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppFormat.duration(batch.startDate, end),
                      style: AppText.mono(size: 10, weight: FontWeight.w500, color: AppColors.successText),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${AppFormat.dateRange(batch.startDate, end)} · ${AppFormat.thousands(batch.sensorCount)} data sensor',
              style: AppText.sans(size: 11, color: AppColors.muted),
            ),
            const SizedBox(height: 11),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F7),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Suhu rata-rata',
                      value: batch.avgTemperature == null
                          ? '--'
                          : '${batch.avgTemperature!.toStringAsFixed(1)}°C',
                    ),
                  ),
                  Expanded(
                    child: _MiniStat(
                      label: 'Kelembapan',
                      value: batch.avgHumidity == null ? '--' : '${batch.avgHumidity!.round()}%',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bingkai putih bersama untuk kedua jenis kartu batch.
class _BatchCardShell extends StatelessWidget {
  const _BatchCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color.fromRGBO(84, 55, 65, 0.07)),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(67, 43, 52, 0.07), blurRadius: 32, offset: Offset(0, 13)),
        ],
      ),
      child: child,
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
  });

  final AppIcons icon;
  final String title;
  final String subtitle;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 4),
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          border: showDivider ? const Border(right: BorderSide(color: AppColors.line)) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon(icon, size: 16, color: AppColors.pink500),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.sans(size: 11, weight: FontWeight.w800)),
                  const SizedBox(height: 1),
                  Text(subtitle, style: AppText.sans(size: 9.5, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.sans(size: 10, color: AppColors.muted)),
        const SizedBox(height: 2),
        Text(value, style: AppText.mono(size: 13, color: const Color(0xFF544A51))),
      ],
    );
  }
}
