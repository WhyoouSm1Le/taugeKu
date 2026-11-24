# TaugeKu — Aplikasi Monitoring Tauge IoT (Flutter + Firebase)

Aplikasi mobile untuk memantau dan menyiram tanaman tauge secara jarak jauh.
Perangkat keras: **Wemos D1 Mini** (sensor suhu, kelembapan, cahaya + pompa).
Aplikasi ini adalah hasil konversi desain web (Figma Make / React) ke **Flutter**.

| Hal | Pilihan |
|---|---|
| Framework | Flutter (Dart) |
| State management | **Provider** |
| Backend | **Firebase**: Authentication, **Realtime Database** (data saat ini), **Cloud Firestore** (riwayat) |
| Platform target | Android & iOS |

## Fitur

| Halaman | Isi |
|---|---|
| **Login** | Masuk dengan Firebase Authentication |
| **Beranda** | Siklus tanam aktif, suhu/kelembapan/cahaya terkini, tombol **Siram**, aktivitas terbaru |
| **Monitoring** | Gauge suhu & kelembapan, grafik tren (hari ini / 7 / 30 hari), status kondisi, data sensor terbaru |
| **Riwayat** | Daftar siklus tanam (aktif & selesai) dengan filter |
| **Perangkat** | Tambah, ubah, hapus perangkat Wemos |
| **Profil** | Data akun, foto profil sementara (tidak tersimpan), keluar |
| **Notifikasi** | Lonceng di header (popover) |

## Mulai cepat (ringkas)

> Langkah rinci dan penjelasannya ada di [`docs/01-PERSIAPAN-DAN-INSTALASI.md`](docs/01-PERSIAPAN-DAN-INSTALASI.md).

```bash
# 1. Buat project Flutter kosong (menghasilkan folder android/ dan ios/)
flutter create taugeku --org id.taugeku --platforms=android,ios

# 2. Salin isi folder ini ke project tersebut (timpa jika diminta):
#    lib/  test/  assets/  pubspec.yaml  analysis_options.yaml
#    firestore.rules  database.rules.json  firebase.json

# 3. Buat Realtime Database & Firestore di Firebase Console, LALU hubungkan
#    (membuat lib/firebase_options.dart)
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Ambil dependensi lalu jalankan
flutter pub get
flutter run
```

## Dokumentasi

| No | Dokumen | Untuk siapa / isinya |
|---|---|---|
| 1 | [Persiapan & Instalasi](docs/01-PERSIAPAN-DAN-INSTALASI.md) | Install tools, setup Firebase, menjalankan aplikasi |
| 2 | [Arsitektur & Struktur Project](docs/02-ARSITEKTUR-DAN-STRUKTUR-PROJECT.md) | Peta folder, alur data, penjelasan Provider |
| 3 | [Firebase & Database](docs/03-FIREBASE-DAN-DATABASE.md) | Pembagian RTDB vs Firestore, struktur data, aturan keamanan, biaya |
| 4 | [Pemetaan React → Flutter](docs/04-PEMETAAN-REACT-KE-FLUTTER.md) | Komponen web ↔ file Flutter, perbedaan dari desain |
| 5 | [Panduan Kode untuk Pemula](docs/05-PANDUAN-KODE-UNTUK-PEMULA.md) | Dasar Dart/Flutter yang dipakai, cara menambah fitur |
| 6 | [Integrasi IoT (Wemos)](docs/06-INTEGRASI-IOT-WEMOS.md) | Format data yang harus dikirim/dibaca Wemos (RTDB + Firestore) |
| 7 | [Troubleshooting & FAQ](docs/07-TROUBLESHOOTING-DAN-FAQ.md) | Masalah umum dan solusinya |
| 8 | [Rencana Mengajar (Live Coding)](docs/08-RENCANA-MENGAJAR-LIVE-CODING.md) | Untuk mentor: 12 sesi bertahap untuk pemula total, tiap sesi ada hasilnya |

> Diagram di dokumentasi berupa gambar SVG (`docs/images/`) yang dibuat oleh skrip di `tools/diagrams/`.
> Teks aslinya tetap ada di bagian lipat **"Versi teks (untuk disalin)"** di bawah tiap gambar.

**Urutan baca yang disarankan untuk orang yang baru mengenal Flutter:**
`01` → `05` → `02` → `03` → `04` → `06` → `07`.

## Catatan penting

* Project ini **belum dikompilasi** oleh penulisnya (lingkungan penulisan tidak memiliki Flutter SDK).
  Sebelum diserahkan, jalankan `flutter pub get`, `flutter analyze`, dan `flutter test`,
  lalu perbaiki peringatan kecil bila ada. Lihat bagian "Verifikasi" di dokumen 01.
* File `lib/firebase_options.dart` hanyalah **placeholder** sampai Anda menjalankan `flutterfire configure`.
* Jangan membagikan file `google-services.json` / `GoogleService-Info.plist` di repositori publik.
