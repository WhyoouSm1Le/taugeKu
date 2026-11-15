import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/activity_item.dart';
import '../services/activity_service.dart';
import 'user_scoped_provider.dart';

/// State untuk DAFTAR AKTIVITAS di Beranda.
class ActivityProvider extends UserScopedProvider {
  ActivityProvider({ActivityService? service}) : _service = service ?? ActivityService();

  final ActivityService _service;
  StreamSubscription<List<ActivityItem>>? _subscription;

  List<ActivityItem> _items = [];

  /// 3 aktivitas terbaru untuk ditampilkan di Beranda.
  List<ActivityItem> get recent => _items.take(3).toList();

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
      onError: (Object error) => debugPrint('Gagal membaca aktivitas: $error'),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
