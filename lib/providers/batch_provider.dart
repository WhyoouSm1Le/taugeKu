import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/planting_batch.dart';
import '../services/batch_service.dart';
import 'user_scoped_provider.dart';

/// State untuk SIKLUS TANAM (kartu hero di Beranda & halaman Riwayat).
class BatchProvider extends UserScopedProvider {
  BatchProvider({BatchService? service}) : _service = service ?? BatchService();

  final BatchService _service;
  StreamSubscription<List<PlantingBatch>>? _subscription;

  List<PlantingBatch> _batches = [];
  bool _isLoading = false;

  // ---- Data yang boleh dibaca layar ----
  List<PlantingBatch> get allBatches => List.unmodifiable(_batches);
  List<PlantingBatch> get activeBatches => _batches.where((b) => b.isActive).toList();
  List<PlantingBatch> get finishedBatches => _batches.where((b) => !b.isActive).toList();
  PlantingBatch? get currentBatch => activeBatches.isEmpty ? null : activeBatches.first;
  int get totalCount => _batches.length;
  bool get isLoading => _isLoading;

  @override
  void onUserChanged(String? newUserId) {
    _subscription?.cancel();
    _subscription = null;
    _batches = [];
    _isLoading = newUserId != null;
    if (newUserId == null) return;

    _subscription = _service.watchBatches(newUserId).listen(
      (list) {
        _batches = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (Object error) {
        debugPrint('Gagal membaca batch: $error');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
