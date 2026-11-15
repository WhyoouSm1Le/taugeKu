import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_format.dart';
import '../core/app_text.dart';
import '../providers/navigation_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_header.dart';
import '../widgets/app_toast.dart';
import '../widgets/notifications_popover.dart';
import 'dashboard_screen.dart';
import 'devices_screen.dart';
import 'history_screen.dart';
import 'monitor_screen.dart';
import 'profile_screen.dart';

/// Kerangka halaman utama setelah login:
/// header di atas, isi halaman di tengah, navigasi bawah, dan lapisan
/// melayang (popover notifikasi + toast).
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = context.select<NavigationProvider, AppTab>((n) => n.currentTab);
    final isNotificationOpen = context.select<NavigationProvider, bool>((n) => n.isNotificationOpen);
    final firstName = context.select<ProfileProvider, String>((p) => p.firstName);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Teks kecil + judul di bawah header (berbeda tiap tab).
    final (String small, String title) = switch (tab) {
      AppTab.home => (AppFormat.greeting(DateTime.now()), 'Halo, $firstName'),
      AppTab.monitor => ('TaugeKu', 'Monitoring'),
      AppTab.history => ('TaugeKu', 'Riwayat'),
      AppTab.devices => ('TaugeKu', 'Perangkat'),
      AppTab.profile => ('TaugeKu', 'Profil'),
    };

    final Widget screen = switch (tab) {
      AppTab.home => const DashboardScreen(key: ValueKey('home')),
      AppTab.monitor => const MonitorScreen(key: ValueKey('monitor')),
      AppTab.history => const HistoryScreen(key: ValueKey('history')),
      AppTab.devices => const DevicesScreen(key: ValueKey('devices')),
      AppTab.profile => const ProfileScreen(key: ValueKey('profile')),
    };

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  const AppHeader(),
                  // Sapaan (hanya di Beranda).
                  if (tab == AppTab.home)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 2, 22, 14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(small, style: AppText.sans(size: 12, color: const Color(0xFF8B8187))),
                            Text(title, style: AppText.sans(size: 25, weight: FontWeight.w800, letterSpacing: -0.9)),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: tab == AppTab.home ? 0 : 4),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: screen,
                      ),
                    ),
                  ),
                ],
              ),

              // Navigasi bawah
              Positioned(
                left: 12,
                right: 12,
                bottom: 10 + bottomInset,
                child: const AppBottomNav(),
              ),

              // Popover notifikasi + penutup saat area luar disentuh
              if (isNotificationOpen) ...[
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: context.read<NavigationProvider>().closeNotifications,
                    child: const SizedBox.expand(),
                  ),
                ),
                const Positioned(top: 58, right: 17, child: NotificationsPopover()),
              ],

              // Toast (di atas navigasi bawah)
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
