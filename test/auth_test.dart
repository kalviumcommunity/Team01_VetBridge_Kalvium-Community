import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/user_model.dart';
import 'package:sprint2/services/mock_auth_service.dart';

void main() {
  group('UserModel Tests', () {
    test('serialization toMap and fromMap works correctly', () {
      final user = UserModel(
        userId: '123',
        name: 'Dr. Test',
        email: 'test@vetbridge.com',
        role: 'Veterinarian',
        branchId: 'branch_1',
      );

      final map = user.toMap();
      expect(map['userId'], '123');
      expect(map['name'], 'Dr. Test');
      expect(map['email'], 'test@vetbridge.com');
      expect(map['role'], 'Veterinarian');
      expect(map['branchId'], 'branch_1');

      final deserialized = UserModel.fromMap(map);
      expect(deserialized.userId, user.userId);
      expect(deserialized.name, user.name);
      expect(deserialized.email, user.email);
      expect(deserialized.role, user.role);
      expect(deserialized.branchId, user.branchId);
      expect(deserialized, user);
    });
  });

  group('MockAuthService Tests', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    test('initial state is logged out', () {
      expect(mockAuthService.currentUser, isNull);
    });

    test('login success for veterinarian', () async {
      final user = await mockAuthService.login('vet@vetbridge.com', 'password123');
      
      expect(user, isNotNull);
      expect(user!.email, 'vet@vetbridge.com');
      expect(user.role, 'Veterinarian');
      expect(user.name, 'Dr. Ananya');
      expect(mockAuthService.currentUser, user);
    });

    test('login success for clinic staff', () async {
      final user = await mockAuthService.login('staff@vetbridge.com', 'password123');
      
      expect(user, isNotNull);
      expect(user!.email, 'staff@vetbridge.com');
      expect(user.role, 'Clinic Staff');
      expect(user.name, 'Rahul');
      expect(mockAuthService.currentUser, user);
    });

    test('login failure with incorrect password', () async {
      expect(
        () => mockAuthService.login('vet@vetbridge.com', 'wrong_password'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Incorrect password'))),
      );
      expect(mockAuthService.currentUser, isNull);
    });

    test('login failure with unknown user email', () async {
      expect(
        () => mockAuthService.login('unknown@vetbridge.com', 'password123'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('User not found'))),
      );
      expect(mockAuthService.currentUser, isNull);
    });

    test('logout clears user state', () async {
      // Login first
      await mockAuthService.login('vet@vetbridge.com', 'password123');
      expect(mockAuthService.currentUser, isNotNull);

      // Logout
      await mockAuthService.logout();
      expect(mockAuthService.currentUser, isNull);
    });

    test('authStateChanges stream emits updates', () async {
      final expectation = expectLater(
        mockAuthService.authStateChanges,
        emitsInOrder([
          isNotNull, // Emitted on login
          isNull,    // Emitted on logout
        ]),
      );

      await mockAuthService.login('vet@vetbridge.com', 'password123');
      await mockAuthService.logout();

      await expectation;
    });
  });
}
