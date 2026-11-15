# 05 — Panduan Kode untuk Pemula Flutter/Dart

Dokumen ini untuk Anda (atau rekan) yang **belum pernah memakai Flutter**. Tidak perlu menghafal;
gunakan sebagai kamus saat membaca kode.

## Daftar isi
1. [Cara berpikir di Flutter](#1-cara-berpikir-di-flutter)
2. [Dasar Dart yang sering muncul](#2-dasar-dart-yang-sering-muncul)
3. [Widget yang paling sering dipakai](#3-widget-yang-paling-sering-dipakai)
4. [Membaca satu file dari atas ke bawah](#4-membaca-satu-file-dari-atas-ke-bawah)
5. [Async, Future, dan Stream](#5-async-future-dan-stream)
6. [Resep: cara mengubah sesuatu](#6-resep-cara-mengubah-sesuatu)
7. [Resep: cara menambah halaman/tab baru](#7-resep-cara-menambah-halamantab-baru)
8. [Resep: cara menambah field data baru](#8-resep-cara-menambah-field-data-baru)
9. [Perintah Flutter yang sering dipakai](#9-perintah-flutter-yang-sering-dipakai)
10. [Kamus istilah](#10-kamus-istilah)

---

## 1. Cara berpikir di Flutter

> **"Semuanya adalah widget, dan layar adalah pohon widget."**

Sebuah tampilan dibangun dengan menumpuk widget kecil menjadi widget besar:

```
Scaffold (halaman)
 └─ Column (susunan vertikal)
     ├─ Text('Halo')
     └─ Row (susunan horizontal)
         ├─ Icon(...)
         └─ Text('Suhu')
```

Saat data berubah, Flutter **menggambar ulang** widget yang terkait (fungsi `build()` dipanggil lagi).
Anda tidak mengubah tampilan secara manual; Anda **mengubah data**, lalu tampilan mengikuti.

Dua jenis widget:

| Jenis | Kapan | Contoh di project |
|---|---|---|
| `StatelessWidget` | Tampilan hanya bergantung pada parameter/Provider | `DashboardScreen`, `SoftCard` |
| `StatefulWidget` | Perlu menyimpan state lokal yang berubah | `MonitorScreen` (sensor terpilih), `LoginScreen` (lihat password) |

---

## 2. Dasar Dart yang sering muncul

```dart
// Variabel
final nama = 'Admin';          // tidak bisa diganti setelah diisi
var jumlah = 3;                // bisa diganti
const pi = 3.14;               // konstanta waktu kompilasi

// Tipe nullable: tanda ? artinya "boleh kosong (null)"
String? foto;                  // bisa null
int panjang = foto?.length ?? 0;
//   ?.  = "jika tidak null, ambil"      ??  = "jika null, pakai nilai ini"
//   foto!  = "saya yakin ini tidak null" (hati-hati, crash jika ternyata null)

// String dengan variabel
Text('Halo, $nama');                    // sederhana
Text('Suhu ${suhu.toStringAsFixed(1)}'); // ekspresi pakai { }

// Fungsi
int tambah(int a, int b) => a + b;      // gaya ringkas (panah)

// Parameter bernama (paling sering di Flutter)
Text('Halo', style: TextStyle(fontSize: 12));
//          ↑ posisi        ↑ bernama

// Kondisi di dalam daftar widget
Column(children: [
  Text('A'),
  if (tampil) Text('B'),                 // muncul hanya bila tampil == true
  for (final item in daftar) Text(item), // ulangi untuk tiap item
]);

// Switch expression (Dart 3)
final pesan = switch (hasil) {
  Hasil.sukses => 'Berhasil',
  Hasil.gagal  => 'Gagal',
};

// Enum (daftar pilihan tetap)
enum AppTab { home, monitor, history }
```

### Class dan constructor
```dart
class DeviceModel {
  const DeviceModel({required this.id, required this.name});  // constructor
  final String id;      // properti
  final String name;
}
final d = DeviceModel(id: 'WMS-001', name: 'Tauge Utama');
```
`required` = wajib diisi saat membuat objek. `this.id` = langsung simpan ke properti `id`.

---

## 3. Widget yang paling sering dipakai

| Widget | Fungsi | Analogi web |
|---|---|---|
| `Text` | Teks | `<span>` |
| `Container` | Kotak dengan warna, padding, sudut, bayangan | `<div>` |
| `Row` / `Column` | Susun horizontal / vertikal | `display:flex` |
| `Expanded` | Isi sisa ruang di Row/Column | `flex: 1` |
| `Stack` + `Positioned` | Tumpuk widget | `position:absolute` |
| `Padding` | Jarak dalam | `padding` |
| `SizedBox` | Jarak kosong / ukuran tetap | `margin` / `width,height` |
| `ListView` | Daftar yang bisa di-scroll | `overflow:auto` |
| `GestureDetector` | Mendeteksi sentuhan (`onTap`) | `onClick` |
| `ElevatedButton` | Tombol | `<button>` |
| `TextFormField` | Kolom isian | `<input>` |
| `Image.asset` | Gambar dari folder `assets/` | `<img>` |
| `CircularProgressIndicator` | Indikator memuat | spinner |

Referensi resmi bergambar: https://docs.flutter.dev/ui/widgets

---

## 4. Membaca satu file dari atas ke bawah

Ambil `lib/widgets/soft_card.dart` sebagai contoh:

```dart
import 'package:flutter/material.dart';     // 1. impor pustaka yang dipakai

class SoftCard extends StatelessWidget {    // 2. widget tanpa state
  const SoftCard({super.key, required this.child});   // 3. constructor + parameter
  final Widget child;                       // 4. isi kartu (dari pemanggil)

  @override
  Widget build(BuildContext context) {      // 5. "resep tampilan"
    return Container(                       // 6. kembalikan pohon widget
      decoration: BoxDecoration(color: Colors.white),
      child: child,
    );
  }
}
```

Pemakaian: `SoftCard(child: Text('Isi'))`.

**Tips membaca:** mulai dari fungsi `build()`, baca dari luar ke dalam. Widget terluar = bingkai, terdalam = isi.

---

## 5. Async, Future, dan Stream

Mengambil data dari internet **butuh waktu**, jadi tidak langsung selesai.

```dart
// Future = "janji hasil di masa depan" (satu kali)
Future<void> simpan() async {
  await FirebaseFirestore.instance.collection('x').add({...});  // tunggu selesai
  print('Selesai');                                             // baru jalan setelahnya
}

// Stream = "aliran hasil berkali-kali" (realtime)
stream.listen((data) {
  print('Data baru: $data');        // dipanggil SETIAP data berubah
});
```

| Istilah | Arti |
|---|---|
| `async` / `await` | Menandai fungsi yang menunggu pekerjaan lambat |
| `Future` | Hasil tunggal yang akan datang |
| `Stream` | Hasil berulang (dipakai untuk data realtime Firebase) |
| `StreamSubscription` | "Langganan" ke stream; harus di-`cancel()` bila tidak dipakai |

### Aturan penting: `context` setelah `await`
```dart
Future<void> _simpan(BuildContext context) async {
  final toast = context.read<ToastProvider>();   // ambil SEBELUM await
  await sesuatu();
  toast.show('Selesai');                         // aman
  // Jika harus memakai context lagi: cek dulu
  if (!context.mounted) return;
}
```
Alasannya: setelah menunggu, layar mungkin sudah ditutup; memakai `context` yang sudah mati menimbulkan error.

---

## 6. Resep: cara mengubah sesuatu

| Ingin mengubah | Buka file | Cari |
|---|---|---|
| Warna | `core/app_colors.dart` | nama warna, ubah kode `0xFF......` |
| Rentang suhu ideal | `core/app_constants.dart` | `idealTempMin`, `idealTempMax` |
| Lama pompa menyala | `core/app_constants.dart` | `wateringSeconds` (ubah juga program Wemos) |
| Jadwal siram yang tampil | `core/app_constants.dart` | `autoWateringTimes` |
| Lama satu siklus (4 hari) | `core/app_constants.dart` | `defaultCycleDays` |
| Teks tombol/judul | `screens/...` atau `widgets/...` | cari teksnya (Ctrl+Shift+F di VS Code) |
| Domain email login | `services/auth_service.dart` | `usernameDomain` |
| Jumlah titik grafik | `core/app_constants.dart` | `maxChartPoints` |
| Font | `core/app_text.dart` | `GoogleFonts.plusJakartaSans` |

---

## 7. Resep: cara menambah halaman/tab baru

Contoh: halaman **"Pengaturan"**.

1. **Buat layar** `lib/screens/settings_screen.dart`:
   ```dart
   class SettingsScreen extends StatelessWidget {
     const SettingsScreen({super.key});
     @override
     Widget build(BuildContext context) => const Center(child: Text('Pengaturan'));
   }
   ```
2. **Tambah nama tab** di `providers/navigation_provider.dart`: `enum AppTab { home, ..., settings }`.
3. **Daftarkan di `screens/main_shell.dart`**: tambahkan satu baris pada dua `switch` (judul & layar) —
   kompilator akan menandai tempat yang terlewat karena `switch` harus lengkap.
4. **(Opsional) Tab navigasi bawah:** tambah satu baris di `_items` pada `widgets/app_bottom_nav.dart`.

---

## 8. Resep: cara menambah field data baru

Contoh: menambah field **`pH`** pada data sensor.

1. **Model** — `models/sensor_reading.dart`: tambahkan `final double ph;`, isi di constructor, dan baca di `fromFirestore`:
   `ph: (data['ph'] as num?)?.toDouble() ?? 0,`
2. **Wemos** — kirim field `ph` ke dokumen `readings` (lihat dokumen 06).
3. **Tampilan** — pakai `reading.ph` di widget yang diinginkan.
4. **Aturan keamanan** — tidak perlu diubah (aturan berlaku untuk seluruh dokumen pengguna).

RTDB dan Firestore tidak punya "skema tabel" yang kaku, jadi tidak ada migrasi database.

---

## 9. Perintah Flutter yang sering dipakai

| Perintah | Fungsi |
|---|---|
| `flutter pub get` | Mengunduh paket di `pubspec.yaml` |
| `flutter run` | Menjalankan aplikasi |
| `r` (di terminal saat `flutter run`) | **Hot reload**: terapkan perubahan kode tanpa memulai ulang |
| `R` | **Hot restart**: mulai ulang aplikasi (state hilang) |
| `flutter analyze` | Mencari error/peringatan kode |
| `flutter test` | Menjalankan unit test |
| `flutter clean` | Membersihkan cache build (obat saat build aneh) |
| `flutter doctor` | Mengecek kesehatan instalasi |
| `dart format lib` | Merapikan format kode |

> Hot reload tidak menerapkan perubahan pada `main()`, nilai `const` global, atau `initState` — gunakan hot restart.

---

## 10. Kamus istilah

| Istilah | Arti sederhana |
|---|---|
| **Widget** | Potongan tampilan |
| **BuildContext** | "Posisi" widget di pohon; dipakai untuk mengambil Provider, tema, ukuran layar |
| **State** | Data yang bisa berubah dan memengaruhi tampilan |
| **Provider** | Pustaka untuk membagi state ke banyak layar |
| **ChangeNotifier** | Kelas dasar state yang dapat memberi tahu pendengarnya |
| **notifyListeners()** | "Data berubah, gambar ulang!" |
| **Stream** | Aliran data realtime |
| **Realtime Database (RTDB)** | Database cloud Firebase berbentuk pohon JSON, cepat untuk data "saat ini" |
| **Firestore** | Database cloud Firebase berbentuk koleksi & dokumen, cocok untuk riwayat dan kueri |
| **Collection / Document** | "Folder" / "berkas" di Firestore |
| **Node** | "Cabang" pada pohon data RTDB |
| **Model** | Kelas penyimpan data |
| **Service** | Kelas yang berbicara dengan layanan luar (Firebase) |
| **Hot reload** | Perubahan kode tampil dalam <1 detik |
| **Null safety** | Fitur Dart agar variabel tidak sembarang kosong (tanda `?` dan `!`) |
| **Immutable** | Tidak berubah setelah dibuat (`final`, `const`) |
