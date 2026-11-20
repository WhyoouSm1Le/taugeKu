# Pembuat diagram dokumentasi

Semua gambar di `docs/images/*.svg` dibuat oleh skrip ini, sehingga mudah diubah dan dibuat ulang
(tidak perlu aplikasi gambar).

```bash
pip install pillow          # satu kali
python3 tools/diagrams/gen.py             # membuat ulang semua SVG di docs/images/
python3 tools/diagrams/gen.py --preview   # sekaligus membuat pratinjau PNG di tools/diagrams/preview/
```

* Kebutuhan: Python 3, paket **Pillow**, dan font **DejaVu Sans** (dipakai hanya untuk mengukur lebar teks
  agar kotak tidak kekecilan; font di SVG sendiri memakai font bawaan sistem pembaca).
* Setiap diagram adalah satu fungsi `d_...()` di `gen.py`. Ubah teks atau posisi di sana lalu jalankan ulang.
* Jika teks melebihi kotak atau keluar kanvas, skrip mencetak peringatan yang diawali tanda `!`.
* Pustaka penggambarnya ada di `dlib.py` (kotak, panah, diagram urutan, kartu).
