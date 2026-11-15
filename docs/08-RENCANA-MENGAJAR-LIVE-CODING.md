# 08 — Rencana Mengajar: Live Coding Bertahap untuk Pemula Total

Panduan untuk **kamu (mentor)** yang mengajar teman yang benar-benar baru di dunia programming.
Tujuannya bukan membuat teman paham seluruh project, tetapi membuatnya **merasa mampu** di setiap sesi.

## Daftar isi
1. [Prinsip utama](#1-prinsip-utama)
2. [Peta 12 sesi](#2-peta-12-sesi)
3. [Persiapan sebelum sesi pertama](#3-persiapan-sebelum-sesi-pertama)
4. [Format satu sesi](#4-format-satu-sesi-berlaku-untuk-semua)
5. [Sesi 0 sampai 11](#5-detail-setiap-sesi)
6. [Tanda burnout & cara menanganinya](#6-tanda-burnout--cara-menanganinya)
7. [Jalur singkat](#7-jalur-singkat-jika-waktu-terbatas)
8. [Git: titik simpan per sesi](#8-git-titik-simpan-per-sesi)
9. [Contoh jadwal](#9-contoh-jadwal)

---

## 1. Prinsip utama

| Prinsip | Artinya dalam praktik |
|---|---|
| **Satu sesi = satu hasil yang terlihat** | Setiap sesi harus berakhir dengan sesuatu yang *tampil di layar*. Hasil yang bisa dipegang menjaga motivasi. |
| **Teman yang mengetik, kamu yang mengarahkan** | Pemula belajar dari tangannya sendiri. Kamu bicara, dia mengetik (*driver/navigator*). Jangan merebut keyboard. |
| **Maksimal 60–90 menit, istirahat tiap 25 menit** | Otak pemula penuh jauh lebih cepat dari yang kamu kira. |
| **Satu konsep baru per 20 menit** | Jika ada dua konsep baru dalam satu langkah, pecah. |
| **Jangan mulai dari proyek jadi** | Project TaugeKu ±6.400 baris akan menenggelamkan. Bangun versi mini dari nol, lalu **baru** buka project jadi sebagai "kunci jawaban". |
| **Kotak hitam itu boleh** | Beberapa widget (grafik, gauge) cukup dipakai tanpa dibedah. Katakan: *"Ini kita pakai saja dulu, bedahnya nanti."* |
| **Error adalah teman** | Ajarkan membaca error sejak sesi 1: baca baris pertama, cari nomor baris. Jangan langsung kamu yang memperbaiki. |
| **Akhiri dengan kondisi yang jalan** | Jangan berhenti di tengah error. Jika waktu habis, kembalikan ke titik terakhir yang jalan (lihat git di bagian 8). |
| **Pekerjaan rumah opsional, maksimal 20 menit** | Atau tidak ada sama sekali. Utamakan konsistensi hadir, bukan beban. |
| **Rayakan hal kecil** | "Kamu baru saja membuat aplikasi yang berubah saat disentuh" itu pencapaian sungguhan. |

### Analogi yang bisa dipakai berulang

| Konsep | Analogi |
|---|---|
| Widget | Balok LEGO: balok kecil disusun jadi besar |
| Pohon widget | Kotak di dalam kotak, seperti boneka matryoshka |
| State | Papan tulis: isinya berubah, orang yang melihat ikut melihat perubahan |
| `setState` | "Hapus dan tulis ulang papan tulisnya" |
| Provider | Papan pengumuman kantor yang dibaca banyak orang |
| `notifyListeners()` | Petugas yang berteriak "ada pengumuman baru!" |
| Stream | Keran air yang terus mengalir (data realtime) |
| Firestore | Lemari arsip online: *collection* = laci, *document* = map berisi data |
| Hot reload | Mengganti lukisan di dinding tanpa membongkar rumah |

---

## 2. Peta 12 sesi

Empat fase. **Fase 1–2 tidak memerlukan Firebase sama sekali**; Firebase baru masuk setelah teman percaya diri.

| Sesi | Judul | Alat | **Hasil yang terlihat** |
|---|---|---|---|
| **0** | Persiapan & "Halo Dunia" | Install (dipandu atau dibantu kamu) | Aplikasi bawaan Flutter berjalan di HP/emulator, Hot Reload dicoba |
| **Fase 1 — Dart & tampilan** | | | |
| 1 | Dart pertama: berpikir seperti program | DartPad (web) | Program kecil yang menilai suhu: "Ideal / Panas / Dingin" |
| 2 | Widget pertama: kartu suhu | DartPad atau lokal | Kartu "Suhu 29.8°C" yang cantik |
| 3 | Menyusun layar: Beranda statis | Lokal | Tampilan Beranda mirip desain (data masih tulisan tetap) |
| **Fase 2 — Interaksi & state** | | | |
| 4 | Menyentuh layar: tombol Siram | Lokal | Tombol yang berubah jadi "Menyiram..." lalu kembali |
| 5 | Data berbentuk daftar: halaman Perangkat | Lokal | Daftar perangkat dari *list* data contoh |
| 6 | Banyak halaman: navigasi bawah | Lokal | Aplikasi 3 tab yang bisa dipindah-pindah |
| 7 | **Provider**: berbagi data antar halaman | Lokal + paket `provider` | Tambah/hapus perangkat di satu halaman, halaman lain ikut berubah |
| **Fase 3 — Firebase** *(mode: baca + ubah sedikit)* | | | |
| 8 | Login dengan Firebase | Project jadi | Login sungguhan dengan akun di Firebase Console |
| 9 | Realtime Database: data yang "hidup" | Project jadi | Ubah suhu di Console → angka di HP berubah **sendiri**; tambah perangkat di aplikasi → muncul di Console |
| 10 | Firestore: riwayat dan dokumentasi tanam | Project jadi | Halaman Riwayat dan grafik Monitoring terisi dari Firestore; tahu kenapa ada dua database |
| **Fase 4 — Penutup** | | | |
| 11 | Siram sungguhan & tur project | Project jadi | Tombol Siram menulis perintah ke RTDB; kamu berperan jadi Wemos; peta besar project |

Jadwal yang realistis: **2 sesi per minggu → ±6 minggu**.

---

## 3. Persiapan sebelum sesi pertama

### 3.1 Yang kamu siapkan (tanpa teman)
- [ ] Flutter terpasang dan `flutter doctor` bersih di laptop **kamu**. Jalankan satu kali seluruh project jadi untuk memastikan semuanya benar.
- [ ] Project Firebase sudah dibuat, **Authentication, Realtime Database, dan Firestore sudah aktif** (RTDB dibuat **sebelum** `flutterfire configure`), aturan keamanan keduanya sudah dipublish, dan satu user `admin@taugeku.id` sudah ada (dokumen 01, bagian 2). Teman tidak perlu mengurus ini; itu sumber kebosanan terbesar.
- [ ] `flutterfire configure` sudah dijalankan di project jadi.
- [ ] Repositori git berisi project jadi sebagai cadangan (bagian 8).
- [ ] Catatan satu halaman berisi: "hasil sesi ini" untuk setiap sesi (tabel bagian 2) agar kamu selalu ingat tujuannya.

### 3.2 Pilih jalur pemasangan (Sesi 0)
Pemasangan Flutter adalah titik di mana banyak pemula menyerah. Pilih salah satu:

| Opsi | Cocok jika | Catatan |
|---|---|---|
| **A. Kamu pasangkan sebelum sesi** | Kamu bisa mengakses laptop teman | Terbaik untuk mencegah frustrasi |
| **B. DartPad dulu (tanpa install)**, install saat Sesi 4 | Laptop teman lemah atau install sulit | Sesi 1–3 bisa 100% di browser: https://dartpad.dev |
| **C. Install bersama di Sesi 0** | Teman cukup sabar | Siapkan 60–90 menit khusus ini |

**Rekomendasi:** opsi **B** untuk pemula total. Teman merasakan keberhasilan dulu, baru menghadapi pemasangan.

Catatan DartPad: gambar dari folder `assets/` (mis. `Image.asset`) **tidak tersedia** di sana, jadi gunakan warna dan ikon saja. Dukungan paket (mis. `provider`) di DartPad berubah-ubah; cek daftar yang didukung di DartPad. Jika tidak ada, pindahkan Sesi 7 ke lokal.

### 3.3 Perangkat uji
HP Android asli (kabel USB + *USB debugging*) biasanya **lebih ringan** daripada emulator di laptop kelas menengah. Emulator boleh dipakai jika laptop kuat.

---

## 4. Format satu sesi (berlaku untuk semua)

| Menit | Kegiatan |
|---|---|
| 0–5 | **Ulas singkat**: "Sesi lalu kita membuat apa?" (jalankan hasilnya dulu) |
| 5–10 | **Tujuan hari ini**: tunjukkan **hasil akhir** sesi dalam bentuk jadi. Ini peta agar tidak tersesat |
| 10–35 | **Live coding blok 1** (satu konsep baru) |
| 35–40 | **Istirahat** (berdiri, minum, jauh dari layar) |
| 40–65 | **Live coding blok 2** + hasil akhir |
| 65–75 | **Tantangan mini** (teman mengerjakan sendiri, kamu hanya memberi petunjuk) |
| 75–80 | **Cek paham** (3 pertanyaan; lihat tiap sesi) + simpan titik git |

Jika teman terlihat lelah, **potong blok 2** dan akhiri lebih awal dengan hasil yang sudah ada.

---

## 5. Detail setiap sesi

Setiap sesi memuat: **Tujuan · Konsep baru · Alur · Kode inti · Hasil · Tantangan · Cek paham · Jebakan umum · Rujukan project jadi**.

> **Peringatan:** kode contoh di bawah belum dijalankan oleh penulis (tidak ada Flutter di lingkungan penulis). Coba semuanya sendiri **sebelum** sesi dan perbaiki bila ada yang berbeda di versi Flutter kamu.

---

### Sesi 0 — Persiapan & "Halo Dunia"
**Tujuan:** teman melihat aplikasi Flutter berjalan di layar.
**Konsep baru:** hampir tidak ada; fokusnya pada perasaan "ini nyata".

**Alur**
1. (Opsi A/C) Buat project: `flutter create latihan`, lalu `cd latihan` dan `flutter run`.
2. Aplikasi bawaan muncul (tombol `+` menambah angka). Biarkan teman menekan tombolnya.
3. **Hot reload:** buka `lib/main.dart`, ubah tulisan `'Flutter Demo Home Page'` menjadi `'Aplikasi Tauge Saya'`, simpan (atau tekan `r` di terminal). Teman melihat tulisannya berubah tanpa memulai ulang.
4. Ubah warna: cari `Colors.deepPurple`, ganti `Colors.pink`. Simpan.

**Hasil:** aplikasi berjalan di HP/emulator, dan teman sudah mengubah teks serta warna sendiri.
**Cek paham:** (1) Apa yang terjadi saat tekan `r`? (2) File mana yang tadi kita ubah? (3) Bagaimana cara menghentikan aplikasi? (`q` di terminal)
**Jebakan:** `flutter doctor` menampilkan tanda silang → selesaikan sebelum sesi, jangan di depan teman.

---

### Sesi 1 — Dart pertama (DartPad)
**Tujuan:** teman menulis logika sederhana dan paham alur program.
**Konsep baru:** variabel, tipe (`String`, `double`), fungsi, `if/else`, `for`, `print`, interpolasi `$`.
**Rujukan project jadi:** `lib/core/sensor_rules.dart`

**Alur**
1. Buka https://dartpad.dev, hapus isi, ketik:
```dart
void main() {
  double suhu = 29.8;
  print('Suhu sekarang: $suhu');
}
```
Tekan *Run*. Ubah angkanya, jalankan lagi. (Analogi: variabel = kotak berlabel.)

2. Buat fungsi penilai (ketik bersama, jelaskan `if`):
```dart
String cekSuhu(double suhu) {
  if (suhu < 28) {
    return 'Dingin';
  } else if (suhu > 30) {
    return 'Panas';
  } else {
    return 'Ideal';
  }
}

void main() {
  double suhu = 29.8;
  print('Suhu $suhu°C → ${cekSuhu(suhu)}');
}
```
3. Blok 2: daftar dan perulangan.
```dart
void main() {
  final bacaan = [29.2, 29.7, 30.4, 30.1, 27.5];
  for (final b in bacaan) {
    print('$b°C → ${cekSuhu(b)}');
  }
}
```
4. Sengaja buat **satu error** (hapus tanda `;`) dan latih membaca pesan: *"Error di baris berapa? Apa katanya?"*

**Hasil:** program yang menilai 5 suhu sekaligus.
**Tantangan:** buat fungsi `cekKelembapan` (kurang dari 70 = "Kering", 70–80 = "Optimal", lebih dari 80 = "Lembap").
**Cek paham:** (1) Apa beda `String` dan `double`? (2) Apa fungsi `return`? (3) Apa arti `$b` di dalam teks?
**Jebakan:** lupa `;`, salah kurung `{ }`, mengetik `'` vs `"` tidak berpasangan.

---

### Sesi 2 — Widget pertama: Kartu Suhu
**Tujuan:** teman membuat tampilan pertamanya.
**Konsep baru:** widget, `StatelessWidget`, `Container`, `Column`, `Text`, `Icon`, parameter bernama.
**Rujukan:** `lib/widgets/sensor_card.dart` (versi jadi yang lebih rumit)

**Alur**
1. Di DartPad pilih templat Flutter (atau di project lokal ganti isi `main.dart`). Ketik:
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(child: KartuSuhu()),
    ),
  ));
}

class KartuSuhu extends StatelessWidget {
  const KartuSuhu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.thermostat, color: Colors.pink),
          SizedBox(height: 8),
          Text('Suhu'),
          Text('29.8°C',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text('Ideal'),
        ],
      ),
    );
  }
}
```
2. Gambarkan **pohon widget** di kertas: `Container → Column → [Icon, SizedBox, Text, Text, Text]`.
3. Eksperimen bebas: ganti warna, `blurRadius`, `borderRadius`, ukuran huruf. Setiap perubahan → Hot Reload. **Biarkan teman bermain 5–10 menit.**

**Hasil:** kartu suhu yang tampil seperti kartu di aplikasi.
**Tantangan:** ubah menjadi kartu **Kelembapan** (ikon `Icons.water_drop`, warna biru, nilai `78%`).
**Cek paham:** (1) Widget apa yang menyusun ke bawah? (`Column`) ke samping? (`Row`) (2) Apa fungsi `padding`? (3) Mengapa ada kata `const`? *(jawaban cukup: "supaya Flutter tidak menggambar ulang yang tidak berubah")*
**Jebakan:** kurung tidak seimbang (gunakan *format*: `Shift+Alt+F` di VS Code); koma di akhir setiap widget membantu pemformatan.

---

### Sesi 3 — Menyusun layar: Beranda statis
**Tujuan:** menyusun beberapa widget menjadi satu layar yang mirip desain.
**Konsep baru:** `Row`, `Expanded`, `ListView`, `SizedBox` sebagai jarak, memecah widget menjadi beberapa kelas, mengambil warna dari satu file.
**Rujukan:** `lib/screens/dashboard_screen.dart`, `lib/core/app_colors.dart`

**Alur**
1. Jadikan kartu sebelumnya **bisa dipakai ulang** dengan parameter:
```dart
class KartuSensor extends StatelessWidget {
  const KartuSensor({super.key, required this.judul, required this.nilai, required this.ikon, required this.warna});

  final String judul;
  final String nilai;
  final IconData ikon;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: warna),
          const SizedBox(height: 8),
          Text(judul),
          Text(nilai, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
```
2. Pakai tiga kali dalam satu `Row`:
```dart
Row(
  children: [
    Expanded(child: KartuSensor(judul: 'Suhu', nilai: '29.8°C', ikon: Icons.thermostat, warna: Colors.pink)),
    const SizedBox(width: 10),
    Expanded(child: KartuSensor(judul: 'Lembap', nilai: '78%', ikon: Icons.water_drop, warna: Colors.blue)),
    const SizedBox(width: 10),
    Expanded(child: KartuSensor(judul: 'Cahaya', nilai: '24%', ikon: Icons.wb_sunny, warna: Colors.orange)),
  ],
)
```
3. Bungkus dalam `ListView` dengan `padding`, tambahkan judul `Text('Halo, Teman')` dan jarak antar bagian.
4. (Opsional, hanya lokal) Salin `lib/core/app_colors.dart` dari project jadi dan ganti warna sembarang dengan `AppColors.pink500`. Tunjukkan: *"Ubah satu angka warna, semua kartu ikut berubah."*

**Hasil:** layar "Beranda" statis: judul + tiga kartu sensor berjajar.
**Tantangan:** tambahkan kartu besar "Siklus aktif: Hari ke-3 dari 4" di atas tiga kartu.
**Cek paham:** (1) Apa fungsi `Expanded`? (2) Mengapa kartu dibuat sebagai class sendiri? (dipakai ulang) (3) Apa itu parameter `required`?
**Jebakan:** error *RenderFlex overflowed* → bungkus dengan `Expanded` atau `ListView`. Ini momen bagus mengajarkan membaca error.

---

### Sesi 4 — Menyentuh layar: tombol Siram
**Tujuan:** layar bereaksi terhadap sentuhan.
**Konsep baru:** `StatefulWidget`, `setState`, `async/await`, `Future.delayed`, `onPressed`, operator ternary `a ? b : c`.
**Rujukan:** `lib/widgets/water_card.dart` (tampilan) dan `lib/providers/watering_provider.dart` (versi jadi)

**Alur**
1. Ketik terlebih dahulu **versi paling sederhana** (penghitung) agar konsep `setState` jelas:
```dart
class Penghitung extends StatefulWidget {
  const Penghitung({super.key});
  @override
  State<Penghitung> createState() => _PenghitungState();
}

class _PenghitungState extends State<Penghitung> {
  int _jumlah = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _jumlah = _jumlah + 1;
        });
      },
      child: Text('Disiram $_jumlah kali'),
    );
  }
}
```
Tunjukkan: hapus `setState` → angka **tidak** berubah di layar. Ini pelajaran terpenting sesi ini.

2. Lanjut ke versi tombol Siram:
```dart
class TombolSiram extends StatefulWidget {
  const TombolSiram({super.key});
  @override
  State<TombolSiram> createState() => _TombolSiramState();
}

class _TombolSiramState extends State<TombolSiram> {
  bool _sedangSiram = false;

  Future<void> _siram() async {
    setState(() => _sedangSiram = true);
    await Future.delayed(const Duration(seconds: 2)); // pura-pura menyiram
    if (!mounted) return;
    setState(() => _sedangSiram = false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _sedangSiram ? null : _siram,
      child: Text(_sedangSiram ? 'Menyiram...' : 'Siram'),
    );
  }
}
```
3. Tambahkan `Text` status di bawah tombol: "Terakhir disiram: baru saja".

**Hasil:** tombol yang berubah menjadi "Menyiram..." selama 2 detik, tidak bisa ditekan dua kali, lalu kembali normal. (Ini sama dengan simulasi 2,2 detik di desain web.)
**Tantangan:** tampilkan `CircularProgressIndicator` kecil selama menyiram.
**Cek paham:** (1) Apa yang terjadi jika `setState` dihapus? (2) Mengapa `onPressed: null` membuat tombol mati? (3) Apa arti `await`? *("menunggu tanpa membekukan layar")*
**Jebakan:** mengubah variabel tanpa `setState`; menulis `onPressed: _siram()` (dengan kurung) alih-alih `_siram`.

---

### Sesi 5 — Data berbentuk daftar: halaman Perangkat
**Tujuan:** menampilkan banyak data dari `list`.
**Konsep baru:** `class` sebagai model data, `List`, `for` di dalam daftar widget, `if` di dalam daftar widget, `ListView`.
**Rujukan:** `lib/models/device_model.dart`, `lib/widgets/device_card.dart`, `lib/screens/devices_screen.dart`

**Alur**
1. Buat model:
```dart
class Perangkat {
  const Perangkat({required this.id, required this.nama, required this.lokasi, required this.online});

  final String id;
  final String nama;
  final String lokasi;
  final bool online;
}
```
2. Buat data contoh:
```dart
const daftarPerangkat = [
  Perangkat(id: 'WMS-001', nama: 'Tauge Utama', lokasi: 'Rak A · Dapur', online: true),
  Perangkat(id: 'WMS-002', nama: 'Tauge Batch 02', lokasi: 'Rak B · Dapur', online: false),
];
```
3. Tampilkan:
```dart
ListView(
  padding: const EdgeInsets.all(16),
  children: [
    for (final p in daftarPerangkat)
      Card(
        child: ListTile(
          title: Text(p.nama),
          subtitle: Text('${p.id} · ${p.lokasi}'),
          trailing: Text(p.online ? 'ONLINE' : 'OFFLINE',
              style: TextStyle(color: p.online ? Colors.green : Colors.grey)),
        ),
      ),
  ],
)
```
4. Tambahkan perangkat ketiga di daftar → Hot Reload → kartunya muncul. *"Kita tidak menulis kartu baru, cukup menambah data."*

**Hasil:** halaman Perangkat dengan daftar dari data contoh.
**Tantangan:** tampilkan teks "Belum ada perangkat" jika daftar kosong (`if (daftar.isEmpty) ...`).
**Cek paham:** (1) Apa itu *model*? (2) Apa fungsi `for ... in` di dalam `children`? (3) Bagaimana menambah satu perangkat lagi?
**Jebakan:** lupa `const` pada daftar yang berisi objek `const`; mencampur `'` dengan `"` di dalam teks.

---

### Sesi 6 — Banyak halaman: navigasi bawah
**Tujuan:** aplikasi punya beberapa halaman yang bisa dipindah.
**Konsep baru:** `Scaffold`, `BottomNavigationBar`, state sederhana (`int _tab`), memilih halaman dengan `switch`/daftar.
**Rujukan:** `lib/screens/main_shell.dart`, `lib/widgets/app_bottom_nav.dart`

**Alur**
1. Gabungkan hasil sesi 3 (Beranda) dan sesi 5 (Perangkat), tambahkan halaman ketiga `Center(child: Text('Profil'))`.
2. Ketik:
```dart
class Utama extends StatefulWidget {
  const Utama({super.key});
  @override
  State<Utama> createState() => _UtamaState();
}

class _UtamaState extends State<Utama> {
  int _tab = 0;

  final List<Widget> _halaman = const [
    BerandaScreen(),
    PerangkatScreen(),
    Center(child: Text('Profil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Perangkat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
```
(`BerandaScreen` dan `PerangkatScreen` = hasil sesi 3 dan 5 yang dibungkus menjadi `StatelessWidget`.)

**Hasil:** aplikasi 3 tab yang berpindah halaman saat disentuh.
**Tantangan:** tambahkan tab keempat "Monitor".
**Cek paham:** (1) Variabel mana yang menyimpan tab aktif? (2) Mengapa memakai `setState` di sini? (3) Bagaimana menambah satu halaman?
**Penghubung ke sesi 7 (ajukan pertanyaan ini di akhir):** *"Bagaimana jika halaman Profil perlu tahu jumlah perangkat di halaman Perangkat?"* Biarkan teman merasakan masalahnya. Jawabannya: Provider.

---

### Sesi 7 — Provider: berbagi data antar halaman ⭐
**Tujuan:** teman merasakan manfaat state management. **Ini sesi paling penting; beri waktu lebih.**
**Konsep baru:** `ChangeNotifier`, `notifyListeners`, `ChangeNotifierProvider`, `context.watch`, `context.read`.
**Rujukan:** `lib/providers/device_provider.dart`, `lib/providers/navigation_provider.dart`, `lib/app.dart`, dokumen 02 bagian 4

**Alur**
1. Tambahkan `provider` ke project lokal: `flutter pub add provider`.
2. Jelaskan masalah (lihat penghubung sesi 6) memakai analogi **papan pengumuman**.
3. Buat "papan pengumuman" untuk daftar perangkat:
```dart
import 'package:flutter/foundation.dart';

class DaftarPerangkat extends ChangeNotifier {
  final List<Perangkat> _items = [
    const Perangkat(id: 'WMS-001', nama: 'Tauge Utama', lokasi: 'Rak A', online: true),
  ];

  List<Perangkat> get items => List.unmodifiable(_items);

  void tambah(Perangkat p) {
    _items.add(p);
    notifyListeners(); // "ada pengumuman baru!"
  }

  void hapus(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
```
4. Pasang di paling atas aplikasi:
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DaftarPerangkat(),
      child: const MaterialApp(home: Utama()),
    ),
  );
}
```
5. **Baca** data di halaman Perangkat dan Profil:
```dart
final items = context.watch<DaftarPerangkat>().items;   // di dalam build
Text('Perangkat: ${items.length}')
```
6. **Ubah** data dari tombol:
```dart
onPressed: () {
  context.read<DaftarPerangkat>().tambah(
    const Perangkat(id: 'WMS-003', nama: 'Baru', lokasi: 'Rak C', online: true),
  );
}
```
7. Demo penutup: tekan tombol "Tambah" di tab Perangkat → pindah ke tab Profil → angka jumlah perangkat sudah naik. **Berhenti sebentar, biarkan teman menikmati momen ini.**

**Hasil:** tambah dan hapus perangkat di satu halaman; halaman lain ikut berubah.
**Tantangan:** tambahkan tombol hapus pada setiap perangkat.
**Cek paham:** (1) Beda `watch` dan `read`? (`watch` untuk membaca di `build`, `read` untuk aksi di tombol) (2) Apa yang terjadi jika lupa `notifyListeners()`? (3) Mengapa Provider diletakkan paling atas?
**Jebakan:** memakai `context.watch` di dalam `onPressed` (error); lupa membungkus aplikasi dengan `ChangeNotifierProvider` (*Could not find the correct Provider*).

---

### Sesi 8 — Login dengan Firebase
**Tujuan:** pengalaman pertama berbicara dengan cloud.
**Mode belajar berubah:** mulai sesi ini kita **membaca dan memodifikasi sedikit** kode project jadi, bukan menulis dari nol. Menulis kode Firebase dari nol terlalu berat untuk pemula.
**Konsep baru:** layanan cloud, autentikasi, pembagian service/provider/screen.
**Rujukan:** `lib/services/auth_service.dart`, `lib/providers/auth_provider.dart`, `lib/screens/login_screen.dart`, dokumen 02 bagian 3

**Alur**
1. Tunjukkan Firebase Console (project yang sudah kamu siapkan): *Authentication → Users*. Ada satu pengguna.
2. Buka project jadi dan jalankan. Layar Login muncul. Coba login dengan password **salah** → baca pesan error → login dengan password benar.
3. **Tur kode terarah (30 menit):** buka berurutan, hanya baca dan tanya "menurutmu ini melakukan apa?":
   `login_screen.dart` (form) → `auth_provider.dart` (state) → `auth_service.dart` (Firebase).
   Gambar tiga kotak: **Layar → Provider → Service → Firebase**.
4. **Modifikasi kecil oleh teman:** di `auth_provider.dart`, ubah pesan `'Username atau password salah.'` menjadi kalimat buatannya sendiri. Hot Reload → coba login salah → pesannya berubah.
5. Di `app.dart`, tunjukkan `AuthGate`: *"Inilah satpam yang memilih tampilkan Login atau Beranda."*

**Hasil:** login sungguhan ke Firebase; teman mengubah satu pesan error dan melihat hasilnya.
**Tantangan:** ubah teks tombol "Masuk →" menjadi teks lain.
**Cek paham:** (1) Siapa yang berbicara dengan Firebase? (`Service`) (2) Mengapa layar tidak langsung memanggil Firebase? (3) Apa arti `isLoggedIn`?
**Jebakan:** project jadi belum dihubungkan (`flutterfire configure`) → kamu harus menyelesaikan ini **sebelum** sesi.

---

### Sesi 9 — Realtime Database: data yang "hidup"
**Tujuan:** teman melihat data aplikasi hidup di database online dan berubah seketika.
**Konsep baru:** database cloud, node/pohon JSON, CRUD (Create/Read/Update/Delete), `Stream` dan `listen`.
**Rujukan:** `lib/services/rtdb_paths.dart`, `lib/services/device_service.dart`, `lib/providers/device_provider.dart`, `lib/screens/devices_screen.dart`, dokumen 03 (bagian 2–3)

**Alur**
1. Di aplikasi, buka Profil → tekan **"Isi data contoh"** (hanya mode debug). Pindah ke Firebase Console → **Realtime Database**: tunjukkan pohon `users → {uid} → devices → WMS-001 → config / sensor / lastWatering`. Analogi **papan tulis**: isinya "keadaan sekarang".
2. Buka tab Perangkat dan Beranda: data yang sama tampil.
3. **Demo wow (10 menit):** tampilkan aplikasi di HP dan Console berdampingan. Ubah `sensor/temperature` dari 29.8 menjadi 33.5. **Angka di HP berubah sendiri**, kartu menjadi "Panas". Ubah `sensor/isOnline` menjadi `false`: label berubah. *Biarkan teman menikmati momen ini.*
4. Analogi **keran air**: Stream = air yang terus mengalir; `listen` = menaruh ember di bawah keran. Baca bersama:
```dart
_subscription = _service.watchDevices(newUserId).listen((list) {
  _devices = list;
  notifyListeners();
});
```
   *"Setiap kali database mengirim daftar baru, simpan ke `_devices`, lalu teriak ke layar."*
5. **Create/Update/Delete:** tekan *Tambah* di aplikasi → perangkat baru muncul di Console (node baru). Edit nama → `config/name` berubah. Hapus → node hilang. Cocokkan dengan fungsi `addDevice`, `updateDevice`, `deleteDevice` di `device_service.dart`.

**Hasil:** mengubah angka di Console langsung mengubah layar HP; menambah perangkat di aplikasi muncul di Console.
**Tantangan:** ubah `config/location` di Console dan temukan di mana teks lokasi muncul di aplikasi.
**Cek paham:** (1) Apa itu Stream (dengan kata sendiri)? (2) Mengapa tidak perlu tombol refresh? (3) Siapa yang nanti menulis suhu sungguhan? (Wemos)
**Jebakan:** `permission-denied` → aturan RTDB belum dipublish; aplikasi tidak bisa terhubung → RTDB dibuat setelah `flutterfire configure` (dokumen 07).

---

### Sesi 10 — Firestore: riwayat dan dokumentasi tanam
**Tujuan:** teman memahami **kenapa ada dua database** dan melihat Firestore bekerja.
**Konsep baru:** collection/document, kueri berdasarkan waktu, perbedaan "data sekarang" vs "riwayat".
**Rujukan:** `lib/services/batch_service.dart`, `lib/services/sensor_service.dart`, `lib/providers/sensor_provider.dart`, `lib/widgets/sensor_line_chart.dart` *(kotak hitam)*, dokumen 03 (bagian 2 dan 4)

**Alur**
1. Mulai dengan analogi: **RTDB = papan tulis** (dihapus dan ditulis ulang terus), **Firestore = buku catatan arsip** (halaman terus bertambah). Tanya teman: *"Kalau mau lihat suhu seminggu lalu, di mana kita cari?"*
2. Buka Console → **Firestore Database**: tunjukkan `users → {uid} → batches` (3 dokumen) dan `devices → WMS-001 → readings` (6 dokumen). Analogi **lemari arsip**: koleksi = laci, dokumen = map berisi data.
3. Buka tab **Riwayat** di aplikasi: tiap kartu = satu dokumen `batches`. **Ubah `isActive` satu batch di Console** dan lihat kartunya pindah antara "Aktif" dan "Selesai" (Firestore juga mendukung pembaruan realtime).
4. Buka **Monitoring**: grafik membaca `readings`. Ubah rentang "Hari ini / 7 hari / 30 hari" → itu hanya mengganti kueri waktu. **Grafik digambar oleh `CustomPainter` dan tidak dibedah** (kotak hitam).
5. Tambah dokumen `readings` baru lewat Console (isi `temperature`, `humidity`, `light`, dan `createdAt` bertipe **timestamp**) → titik baru muncul di grafik. Pelajaran: *`createdAt` harus bertipe timestamp*.

**Hasil:** Riwayat dan grafik terisi dari Firestore, dan teman bisa menjelaskan pembagian RTDB vs Firestore dengan kata-katanya sendiri.
**Tantangan:** tambah satu dokumen `batches` baru lewat Console dan lihat muncul di Riwayat.
**Cek paham:** (1) Data apa yang disimpan di RTDB, dan di Firestore? (2) Mengapa grafik tidak memakai RTDB? (3) Mengapa rekaman Firestore cukup tiap 15–30 menit, sedangkan RTDB tiap beberapa detik?
**Jebakan:** `startDate` hilang → batch tidak muncul; `createdAt` bukan timestamp → data tidak muncul di grafik.

---

### Sesi 11 — Siram sungguhan & tur project
**Tujuan:** menyambungkan semua pengetahuan menjadi peta besar, dan menutup dengan rasa bangga.
**Rujukan:** `lib/services/watering_service.dart`, `lib/providers/watering_provider.dart`, dokumen 02 (bagian 6) dan 06 (Wemos)

**Alur**
1. Tekan **Siram** di aplikasi. Setelah 30 detik muncul pesan "Wemos belum merespons". Buka Console → RTDB → `devices/WMS-001/command`: perintah ada di sana (`status: timeout`).
2. Ulangi, tetapi **kali ini kamu berperan sebagai Wemos**: saat tombol ditekan, buka Console dan ubah `command/status` menjadi `done`. Aplikasi menampilkan "Penyiraman selesai". Lalu ubah `lastWatering/at` (isi angka milidetik, atau salin dari `command/requestedAt`) → tulisan "Terakhir · …" di Beranda ikut berubah. *"Kamu baru saja memainkan peran perangkat keras."*
3. Matikan internet HP lalu tekan Siram → muncul "Tidak ada koneksi internet". Jelaskan: *perintah yang ditulis saat offline akan menunggu lalu terkirim belakangan, jadi pompa bisa menyala tiba-tiba*. Itu alasan tombolnya dikunci.
4. Gambar **peta besar** bersama (dokumen 02, bagian 1 dan 3): Wemos ⇄ RTDB / Firestore ⇄ Aplikasi; Layar → Provider → Service → Firebase.
5. Tunjukkan folder `docs/` dan beri tugas membaca dokumen 05 (kamus) saat butuh.
6. Berikan **tantangan akhir** (pilih satu): mengganti warna utama di `app_colors.dart`; mengubah `config/wateringSeconds` di Console dan melihat teks "Pompa aktif · N dtk" berubah; menambah satu teks baru di Profil.
7. **Refleksi (5 menit):** *"Apa yang tadinya terasa mustahil, sekarang terasa biasa?"*

**Hasil:** teman menjalankan alur siram penuh dan bisa menjelaskan peta besar dengan kata-katanya sendiri.
**Selanjutnya (opsional):** membaca dokumen 06 untuk mulai memprogram Wemos; belajar dasar Git; membuat fitur baru (mis. layar pengaturan jadwal siram yang menulis ke `config`).

---

## 6. Tanda burnout & cara menanganinya

| Tanda | Yang bisa kamu lakukan |
|---|---|
| Diam lama, tidak lagi bertanya | Berhenti sebentar. Tanya: "Bagian mana yang paling membingungkan?" |
| Mengetik asal / menyalin tanpa membaca | Jeda 5 menit; minta teman **menjelaskan satu baris** kode yang baru diketik |
| Kata-kata: "aku bodoh", "ini terlalu sulit" | Hentikan sesi lebih awal. Tunjukkan semua yang sudah dibuatnya. Normalisasi: "Semua programmer kebingungan di bagian ini." |
| Marah pada error | Ajarkan error sebagai petunjuk: "Error ini baik, dia memberi tahu persis baris berapa." |
| Sering absen | Kurangi beban: potong sesi menjadi 45 menit, hapus tantangan, atau pakai jalur singkat |
| Terlalu mudah / bosan | Beri tantangan tambahan atau minta dia mengajarkan konsep itu balik ke kamu |

**Aturan darurat:** jika sesi berantakan, kembalikan ke titik git terakhir yang berjalan, jalankan aplikasi, dan akhiri dengan hasil yang sudah ada. Lebih baik berhenti dengan rasa berhasil daripada memaksa sampai selesai.

**Hal yang sebaiknya dihindari**
- Menjelaskan *semua* detail baris per baris (cukup bagian yang relevan hari ini).
- Menyebut banyak istilah baru sekaligus (maksimal 3 istilah baru per sesi).
- Membandingkan kecepatan belajar dengan orang lain.
- Memperbaiki error temanmu tanpa memberi kesempatan mencari tahu 3–5 menit dulu.

---

## 7. Jalur singkat (jika waktu terbatas)

Jika hanya ada ±6 sesi:

| Urutan | Sesi |
|---|---|
| 1 | Sesi 0 (persiapan) |
| 2 | Sesi 2 (widget pertama) + sebagian Sesi 3 |
| 3 | Sesi 4 (tombol Siram) |
| 4 | Sesi 7 (Provider) *— versi ringkas tanpa tantangan* |
| 5 | Sesi 9 (Firestore: demo + baca kode) |
| 6 | Sesi 10 + 11 (realtime, siram, peta besar) |

Sesi 1, 5, 6, 8 dijadikan **bahan bacaan mandiri** dan dibahas singkat bila ada pertanyaan.

---

## 8. Git: titik simpan per sesi

Menyimpan hasil tiap sesi memudahkan kembali ke kondisi yang berjalan dan membuat teman bisa melihat kemajuannya.

```bash
# Sekali saja, di folder latihan
git init
git add .
git commit -m "Sesi 0: aplikasi pertama berjalan"

# Akhir tiap sesi
git add .
git commit -m "Sesi 3: Beranda statis"
git tag sesi-3

# Kembali ke akhir sesi tertentu (jika sesi berikutnya berantakan)
git checkout sesi-3          # lihat kondisi saat itu
git checkout main            # kembali ke terbaru
```

> Jangan mengajarkan seluruh Git di awal. Cukup kamu yang menjalankan perintah di atas di akhir sesi, dan teman
> **melihat riwayatnya** sebagai "album kemajuan". Ajarkan Git secara bertahap setelah sesi 11.

**Cadangan kunci jawaban:** simpan project jadi (zip yang kamu terima) di folder terpisah, mis. `taugeku-jadi/`.
Jangan dibuka sampai Sesi 8, kecuali teman ingin mengintip untuk tantangan.

---

## 9. Contoh jadwal

| Minggu | Sesi 1 | Sesi 2 |
|---|---|---|
| 1 | Sesi 0 (persiapan) + Sesi 1 (Dart) | Sesi 2 (kartu suhu) |
| 2 | Sesi 3 (Beranda statis) | Sesi 4 (tombol Siram) |
| 3 | Sesi 5 (daftar perangkat) | Sesi 6 (navigasi) |
| 4 | Sesi 7 (**Provider**), beri waktu penuh | Latihan ulang Sesi 7 / tantangan |
| 5 | Sesi 8 (login Firebase) | Sesi 9 (Firestore) |
| 6 | Sesi 10 (realtime) | Sesi 11 (siram & tur) |

Sisakan **satu minggu cadangan** untuk mengulang sesi yang terasa berat, terutama Sesi 4 dan Sesi 7.
