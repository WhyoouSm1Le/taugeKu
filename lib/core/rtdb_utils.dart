// Alat bantu membaca data mentah dari Realtime Database.
//
// Data dari RTDB datang sebagai `Object?` (bisa Map, angka, teks, atau null).
// Fungsi-fungsi kecil di bawah mengubahnya menjadi tipe yang aman dipakai,
// dan TIDAK melempar error bila datanya kosong atau bentuknya tidak sesuai.

/// Mengubah data RTDB menjadi Map. Jika bukan Map -> Map kosong.
Map<String, dynamic> asStringMap(Object? value) {
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

/// Angka desimal (RTDB bisa mengembalikan int atau double). Bukan angka -> null.
double? asDouble(Object? value) => value is num ? value.toDouble() : null;

/// Bilangan bulat. Bukan angka -> null.
int? asInt(Object? value) => value is num ? value.toInt() : null;

/// Teks. Bukan teks / kosong -> [fallback].
String asString(Object? value, {String fallback = ''}) {
  if (value is String && value.isNotEmpty) return value;
  return fallback;
}

/// Waktu dari milidetik sejak 1970 (epoch ms), format waktu di RTDB. Bukan angka -> null.
DateTime? asDateTime(Object? millis) {
  if (millis is num) return DateTime.fromMillisecondsSinceEpoch(millis.toInt());
  return null;
}
