import 'package:flutter/foundation.dart';

enum AppTab { home, monitor, history, devices, profile }

class NavigationProvider extends ChangeNotifier {
  AppTab _currentTab = AppTab.home;
  bool _isNotificationOpen = false;

  AppTab get currentTab => _currentTab;
  bool get isNotificationOpen => _isNotificationOpen;

  void setTab(AppTab tab) {
    _currentTab = tab;
    _isNotificationOpen = false;
    notifyListeners();
  }

  void toggleNotifications() {
    _isNotificationOpen = ! _isNotificationOpen;
    notifyListeners();
  }

  void closeNotifications() {
    if (! _isNotificationOpen) return;
    _isNotificationOpen = false;
    notifyListeners();
  }

  void reset() {
    _currentTab = AppTab.home;
    _isNotificationOpen = false;
    notifyListeners();
  }
}