import 'package:flutter/material.dart';

class DashboardStats {
  const DashboardStats({
    required this.todaysAppointments,
    required this.registeredPets,
    required this.upcomingAppointments,
    required this.pendingFollowUps,
  });

  final int todaysAppointments;
  final int registeredPets;
  final int upcomingAppointments;
  final int pendingFollowUps;
}

class DashboardAppointment {
  const DashboardAppointment({
    required this.petName,
    required this.ownerName,
    required this.time,
    required this.reason,
    required this.status,
    required this.icon,
    required this.iconColor,
  });

  final String petName;
  final String ownerName;
  final String time;
  final String reason;
  final String status;
  final IconData icon;
  final Color iconColor;
}

class DashboardFollowUp {
  const DashboardFollowUp({
    required this.petName,
    required this.reason,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  final String petName;
  final String reason;
  final String date;
  final String status;
  final Color statusColor;
}

class DashboardPet {
  const DashboardPet({
    required this.name,
    required this.ownerName,
    required this.species,
    required this.breed,
    required this.lastVisit,
    required this.status,
  });

  final String name;
  final String ownerName;
  final String species;
  final String breed;
  final String lastVisit;
  final String status;
}

class DashboardData {
  const DashboardData({
    required this.stats,
    required this.appointments,
    required this.followUps,
    required this.recentPets,
  });

  final DashboardStats stats;
  final List<DashboardAppointment> appointments;
  final List<DashboardFollowUp> followUps;
  final List<DashboardPet> recentPets;

  static DashboardData mock() {
    return const DashboardData(
      stats: DashboardStats(
        todaysAppointments: 3,
        registeredPets: 5,
        upcomingAppointments: 5,
        pendingFollowUps: 3,
      ),
      appointments: [
        DashboardAppointment(
          petName: 'Buddy',
          ownerName: 'John Smith',
          time: '09:30',
          reason: 'Skin follow-up & general check',
          status: 'Scheduled',
          icon: Icons.pets_outlined,
          iconColor: Color(0xFFE7A65D),
        ),
        DashboardAppointment(
          petName: 'Luna',
          ownerName: 'Priya Sharma',
          time: '11:00',
          reason: 'Respiratory follow-up',
          status: 'Scheduled',
          icon: Icons.pets_outlined,
          iconColor: Color(0xFF72AEDD),
        ),
        DashboardAppointment(
          petName: 'Milo',
          ownerName: 'Kavya Reddy',
          time: '14:00',
          reason: 'Annual wellness check',
          status: 'Scheduled',
          icon: Icons.pets_outlined,
          iconColor: Color(0xFFB08BD5),
        ),
      ],
      followUps: [
        DashboardFollowUp(
          petName: 'Buddy',
          reason: 'Recovery check - skin infection',
          date: '31 Aug 2026',
          status: 'Pending',
          statusColor: Color(0xFF2E81CF),
        ),
        DashboardFollowUp(
          petName: 'Luna',
          reason: 'Post-treatment respiratory check',
          date: '25 Aug 2026',
          status: 'Pending',
          statusColor: Color(0xFF2E81CF),
        ),
        DashboardFollowUp(
          petName: 'Max',
          reason: 'Hip assessment',
          date: '15 Aug 2026',
          status: 'Overdue',
          statusColor: Color(0xFFD14B4B),
        ),
      ],
      recentPets: [
        DashboardPet(name: 'Buddy', ownerName: 'John Smith', species: 'Dog', breed: 'Golden Retriever', lastVisit: '24 Aug 2026', status: 'Active'),
        DashboardPet(name: 'Luna', ownerName: 'Priya Sharma', species: 'Cat', breed: 'Persian', lastVisit: '18 Aug 2026', status: 'Active'),
        DashboardPet(name: 'Max', ownerName: 'Arjun Nair', species: 'Dog', breed: 'Labrador', lastVisit: '10 Aug 2026', status: 'Active'),
        DashboardPet(name: 'Milo', ownerName: 'Kavya Reddy', species: 'Rabbit', breed: 'Holland Lop', lastVisit: '30 Jul 2026', status: 'Active'),
        DashboardPet(name: 'Bella', ownerName: 'Rohan Gupta', species: 'Dog', breed: 'Beagle', lastVisit: '5 Aug 2026', status: 'Active'),
      ],
    );
  }
}