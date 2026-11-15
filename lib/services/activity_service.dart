import '../core/rtdb_utils.dart';
import '../models/activity_item.dart';
import 'rtdb_paths.dart';

/// Membaca daftar aktivitas dari **Realtime Database**: `users/{uid}/activities`.
class ActivityService {
  /// Aktivitas terbaru lebih dulu, dibatasi [limit] item.
  ///
  /// `orderByKey` + `limitToLast`: kunci "push id" Firebase berurutan menurut waktu,
  /// jadi tidak perlu membuat index khusus.
  Stream<List<ActivityItem>> watchRecent(String uid, {int limit = 10}) {
    return RtdbPaths.activities(uid).orderByKey().limitToLast(limit).onValue.map((event) {
      final all = asStringMap(event.snapshot.value);
      final list = [
        for (final entry in all.entries)
          ActivityItem.fromRtdb(entry.key, asStringMap(entry.value)),
      ];
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }
}
