import 'package:flutter/foundation.dart';

/// Nama-nama tab pada navigasi bawah (+ halaman profil yang dibuka dari avatar).
enum AppTab { home, monitor, history, devices, profile }

/// State untuk: tab yang sedang aktif & popover notifikasi.
class NavigationProvider extends ChangeNotifier {
  AppTab _currentTab = AppTab.home;
  bool _isNotificationOpen = false;

  AppTab get currentTab => _currentTab;
  bool get isNotificationOpen => _isNotificationOpen;

  void setTab(AppTab tab) {
    _currentTab = tab;
    _isNotificationOpen = false; // pindah halaman -> tutup popover
    notifyListeners();
  }

  void toggleNotifications() {
    _isNotificationOpen = !_isNotificationOpen;
    notifyListeners();
  }

  void closeNotifications() {
    if (!_isNotificationOpen) return;
    _isNotificationOpen = false;
    notifyListeners();
  }

  /// Dipanggil saat logout agar login berikutnya mulai dari Beranda.
  void reset() {
    _currentTab = AppTab.home;
    _isNotificationOpen = false;
    notifyListeners();
  }
}
