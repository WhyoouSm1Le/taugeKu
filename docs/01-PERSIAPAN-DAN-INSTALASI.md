# 01 — Persiapan & Instalasi

Dokumen ini membawa Anda dari **nol** sampai aplikasi berjalan di HP/emulator.
Estimasi waktu: 45–90 menit (tergantung kecepatan unduhan).

## Daftar isi
1. [Yang perlu disiapkan](#1-yang-perlu-disiapkan)
2. [Membuat project Firebase](#2-membuat-project-firebase)
3. [Membuat project Flutter](#3-membuat-project-flutter)
4. [Menghubungkan Flutter ke Firebase](#4-menghubungkan-flutter-ke-firebase)
5. [Pengaturan platform (Android & iOS)](#5-pengaturan-platform-android--ios)
6. [Menjalankan aplikasi](#6-menjalankan-aplikasi)
7. [Mengisi data contoh](#7-mengisi-data-contoh)
8. [Verifikasi kualitas kode](#8-verifikasi-kualitas-kode)
9. [Membuat file APK](#9-membuat-file-apk)

---

## 1. Yang perlu disiapkan

| Kebutuhan | Keterangan |
|---|---|
| **Flutter SDK** (versi 3.27 atau lebih baru) | https://docs.flutter.dev/get-started/install — setelah install jalankan `flutter doctor` dan ikuti saran perbaikannya |
| **Android Studio** | Untuk Android SDK dan emulator. Untuk iOS dibutuhkan Mac + Xcode |
| **Akun Google** | Untuk Firebase |
| **Node.js** | Dibutuhkan Firebase CLI (bila diinstal lewat npm) |
| **Firebase CLI** | `npm install -g firebase-tools` lalu `firebase login` |
| **FlutterFire CLI** | `dart pub global activate flutterfire_cli` |

> **Kenapa Flutter 3.27+?** Kode memakai `Color.withValues(...)` dan fitur Dart 3 (records, switch expression)
> yang baru tersedia di versi tersebut.

Cek instalasi:

```bash
flutter --version
flutter doctor
firebase --version
```

---

## 2. Membuat project Firebase

Semua dilakukan di https://console.firebase.google.com

### 2.1 Buat project
1. Klik **Add project** (Tambahkan project) → beri nama, misalnya `taugeku`.
2. Google Analytics boleh dimatikan (tidak dipakai aplikasi ini).

### 2.2 Aktifkan Authentication
1. Menu **Build → Authentication → Get started**.
2. Tab **Sign-in method** → pilih **Email/Password** → **Enable** → Save.
3. Tab **Users → Add user**:
   * Email: `admin@taugeku.id`
   * Password: pilih sendiri (minimal 6 karakter)

> **Kenapa email, padahal layar login memakai "Username"?**
> Firebase Authentication butuh email. Aplikasi mengubah username `admin` menjadi `admin@taugeku.id`
> secara otomatis (lihat `AuthService.usernameToEmail`). Jadi di layar login cukup mengetik `admin`.
> Pengguna juga boleh mengetik email lengkap.

### 2.3 Buat Realtime Database (RTDB) — **lakukan SEBELUM `flutterfire configure`**
1. Menu **Build → Realtime Database → Create Database**.
2. Pilih lokasi terdekat (mis. Singapura) dan mulai dalam **locked mode**.
3. Tab **Rules** → ganti isinya dengan isi file [`database.rules.json`](../database.rules.json) → **Publish**.

> **Kenapa harus dibuat lebih dulu?** `flutterfire configure` menulis alamat database (`databaseURL`) ke
> `lib/firebase_options.dart`. Jika RTDB belum ada saat perintah itu dijalankan, alamatnya tidak tercatat dan aplikasi
> akan gagal terhubung ke RTDB (lihat dokumen 07). Kalau terlanjur, cukup jalankan `flutterfire configure` sekali lagi.

### 2.4 Buat database Cloud Firestore
1. Menu **Build → Firestore Database → Create database**.
2. Pilih lokasi terdekat, mis. `asia-southeast2` (Jakarta). **Lokasi tidak bisa diubah setelahnya.**
3. Pilih **Production mode**.
4. Tab **Rules** → ganti isinya dengan isi file [`firestore.rules`](../firestore.rules) → **Publish**.

> **Pembagian tugas:** RTDB menyimpan data *saat ini* (konfigurasi, perintah pompa, sensor realtime, siram terakhir).
> Firestore menyimpan *riwayat* (dokumentasi tiap penanaman dan rekaman sensor terjadwal). Penjelasan lengkap di dokumen 03.

> **Catatan biaya:** Authentication, Realtime Database, dan Firestore tersedia di paket gratis (Spark) dengan batas
> pemakaian. Layanan **Cloud Storage** diketahui mensyaratkan paket berbayar (Blaze), karena itu aplikasi ini
> **tidak memakai Storage**: foto profil hanya disimpan sementara di memori. Cek https://firebase.google.com/pricing
> karena ketentuan dapat berubah.

---

## 3. Membuat project Flutter

Folder yang Anda terima berisi kode aplikasi (`lib/`, `assets/`, dst.) tetapi **tidak** berisi folder
`android/` dan `ios/` (folder itu dibuat otomatis oleh Flutter dan berisi banyak file mesin).
Cara paling aman:

```bash
# 1) Buat project baru (menghasilkan android/ dan ios/ yang valid)
flutter create taugeku --org id.taugeku --platforms=android,ios
cd taugeku

# 2) Hapus lib/ bawaan, lalu salin dari folder yang Anda terima:
#      lib/   test/   assets/   pubspec.yaml   analysis_options.yaml
#      firestore.rules   database.rules.json   firebase.json   .gitignore
#    (timpa pubspec.yaml dan analysis_options.yaml bawaan)

# 3) Ambil dependensi
flutter pub get
```

Jika `flutter pub get` melaporkan konflik versi, lihat [Troubleshooting](07-TROUBLESHOOTING-DAN-FAQ.md#konflik-versi-paket).

---

## 4. Menghubungkan Flutter ke Firebase

Di dalam folder project:

```bash
flutterfire configure
```

Perintah ini akan:
1. Menampilkan daftar project Firebase Anda → pilih `taugeku`.
2. Menanyakan platform → pilih **android** dan **ios**.
3. **Membuat/menimpa `lib/firebase_options.dart`** berisi kunci project Anda.
4. Mendaftarkan aplikasi Android/iOS di Firebase dan menambahkan konfigurasi platform
   (biasanya termasuk `google-services.json` di Android).

> Selama langkah ini belum dilakukan, aplikasi akan berhenti dengan pesan
> *"Firebase belum dikonfigurasi"* — itu perilaku yang disengaja.

**Periksa hasilnya:** buka `lib/firebase_options.dart` dan pastikan ada baris `databaseURL: 'https://...firebasedatabase.app'`.
Jika tidak ada, RTDB belum dibuat saat perintah dijalankan (lihat 2.3) — buat RTDB lalu ulangi `flutterfire configure`.

---

## 5. Pengaturan platform (Android & iOS)

### Android
Buka `android/app/build.gradle` (atau `build.gradle.kts`) dan pastikan **minSdk minimal 23**:

```groovy
defaultConfig {
    minSdk = 23        // atau: minSdkVersion 23  (tergantung format file)
}
```

Plugin Google Services biasanya ditambahkan otomatis oleh `flutterfire configure`. Jika build Android
mengeluhkan `google-services.json`, ikuti panduan resmi FlutterFire.

### iOS (hanya di Mac)
Buka `ios/Podfile`, pastikan baris platform minimal iOS 15:

```ruby
platform :ios, '15.0'
```

Lalu jalankan:

```bash
cd ios && pod install && cd ..
```

> Angka versi minimum bisa berubah mengikuti rilis Firebase. Jika `pod install` menyebut versi
> iOS minimum yang berbeda, ikuti pesan tersebut.

---

## 6. Menjalankan aplikasi

```bash
flutter devices        # lihat perangkat/emulator yang tersedia
flutter run            # jalankan
```

Saat pertama kali dijalankan, font (Plus Jakarta Sans & DM Mono) diunduh dari internet oleh paket
`google_fonts` lalu disimpan di cache. Jadi **pastikan perangkat online saat pertama kali dibuka**.

Login: username `admin` + password yang Anda buat di langkah 2.2.

---

## 7. Mengisi data contoh

Database baru masih kosong, sehingga semua halaman menampilkan kondisi "belum ada data".
Untuk mencoba tampilan tanpa perangkat Wemos:

1. Jalankan aplikasi dalam **mode debug** (`flutter run`).
2. Login → buka tab **Profil** (ketuk avatar di pojok kanan atas).
3. Tekan **"Isi data contoh (khusus debug)"** di bagian bawah.

Akan dibuat — di **Realtime Database**: 2 perangkat (config, sensor, siram terakhir), 3 aktivitas, 2 notifikasi;
di **Firestore**: 3 batch tanam dan 6 rekaman sensor untuk grafik. Datanya sama dengan data contoh pada desain web.
Tombol ini **tidak muncul** pada build rilis.

---

## 8. Verifikasi kualitas kode

Penulis dokumen ini tidak dapat menjalankan Flutter di lingkungan pembuatan, jadi **jalankan tiga perintah ini
sebelum menyerahkan project**:

```bash
flutter pub get
flutter analyze     # cari error/peringatan; perbaiki jika ada
flutter test        # menjalankan unit test di folder test/
```

Yang mungkin perlu penyesuaian kecil (bukan kesalahan logika):
* Versi paket Firebase yang terus berkembang (lihat dokumen 07).
* Peringatan *deprecated* dari versi Flutter yang lebih baru.

---

## 9. Membuat file APK

```bash
flutter build apk --release
# hasil: build/app/outputs/flutter-apk/app-release.apk
```

Untuk rilis ke Play Store Anda perlu menandatangani aplikasi (signing). Panduan resmi:
https://docs.flutter.dev/deployment/android
