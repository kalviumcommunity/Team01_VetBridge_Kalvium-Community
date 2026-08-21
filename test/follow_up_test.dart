import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/follow_up_model.dart';
import 'package:sprint2/services/follow_up_service.dart';

void main() {
  group('FollowUpModel Tests', () {
    test('serialization toMap and fromMap works correctly', () {
      final now = DateTime.now();
      final followUp = FollowUpModel(
        followUpId: 'FLP_100',
        petId: 'PET_001',
        followUpDate: now.add(const Duration(days: 5)),
        reason: 'Post-op checkup',
        relatedTreatmentId: 'TRT_001',
        status: 'Pending',
        notes: 'Check wound healing.',
        createdAt: now,
      );

      final map = followUp.toMap();
      expect(map['followUpId'], 'FLP_100');
      expect(map['petId'], 'PET_001');
      expect(map['reason'], 'Post-op checkup');
      expect(map['status'], 'Pending');

      final deserialized = FollowUpModel.fromMap(map);
      expect(deserialized.followUpId, followUp.followUpId);
      expect(deserialized.petId, followUp.petId);
      expect(deserialized.reason, followUp.reason);
      expect(deserialized.status, followUp.status);
    });
  });

  group('MockFollowUpService Tests', () {
    late MockFollowUpService mockService;

    setUp(() {
      mockService = MockFollowUpService();
    });

    test('getFollowUps returns entries filtered by petId', () async {
      final list = await mockService.getFollowUps('PET_001');
      expect(list.length, 1);
      expect(list.first.reason, contains('Re-check ear infection'));

      final emptyList = await mockService.getFollowUps('UNKNOWN_PET');
      expect(emptyList, isEmpty);
    });

    test('getPendingFollowUps returns only pending entries', () async {
      final pendingList = await mockService.getPendingFollowUps();
      expect(pendingList.isNotEmpty, isTrue);
      expect(pendingList.every((f) => f.status.toLowerCase() == 'pending'), isTrue);
    });

    test('addFollowUp saves new follow-up record', () async {
      final newFlp = FollowUpModel(
        followUpId: '',
        petId: 'PET_002',
        followUpDate: DateTime.now().add(const Duration(days: 14)),
        reason: 'Suture removal',
        relatedTreatmentId: 'TRT_002',
        status: 'Pending',
        notes: 'Check incision site.',
        createdAt: DateTime.now(),
      );

      final added = await mockService.addFollowUp(newFlp);
      expect(added.followUpId, startsWith('FLP_MOCK_'));
      expect(added.reason, 'Suture removal');

      final fetched = await mockService.getFollowUps('PET_002');
      expect(fetched.length, 1);
      expect(fetched.first.reason, 'Suture removal');
    });

    test('updateFollowUp modifies status to Completed', () async {
      final list = await mockService.getFollowUps('PET_001');
      final original = list.first;

      final updatedInput = FollowUpModel(
        followUpId: original.followUpId,
        petId: original.petId,
        followUpDate: original.followUpDate,
        reason: original.reason,
        relatedTreatmentId: original.relatedTreatmentId,
        status: 'Completed', // status updated
        notes: 'Ears healed cleanly.',
        createdAt: original.createdAt,
      );

      final updated = await mockService.updateFollowUp(updatedInput);
      expect(updated.status, 'Completed');

      final pendingAfterUpdate = await mockService.getPendingFollowUps();
      expect(pendingAfterUpdate.any((f) => f.followUpId == original.followUpId), isFalse);
    });
  });
}
