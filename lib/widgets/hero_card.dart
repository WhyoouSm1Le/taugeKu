import 'package:flutter/material.dart';

import '../core/app_text.dart';
import '../models/device_model.dart';
import '../models/planting_batch.dart';
import 'app_icon.dart';

/// Kartu besar berfoto di bagian atas Beranda: siklus tanam yang sedang aktif.
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.batch, required this.device});

  /// Batch aktif (null jika belum ada).
  final PlantingBatch? batch;

  /// Perangkat utama (null jika belum ada perangkat).
  final DeviceModel? device;

  @override
  Widget build(BuildContext context) {
    final isOnline = device?.isOnline ?? false;
    final statusText = device == null
        ? 'Belum ada perangkat'
        : (isOnline ? 'Sistem aktif' : 'Perangkat offline');

    return Container(
      height: 232,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
          bottomRight: Radius.circular(31),
          bottomLeft: Radius.circular(11),
        ),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(28, 54, 41, 0.2), blurRadius: 45, offset: Offset(0, 22)),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Foto latar
          Image.asset('assets/images/tauge.jpg', fit: BoxFit.cover),

          // Lapisan gelap agar teks putih mudah dibaca
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(16, 32, 23, 0.10), Color.fromRGBO(16, 32, 23, 0.82)],
                stops: [0.35, 1.0],
              ),
            ),
          ),

          // Label status & perangkat
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                _Pill(
                  background: const Color.fromRGBO(247, 255, 250, 0.92),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isOnline ? const Color(0xFF3E9B70) : const Color(0xFFA9A2A6),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: AppText.sans(size: 11, weight: FontWeight.w700, color: const Color(0xFF305945)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (device != null)
                  _Pill(
                    background: const Color.fromRGBO(16, 39, 29, 0.55),
                    border: const Color.fromRGBO(255, 255, 255, 0.32),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppIcon(AppIcons.wifi, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          device!.id,
                          style: AppText.sans(size: 11, weight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Judul & progres
          Positioned(
            left: 18,
            right: 18,
            bottom: 17,
            child: _HeroCopy(batch: batch),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child, required this.background, this.border});

  final Widget child;
  final Color background;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: border ?? const Color.fromRGBO(255, 255, 255, 0.32)),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.batch});

  final PlantingBatch? batch;

  @override
  Widget build(BuildContext context) {
    final white70 = AppText.sans(size: 12, color: const Color.fromRGBO(255, 255, 255, 0.85));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SIKLUS AKTIF',
          style: AppText.sans(
            size: 10,
            weight: FontWeight.w700,
            letterSpacing: 0.8,
            color: const Color.fromRGBO(255, 255, 255, 0.78),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          batch?.name ?? 'Belum ada siklus aktif',
          style: AppText.sans(size: 22, weight: FontWeight.w800, letterSpacing: -0.6, color: Colors.white),
        ),
        const SizedBox(height: 4),
        if (batch != null)
          Row(
            children: [
              Text('Hari ke-', style: white70),
              Text(
                '${batch!.currentDay}',
                style: AppText.sans(size: 12, weight: FontWeight.w800, color: Colors.white),
              ),
              Text(' dari ${batch!.cycleDays}  ·  ${batch!.harvestText}', style: white70),
            ],
          )
        else
          Text('Tambahkan batch tanam untuk memulai', style: white70),
        const SizedBox(height: 11),
        // Batang progres
        Container(
          height: 6,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.25),
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: (batch?.progress ?? 0).clamp(0.0, 1.0).toDouble(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: const LinearGradient(colors: [Color(0xFFFF99B6), Color(0xFFFFD7A7)]),
                boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(255, 177, 198, 0.7), blurRadius: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
