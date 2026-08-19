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
      branchId: map['branchId'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
