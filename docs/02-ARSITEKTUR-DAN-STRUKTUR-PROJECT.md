# 02 — Arsitektur & Struktur Project

## Daftar isi
1. [Gambaran besar](#1-gambaran-besar)
2. [Peta folder](#2-peta-folder)
3. [Empat lapisan kode](#3-empat-lapisan-kode)
4. [Provider: cara kerjanya](#4-provider-cara-kerjanya)
5. [Daftar semua provider](#5-daftar-semua-provider)
6. [Alur data lengkap (contoh)](#6-alur-data-lengkap-contoh)
7. [Pola ProxyProvider](#7-pola-proxyprovider)
8. [Alur startup aplikasi](#8-alur-startup-aplikasi)

---

## 1. Gambaran besar

```
                  sensor realtime, perintah, config          rekaman terjadwal (15–30 mnt)
┌─────────────┐ ◄───────────────────────────────► ┌─────────────────────┐
│ Wemos D1    │                                    │ Realtime Database   │  ← data SAAT INI
│ Mini (IoT)  │ ────────────────────────────────►  ├─────────────────────┤
└─────────────┘                                    │ Cloud Firestore     │  ← RIWAYAT & dokumentasi penanaman
                                                   └──────────┬──────────┘
                                                      realtime│  kueri
                                                              ▼
                                                   ┌─────────────────────┐
                                                   │ Aplikasi Flutter    │ ← login lewat Firebase Authentication
                                                   └─────────────────────┘
```

Aplikasi **tidak pernah berbicara langsung dengan Wemos**. Keduanya hanya membaca/menulis database Firebase.
Keuntungannya: aplikasi bisa dipakai dari mana saja (tidak harus satu WiFi), dan riwayat tersimpan.

| Database | Menyimpan | Analogi |
|---|---|---|
| **Realtime Database** | konfigurasi, perintah pompa, data sensor realtime, waktu siram terakhir (+ aktivitas & notifikasi) | Papan tulis (ditulis ulang terus) |
| **Cloud Firestore** | dokumentasi tiap penanaman, rekaman sensor terjadwal (grafik historis) | Buku catatan arsip |

---

## 2. Peta folder

```
taugeku/
├── lib/
│   ├── main.dart                 ← titik awal: menyalakan Firebase lalu menjalankan app
│   ├── app.dart                  ← mendaftarkan semua Provider + penjaga login (AuthGate)
│   ├── firebase_options.dart     ← dibuat oleh `flutterfire configure`
│   │
│   ├── core/                     ← hal-hal umum (tidak tahu soal Firebase / layar)
│   │   ├── app_colors.dart       ·  semua warna
│   │   ├── app_text.dart         ·  gaya teks (font)
│   │   ├── app_theme.dart        ·  tema Material
│   │   ├── app_radius.dart       ·  bentuk sudut "daun"
│   │   ├── app_constants.dart    ·  angka tetap (rentang ideal, nilai cadangan siram, ...)
│   │   ├── app_format.dart       ·  format jam, tanggal, angka
│   │   ├── rtdb_utils.dart       ·  membaca data mentah RTDB dengan aman
│   │   ├── sensor_rules.dart     ·  arti angka sensor ("Ideal", "Kering", ...)
│   │   └── watering_schedule.dart·  hitung jadwal siram berikutnya
│   │
│   ├── models/                   ← LAPISAN 1: bentuk data
│   │   ├── device_model.dart (RTDB) · activity_item.dart (RTDB) · notification_item.dart (RTDB)
│   │   ├── planting_batch.dart (Firestore) · sensor_reading.dart (Firestore)
│   │   └── user_profile.dart (dari Firebase Auth)
│   │
│   ├── services/                 ← LAPISAN 2: bicara dengan Firebase (tanpa UI)
│   │   ├── rtdb_paths.dart       ·  alamat semua node Realtime Database
│   │   ├── firestore_paths.dart  ·  alamat koleksi Firestore
│   │   ├── auth_service.dart                                  (Authentication)
│   │   ├── device_service.dart · watering_service.dart        (RTDB)
│   │   ├── activity_service.dart · notification_service.dart  (RTDB)
│   │   ├── batch_service.dart · sensor_service.dart           (Firestore)
│   │   └── demo_data_service.dart·  isi data contoh (debug)
│   │
│   ├── providers/                ← LAPISAN 3: state management (Provider)
│   │   ├── user_scoped_provider.dart  (kelas dasar)
│   │   ├── auth_provider.dart · navigation_provider.dart · toast_provider.dart
│   │   ├── device_provider.dart · sensor_provider.dart · batch_provider.dart
│   │   ├── activity_provider.dart · notification_provider.dart
│   │   └── watering_provider.dart · profile_provider.dart
│   │
│   ├── screens/                  ← LAPISAN 4: halaman penuh
│   │   ├── login_screen.dart · main_shell.dart
│   │   ├── dashboard_screen.dart (Beranda) · monitor_screen.dart
│   │   ├── history_screen.dart · devices_screen.dart · profile_screen.dart
│   │
│   └── widgets/                  ← potongan tampilan yang dipakai ulang
│       ├── app_icon.dart (23 ikon SVG dari desain) · soft_card.dart · ...
│
├── assets/images/tauge.jpg       ← foto dari desain
├── test/app_format_test.dart     ← unit test
├── database.rules.json · firestore.rules · firebase.json
└── docs/                         ← dokumentasi (folder ini)
```

---

## 3. Empat lapisan kode

Kode dibagi per **tanggung jawab**. Aturan emasnya: **lapisan atas boleh memanggil lapisan bawah, tidak sebaliknya.**

```
 Screens / Widgets   ← menggambar layar, menangkap sentuhan
        │ memanggil / mendengarkan
        ▼
 Providers           ← menyimpan state, memberi tahu layar saat berubah
        │ memanggil
        ▼
 Services            ← satu-satunya yang menyentuh Firebase
        │ membaca/menulis
        ▼
 Models              ← bentuk data (Map RTDB/Firestore ⇄ objek Dart)
```

| Lapisan | Boleh | Tidak boleh |
|---|---|---|
| Screens/Widgets | Menampilkan data, memanggil method Provider | Menyentuh Firebase langsung |
| Providers | Menyimpan state, memanggil Service | Membuat widget / memakai `BuildContext` untuk tampilan |
| Services | Memanggil Firebase | Tahu tentang layar atau Provider |
| Models | Menyimpan data, konversi dari/ke Map | Memanggil Firebase (hanya boleh memakai tipe data Firebase seperti `Timestamp`/`User`) |

**Manfaat bagi tim:** jika Anda ingin mengganti Firebase dengan backend lain, cukup ubah folder `services/`.
Jika ingin mengubah tampilan, cukup ubah `screens/` dan `widgets/`.

---

## 4. Provider: cara kerjanya

### 4.1 Ide dasarnya (analogi)
Bayangkan **papan pengumuman** di kantor:
* **Provider** = papan pengumuman (menyimpan informasi terbaru).
* **Layar** = karyawan yang membaca papan.
* `notifyListeners()` = petugas yang berteriak "Ada pengumuman baru!".
* Karyawan yang sedang melihat papan itu otomatis membaca ulang (layar digambar ulang).

### 4.2 Contoh paling sederhana di project ini
`toast_provider.dart` (potongan):

```dart
class ToastProvider extends ChangeNotifier {      // 1. "papan pengumuman"
  String? _message;                               // 2. data yang disimpan
  String? get message => _message;                // 3. cara membaca data

  void show(String text) {
    _message = text;                              // 4. ubah data
    notifyListeners();                            // 5. beri tahu layar
  }
}
```

Cara memakainya di layar:

```dart
// MENULIS / memanggil aksi  ->  context.read
context.read<ToastProvider>().show('Perangkat ditambahkan');

// MEMBACA & ikut digambar ulang saat berubah  ->  context.watch
final message = context.watch<ToastProvider>().message;

// MEMBACA satu nilai saja  ->  context.select  (lebih hemat)
final message = context.select<ToastProvider, String?>((t) => t.message);
```

### 4.3 Kapan memakai yang mana?

| Perintah | Dipakai di | Artinya |
|---|---|---|
| `context.read<X>()` | **Event handler** (`onTap`, `onPressed`) | Ambil objek, **tidak** menggambar ulang layar |
| `context.watch<X>()` | Di dalam `build()` | Ambil objek **dan** gambar ulang setiap `notifyListeners()` |
| `context.select<X, T>(...)` | Di dalam `build()` | Seperti `watch`, tetapi hanya gambar ulang bila nilai `T` yang dipilih berubah |

> **Kesalahan paling umum pemula:** memakai `context.watch` di dalam `onPressed`.
> Itu akan menimbulkan error. Di dalam `onPressed`, selalu pakai `context.read`.

### 4.4 Stream database → Provider → Layar

Provider data (mis. `DeviceProvider`) **berlangganan** (*subscribe*) ke Realtime Database:

```dart
_subscription = _service.watchDevices(uid).listen((list) {
  _devices = list;
  notifyListeners();        // layar otomatis diperbarui
});
```
Setiap kali data di database berubah (misal Wemos mengirim suhu baru), blok `listen` berjalan otomatis.
Itulah sebabnya aplikasi bersifat **realtime** tanpa tombol refresh.

---

## 5. Daftar semua provider

| Provider | Tugas | Bergantung pada |
|---|---|---|
| `AuthProvider` | Status login, proses login, pesan error login | — |
| `NavigationProvider` | Tab aktif, popover notifikasi terbuka/tutup | — |
| `ToastProvider` | Pesan singkat di bawah layar | — |
| `DeviceProvider` | Daftar perangkat **+ data sensor realtime** (RTDB), tambah/ubah/hapus, status sambungan | `AuthProvider` |
| `SensorProvider` | **Riwayat** sensor untuk grafik (Firestore), pilihan rentang waktu | `AuthProvider`, `DeviceProvider` |
| `BatchProvider` | Dokumentasi siklus tanam (Firestore) | `AuthProvider` |
| `ActivityProvider` | Aktivitas terbaru (RTDB) | `AuthProvider` |
| `NotificationProvider` | Notifikasi (RTDB) + jumlah belum dibaca | `AuthProvider` |
| `ProfileProvider` | Profil dari akun Auth, **foto sementara di memori**, data contoh | `AuthProvider` |
| `WateringProvider` | Tombol "Siram" (tulis perintah ke RTDB & tunggu hasil) | `AuthProvider`, `DeviceProvider` |

**State lokal** (tidak perlu Provider) dipakai untuk hal yang hanya penting bagi satu layar, misalnya
sensor mana yang dipilih pada grafik (`_metric` di `MonitorScreen`), filter Riwayat, dan form perangkat.
Ini praktik yang disarankan: *jangan menaruh semuanya di Provider*.

---

## 6. Alur data lengkap (contoh)

### Contoh A — pengguna menekan tombol "Siram"

```
1. DashboardScreen    onPressed → context.read<WateringProvider>().startWatering()
2. WateringProvider   cek: perangkat online? aplikasi tersambung? → isWatering = true; notifyListeners()
3. WateringService    menulis RTDB  users/{uid}/devices/WMS-001/command
                      {action:"water", durationSeconds:10, status:"pending", requestedAt:<jam server>}
4. Wemos              melihat perintah baru → menyalakan pompa → command/status = "done"
                      → mengisi lastWatering, activities, notifications
5. WateringService    (sedang mendengarkan command/status) menerima "done"
6. WateringProvider   isWatering = false; mengembalikan WateringResult.success
7. DashboardScreen    toast "Penyiraman selesai · 10 detik"; "Terakhir · 18.30" ikut berubah
                      sendiri (karena lastWatering ada di data perangkat RTDB)
```
Jika Wemos tidak menjawab dalam 30 detik → status menjadi `timeout` dan toast menyarankan memeriksa koneksi.
Jika aplikasi sedang offline → tombol langsung menolak ("Tidak ada koneksi internet") agar perintah tidak mengantre.

### Contoh B — Wemos mengirim suhu baru (realtime)

```
1. Wemos           PATCH  RTDB users/{uid}/devices/WMS-001/sensor  {temperature: 30.1, ...}
2. RTDB            mengirim perubahan ke semua klien yang berlangganan
3. DeviceService   stream onValue memancarkan daftar perangkat baru
4. DeviceProvider  listen(...) menerima daftar → notifyListeners()
5. Layar           Beranda & gauge Monitoring otomatis menampilkan 30.1°C
```

### Contoh C — membuka grafik "7 hari" (riwayat)

```
1. MonitorScreen   pengguna memilih "7 hari" → SensorProvider.setRange(week)
2. SensorProvider  membatalkan langganan lama, membuat kueri baru
3. SensorService   Firestore: users/{uid}/devices/WMS-001/readings  createdAt >= 7 hari lalu, limit 500
4. SensorProvider  menerima data → diringkas jadi 8 titik → notifyListeners()
5. MonitorScreen   grafik digambar ulang
```

---

## 7. Pola ProxyProvider

Hampir semua data milik **satu pengguna** (`users/{uid}/...`). Maka provider harus tahu "siapa yang login".
Kita memakai `ChangeNotifierProxyProvider` di `lib/app.dart`:

```dart
ChangeNotifierProxyProvider<AuthProvider, DeviceProvider>(
  create: (_) => DeviceProvider(),
  update: (_, auth, provider) => provider!..setUser(auth.userId),
),
```

Bacanya: *"Buat `DeviceProvider` satu kali. Setiap kali `AuthProvider` berubah, panggil `setUser(...)`."*

* Pengguna **login** → `setUser('abc123')` → `DeviceProvider` mulai mendengarkan `users/abc123/devices`.
* Pengguna **logout** → `setUser(null)` → langganan dibatalkan dan data dikosongkan.

Kelas dasar `UserScopedProvider` menyimpan logika "uid berubah" ini agar tidak ditulis berulang.

> **Aturan penting:** di dalam `onUserChanged` **jangan** memanggil `notifyListeners()` secara langsung,
> karena fungsi itu dapat berjalan saat layar sedang digambar (menimbulkan error
> *"setState() or markNeedsBuild() called during build"*). Cukup panggil di dalam callback stream.

`SensorProvider` dan `WateringProvider` memakai `ChangeNotifierProxyProvider2` karena butuh **dua** hal:
pengguna (`AuthProvider`) dan perangkat yang sedang dipilih (`DeviceProvider.selectedDevice`).

---

## 8. Alur startup aplikasi

```
main()                                  ← lib/main.dart
 ├─ WidgetsFlutterBinding.ensureInitialized()
 ├─ Firebase.initializeApp(...)         ← sambung ke project Firebase
 └─ runApp(TaugeKuApp)                  ← lib/app.dart
      ├─ MultiProvider (daftarkan semua provider)
      └─ MaterialApp → AuthGate
            ├─ Firebase belum menjawab   → layar loading
            ├─ sudah login               → MainShell (header + halaman + navigasi bawah)
            └─ belum login               → LoginScreen
```

`AuthGate` mendengarkan `AuthProvider`. Saat login berhasil, `isLoggedIn` menjadi `true` dan layar berganti
**otomatis** — tidak ada kode `Navigator.push` manual untuk login/logout.

`MainShell` memilih halaman berdasarkan `NavigationProvider.currentTab`, sehingga pindah tab tidak memakai
route Flutter; cukup mengubah satu nilai state.
