import '../models/planting_batch.dart';
import 'firestore_paths.dart';

/// Membaca siklus tanam dari **Cloud Firestore**: `users/{uid}/batches`.
class BatchService {
  /// Semua batch, yang paling baru dimulai tampil paling atas.
  Stream<List<PlantingBatch>> watchBatches(String uid) {
    return FirestorePaths.batches(uid)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(PlantingBatch.fromFirestore).toList());
  }
}
