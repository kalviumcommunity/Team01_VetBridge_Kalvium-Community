import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/follow_up_model.dart';
import '../../services/follow_up_service.dart';
import '../../services/pet_service.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/filter_tabs.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/follow_ups/follow_up_card.dart';
import '../pets/pet_details_screen.dart';

/// Follow-up schedule presented as an actionable card list.
class FollowUpsScreen extends StatefulWidget {
  const FollowUpsScreen({super.key});

  @override
  State<FollowUpsScreen> createState() => _FollowUpsScreenState();
}

// Follow-up filter categories — the enum itself only has pending/completed now.
// Overdue is a derived display concept surfaced through FollowUp.isOverdue.
enum _FollowUpFilter { all, pending, overdue, completed }

class _FollowUpsScreenState extends State<FollowUpsScreen> {
  _FollowUpFilter _selectedFilter = _FollowUpFilter.all;
  String? _completingId;

  List<FollowUp> _filterFollowUps(List<FollowUp> allFollowUps) {
    final items = switch (_selectedFilter) {
      _FollowUpFilter.all => allFollowUps,
      _FollowUpFilter.pending =>
        allFollowUps.where((f) => f.status == FollowUpStatus.pending && !f.isOverdue).toList(),
      // Overdue = pending AND past followUpDate
      _FollowUpFilter.overdue => allFollowUps.where((f) => f.isOverdue).toList(),
      _FollowUpFilter.completed =>
        allFollowUps.where((f) => f.status == FollowUpStatus.completed).toList(),
    };
    return [...items]..sort((a, b) => a.followUpDate.compareTo(b.followUpDate));
  }

  int _countFor(List<FollowUp> allFollowUps, _FollowUpFilter filter) => switch (filter) {
        _FollowUpFilter.all => allFollowUps.length,
        _FollowUpFilter.pending =>
          allFollowUps.where((f) => f.status == FollowUpStatus.pending && !f.isOverdue).length,
        _FollowUpFilter.overdue => allFollowUps.where((f) => f.isOverdue).length,
        _FollowUpFilter.completed =>
          allFollowUps.where((f) => f.status == FollowUpStatus.completed).length,
      };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FollowUp>>(
      stream: FollowUpService.instance.streamFollowUps(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget(message: 'Loading follow-ups...');
        }
        if (snapshot.hasError) {
          return Center(
            child: EmptyState(
              icon: Icons.error_outline,
              title: 'Error loading follow-ups',
              message: snapshot.error.toString(),
            ),
          );
        }

        final allFollowUps = snapshot.data ?? [];
        final filteredFollowUps = _filterFollowUps(allFollowUps);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const _Header(),
                const SizedBox(height: 20),
                FilterTabs<_FollowUpFilter>(
                  options: _FollowUpFilter.values,
                  selected: _selectedFilter,
                  allLabel: 'All (${_countFor(allFollowUps, _FollowUpFilter.all)})',
                  onChanged: (value) => setState(() => _selectedFilter = value ?? _FollowUpFilter.all),
                  labelBuilder: (filter) {
                    final label = _filterLabel(filter);
                    final count = _countFor(allFollowUps, filter);
                    return '$label ($count)';
                  },
                ),
                const SizedBox(height: 20),
                if (filteredFollowUps.isEmpty)
                  const SizedBox(
                    height: 300,
                    child: EmptyState(
                      icon: Icons.event_repeat_outlined,
                      title: 'No follow-ups found',
                      message: 'No follow-ups match this filter.',
                    ),
                  )
                else
                  ...filteredFollowUps.map(
                    (followUp) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: FollowUpCard(
                        followUp: followUp,
                        isCompleting: _completingId == followUp.id,
                        onViewPet: () => _viewPet(followUp),
                        onMarkComplete: () => _markComplete(followUp),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        );
      },
    );
  }

  Future<void> _markComplete(FollowUp followUp) async {
    setState(() => _completingId = followUp.id);
    
    try {
      final updatedFollowUp = FollowUp(
        id: followUp.id,
        petName: followUp.petName,
        petId: followUp.petId,
        reason: followUp.reason,
        relatedTreatmentId: followUp.relatedTreatmentId,
        followUpDate: followUp.followUpDate,
        note: followUp.note,
        status: FollowUpStatus.completed,
        createdAt: followUp.createdAt,
        updatedAt: DateTime.now(),
      );
      
      await FollowUpService.instance.updateFollowUp(updatedFollowUp);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marked as complete.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _completingId = null);
    }
  }

  Future<void> _viewPet(FollowUp followUp) async {
    final pet = await PetService.instance.getPetById(followUp.petId);
    if (!mounted) return;
    
    if (pet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet record could not be found.')),
      );
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PetDetailsScreen(pet: pet, onBack: () => Navigator.of(context).pop()),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Follow-Ups', style: AppTypography.pageTitle),
      const SizedBox(height: 5),
      const Text(
        'Track and manage patient follow-up schedules.',
        style: AppTypography.pageSubtitle,
      ),
    ],
  );
}

String _filterLabel(_FollowUpFilter filter) => switch (filter) {
      _FollowUpFilter.all => 'All',
      _FollowUpFilter.pending => 'Pending',
      _FollowUpFilter.overdue => 'Overdue',
      _FollowUpFilter.completed => 'Completed',
    };
