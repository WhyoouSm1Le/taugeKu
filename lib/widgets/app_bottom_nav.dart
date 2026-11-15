import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_text.dart';
import '../providers/navigation_provider.dart';
import 'app_icon.dart';

/// Navigasi bawah (melayang) dengan 4 tab.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  /// (tab, ikon, label) — tambahkan baris baru di sini untuk menambah tab.
  static const List<(AppTab, AppIcons, String)> _items = [
    (AppTab.home, AppIcons.home, 'Beranda'),
    (AppTab.monitor, AppIcons.pulse, 'Monitor'),
    (AppTab.history, AppIcons.chart, 'Riwayat'),
    (AppTab.devices, AppIcons.device, 'Perangkat'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.select<NavigationProvider, AppTab>((n) => n.currentTab);
    final nav = context.read<NavigationProvider>();

    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 245, 248, 0.95),
        borderRadius: AppRadius.leaf(27, 13),
        border: Border.all(color: const Color.fromRGBO(219, 90, 129, 0.15)),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(115, 42, 69, 0.17), blurRadius: 40, offset: Offset(0, 15)),
        ],
      ),
      child: Row(
        children: [
          for (final item in _items)
            Expanded(
              child: _NavItem(
                icon: item.$2,
                label: item.$3,
                isActive: current == item.$1,
                onTap: () => nav.setTab(item.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final AppIcons icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: 46,
            height: isActive ? 35 : 29,
            transform: Matrix4.translationValues(0, isActive ? -5 : 0, 0),
            decoration: BoxDecoration(
              borderRadius: isActive ? AppRadius.blob(35) : BorderRadius.circular(12),
              gradient: isActive
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE65B84), Color(0xFFAE2856)],
                    )
                  : null,
              boxShadow: isActive
                  ? const [
                      BoxShadow(color: Color.fromRGBO(188, 47, 91, 0.28), blurRadius: 18, offset: Offset(0, 9)),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: AppIcon(
              icon,
              size: 21,
              color: isActive ? Colors.white : const Color(0xFF9B7F89),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: AppText.sans(
              size: 10,
              weight: FontWeight.w700,
              color: isActive ? AppColors.pink700 : const Color(0xFF9B7F89),
            ),
          ),
        ],
      ),
    );
  }
}
