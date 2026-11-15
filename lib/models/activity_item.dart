import '../core/rtdb_utils.dart';

/// Jenis aktivitas (menentukan ikon & warna di daftar aktivitas).
enum ActivityType { watering, saved, light }

/// Satu baris di daftar "Aktivitas hari ini".
///
/// Tersimpan di **Realtime Database**: `users/{uid}/activities/{pushId}`
class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String title; // contoh "Penyiraman otomatis"
  final String subtitle; // contoh "10 detik"
  final ActivityType type;
  final DateTime createdAt;

  factory ActivityItem.fromRtdb(String id, Map<String, dynamic> data) {
    return ActivityItem(
      id: id,
      title: asString(data['title'], fallback: '-'),
      subtitle: asString(data['subtitle']),
      type: _typeFromText(data['type'] as String?),
      createdAt: asDateTime(data['at']) ?? DateTime.now(),
    );
  }

  /// Mengubah teks dari database ("watering") menjadi enum.
  static ActivityType _typeFromText(String? text) {
    switch (text) {
      case 'watering':
        return ActivityType.watering;
      case 'light':
        return ActivityType.light;
      default:
        return ActivityType.saved;
    }
  }
}
