import 'package:flutter/material.dart';

enum AppSection {
  dashboard,
  pets,
  medicalRecords,
  appointments,
  vaccinations,
  followUps,
  branches,
  profile,
}

class NavItem {
  const NavItem({
    required this.section,
    required this.label,
    required this.icon,
    this.isAccountSection = false,
  });

  final AppSection section;
  final String label;
  final IconData icon;
  final bool isAccountSection;
}

const appNavItems = <NavItem>[
  NavItem(
    section: AppSection.dashboard,
    label: 'Dashboard',
    icon: Icons.space_dashboard_outlined,
  ),
  NavItem(
    section: AppSection.pets,
    label: 'Pets',
    icon: Icons.pets_outlined,
  ),
  NavItem(
    section: AppSection.medicalRecords,
    label: 'Medical Records',
    icon: Icons.description_outlined,
  ),
  NavItem(
    section: AppSection.appointments,
    label: 'Appointments',
    icon: Icons.calendar_today_outlined,
  ),
  NavItem(
    section: AppSection.vaccinations,
    label: 'Vaccinations',
    icon: Icons.vaccines_outlined,
  ),
  NavItem(
    section: AppSection.followUps,
    label: 'Follow-Ups',
    icon: Icons.event_repeat_outlined,
  ),
  NavItem(
    section: AppSection.branches,
    label: 'Clinic Branches',
    icon: Icons.apartment_outlined,
  ),
  NavItem(
    section: AppSection.profile,
    label: 'Profile',
    icon: Icons.person_outline,
    isAccountSection: true,
  ),
];
