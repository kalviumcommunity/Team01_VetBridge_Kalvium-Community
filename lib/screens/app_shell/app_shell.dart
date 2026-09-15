import 'package:flutter/material.dart';

import '../../core/constants/nav_items.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../dashboard/dashboard_screen.dart';
import '../appointments/appointments_screen.dart';
import '../branches/branches_screen.dart';
import '../follow_ups/follow_ups_screen.dart';
import '../medical_records/medical_records_screen.dart';
import '../pets/pets_screen.dart';
import '../profile/profile_screen.dart';
import '../vaccinations/vaccinations_screen.dart';
import '../../widgets/common/app_sidebar.dart';
import '../../widgets/common/app_topbar.dart';
import '../../widgets/common/mobile_drawer.dart';
import '../../widgets/common/section_placeholder.dart';

/// Responsive authenticated application shell for all clinic modules.
class AppShell extends StatefulWidget {
  const AppShell({required this.userName, required this.userInitials, super.key});

  final String userName;
  final String userInitials;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppSection _currentSection = AppSection.dashboard;

  @override
  Widget build(BuildContext context) {
    final desktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    if (desktop) return _buildDesktopLayout();
    return _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AppSidebar(
            currentSection: _currentSection,
            onSectionSelected: _selectSection,
          ),
          Expanded(
            child: Column(
              children: [
                _topBar(showMenuButton: false),
                Expanded(child: _content()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: MobileDrawer(
        currentSection: _currentSection,
        onSectionSelected: _selectSection,
      ),
      appBar: _topBar(showMenuButton: true),
      body: _content(),
    );
  }

  PreferredSizeWidget _topBar({required bool showMenuButton}) {
    return AppTopBar(
      currentBranch: 'North Clinic',
      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      showMenuButton: showMenuButton,
      userName: widget.userName,
      userInitials: widget.userInitials,
    );
  }

  Widget _content() {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: _sectionPlaceholder(),
    );
  }

  Widget _sectionPlaceholder() {
    if (_currentSection == AppSection.dashboard) {
      return DashboardScreen(userName: widget.userName, onSectionSelected: _selectSection);
    }
    if (_currentSection == AppSection.pets) {
      return const PetsScreen();
    }
    if (_currentSection == AppSection.medicalRecords) {
      return const MedicalRecordsScreen();
    }
    if (_currentSection == AppSection.appointments) {
      return const AppointmentsScreen();
    }
    if (_currentSection == AppSection.vaccinations) {
      return const VaccinationsScreen();
    }
    if (_currentSection == AppSection.followUps) {
      return const FollowUpsScreen();
    }
    if (_currentSection == AppSection.branches) {
      return const BranchesScreen();
    }
    if (_currentSection == AppSection.profile) {
      return ProfileScreen(userName: widget.userName, userInitials: widget.userInitials);
    }
    final item = appNavItems.firstWhere((item) => item.section == _currentSection);
    final part = switch (_currentSection) {
      AppSection.dashboard => 5,
      AppSection.pets => 6,
      AppSection.medicalRecords => 8,
      AppSection.appointments => 9,
      AppSection.vaccinations => 10,
      AppSection.followUps => 11,
      AppSection.branches => 12,
      AppSection.profile => 13,
    };
    return SectionPlaceholder(
      title: item.label,
      icon: item.icon,
      description: '${item.label} — coming in Part $part.',
    );
  }

  void _selectSection(AppSection section) {
    if (_currentSection == section) return;
    setState(() => _currentSection = section);
  }
}
