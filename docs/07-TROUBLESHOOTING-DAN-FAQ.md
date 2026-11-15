# 07 — Troubleshooting & FAQ

## Daftar isi
1. [Masalah saat instalasi/build](#masalah-saat-instalasibuild)
2. [Konflik versi paket](#konflik-versi-paket)
3. [Masalah Firebase](#masalah-firebase)
4. [Masalah tampilan & data](#masalah-tampilan--data)
5. [Masalah kode (error umum Flutter)](#masalah-kode-error-umum-flutter)
6. [FAQ](#faq)

---

## Masalah saat instalasi/build

| Gejala | Penyebab | Solusi |
|---|---|---|
| `Firebase belum dikonfigurasi` saat aplikasi dibuka | `firebase_options.dart` masih placeholder | Jalankan `flutterfire configure` |
| `flutterfire: command not found` | PATH Dart global belum diset | Tambahkan `~/.pub-cache/bin` (Windows: `%LOCALAPPDATA%\Pub\Cache\bin`) ke PATH |
| Build Android: `minSdkVersion ... cannot be smaller` | minSdk terlalu rendah | Set `minSdk = 23` di `android/app/build.gradle(.kts)` |
| Build Android: `google-services.json is missing` | Konfigurasi Firebase Android belum terpasang | Jalankan ulang `flutterfire configure`, pilih android |
| `pod install` gagal (iOS) | Versi iOS minimum terlalu rendah / repo pod usang | Set `platform :ios, '15.0'` (atau sesuai pesan error), lalu `pod repo update` |
| Build aneh setelah ganti paket | Cache lama | `flutter clean && flutter pub get` |

## Konflik versi paket

Jika `flutter pub get` menolak karena versi tidak cocok:

1. Jalankan `flutter pub upgrade --major-versions` untuk menaikkan semua paket ke versi terbaru yang cocok.
2. Atau tambahkan ulang paket Firebase dengan versi otomatis:
   ```bash
   flutter pub add firebase_core firebase_auth firebase_database cloud_firestore
   ```
   Paket-paket FlutterFire dirilis **bersamaan sebagai satu set**; biarkan `pub` memilih set yang kompatibel.
3. Setelah menaikkan versi **mayor**, baca *changelog* paket tersebut dan jalankan `flutter analyze`.

> Saat dokumen ini ditulis, `pubspec.yaml` memakai batas bawah `firebase_core ^4`, `firebase_auth ^6`,
> `firebase_database ^12`, `cloud_firestore ^6`. Versi mayor yang lebih baru mungkin sudah tersedia.

---

## Masalah Firebase

| Gejala | Penyebab | Solusi |
|---|---|---|
| Login: "Username atau password salah" padahal benar | Pengguna belum dibuat / email berbeda | Pastikan di Console ada `admin@taugeku.id`. Ingat: username `admin` → `admin@taugeku.id` |
| Login: "Tidak ada koneksi internet" | Emulator offline | Cek internet emulator/HP |
| Login berhasil tetapi Beranda/Perangkat kosong atau error | Aturan **RTDB** belum dipasang atau menolak | Publish `database.rules.json`; lihat log `flutter run` untuk `permission-denied` |
| Riwayat / grafik kosong atau error | Aturan **Firestore** belum dipasang atau menolak | Publish `firestore.rules` |
| Log: `Firebase Database ... databaseURL` / aplikasi tidak bisa terhubung ke RTDB | RTDB belum dibuat saat `flutterfire configure` dijalankan | Buat Realtime Database (dokumen 01, 2.3), lalu jalankan `flutterfire configure` lagi; pastikan `databaseURL` ada di `firebase_options.dart` |
| Halaman Perangkat menampilkan "Firebase • Offline" | Aplikasi tidak tersambung ke RTDB | Cek internet; cek `databaseURL` |
| Log: `permission-denied` | Aturan menolak | Pastikan login dan data berada di `users/{uid}` milik akun yang sama |
| Log: `The query requires an index` | Kueri gabungan butuh composite index | Klik tautan di pesan error untuk membuat index |
| Foto profil hilang setelah logout / aplikasi ditutup | **Memang disengaja**: foto hanya disimpan sementara di memori | Tidak ada yang perlu diperbaiki. (Menyimpannya permanen memerlukan Cloud Storage yang berbayar atau penyimpanan lokal di perangkat) |
| Tombol Siram: "Wemos belum merespons" | Wemos belum online / tidak memantau node `command` | Lihat dokumen 06 bagian 3.3 |
| Tombol Siram: "Tidak ada koneksi internet" | Aplikasi tidak tersambung ke RTDB | Cek internet. Ditolak sengaja agar perintah tidak mengantre |
| Tombol Siram: "Perangkat sedang offline" | `sensor/isOnline = false` | Ubah status lewat form Edit, atau Wemos menulis `isOnline: true` |
| Refresh: "Gagal memperbarui" | Tidak ada koneksi ke server (batas tunggu 10 detik) | Cek internet. Tombol ini sengaja membaca dari server |

## Masalah tampilan & data

| Gejala | Penyebab | Solusi |
|---|---|---|
| Font tampak berbeda saat pertama kali | Font diunduh dulu | Online saat pertama dibuka; setelah itu tersimpan |
| Beranda menampilkan `--` | Belum ada perangkat atau perangkat belum punya data | Tambah perangkat / jalankan Wemos / isi data contoh |
| Grafik: "Belum ada data sensor untuk rentang ini" | Belum ada `readings` di **Firestore** pada rentang itu (rekaman terjadwal), atau `createdAt` bukan timestamp | Pastikan Wemos menulis `readings` (dokumen 06, bagian 4); cek `createdAt` bertipe timestamp |
| Gauge/Beranda hidup tetapi grafik kosong | Data realtime (RTDB) dan riwayat (Firestore) adalah dua jalur terpisah | Normal bila Wemos baru menulis ke RTDB. Rekaman Firestore baru muncul setelah interval pertama (15–30 menit) |
| Batch tidak muncul | Field `startDate` hilang | `startDate` wajib ada (dipakai `orderBy`) |
| Angka salah di "Hari ke-N" | `startDate` atau zona waktu | `currentDay` dihitung dari tanggal lokal HP |
| Tombol "Isi data contoh" tidak ada | Build rilis | Tombol hanya ada di mode debug (`flutter run`) |
| Data contoh ditambah dua kali | Tombol ditekan berulang | Data perangkat/batch memakai ID tetap (tertimpa), tetapi `readings`/aktivitas/notifikasi bertambah. Hapus manual lewat Console |

## Masalah kode (error umum Flutter)

| Pesan error | Arti | Solusi |
|---|---|---|
| `Could not find the correct Provider<X> above this Widget` | Provider tidak terdaftar / `context` di luar `MultiProvider` | Pastikan terdaftar di `lib/app.dart`; jangan memakai `context` dari luar pohon widget |
| `setState() or markNeedsBuild() called during build` | `notifyListeners()` dipanggil saat layar sedang digambar | Jangan panggil `notifyListeners()` di `onUserChanged` / `setTarget` secara langsung |
| `Looking up a deactivated widget's ancestor is unsafe` | Memakai `context` setelah layar ditutup | Ambil Provider **sebelum** `await`, atau cek `context.mounted` |
| `A RenderFlex overflowed by N pixels` | Isi lebih lebar/tinggi dari ruang | Bungkus dengan `Expanded`/`Flexible`/`SingleChildScrollView`, atau kecilkan ukuran |
| `Bad state: No element` | `firstWhere` tanpa hasil | Pakai `firstWhereOrNull` atau berikan `orElse` |
| Peringatan `'X' is deprecated` | API lama di versi Flutter baru | Ikuti saran penggantian di pesan. Contoh bila `inputDecorationTheme` dikeluhkan: gunakan `InputDecorationThemeData` di `lib/core/app_theme.dart` |

---

## FAQ

**Apakah aplikasi bisa jalan di web/desktop?**
Dirancang untuk Android & iOS. Kode tidak memakai `dart:io`, sehingga *mungkin* bisa di web, tetapi belum diuji
dan tidak dikonfigurasi (`flutterfire configure` perlu menyertakan platform web).

**Bagaimana membuat pengguna baru?**
Lewat Firebase Console → Authentication → Add user. Aplikasi tidak memiliki layar pendaftaran (tidak ada di desain).

**Bagaimana mengganti nama yang tampil di profil?**
Nama diambil dari akun Firebase Authentication; jika `displayName` akun kosong, aplikasi memakai bagian depan email (mis. `admin@taugeku.id` → "Admin"). Layar edit nama belum ada.

**Kenapa memakai Provider, bukan Riverpod/Bloc?**
Sesuai permintaan, dan Provider adalah yang paling mudah dipelajari pemula. Strukturnya (service → provider → layar)
juga mudah dipindahkan ke solusi lain.

**Bagaimana mengganti warna tema?**
`lib/core/app_colors.dart`.

**Bagaimana mengubah logo/ikon aplikasi?**
Gunakan paket `flutter_launcher_icons` dengan gambar `assets/images/favicon.png` (ikon dari desain web).

**Bagaimana mengganti nama paket (`id.taugeku.taugeku`)?**
Gunakan `flutter create --org <domain-anda>` saat membuat project (dokumen 01), atau paket `rename`.

**Kenapa tidak ada Cloud Storage?**
Layanan itu mensyaratkan paket berbayar (Blaze) pada ketentuan Firebase saat dokumen ini ditulis. Foto profil karenanya hanya disimpan sementara di memori. Jika suatu hari Anda berlangganan Blaze, penyimpanan foto bisa ditambahkan kembali.

**Kenapa dua database (RTDB dan Firestore)?**
RTDB untuk data *saat ini* yang sering berubah (sensor, perintah); Firestore untuk *riwayat* yang dikueri (grafik, dokumentasi tanam). Lihat dokumen 03 bagian 2.

**Apakah aman menaruh kunci Firebase di aplikasi?**
Kunci di `firebase_options.dart` adalah identitas project, bukan rahasia; **keamanan data ditentukan oleh aturan
Realtime Database/Firestore** (karena itu aturan wajib dipasang dengan benar).
