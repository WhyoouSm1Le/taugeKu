import '../core/rtdb_utils.dart';

/// Jenis notifikasi: 'info' (biasa) atau 'warning' (peringatan, warna kuning).
enum NotificationType { info, warning }

/// Satu notifikasi di popover lonceng.
///
/// Tersimpan di **Realtime Database**: `users/{uid}/notifications/{pushId}`
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String title; // contoh "Penyiraman selesai"
  final String message; // contoh "Batch 01 · 10 detik"
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  factory NotificationItem.fromRtdb(String id, Map<String, dynamic> data) {
    return NotificationItem(
      id: id,
      title: asString(data['title'], fallback: '-'),
      message: asString(data['message']),
      type: data['type'] == 'warning' ? NotificationType.warning : NotificationType.info,
      createdAt: asDateTime(data['at']) ?? DateTime.now(),
      isRead: data['isRead'] == true,
    );
  }
}
