import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../providers/auth_provider.dart';
import '../providers/batch_provider.dart';
import '../providers/device_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/toast_provider.dart';
import '../widgets/app_icon.dart';
import '../widgets/page_title.dart';
import '../widgets/soft_card.dart';
import '../widgets/user_avatar.dart';

/// Halaman PROFIL: foto, data akun, statistik singkat, dan tombol keluar.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _changePhoto(BuildContext context) async {
    final toast = context.read<ToastProvider>();
    final error = await context.read<ProfileProvider>().pickPhoto();
    if (error != null) toast.show(error);
  }

  Future<void> _logout(BuildContext context) async {
    // Reset tab dulu agar login berikutnya mulai dari Beranda.
    context.read<NavigationProvider>().reset();
    await context.read<AuthProvider>().signOut();
  }

  Future<void> _seedDemo(BuildContext context) async {
    final toast = context.read<ToastProvider>();
    final error = await context.read<ProfileProvider>().seedDemoData();
    toast.show(error ?? 'Data contoh berhasil dibuat');
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    final deviceCount = context.watch<DeviceProvider>().devices.length;
    final batchCount = context.watch<BatchProvider>().totalCount;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final joinedYear = profile?.createdAt?.year.toString() ?? '--';

    return ListView(
      padding: EdgeInsets.fromLTRB(17, 0, 17, 110 + bottomInset),
      children: [
        const PageTitle(eyebrow: 'AKUN', title: 'Profil'),

        // ---- Kartu identitas ----
        SoftCard(
          radius: AppRadius.leaf(28, 10),
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
          child: Column(
            children: [
              UserAvatar(
                initials: profileProvider.initials,
                photoBytes: profileProvider.photoBytes,
                size: 84,
                radius: 28,
                background: AppColors.pink50,
                fontSize: 26,
              ),
              const SizedBox(height: 14),
              Text(
                profile?.displayName ?? '-',
                style: AppText.sans(size: 19, weight: FontWeight.w800, letterSpacing: -0.4),
              ),
              const SizedBox(height: 3),
              Text(profile?.email ?? '-', style: AppText.sans(size: 12, color: AppColors.muted)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _changePhoto(context),
                child: Text(
                  'Ganti foto',
                  style: AppText.sans(size: 12, weight: FontWeight.w700, color: AppColors.pink600),
                ),
              ),
              Text(
                'Foto hanya tersimpan sementara dan\nhilang saat keluar atau aplikasi ditutup.',
                textAlign: TextAlign.center,
                style: AppText.sans(size: 10, color: const Color(0xFFA0979C)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---- Statistik ----
        Row(
          children: [
            Expanded(child: _FactCard(label: 'PERANGKAT', value: '$deviceCount')),
            const SizedBox(width: 10),
            Expanded(child: _FactCard(label: 'SIKLUS', value: '$batchCount')),
            const SizedBox(width: 10),
            Expanded(child: _FactCard(label: 'BERGABUNG', value: joinedYear)),
          ],
        ),
        const SizedBox(height: 18),

        // ---- Keluar ----
        GestureDetector(
          onTap: () => _logout(context),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.dangerBg,
              borderRadius: AppRadius.leaf(16, 6),
              border: Border.all(color: const Color(0xFFF6D5DD)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppIcon(AppIcons.logout, size: 18, color: AppColors.danger),
                const SizedBox(width: 8),
                Text('Keluar', style: AppText.sans(size: 14, weight: FontWeight.w800, color: AppColors.danger)),
              ],
            ),
          ),
        ),

        // ---- Hanya tampil saat mode debug ----
        if (kDebugMode) ...[
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => _seedDemo(context),
              child: Text(
                'Isi data contoh (khusus debug)',
                style: AppText.sans(size: 11, weight: FontWeight.w600, color: AppColors.muted),
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        Center(
          child: Text('TaugeKu · v1.0.0', style: AppText.sans(size: 10, color: const Color(0xFFA0979C))),
        ),
      ],
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      radius: AppRadius.leaf(18, 7),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Text(value, style: AppText.mono(size: 20, color: AppColors.pink600)),
          const SizedBox(height: 3),
          Text(
            label,
            style: AppText.sans(size: 8.5, weight: FontWeight.w800, letterSpacing: 0.8, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
