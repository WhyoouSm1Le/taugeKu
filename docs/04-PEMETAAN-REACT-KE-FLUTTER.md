# 04 — Pemetaan React → Flutter

Dokumen ini menjelaskan bagaimana project web hasil Figma Make (`Design_TaugeKu_IoT_App.zip`, React + TypeScript + CSS)
diterjemahkan ke Flutter, dan **apa saja yang sengaja berbeda**.

## Daftar isi
1. [Istilah yang setara](#1-istilah-yang-setara)
2. [Komponen web ↔ file Flutter](#2-komponen-web--file-flutter)
3. [State React ↔ Provider](#3-state-react--provider)
4. [Data contoh (hardcode) ↔ Firebase](#4-data-contoh-hardcode--firebase)
5. [CSS ↔ Flutter](#5-css--flutter)
6. [Perbedaan yang disengaja](#6-perbedaan-yang-disengaja)
7. [Hal yang ditambahkan](#7-hal-yang-ditambahkan)
8. [Belum ada di desain (tombol "segera hadir")](#8-belum-ada-di-desain-tombol-segera-hadir)

---

## 1. Istilah yang setara

| React / Web | Flutter |
|---|---|
| Komponen (`function Dashboard()`) | Widget (`class DashboardScreen extends StatelessWidget`) |
| JSX `<div>` | `Container`, `Column`, `Row`, `Stack`, ... |
| `className` + CSS | Properti widget (`padding`, `decoration`, `style`) |
| `useState` | State lokal: `StatefulWidget` + `setState` — **atau** Provider (state yang dibagi) |
| `props` | Parameter constructor |
| `onClick` | `onTap` / `onPressed` |
| `useEffect` | `initState` / listener stream di Provider |
| `{cond && <X/>}` | `if (cond) X(),` di dalam daftar children |
| `list.map(...)` | `for (final item in list) Widget(item)` |
| SVG inline | `flutter_svg` (`AppIcon`) |
| `fetch` / data hardcode | Service Firebase |

---

## 2. Komponen web ↔ file Flutter

| Di `src/App.tsx` (baris) | Fungsinya | Di Flutter |
|---|---|---|
| `Icon` (29) + objek `paths` | 23 ikon SVG | `widgets/app_icon.dart` (path **disalin otomatis** dari kode web) |
| `SensorCard` (226) | Kartu suhu/lembap/cahaya | `widgets/sensor_card.dart` |
| `Dashboard` (267) | Beranda | `screens/dashboard_screen.dart` + `widgets/hero_card.dart`, `water_card.dart` |
| `Monitor` (451) | Monitoring | `screens/monitor_screen.dart` + `widgets/gauge_card.dart`, `sensor_line_chart.dart` |
| `History` (661) | Riwayat | `screens/history_screen.dart` + `widgets/batch_cards.dart` |
| `Devices` (793) | Perangkat + modal form + dialog hapus | `screens/devices_screen.dart` + `widgets/device_card.dart`, `device_form_sheet.dart`, `confirm_delete_dialog.dart` |
| `Profile` (1009) | Profil | `screens/profile_screen.dart` |
| `Login` (1061) | Masuk | `screens/login_screen.dart` |
| `App` (1127) | Header, navigasi bawah, toast, popover notifikasi | `screens/main_shell.dart` + `widgets/app_header.dart`, `app_bottom_nav.dart`, `app_toast.dart`, `notifications_popover.dart`; login gate di `app.dart` |
| `src/index.css` (±3.500 baris) | Seluruh gaya | `core/app_colors.dart`, `app_text.dart`, `app_radius.dart`, `app_theme.dart` + gaya di tiap widget |
| `src/assets/tauge.jpg` | Foto | `assets/images/tauge.jpg` |

---

## 3. State React ↔ Provider

| `useState` di web | Tempat di Flutter |
|---|---|
| `App.tab` | `NavigationProvider.currentTab` |
| `App.showNotifications` | `NavigationProvider.isNotificationOpen` |
| `App.toast` (+ `useEffect` timer) | `ToastProvider` (memakai `Timer`) |
| `App.loggedIn` | `AuthProvider` + `AuthGate` (status dari Firebase Auth) |
| `Dashboard.watering` | `WateringProvider.isWatering` |
| `Dashboard.refreshing` | State lokal di `RefreshButton` |
| `Dashboard.temp` | `DeviceProvider.selectedDevice.temperature` (dari **Realtime Database**, realtime) |
| `Monitor.range` | `SensorProvider.range` (karena mengubah kueri **Firestore** untuk grafik historis) |
| `History.filter` | State lokal `_filter` di `HistoryScreen` |
| `Devices.devices` | `DeviceProvider.devices` |
| `Devices.modal` / `Devices.form` | `showDeviceFormSheet` + state lokal form |

---

## 4. Data contoh (hardcode) ↔ Firebase

| Data hardcode di web | Sekarang berasal dari |
|---|---|
| `devicesSeed` (daftar perangkat) | RTDB `users/{uid}/devices` (`config`) |
| Suhu 29.8°C, lembap 78%, cahaya 24% | RTDB `devices/{id}/sensor` (realtime) |
| Titik grafik 6 buah | Firestore `devices/{id}/readings` (rekaman terjadwal; rentang waktu sesuai pilihan) |
| Batch "Tauge Batch 01", TANAM-007, TANAM-006 | Firestore `users/{uid}/batches` (dokumentasi penanaman) |
| Aktivitas (Penyiraman otomatis, dst.) | RTDB `users/{uid}/activities` |
| 2 notifikasi | RTDB `users/{uid}/notifications` |
| "Terakhir · 18.30" | RTDB `devices/{id}/lastWatering` |
| "Berikutnya 06.30" | RTDB `devices/{id}/config/autoWateringTimes` |
| "Halo, Keisya" dan avatar "AR" | Akun Firebase Authentication (nama dari email) |
| Login `admin` / `taugeku123` | Firebase Authentication |
| Simulasi siram 2,2 detik | Perintah ke Wemos via RTDB `devices/{id}/command` |

---

## 5. CSS ↔ Flutter

| CSS | Flutter |
|---|---|
| `border-radius: 24px 24px 24px 8px` | `AppRadius.leaf(24, 8)` |
| `box-shadow` | `BoxDecoration.boxShadow` |
| `linear-gradient(...)` | `LinearGradient(...)` |
| `radial-gradient(...)` | `RadialGradient(...)` (lihat `AppBackground`) |
| `conic-gradient` (lingkaran gauge) | `CustomPainter` + `drawArc` (`gauge_card.dart`) |
| Grafik SVG `path` + kurva halus | `CustomPainter` + `Path.cubicTo` (`sensor_line_chart.dart`) |
| `position: absolute` | `Stack` + `Positioned` |
| `display: flex` | `Row` / `Column` / `Expanded` |
| `font-family` | `google_fonts` (Plus Jakarta Sans, DM Mono) |
| `transition` | `AnimatedContainer`, `AnimatedSwitcher` |
| `rgba(255,255,255,.8)` | `Color.fromRGBO(255,255,255,0.8)` |

---

## 6. Perbedaan yang disengaja

| Desain web | Aplikasi Flutter | Alasan |
|---|---|---|
| Kolom login sudah terisi `admin` / `taugeku123` | Kosong | Kredensial bawaan tidak aman dan tidak ada di Firebase |
| Username `admin` | Diubah menjadi `admin@taugeku.id` | Firebase Auth butuh email (lihat `AuthService.usernameToEmail`) |
| Sapaan "Selamat malam, Halo Keisya" tetap | Sapaan mengikuti jam, nama dari profil | Data dinamis |
| Cincin gauge selalu 78% | Suhu = nilai ÷ 40°C; lembap = nilai ÷ 100 | Agar mencerminkan data sungguhan |
| Panah tren tetap (↗ ↗ — —) | Dihitung dari selisih suhu dua data berurutan | Data sungguhan |
| "Firebase • Online" teks tetap | Mengikuti status sambungan RTDB sebenarnya (Online/Offline/Error) | Agar jujur |
| "Sistem normal" tetap | Mengikuti jumlah perangkat offline | Data dinamis |
| Titik merah lonceng selalu ada | Hanya bila ada notifikasi belum dibaca | Data dinamis |
| Dropdown status Online/Offline di form | Dua `ChoiceChip` | Tidak terkena perubahan API dropdown di versi Flutter baru |
| ID perangkat dapat diubah saat edit | ID **dikunci** saat edit | ID = nama node di RTDB; mengubahnya berarti memindahkan seluruh node |
| Tombol "Tambah foto" tanpa fungsi | Memilih foto dari galeri, **disimpan sementara di memori** | Cloud Storage memerlukan paket berbayar; foto hilang saat logout/aplikasi ditutup (sengaja) |
| Tombol Siram selalu bisa ditekan | Ditolak bila perangkat offline atau aplikasi tidak tersambung | Mencegah perintah yang mengantre lalu menyalakan pompa belakangan |
| Ukuran huruf kecil (8–10px) | Dinaikkan sedikit (±9–11) | Desain web memakai kanvas ± 430px yang diperkecil; di HP asli teks 8px sulit dibaca |
| Bingkai "ponsel" dan status bar palsu | Tidak ada | Di perangkat asli sudah ada |
| Animasi latar bentuk organik yang melayang (`organicDrift`) dan efek hover/putar pada ikon aktivitas | Tidak ditiru | Efek hover tidak ada di layar sentuh; animasi latar bersifat dekoratif dan mudah ditambah belakangan |
| Ikon notifikasi mengikuti tipe | `info` → tetes air, `warning` → matahari | Aturan sederhana; ubah di `notifications_popover.dart` |

---

## 7. Hal yang ditambahkan

* Kondisi **memuat / kosong / error** pada setiap daftar (web hanya punya data contoh).
* Validasi form perangkat (wajib diisi, format ID, ID kembar ditolak).
* Penanganan error login dengan pesan bahasa Indonesia (`AuthProvider._friendlyMessage`).
* Memilih **foto profil** dari galeri (disimpan sementara di memori; web hanya tulisan "Tambah foto").
* Tombol **"Isi data contoh"** (hanya mode debug) untuk mencoba tanpa Wemos.
* **Unit test** untuk logika murni (`test/app_format_test.dart`).
* Aturan keamanan Realtime Database & Firestore.

---

## 8. Belum ada di desain (tombol "segera hadir")

Beberapa tombol pada desain web **tidak memiliki aksi** (hanya tampilan). Di Flutter, tombol-tombol ini menampilkan
toast *"Fitur ini akan segera hadir"* agar pengguna tidak bingung:

| Tombol | Lokasi |
|---|---|
| Ikon kalender | Riwayat (pojok kanan atas) |
| Menu titik tiga (⋯) pada batch aktif | Riwayat |
| "Detail ›" pada kartu perangkat | Perangkat |

Fitur yang juga **belum ada di desain** sehingga belum dibuat: tambah/ubah batch, mengganti nama pengguna,
memilih perangkat utama, pengaturan jadwal siram, lupa password.
