import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/toast_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_toast.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = context.select<NavigationProvider, AppTab>((n) => n.currentTab);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final Widget screen = switch (tab) {
      AppTab.home => const _PlaceholderTab(title: 'Halaman Beranda (Coming Soon)'),
      AppTab.monitor => const _PlaceholderTab(title: 'Halaman Monitoring (Coming Soon)'),
      AppTab.history => const _PlaceholderTab(title: 'Halaman Riwayat (Coming Soon)'),
      AppTab.devices => const _PlaceholderTab(title: 'Halaman Perangkat (Coming Soon)'),
      AppTab.profile => const _PlaceholderTab(title: 'Halaman Profil (Coming Soon)'),
    };

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Isi halaman utama
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: KeyedSubtree(key: ValueKey(tab), child: screen),
                ),
              ),

              // Navigasi bawah melayang
              Positioned(
                left: 12,
                right: 12,
                bottom: 10 + bottomInset,
                child: const AppBottomNav(),
              ),

              // Toast melayang di atas navigasi bawah
              Positioned(
                left: 30,
                right: 30,
                bottom: 91 + bottomInset,
                child: const IgnorePointer(child: AppToast()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ToastProvider>().show('Toast dari $title'),
            child: const Text('Tes Toast'),
          ),
          TextButton(
            onPressed: () => context.read<AuthProvider>().signOut(),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}