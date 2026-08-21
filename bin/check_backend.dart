// ignore_for_file: avoid_print
import 'package:sprint2/services/mock_auth_service.dart';
import 'package:sprint2/models/pet_model.dart';
import 'package:sprint2/services/pet_service.dart';
import 'package:sprint2/models/vaccination_model.dart';
import 'package:sprint2/services/vaccination_service.dart';
import 'package:sprint2/models/treatment_model.dart';
import 'package:sprint2/services/treatment_service.dart';
import 'package:sprint2/models/follow_up_model.dart';
import 'package:sprint2/services/follow_up_service.dart';

Future<void> main() async {
  print('========================================');
  print('   VETBRIDGE BACKEND SERVICE VERIFIER  ');
  print('========================================\n');

  final mockAuth = MockAuthService();

  // 1. Check Initial State
  print('[TEST 1] Checking initial auth state...');
  if (mockAuth.currentUser == null) {
    print('  ✅ Success: No user logged in initially.\n');
  } else {
    print('  ❌ Failure: Expected null user, got: ${mockAuth.currentUser}\n');
  }

  // 2. Check Login Success for Veterinarian
  print('[TEST 2] Testing Veterinarian login route...');
  try {
    print('  Sending credentials: vet@vetbridge.com / password123');
    final user = await mockAuth.login('vet@vetbridge.com', 'password123');
    if (user != null && user.role == 'Veterinarian' && user.name == 'Dr. Ananya') {
      print('  ✅ Success: Authenticated as ${user.name} (${user.role}).');
      print('  Current Session: ID=${user.userId}, Branch=${user.branchId}\n');
    } else {
      print('  ❌ Failure: Logged in but user details did not match.\n');
    }
  } catch (e) {
    print('  ❌ Failure: Login failed with error: $e\n');
  }

  // 3. Check Logout
  print('[TEST 3] Testing Logout route...');
  try {
    await mockAuth.logout();
    if (mockAuth.currentUser == null) {
      print('  ✅ Success: Session cleared.\n');
    } else {
      print('  ❌ Failure: User still exists after logout.\n');
    }
  } catch (e) {
    print('  ❌ Failure: Logout failed with error: $e\n');
  }

  // 4. Check Login Success for Clinic Staff
  print('[TEST 4] Testing Clinic Staff login route...');
  try {
    print('  Sending credentials: staff@vetbridge.com / password123');
    final user = await mockAuth.login('staff@vetbridge.com', 'password123');
    if (user != null && user.role == 'Clinic Staff' && user.name == 'Rahul') {
      print('  ✅ Success: Authenticated as ${user.name} (${user.role}).');
      print('  Current Session: ID=${user.userId}, Branch=${user.branchId}\n');
    } else {
      print('  ❌ Failure: Logged in but user details did not match.\n');
    }
  } catch (e) {
    print('  ❌ Failure: Login failed with error: $e\n');
  }

  // 5. Check Login Failure Route
  print('[TEST 5] Testing Login failure route (Invalid password)...');
  try {
    print('  Sending credentials: staff@vetbridge.com / wrongpassword');
    await mockAuth.login('staff@vetbridge.com', 'wrongpassword');
    print('  ❌ Failure: Login succeeded but was expected to fail.\n');
  } catch (e) {
    print('  ✅ Success: Correctly threw exception: $e\n');
  }

  // 6. Test Pet Management Routes
  print('[TEST 6] Testing Pet Management (MockPetService) routes...');
  final mockPet = MockPetService();

  try {
    // 6a. Search all pets
    print('  Searching all pets (query="")...');
    final all = await mockPet.searchPets('');
    print('  ✅ Success: Retrieved ${all.length} mock pets.');

    // 6b. Search by name
    print('  Searching pets by query="buddy"...');
    final searchName = await mockPet.searchPets('buddy');
    if (searchName.isNotEmpty && searchName.first.name == 'Buddy') {
      print('  ✅ Success: Found pet: ${searchName.first.name} (ID: ${searchName.first.petId}).');
    } else {
      print('  ❌ Failure: Could not find Buddy.');
    }

    // 6c. Get specific pet details (including checking nullable DOB)
    print('  Retrieving pet by ID="PET_002" (Luna)...');
    final luna = await mockPet.getPet('PET_002');
    if (luna != null && luna.name == 'Luna') {
      print('  ✅ Success: Found Luna. Date of Birth is: ${luna.dateOfBirth ?? "Unknown (Null)"}');
    } else {
      print('  ❌ Failure: Could not retrieve Luna.');
    }

    // 6d. Register new pet
    print('  Registering a new pet (Rocky)...');
    final newPet = PetModel(
      petId: '',
      name: 'Rocky',
      species: 'Dog',
      breed: 'Bulldog',
      dateOfBirth: null, // Test nullable DOB
      ownerName: 'Dan Green',
      ownerContact: '+555-8888',
      createdAt: DateTime.now(),
    );
    final registered = await mockPet.createPet(newPet);
    if (registered.petId.isNotEmpty && registered.name == 'Rocky') {
      print('  ✅ Success: Registered Rocky. Generated ID: ${registered.petId}');
    } else {
      print('  ❌ Failure: Failed to register Rocky.');
    }

    // 6e. Update pet information
    print('  Updating Rocky\'s breed to "French Bulldog"...');
    final updatedInput = PetModel(
      petId: registered.petId,
      name: registered.name,
      species: registered.species,
      breed: 'French Bulldog',
      dateOfBirth: registered.dateOfBirth,
      ownerName: registered.ownerName,
      ownerContact: registered.ownerContact,
      createdAt: registered.createdAt,
    );
    final updated = await mockPet.updatePet(updatedInput);
    if (updated.breed == 'French Bulldog') {
      print('  ✅ Success: Rocky\'s breed updated to French Bulldog.\n');
    } else {
      print('  ❌ Failure: Breed update failed.\n');
    }

  } catch (e) {
    print('  ❌ Failure: Pet management checks failed with error: $e\n');
  }

  // 7. Test Vaccination Management Routes
  print('[TEST 7] Testing Vaccination Management (MockVaccinationService) routes...');
  final mockVac = MockVaccinationService();

  try {
    // 7a. Get vaccinations for PET_001
    print('  Retrieving vaccination records for PET_001...');
    final list = await mockVac.getVaccinations('PET_001');
    if (list.length == 2) {
      print('  ✅ Success: Found ${list.length} vaccinations for PET_001.');
      print('  First record: ${list.first.vaccineName} (Next Due: ${list.first.nextDueDate})');
      print('  Second record: ${list.last.vaccineName} (Next Due: ${list.last.nextDueDate ?? "None (Null)"})');
    } else {
      print('  ❌ Failure: Expected 2 vaccinations, found ${list.length}.');
    }

    // 7b. Add vaccination
    print('  Adding new vaccination (Bordetella) for PET_002...');
    final newVac = VaccinationModel(
      vaccinationId: '',
      petId: 'PET_002',
      vaccineName: 'Bordetella',
      dateAdministered: DateTime.now(),
      nextDueDate: null, // Nullable nextDueDate test
      notes: 'Administered Kennel Cough protection.',
      vetId: 'mock_vet_123',
      branchId: 'branch_west',
      createdAt: DateTime.now(),
    );
    final added = await mockVac.addVaccination(newVac);
    if (added.vaccinationId.isNotEmpty && added.vaccineName == 'Bordetella') {
      print('  ✅ Success: Vaccination added. Generated ID: ${added.vaccinationId}');
    } else {
      print('  ❌ Failure: Failed to add vaccination.');
    }

    // 7c. Update vaccination notes
    print('  Updating vaccination ${added.vaccinationId} notes...');
    final updatedVac = VaccinationModel(
      vaccinationId: added.vaccinationId,
      petId: added.petId,
      vaccineName: added.vaccineName,
      dateAdministered: added.dateAdministered,
      nextDueDate: added.nextDueDate,
      notes: 'Successfully updated notes.',
      vetId: added.vetId,
      branchId: added.branchId,
      createdAt: added.createdAt,
    );
    final result = await mockVac.updateVaccination(updatedVac);
    if (result.notes == 'Successfully updated notes.') {
      print('  ✅ Success: Notes updated successfully.\n');
    } else {
      print('  ❌ Failure: Update failed.\n');
    }

  } catch (e) {
    print('  ❌ Failure: Vaccination management checks failed with error: $e\n');
  }

  // 8. Test Treatment & Medication Management Routes
  print('[TEST 8] Testing Treatment & Medication Management (MockTreatmentService) routes...');
  final mockTrt = MockTreatmentService();

  try {
    print('  Retrieving treatment records for PET_001...');
    final list = await mockTrt.getTreatments('PET_001');
    if (list.isNotEmpty && list.first.diagnosis == 'Ear Infection') {
      print('  ✅ Success: Found treatment for PET_001: ${list.first.diagnosis}');
    } else {
      print('  ❌ Failure: Failed to fetch treatments.');
    }

    print('  Adding new treatment entry...');
    final newTrt = TreatmentModel(
      treatmentId: '',
      petId: 'PET_002',
      diagnosis: 'Gastritis',
      medicines: [
        {'medicine': 'Antacid', 'dosage': '1 tab'}
      ],
      date: DateTime.now(),
      notes: 'Bland diet recommended.',
      vetId: 'mock_vet_123',
      branchId: 'branch_west',
      createdAt: DateTime.now(),
    );
    final addedTrt = await mockTrt.addTreatment(newTrt);
    if (addedTrt.treatmentId.isNotEmpty && addedTrt.diagnosis == 'Gastritis') {
      print('  ✅ Success: Added treatment: ID=${addedTrt.treatmentId}\n');
    } else {
      print('  ❌ Failure: Failed to add treatment.\n');
    }
  } catch (e) {
    print('  ❌ Failure: Treatment management checks failed with error: $e\n');
  }

  // 9. Test Follow-Up Management Routes
  print('[TEST 9] Testing Follow-Up Management (MockFollowUpService) routes...');
  final mockFlp = MockFollowUpService();

  try {
    print('  Retrieving pending follow-ups...');
    final pending = await mockFlp.getPendingFollowUps();
    if (pending.isNotEmpty) {
      print('  ✅ Success: Found ${pending.length} pending follow-up(s).');
      print('  Reason: ${pending.first.reason}');
    } else {
      print('  ❌ Failure: Expected pending follow-ups.');
    }

    print('  Updating follow-up status to Completed...');
    final updatedFlp = FollowUpModel(
      followUpId: pending.first.followUpId,
      petId: pending.first.petId,
      followUpDate: pending.first.followUpDate,
      reason: pending.first.reason,
      relatedTreatmentId: pending.first.relatedTreatmentId,
      status: 'Completed',
      notes: 'Fully resolved.',
      createdAt: pending.first.createdAt,
    );
    final res = await mockFlp.updateFollowUp(updatedFlp);
    if (res.status == 'Completed') {
      print('  ✅ Success: Follow-up status changed to Completed.\n');
    } else {
      print('  ❌ Failure: Failed to update follow-up.\n');
    }
  } catch (e) {
    print('  ❌ Failure: Follow-up management checks failed with error: $e\n');
  }

  print('========================================');
  print('         VERIFICATION COMPLETE          ');
  print('========================================');
}
