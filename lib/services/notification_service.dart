import '../core/app_constants.dart';
import '../core/rtdb_utils.dart';
import '../models/notification_item.dart';
import 'rtdb_paths.dart';

/// Notifikasi di dalam aplikasi, disimpan di **Realtime Database**.
class NotificationService {
  Stream<List<NotificationItem>> watchRecent(String uid) {
    return RtdbPaths.notifications(uid)
        .orderByKey()
        .limitToLast(AppConstants.maxNotifications)
        .onValue
        .map((event) {
      final all = asStringMap(event.snapshot.value);
      final list = [
        for (final entry in all.entries)
          NotificationItem.fromRtdb(entry.key, asStringMap(entry.value)),
      ];
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  /// Menandai semua notifikasi yang belum dibaca menjadi sudah dibaca.
  Future<void> markAllAsRead(String uid) async {
    final snapshot = await RtdbPaths.notifications(uid)
        .orderByKey()
        .limitToLast(AppConstants.maxNotifications)
        .get();

    // Kumpulkan semua perubahan, lalu kirim SEKALIGUS dalam satu update.
    final updates = <String, Object?>{};
    asStringMap(snapshot.value).forEach((key, value) {
      if (asStringMap(value)['isRead'] != true) {
        updates['$key/isRead'] = true;
      }
    });
    if (updates.isEmpty) return;

    await RtdbPaths.notifications(uid).update(updates);
  }
}
