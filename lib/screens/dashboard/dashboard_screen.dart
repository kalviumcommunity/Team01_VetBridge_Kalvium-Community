import 'package:flutter/material.dart';

import '../../core/constants/nav_items.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/dashboard_models.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/pet_avatar.dart';
import '../../widgets/common/status_badge.dart';

/// Dashboard overview for the authenticated clinic workspace.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.userName, super.key, this.onSectionSelected});

  final String userName;
  final ValueChanged<AppSection>? onSectionSelected;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardData? _data;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    // TODO: Replace this mock delay and data with Firestore repository calls.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _data = DashboardData.mock());
  }

  @override
  Widget build(BuildContext context) {
    return LightGlassBackground(
      child: _data == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1240),
                      child: _DashboardContent(data: _data!, userName: widget.userName, onSectionSelected: widget.onSectionSelected),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data, required this.userName, this.onSectionSelected});

  final DashboardData data;
  final String userName;
  final ValueChanged<AppSection>? onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GreetingHeader(userName: userName, onSectionSelected: onSectionSelected),
        const SizedBox(height: 26),
        _StatsGrid(stats: data.stats),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 820;
            if (stacked) {
              return Column(
                children: [
                  _AppointmentsCard(appointments: data.appointments, onViewAll: () => onSectionSelected?.call(AppSection.appointments)),
                  const SizedBox(height: 20),
                  _FollowUpsCard(followUps: data.followUps, onViewAll: () => onSectionSelected?.call(AppSection.followUps)),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _AppointmentsCard(appointments: data.appointments, onViewAll: () => onSectionSelected?.call(AppSection.appointments))),
                const SizedBox(width: 20),
                Expanded(child: _FollowUpsCard(followUps: data.followUps, onViewAll: () => onSectionSelected?.call(AppSection.followUps))),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        _RecentPetsCard(pets: data.recentPets, onViewAll: () => onSectionSelected?.call(AppSection.pets)),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.userName, this.onSectionSelected});

  final String userName;
  final ValueChanged<AppSection>? onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, ${userName.split(' ').first}',
              style: AppTypography.textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Here's an overview of today's clinic activity.",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => onSectionSelected?.call(AppSection.pets),
              icon: const Icon(Icons.search, size: 17),
              label: const Text('Search Pet'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.border.withValues(alpha: .8)),
                backgroundColor: Colors.white.withValues(alpha: .55),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: () => onSectionSelected?.call(AppSection.appointments),
              icon: const Icon(Icons.add, size: 17),
              label: const Text('Schedule Appointment'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 580 ? 1 : constraints.maxWidth < 900 ? 2 : 4;
        final width = (constraints.maxWidth - ((columns - 1) * 16)) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatCard(width: width, icon: Icons.calendar_today_outlined, iconColor: AppColors.statusInfo, label: "Today's Appointments", value: '${stats.todaysAppointments}'),
            _StatCard(width: width, icon: Icons.pets_outlined, iconColor: AppColors.statusSuccess, label: 'Registered Pets', value: '${stats.registeredPets}'),
            _StatCard(width: width, icon: Icons.schedule_outlined, iconColor: AppColors.statusWarning, label: 'Upcoming Appointments', value: '${stats.upcomingAppointments}'),
            _StatCard(width: width, icon: Icons.notifications_none_outlined, iconColor: AppColors.statusDanger, label: 'Pending Follow-Ups', value: '${stats.pendingFollowUps}'),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.width, required this.icon, required this.iconColor, required this.label, required this.value});

  final double width;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LightGlassPanel(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: .10), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsCard extends StatelessWidget {
  const _AppointmentsCard({required this.appointments, required this.onViewAll});

  final List<DashboardAppointment> appointments;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: "Today's Appointments",
      action: 'View all',
      onAction: onViewAll,
      child: appointments.isEmpty
          ? const SizedBox(height: 120, child: EmptyState(icon: Icons.event_available_outlined, title: 'No appointments today', message: 'There are no appointments scheduled for today.'))
          : Column(children: appointments.map((appointment) => _AppointmentRow(appointment: appointment)).toList()),
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.appointment});

  final DashboardAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: appointment.iconColor.withValues(alpha: .14), shape: BoxShape.circle),
            child: Icon(appointment.icon, color: appointment.iconColor, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointment.petName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13)),
                const SizedBox(height: 2),
                Text('${appointment.ownerName} · ${appointment.reason}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(appointment.time, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12)),
              const SizedBox(height: 4),
              StatusBadge(label: appointment.status, color: AppColors.statusSuccess, backgroundColor: AppColors.statusSuccess.withValues(alpha: .10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FollowUpsCard extends StatelessWidget {
  const _FollowUpsCard({required this.followUps, required this.onViewAll});

  final List<DashboardFollowUp> followUps;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Upcoming Follow-Ups',
      action: 'View all',
      onAction: onViewAll,
      child: followUps.isEmpty
          ? const SizedBox(height: 120, child: EmptyState(icon: Icons.event_repeat_outlined, title: 'No upcoming follow-ups', message: 'There are no follow-ups to show.'))
          : Column(children: followUps.map((followUp) => _FollowUpRow(followUp: followUp)).toList()),
    );
  }
}

class _FollowUpRow extends StatelessWidget {
  const _FollowUpRow({required this.followUp});

  final DashboardFollowUp followUp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(width: 4, height: 38, decoration: BoxDecoration(color: followUp.statusColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(followUp.petName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13))),
                    const SizedBox(width: 6),
                    StatusBadge(label: followUp.status, color: followUp.statusColor, backgroundColor: followUp.statusColor.withValues(alpha: .10)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(followUp.reason, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(followUp.date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _RecentPetsCard extends StatelessWidget {
  const _RecentPetsCard({required this.pets, required this.onViewAll});

  final List<DashboardPet> pets;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Recently Registered Pets',
      action: 'View all',
      onAction: onViewAll,
      child: pets.isEmpty
          ? const SizedBox(height: 120, child: EmptyState(icon: Icons.pets_outlined, title: 'No recently registered pets', message: 'Newly registered pets will appear here.'))
          : Column(children: pets.map((pet) => _PetRow(pet: pet)).toList()),
    );
  }
}

class _PetRow extends StatelessWidget {
  const _PetRow({required this.pet});

  final DashboardPet pet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          PetAvatar(species: pet.species, size: 34),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _PetInfo(label: pet.name, value: pet.ownerName)),
          Expanded(flex: 2, child: _PetInfo(label: pet.species, value: pet.breed)),
          Expanded(child: _PetInfo(label: 'Last visit', value: pet.lastVisit)),
          StatusBadge(label: pet.status, color: AppColors.statusSuccess, backgroundColor: AppColors.statusSuccess.withValues(alpha: .10)),
        ],
      ),
    );
  }
}

class _PetInfo extends StatelessWidget {
  const _PetInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.action, required this.onAction, required this.child});

  final String title;
  final String action;
  final VoidCallback onAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800))),
              TextButton(onPressed: onAction, child: Text(action, style: const TextStyle(color: AppColors.primary, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

