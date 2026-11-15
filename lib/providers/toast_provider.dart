import 'dart:async';

import 'package:flutter/foundation.dart';

/// State untuk pesan singkat (toast) yang muncul di bawah layar.
///
/// Pakai dari mana saja:
/// ```dart
/// context.read<ToastProvider>().show('Perangkat ditambahkan');
/// ```
class ToastProvider extends ChangeNotifier {
  String? _message;
  Timer? _timer;

  /// Pesan yang sedang tampil. null = tidak ada.
  String? get message => _message;

  void show(String text) {
    _timer?.cancel();
    _message = text;
    notifyListeners();
    // Hilang otomatis setelah 2,6 detik (sama seperti desain web).
    _timer = Timer(const Duration(milliseconds: 2600), () {
      _message = null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
