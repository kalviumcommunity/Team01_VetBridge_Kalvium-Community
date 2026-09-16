import 'package:cloud_firestore/cloud_firestore.dart';

/// Standardized exception for application-level data errors.
class AppDataException implements Exception {
  const AppDataException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Generic wrapper for common Firestore operations with built-in error handling.
abstract class FirestoreService<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns a stream of all documents in the collection at [path].
  Stream<List<T>> streamCollection(
    String path,
    T Function(String id, Map<String, dynamic> data) fromMap,
  ) {
    try {
      return _db.collection(path).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          // Provide ID to fromMap for convenience
          return fromMap(doc.id, data);
        }).toList();
      });
    } catch (e) {
      throw AppDataException('Failed to stream $path: $e');
    }
  }

  /// Writes a document to Firestore at [path]/[id].
  Future<void> setDoc(String path, String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(path).doc(id).set(data);
    } catch (e) {
      throw AppDataException('Failed to set document in $path: $e');
    }
  }

  /// Updates a document in Firestore at [path]/[id].
  Future<void> updateDoc(String path, String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(path).doc(id).update(data);
    } catch (e) {
      throw AppDataException('Failed to update document in $path: $e');
    }
  }

  /// Deletes a document from Firestore at [path]/[id].
  Future<void> deleteDoc(String path, String id) async {
    try {
      await _db.collection(path).doc(id).delete();
    } catch (e) {
      throw AppDataException('Failed to delete document from $path: $e');
    }
  }
}
