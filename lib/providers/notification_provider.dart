import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/notification_item.dart';
import '../services/notification_service.dart';
import 'user_scoped_provider.dart';

/// State untuk NOTIFIKASI (ikon lonceng di header).
class NotificationProvider extends UserScopedProvider {
  NotificationProvider({NotificationService? service})
      : _service = service ?? NotificationService();

  final NotificationService _service;
  StreamSubscription<List<NotificationItem>>? _subscription;

  List<NotificationItem> _items = [];

  List<NotificationItem> get items => List.unmodifiable(_items);
  int get unreadCount => _items.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;

  @override
  void onUserChanged(String? newUserId) {
    _subscription?.cancel();
    _subscription = null;
    _items = [];
    if (newUserId == null) return;

    _subscription = _service.watchRecent(newUserId).listen(
      (list) {
        _items = list;
        notifyListeners();
      },
      onError: (Object error) => debugPrint('Gagal membaca notifikasi: $error'),
    );
  }

  /// Menandai semua notifikasi sudah dibaca (titik merah di lonceng hilang).
  Future<void> markAllAsRead() async {
    final uid = userId;
    if (uid == null || !hasUnread) return;
    try {
      await _service.markAllAsRead(uid);
    } catch (e) {
      debugPrint('Gagal menandai notifikasi: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
