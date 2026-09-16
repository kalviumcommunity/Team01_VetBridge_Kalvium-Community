import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class Branch {
  const Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.activePetsCount,
    required this.veterinariansCount,
    required this.colorKey,
  });

  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final int activePetsCount;
  final int veterinariansCount;
  final String colorKey;

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      activePetsCount: map['activePetsCount'] ?? 0,
      veterinariansCount: map['veterinariansCount'] ?? 0,
      colorKey: map['colorKey'] ?? 'central',
    );
  }
}

// TODO: Replace this mock list with a Firestore `branches` collection query.
// TODO: Active pets and veterinarian counts should become aggregation queries
// or denormalized counters maintained by Cloud Functions.
const mockBranches = <Branch>[
  Branch(id: 'central', name: 'Central Clinic', address: '42 MG Road, Koramangala, Bengaluru 560034', phone: '+91 80 4567 8900', email: 'central@vetbridge.com', activePetsCount: 248, veterinariansCount: 4, colorKey: 'central'),
  Branch(id: 'north', name: 'North Clinic', address: '16 Hennur Road, Kalyan Nagar, Bengaluru 560043', phone: '+91 80 4567 8901', email: 'north@vetbridge.com', activePetsCount: 183, veterinariansCount: 3, colorKey: 'north'),
  Branch(id: 'south', name: 'South Clinic', address: '77 Bannerghatta Road, JP Nagar, Bengaluru', phone: '+91 80 4567 8902', email: 'south@vetbridge.com', activePetsCount: 156, veterinariansCount: 2, colorKey: 'south'),
];

Color branchColor(String colorKey) {
  switch (colorKey.toLowerCase()) {
    case 'north':
      return AppColors.branchNorth;
    case 'south':
      return AppColors.branchSouth;
    case 'central':
    default:
      return AppColors.branchCentral;
  }
}

Color branchBgColor(String colorKey) {
  switch (colorKey.toLowerCase()) {
    case 'north':
      return AppColors.branchNorthBg;
    case 'south':
      return AppColors.branchSouthBg;
    case 'central':
    default:
      return AppColors.branchCentralBg;
  }
}
