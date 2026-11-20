"""Membuat semua diagram SVG di docs/images/.

Jalankan:  python3 gen.py            (hanya SVG)
           python3 gen.py --preview  (SVG + pratinjau PNG di folder preview/)
"""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from dlib import *

OUT = os.path.normpath(os.path.join(HERE, '..', '..', 'docs', 'images'))
PRE = os.path.join(HERE, 'preview')
WITH_PREVIEW = '--preview' in sys.argv
os.makedirs(OUT, exist_ok=True)
if WITH_PREVIEW: os.makedirs(PRE, exist_ok=True)
made = []

def done(s, name):
    s.save(f'{OUT}/{name}.svg')
    if WITH_PREVIEW: preview(s, f'{PRE}/{name}.png', 1.4)
    made.append(name)

# ---------------------------------------------------------------- 1. arsitektur besar
def d_arsitektur():
    s = Svg(900, 430, 'Gambaran besar arsitektur TaugeKu',
            'Wemos menulis ke Realtime Database dan Firestore. Aplikasi Flutter membaca keduanya dan menulis perintah ke Realtime Database. Login lewat Firebase Authentication.')
    s.box(24, 168, 170, 84, 'Wemos D1 Mini', 'sensor + pompa', 'gray')
    box3(s, 340, 40, 230, 100, 'Realtime Database', 'data SAAT INI', 'sensor · perintah · config', 'coral')
    box3(s, 340, 270, 230, 100, 'Cloud Firestore', 'RIWAYAT & arsip', 'batch tanam · rekaman terjadwal', 'amber')
    s.box(700, 168, 190, 84, 'Aplikasi', 'Flutter + Provider', 'purple')
    s.box(705, 300, 180, 64, 'Firebase Auth', 'login pengguna', 'green')
    s.line(196, 195, 338, 105, start=True, end=True)
    s.label(260, 135, 'tiap 5–10 dtk')
    s.line(196, 226, 338, 316)
    s.label(260, 290, 'tiap 15–30 mnt')
    s.line(572, 105, 698, 192, start=True, end=True)
    s.label(655, 140, 'realtime')
    s.line(572, 316, 698, 230)
    s.label(655, 290, 'kueri riwayat')
    s.line(795, 298, 795, 254)
    s.label(795, 276, 'login')
    caption(s, 405, 'Aplikasi tidak pernah berbicara langsung dengan Wemos: keduanya hanya membaca dan menulis database.')
    done(s, 'arsitektur-besar')

# ---------------------------------------------------------------- 2. peta folder
def d_folder():
    W = 900
    s = Svg(W, 1020, 'Peta folder project TaugeKu',
            'Kartu per folder: lib root, core, models, services, providers, screens, widgets, dan file di luar lib.')
    cw = 420
    xl, xr = 20, 460
    left = [
        ('lib/', 'titik masuk aplikasi', 'gray', [('main.dart', 'menyalakan Firebase, menjalankan app'), ('app.dart', 'daftar Provider + AuthGate'), ('firebase_options.dart', 'dibuat flutterfire configure')], 1),
        ('models/', 'LAPISAN 1 · bentuk data', 'blue', [('device_model.dart', 'RTDB'), ('activity_item.dart', 'RTDB'), ('notification_item.dart', 'RTDB'), ('planting_batch.dart', 'Firestore'), ('sensor_reading.dart', 'Firestore'), ('user_profile.dart', 'dari Firebase Auth')], 1),
        ('providers/', 'LAPISAN 3 · state management (Provider)', 'purple', [('user_scoped_provider.dart', 'kelas dasar'), ('auth_provider.dart', 'login / logout'), ('navigation_provider.dart', 'tab aktif'), ('toast_provider.dart', 'pesan singkat'), ('device_provider.dart', 'perangkat + sensor realtime'), ('sensor_provider.dart', 'riwayat untuk grafik'), ('batch_provider.dart', 'siklus tanam'), ('activity_provider.dart', 'aktivitas'), ('notification_provider.dart', 'notifikasi'), ('watering_provider.dart', 'tombol Siram'), ('profile_provider.dart', 'profil + foto sementara')], 1),
        ('widgets/', 'potongan tampilan yang dipakai ulang', 'pink', ['app_icon.dart', 'soft_card.dart', 'eyebrow.dart', 'icon_bubble.dart', 'section_heading.dart', 'page_title.dart', 'empty_state.dart', 'app_background.dart', 'user_avatar.dart', 'refresh_button.dart', 'app_header.dart', 'app_bottom_nav.dart', 'app_toast.dart', 'notifications_popover.dart', 'sensor_card.dart', 'hero_card.dart', 'water_card.dart', 'gauge_card.dart', 'sensor_line_chart.dart', 'batch_cards.dart', 'device_card.dart', 'device_form_sheet.dart', 'confirm_delete_dialog.dart'], 2),
    ]
    right = [
        ('core/', 'hal umum (tidak tahu soal Firebase atau layar)', 'gray', [('app_colors.dart', 'semua warna'), ('app_text.dart', 'gaya teks'), ('app_theme.dart', 'tema Material'), ('app_radius.dart', 'sudut "daun"'), ('app_constants.dart', 'angka tetap'), ('app_format.dart', 'format jam, tanggal, angka'), ('rtdb_utils.dart', 'baca data RTDB dengan aman'), ('sensor_rules.dart', 'arti angka sensor'), ('watering_schedule.dart', 'jadwal siram berikutnya')], 1),
        ('services/', 'LAPISAN 2 · satu-satunya yang menyentuh Firebase', 'teal', [('rtdb_paths.dart', 'alamat node RTDB'), ('firestore_paths.dart', 'alamat koleksi Firestore'), ('auth_service.dart', 'Authentication'), ('device_service.dart', 'RTDB'), ('watering_service.dart', 'RTDB'), ('activity_service.dart', 'RTDB'), ('notification_service.dart', 'RTDB'), ('batch_service.dart', 'Firestore'), ('sensor_service.dart', 'Firestore'), ('demo_data_service.dart', 'data contoh (debug)')], 1),
        ('screens/', 'LAPISAN 4 · halaman penuh', 'pink', [('login_screen.dart', 'Login'), ('main_shell.dart', 'header + halaman + navigasi bawah'), ('dashboard_screen.dart', 'Beranda'), ('monitor_screen.dart', 'Monitoring'), ('history_screen.dart', 'Riwayat'), ('devices_screen.dart', 'Perangkat'), ('profile_screen.dart', 'Profil')], 1),
        ('di luar lib/', 'aset, tes, aturan, dokumentasi', 'green', [('assets/images/tauge.jpg', 'foto desain'), ('test/app_format_test.dart', 'unit test'), ('database.rules.json', 'aturan RTDB'), ('firestore.rules', 'aturan Firestore'), ('firebase.json', 'konfigurasi deploy'), ('docs/', 'dokumentasi')], 1),
    ]
    def col(x, items):
        y = 24
        for title, sub, ramp, rows, ncols in items:
            h = folder_card(s, x, y, cw, title, sub, ramp, rows, ncols)
            y += h + 14
        return y
    yl = col(xl, left); yr = col(xr, right)
    H = int(max(yl, yr) + 34)
    s.h = H
    caption(s, H - 20, 'Aturan: lapisan atas boleh memanggil lapisan di bawahnya (screens → providers → services → models), tidak sebaliknya.')
    done(s, 'peta-folder')

# ---------------------------------------------------------------- 3. empat lapisan
def d_lapisan():
    s = Svg(900, 566, 'Empat lapisan kode TaugeKu',
            'Screens dan widgets memanggil providers, providers memanggil services, services memakai models. Setiap lapisan punya hal yang boleh dan tidak boleh dilakukan.')
    layers = [
        ('Screens / Widgets', 'menggambar layar, menangkap sentuhan', 'pink',
         'tampilkan data, panggil method Provider', 'menyentuh Firebase langsung'),
        ('Providers', 'menyimpan state, memberi tahu layar saat berubah', 'purple',
         'simpan state, panggil Service', 'membuat widget'),
        ('Services', 'satu-satunya yang menyentuh Firebase', 'teal',
         'memanggil Firebase', 'tahu soal layar atau Provider'),
        ('Models', 'bentuk data: Map Firebase ⇄ objek Dart', 'blue',
         'simpan data, konversi dari/ke Map', 'memanggil Firebase (selain tipe data seperti Timestamp atau User)'),
    ]
    y = 40
    s.text(40, 20, 'LAPISAN', 11, 700, MUTED); s.text(560, 20, 'ATURAN', 11, 700, MUTED)
    for i, (t, sub, ramp, ok, no) in enumerate(layers):
        s.box(40, y, 460, 84, t, sub, ramp, 15, 12)
        w1 = s.pill(560, y + 20, 'BOLEH', 'green', size=10, pad=8, h=18)
        s.text(560 + w1 + 10, y + 20, ok, 12, 400, INK)
        w2 = s.pill(560, y + 50, 'TIDAK', 'red', size=10, pad=8, h=18)
        for li, ln in enumerate(wrap(no, 12, 235)):
            s.text(560 + w2 + 10, y + 50 + li*16, ln, 12, 400, INK)
        if i < 3:
            s.line(270, y + 86, 270, y + 130)
            lab = ['memanggil method, context.watch', 'memanggil', 'memakai bentuk data'][i]
            s.text(284, y + 108, lab, 12, 400, MUTED)
        y += 132
    caption(s, 538, 'Jika Firebase diganti backend lain, cukup ubah folder services/.')
    done(s, 'empat-lapisan')

# ---------------------------------------------------------------- 4-6. urutan
def d_seq_siram():
    s = sequence('Alur tombol Siram', 'Dari tap tombol Siram, perintah ditulis ke node command di Realtime Database, Wemos menyalakan pompa lalu menjawab done, dan layar menampilkan toast.',
        [('Layar', 'DashboardScreen', 'pink'), ('Provider', 'WateringProvider', 'purple'), ('Service', 'WateringService', 'teal'), ('RTDB', 'node command', 'coral'), ('Wemos', 'pompa + sensor', 'gray')],
        [dict(f=0, t=1, label='onPressed → startWatering()'),
         dict(f=1, self=True, label='cek: online? tersambung? lalu isWatering = true, notifyListeners()'),
         dict(f=1, t=2, label='requestWatering(...)'),
         dict(f=2, t=3, label='set command: pending'),
         dict(f=3, t=4, label='onValue: pending'),
         dict(f=4, self=True, label='cek umur perintah, pompa menyala 10 dtk'),
         dict(f=4, t=3, label='status = done, isi lastWatering'),
         dict(f=3, t=2, label='onValue: status = done'),
         dict(f=2, t=1, label='hasil: done'),
         dict(f=1, self=True, label='isWatering = false, notifyListeners()'),
         dict(f=1, t=0, label='WateringResult.success'),
         dict(f=0, self=True, label='toast "Penyiraman selesai", teks "Terakhir" ikut berubah')],
        spacing=176, footer=['Tanpa jawaban dalam 30 detik: status ditulis timeout. Saat aplikasi offline, tombol Siram ditolak sejak awal.'])
    done(s, 'alur-siram')

def d_seq_sensor():
    s = sequence('Alur data sensor realtime', 'Wemos menulis sensor ke RTDB, perubahan mengalir lewat DeviceService dan DeviceProvider hingga layar Beranda dan gauge Monitoring digambar ulang.',
        [('Wemos', 'pompa + sensor', 'gray'), ('RTDB', 'node sensor', 'coral'), ('Service', 'DeviceService', 'teal'), ('Provider', 'DeviceProvider', 'purple'), ('Layar', 'Beranda · Monitoring', 'pink')],
        [dict(f=0, t=1, label='PATCH sensor: suhu 30.1, ...'),
         dict(f=1, t=2, label='onValue: data berubah'),
         dict(f=2, self=True, label='asStringMap lalu DeviceModel.fromRtdb'),
         dict(f=2, t=3, label='emit List<DeviceModel>'),
         dict(f=3, self=True, label='_devices = list, notifyListeners()'),
         dict(f=3, t=4, label='memberi tahu pendengar'),
         dict(f=4, self=True, label='build() ulang: Beranda dan gauge menampilkan 30.1 °C')],
        spacing=176, footer=['Tidak ada tombol refresh: aliran (stream) terus mengalir selama pengguna login.'])
    done(s, 'alur-sensor-realtime')

def d_seq_grafik():
    s = sequence('Alur grafik riwayat', 'Memilih rentang 7 hari membuat SensorProvider membuat kueri baru ke Firestore, meringkas data, lalu grafik digambar ulang.',
        [('Layar', 'MonitorScreen', 'pink'), ('Provider', 'SensorProvider', 'purple'), ('Service', 'SensorService', 'teal'), ('Firestore', 'readings', 'amber')],
        [dict(f=0, t=1, label='pilih "7 hari": setRange(week)'),
         dict(f=1, self=True, label='batalkan langganan lama, buat kueri baru'),
         dict(f=1, t=2, label='watchReadings(since: 7 hari lalu)'),
         dict(f=2, t=3, label='createdAt ≥ awal, desc, limit 500'),
         dict(f=3, t=2, label='snapshot dokumen readings'),
         dict(f=2, t=1, label='List<SensorReading>'),
         dict(f=1, self=True, label='balik urutan (lama ke baru), ringkas ≤ 8 titik'),
         dict(f=1, t=0, label='notifyListeners()'),
         dict(f=0, self=True, label='SensorLineChart menggambar ulang kurva')],
        spacing=190, footer=['Memilih rentang hanya mengganti kueri; datanya di Firestore tidak berubah.'])
    done(s, 'alur-grafik')

# ---------------------------------------------------------------- 7. startup
def d_startup():
    s = Svg(900, 600, 'Alur startup aplikasi', 'main() menyalakan Firebase dan menjalankan TaugeKuApp. AuthGate memilih layar loading, MainShell, atau LoginScreen berdasarkan status login.')
    s.box(350, 24, 200, 56, 'main()', 'lib/main.dart', 'gray')
    s.line(450, 82, 450, 106)
    s.rect(270, 108, 360, 88, '#f9fafb', '#d1d5db', 10, 1)
    s.text(288, 130, '1. WidgetsFlutterBinding.ensureInitialized()', 12, 400, INK, kind='mono')
    s.text(288, 152, '2. Firebase.initializeApp(...)', 12, 400, INK, kind='mono')
    s.text(288, 174, '3. runApp(TaugeKuApp)', 12, 400, INK, kind='mono')
    s.line(450, 198, 450, 226)
    s.box(300, 228, 300, 60, 'TaugeKuApp', 'lib/app.dart: MultiProvider lalu MaterialApp', 'purple')
    s.line(450, 290, 450, 318)
    s.box(350, 320, 200, 56, 'AuthGate', 'membaca AuthProvider', 'purple')
    # cabang
    bx = [(30, 'isInitializing', 'layar loading', 'Firebase belum menjawab', 'gray'),
          (335, 'sudah login', 'MainShell', 'header + halaman + navigasi bawah', 'green'),
          (640, 'belum login', 'LoginScreen', 'form username dan password', 'pink')]
    for x, t, sub, small, ramp in bx:
        box3(s, x, 448, 230, 96, t, sub, small, ramp)
        cx = x + 115
        s.poly([(450, 378), (450, 412), (cx, 412), (cx, 446)])
    caption(s, 578, 'Login berhasil: isLoggedIn menjadi true, layar berganti otomatis (tanpa Navigator.push manual).')
    done(s, 'startup')

# ---------------------------------------------------------------- 8. peta langganan
def d_langganan():
    s = Svg(900, 450, 'Peta langganan provider per pengguna', 'AuthProvider memberi uid ke empat provider data; DeviceProvider memberi deviceId ke SensorProvider dan WateringProvider.')
    s.box(350, 24, 200, 60, 'AuthProvider', 'uid pengguna yang login', 'green')
    row = [(40, 'Device', 'RTDB · devices', 'coral'), (250, 'Activity', 'RTDB · activities', 'coral'),
           (460, 'Notification', 'RTDB · notifications', 'coral'), (670, 'Batch', 'Firestore · batches', 'amber')]
    for x, t, sub, ramp in row:
        s.box(x, 160, 190, 62, t, sub, ramp)
        s.line(450 if x > 400 else 450, 86, x + 95, 158) if False else None
    for x, t, sub, ramp in row:
        s.line(450 + (x + 95 - 450)*0.12, 86, x + 95, 158)
    s.label(450, 128, 'setUser(uid)', bg=False) if False else None
    s.box(40, 316, 190, 62, 'Sensor', 'Firestore · readings', 'amber')
    s.box(250, 316, 190, 62, 'Watering', 'RTDB · command', 'coral')
    s.line(100, 224, 100, 314)
    s.label(100, 270, 'deviceId')
    s.line(170, 224, 330, 314)
    s.label(250, 270, 'deviceId')
    s.rect(40, 404, 14, 14, RAMPS['coral'][0], RAMPS['coral'][1], 3)
    s.text(62, 411, 'Realtime Database', 12, 400, INK)
    s.rect(206, 404, 14, 14, RAMPS['amber'][0], RAMPS['amber'][1], 3)
    s.text(228, 411, 'Firestore', 12, 400, INK)
    s.text(740, 340, 'login: setUser(uid), mulai berlangganan', 12, 400, INK, 'middle')
    s.text(740, 362, 'logout: setUser(null), batalkan dan kosongkan', 12, 400, INK, 'middle')
    done(s, 'peta-langganan')

# ---------------------------------------------------------------- 9. dua database
def d_dua_db():
    s = Svg(900, 400, 'Dua jalur data: Realtime Database dan Firestore', 'Wemos mengirim sensor tiap 5-10 detik ke Realtime Database untuk layar realtime, dan rekaman tiap 15-30 menit ke Firestore untuk grafik historis.')
    s.box(30, 110, 150, 170, 'Wemos', 'sensor + pompa', 'gray')
    box3(s, 290, 30, 280, 92, 'Realtime Database', '.../devices/WMS-001/sensor', 'keadaan SAAT INI, ditimpa terus', 'coral')
    box3(s, 290, 262, 280, 92, 'Cloud Firestore', '.../devices/WMS-001/readings/{id}', 'RIWAYAT, terus bertambah', 'amber')
    s.box(680, 44, 190, 64, 'Layar realtime', 'Beranda · gauge Monitoring', 'pink', 14, 11)
    s.box(680, 276, 190, 64, 'Grafik historis', 'hari ini · 7 hari · 30 hari', 'pink', 14, 11)
    s.line(182, 170, 288, 90)
    s.label(235, 124, 'tiap 5–10 dtk')
    s.line(182, 222, 288, 300)
    s.label(235, 270, 'tiap 15–30 mnt')
    s.line(572, 76, 678, 76)
    s.label(625, 58, 'stream')
    s.line(572, 308, 678, 308)
    s.label(625, 290, 'kueri waktu')
    s.text(430, 134, 'seperti papan tulis', 12, 400, MUTED, 'middle', italic=True)
    s.text(430, 368, 'seperti buku catatan arsip', 12, 400, MUTED, 'middle', italic=True)
    done(s, 'dua-database')

# ---------------------------------------------------------------- 10. struktur RTDB
def d_rtdb():
    W = 900
    s = Svg(W, 514, 'Struktur Realtime Database', 'Di bawah users/uid ada devices/deviceId dengan config, sensor, command, dan lastWatering, serta activities dan notifications.')
    s.rect(10, 10, 880, 494, '#ffffff', '#9ca3af', 14, 1.2, '6 4')
    s.pill(28, 30, 'users / {uid}', 'gray', size=12, pad=10, h=24)
    # devices container
    cx, cy, cw_ = 28, 62, 590
    s.rect(cx, cy, cw_, 424, '#fdf8f6', RAMPS['coral'][1], 12, 1, '5 4')
    s.pill(cx + 14, cy + 20, 'devices / {deviceId}', 'coral', size=12, pad=10, h=24)
    s.text(cx + 176, cy + 20, 'contoh: "WMS-001"', 11.5, 400, MUTED)
    wc = 272
    a = field_card(s, cx + 14, cy + 48, wc, 'config', 'KONFIGURASI', 'App', 'coral',
                   [('name', '"Tauge Utama"'), ('location', '"Rak A · Dapur"'), ('wateringSeconds', '10'), ('autoWateringTimes', '"06:30,18:30"')], 'purple')
    b = field_card(s, cx + 14 + wc + 16, cy + 48, wc, 'sensor', 'DATA SENSOR REALTIME', 'Wemos', 'coral',
                   [('temperature', '29.8'), ('humidity', '78'), ('light', '24'), ('updatedAt', '1763100000000'), ('isOnline', 'true')], 'gray')
    r2 = cy + 48 + max(a, b) + 16
    c = field_card(s, cx + 14, r2, wc, 'command', 'PERINTAH POMPA', 'App → Wemos', 'coral',
                   [('action', '"water"'), ('durationSeconds', '10'), ('status', '"pending"'), ('requestedAt', '1763100000000')], 'purple')
    d = field_card(s, cx + 14 + wc + 16, r2, wc, 'lastWatering', 'WAKTU SIRAM TERAKHIR', 'Wemos', 'coral',
                   [('at', '1763099300000'), ('durationSeconds', '10'), ('source', '"auto"')], 'gray')
    yb = r2 + max(c, d) + 14
    s.text(cx + 16, yb + 8, 'status: pending → done | failed | timeout', 11.5, 400, MUTED, kind='mono')
    s.text(cx + 16, yb + 28, 'waktu = epoch milidetik (angka)', 11.5, 400, MUTED, kind='mono')
    # kanan
    rx = 640; rw = 232
    s.pill(rx + 6, 82, 'activities / {pushId}', 'coral', size=11, pad=9, h=22) if False else None
    h1 = field_card(s, rx, 62, rw, 'activities', 'DAFTAR AKTIVITAS', 'Wemos', 'coral',
                    [('title', '"Penyiraman otomatis"'), ('subtitle', '"10 detik"'), ('type', '"watering"'), ('at', '1763100000000')], 'gray')
    h2 = field_card(s, rx, 62 + h1 + 18, rw, 'notifications', 'ISI POPOVER LONCENG', 'Wemos', 'coral',
                    [('title', '"Penyiraman selesai"'), ('message', '"Batch 01 · 10 detik"'), ('type', '"info"'), ('isRead', 'false'), ('at', '1763100000000')], 'gray')
    s.text(rx, 62 + h1 + 18 + h2 + 22, 'tiap entri memakai {pushId}:', 11.5, 400, MUTED, italic=True)
    s.text(rx, 62 + h1 + 18 + h2 + 42, 'kunci otomatis, urut menurut waktu', 11.5, 400, MUTED, italic=True)
    done(s, 'struktur-rtdb')

# ---------------------------------------------------------------- 11. struktur Firestore
def d_firestore():
    s = Svg(900, 372, 'Struktur Cloud Firestore', 'Di bawah users/uid ada koleksi batches untuk dokumentasi penanaman, dan devices/deviceId/readings untuk rekaman sensor terjadwal.')
    s.rect(10, 10, 880, 352, '#ffffff', '#9ca3af', 14, 1.2, '6 4')
    s.pill(28, 30, 'users / {uid}', 'gray', size=12, pad=10, h=24)
    h1 = field_card(s, 28, 62, 400, 'batches / {batchId}', 'DOKUMENTASI TIAP PENANAMAN', 'Anda (Console)', 'amber',
                    [('code', '"TANAM-008"'), ('name', '"Tauge Batch 01"'), ('startDate', 'timestamp'), ('endDate', 'timestamp, boleh kosong'), ('isActive', 'true'),
                     ('cycleDays', '4'), ('wateringCount', '6'), ('sensorCount', '842'), ('avgTemperature', '29.7'), ('avgHumidity', '76')], 'purple')
    s.rect(452, 62, 424, 224, '#fffcf5', RAMPS['amber'][1], 12, 1, '5 4')
    s.pill(466, 82, 'devices / {deviceId}', 'amber', size=12, pad=10, h=24)
    s.text(466, 108, 'dokumen induk tidak perlu dibuat', 11.5, 400, MUTED, italic=True)
    field_card(s, 466, 128, 396, 'readings / {autoId}', 'REKAMAN SENSOR TERJADWAL (tiap 15–30 menit)', 'Wemos', 'amber',
               [('temperature', '29.8'), ('humidity', '78'), ('light', '24'), ('createdAt', 'timestamp (wajib bertipe timestamp)')], 'gray')
    done(s, 'struktur-firestore')

# ---------------------------------------------------------------- 12. status perintah
def d_status():
    s = Svg(820, 330, 'Status perintah siram', 'App membuat perintah dengan status pending. Wemos mengubahnya menjadi done atau failed. Jika 30 detik tanpa jawaban, aplikasi menulis timeout.')
    s.rect(58, 140, 22, 22, '#1f2937', '#1f2937', 11)
    s.text(69, 182, 'App membuat', 12, 400, MUTED, 'middle')
    s.text(69, 198, 'perintah', 12, 400, MUTED, 'middle')
    s.line(82, 151, 118, 151)
    s.box(120, 116, 150, 70, 'pending', 'menunggu Wemos', 'amber')
    targets = [(40, 'done', 'ditulis oleh Wemos', 'green', 'Wemos sukses', None),
               (121, 'failed', 'ditulis oleh Wemos', 'red', 'Wemos gagal', None),
               (232, 'timeout', 'ditulis oleh aplikasi', 'gray', '30 dtk tanpa jawaban', '6 4')]
    for y, t, sub, ramp, lab, dash in targets:
        s.box(540, y, 200, 60, t, sub, ramp)
        s.line(272, 151, 538, y + 30, dash=dash)
        mx, my = (272 + 538)/2, (151 + y + 30)/2
        s.label(mx + 10, my, lab)
    caption(s, 312, 'Node command hanya menyimpan perintah terakhir; perintah baru menimpa yang lama.')
    done(s, 'status-perintah')

# ---------------------------------------------------------------- 13. pohon widget
def d_widget_tree():
    s = Svg(700, 420, 'Pohon widget Flutter', 'Scaffold berisi Column. Column berisi Text dan Row. Row berisi Icon dan Text.')
    def node(x, y, w, t, sub, ramp): s.box(x, y, w, 54, t, sub, ramp, 13, 11)
    node(250, 20, 200, 'Scaffold', 'halaman', 'gray')
    node(250, 116, 200, 'Column', 'susunan vertikal', 'blue')
    node(70, 216, 170, "Text('Halo')", 'teks', 'pink')
    node(330, 216, 200, 'Row', 'susunan horizontal', 'blue')
    node(290, 316, 130, 'Icon(...)', 'ikon', 'pink')
    node(450, 316, 150, "Text('Suhu')", 'teks', 'pink')
    s.line(350, 76, 350, 114, end=False)
    s.poly([(350, 170), (350, 193), (155, 193), (155, 214)], end=False)
    s.poly([(350, 170), (350, 193), (430, 193), (430, 214)], end=False)
    s.poly([(430, 270), (430, 293), (355, 293), (355, 314)], end=False)
    s.poly([(430, 270), (430, 293), (525, 293), (525, 314)], end=False)
    s.rect(24, 28, 14, 14, RAMPS['blue'][0], RAMPS['blue'][1], 3); s.text(46, 35, 'penyusun (layout)', 12, 400, INK)
    s.rect(24, 52, 14, 14, RAMPS['pink'][0], RAMPS['pink'][1], 3); s.text(46, 59, 'isi (teks, ikon)', 12, 400, INK)
    caption(s, 398, 'Layar = kotak di dalam kotak. Saat data berubah, Flutter menggambar ulang widget yang terkait.')
    done(s, 'pohon-widget')

# ---------------------------------------------------------------- 14. alur Wemos
def d_wemos():
    s = Svg(900, 552, 'Alur program Wemos', 'Setup: WiFi, NTP, login Firebase, baca config. Loop: kirim sensor ke RTDB, cek perintah siram, rekaman Firestore, jadwal otomatis, dan perbarui token.')
    steps = ['Sambung WiFi', 'Sinkron jam (NTP)', 'Login Firebase', 'Baca config']
    s.text(30, 26, 'setup()', 13, 700, INK, kind='mono')
    for i, t in enumerate(steps):
        x = 30 + i*212
        s.box(x, 44, 180, 46, t, None, 'gray', 13)
        if i < 3: s.line(x + 182, 67, x + 210, 67)
    s.rect(20, 120, 860, 380, '#ffffff', '#9ca3af', 12, 1.2, '6 4')
    s.text(36, 142, 'loop()', 13, 700, INK, kind='mono')
    rows = [
        ('tiap 5–10 dtk', 'baca sensor, lalu PATCH ke RTDB (isOnline = true)', [('RTDB · .../sensor', 'coral')], 56),
        ('tiap 3–5 dtk', 'baca command: bila pending dan belum basi, nyalakan pompa. Selesai: status = done/failed, PUT lastWatering, POST activities dan notifications', [('RTDB · .../command', 'coral')], 84),
        ('tiap 15–30 mnt', 'POST rekaman sensor terjadwal', [('Firestore · .../readings', 'amber')], 56),
        ('sesuai config', 'siram otomatis menurut autoWateringTimes, catat seperti di atas dengan source = "auto"', [('RTDB · .../lastWatering', 'coral')], 56),
        ('tiap ±50 mnt', 'perbarui token login (ID token berlaku ± 1 jam)', [('Firebase Auth', 'green')], 56),
    ]
    y = 160
    for interval, action, chips, h in rows:
        s.rect(36, y, 170, 36 if h == 56 else 36, '#f3f4f6', '#d1d5db', 8, 1)
        s.text(121, y + 18, interval, 12, 600, INK, 'middle')
        s.line(208, y + 18, 232, y + 18)
        lines = wrap(action, 13, 400)
        for li, ln in enumerate(lines):
            s.text(240, y + 18 + li*18 - (len(lines)-1)*9 + (len(lines)-1)*9, ln, 13, 400, INK)
        for t, ramp in chips:
            s.pill(868, y + 18, t, ramp, size=11, pad=9, h=22, anchor='end')
        y += h + 6
    caption(s, 530, 'Kirim terlalu sering menghabiskan kuota gratis Firebase; ikuti interval yang disarankan.')
    done(s, 'alur-wemos')

for fn in [d_arsitektur, d_folder, d_lapisan, d_seq_siram, d_seq_sensor, d_seq_grafik, d_startup, d_langganan, d_dua_db, d_rtdb, d_firestore, d_status, d_widget_tree, d_wemos]:
    fn()
print('dibuat:', len(made), made)
