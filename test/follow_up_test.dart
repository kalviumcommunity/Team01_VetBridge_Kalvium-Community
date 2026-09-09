import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/follow_up.dart';

void main() {
  group('FollowUp Tests', () {
    test('serialization toMap and fromMap works correctly', () {
      final now = DateTime.now();
      final followUp = FollowUp(
        followUpId: 'FLP_100',
        petId: 'PET_001',
        followUpDate: now.add(const Duration(days: 5)),
        reason: 'Post-op checkup',
        relatedTreatmentId: 'TRT_001',
        status: 'Pending',
        notes: 'Check wound healing.',
        createdAt: now,
        updatedAt: now,
      );

      final map = followUp.toMap();
      expect(map['followUpId'], 'FLP_100');
      expect(map['petId'], 'PET_001');
      expect(map['reason'], 'Post-op checkup');
      expect(map['status'], 'Pending');

      final deserialized = FollowUp.fromMap(map);
      expect(deserialized.followUpId, followUp.followUpId);
      expect(deserialized.petId, followUp.petId);
      expect(deserialized.reason, followUp.reason);
      expect(deserialized.status, followUp.status);
    });
  });
}
