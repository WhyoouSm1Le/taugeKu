import 'package:flutter/material.dart';

/// Bentuk sudut khas desain TaugeKu: tiga sudut membulat besar,
/// satu sudut dibuat lebih kecil sehingga bentuknya mirip "daun".
class AppRadius {
  AppRadius._();

  /// Sudut kiri-bawah yang kecil. Contoh: `AppRadius.leaf(24, 8)`.
  static BorderRadius leaf(double big, double small) {
    return BorderRadius.only(
      topLeft: Radius.circular(big),
      topRight: Radius.circular(big),
      bottomRight: Radius.circular(big),
      bottomLeft: Radius.circular(small),
    );
  }

  /// Sudut kanan-bawah yang kecil.
  static BorderRadius leafRight(double big, double small) {
    return BorderRadius.only(
      topLeft: Radius.circular(big),
      topRight: Radius.circular(big),
      bottomRight: Radius.circular(small),
      bottomLeft: Radius.circular(big),
    );
  }

  /// Bentuk "tetesan" untuk kotak ikon (setara 50% 50% 45% 20% di CSS).
  static BorderRadius blob(double size) {
    return BorderRadius.only(
      topLeft: Radius.circular(size * 0.5),
      topRight: Radius.circular(size * 0.5),
      bottomRight: Radius.circular(size * 0.45),
      bottomLeft: Radius.circular(size * 0.2),
    );
  }
}
