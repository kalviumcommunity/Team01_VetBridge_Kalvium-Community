import 'package:cloud_firestore/cloud_firestore.dart';

class Clinic {
  final String branchId;
  final String name;
  final String address;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Clinic({
    required this.branchId,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'branchId': branchId,
      'name': name,
      'address': address,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Clinic.fromMap(Map<String, dynamic> map) {
    return Clinic(
      branchId: map['branchId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      address: map['address'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      createdAt: _toDate(map['createdAt']),
      updatedAt: _toDate(map['updatedAt']),
    );
  }

  static DateTime _toDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }

  /// Two [Clinic] instances are equal when they share the same [branchId].
  /// Prevents DropdownButton identity mismatches when stream rebuilds
  /// produce new instances of the same clinic.
  @override
  bool operator ==(Object other) => other is Clinic && other.branchId == branchId;

  @override
  int get hashCode => branchId.hashCode;
}
