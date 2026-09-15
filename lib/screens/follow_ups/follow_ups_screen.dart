import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/follow_up_model.dart';
import '../../models/pet_model.dart';
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

class _FollowUpsScreenState extends State<FollowUpsScreen> {
  late List<FollowUp> _followUps;
  FollowUpStatus? _selectedStatus;
  bool _isLoading = true;
  String? _completingId;

  @override
  void initState() {
    super.initState();
    _followUps = List<FollowUp>.from(mockFollowUps);
    _loadFollowUps();
  }

  Future<void> _loadFollowUps() async {
    // TODO: Replace this mock delay with a Firestore followUps stream.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isLoading = false);
  }

  List<FollowUp> get _filteredFollowUps {
    final items = _followUps.where((followUp) => _selectedStatus == null || followUp.status == _selectedStatus).toList();
    items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingWidget(message: 'Loading follow-ups...');
    final total = totalFollowUps(_followUps);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const _Header(),
            const SizedBox(height: 20),
            FilterTabs<FollowUpStatus>(
              options: FollowUpStatus.values,
              selected: _selectedStatus,
              allLabel: 'All ($total)',
              onChanged: (value) => setState(() => _selectedStatus = value),
              labelBuilder: (status) => '${_statusLabel(status)} (${countFollowUps(_followUps, status)})',
            ),
            const SizedBox(height: 20),
            if (_filteredFollowUps.isEmpty)
              const SizedBox(height: 300, child: EmptyState(icon: Icons.event_repeat_outlined, title: 'No follow-ups found', message: 'No follow-ups match this filter.'))
            else
              ..._filteredFollowUps.map((followUp) => Padding(padding: const EdgeInsets.only(bottom: 14), child: FollowUpCard(followUp: followUp, isCompleting: _completingId == followUp.id, onViewPet: () => _viewPet(followUp), onMarkComplete: () => _markComplete(followUp)))),
          ]),
        ),
      ),
    );
  }

  Future<void> _markComplete(FollowUp followUp) async {
    setState(() => _completingId = followUp.id);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      final index = _followUps.indexWhere((item) => item.id == followUp.id);
      if (index >= 0) {
        final current = _followUps[index];
        _followUps[index] = FollowUp(id: current.id, petName: current.petName, petId: current.petId, title: current.title, relatedTo: current.relatedTo, branch: current.branch, dueDate: current.dueDate, note: current.note, status: FollowUpStatus.completed);
      }
      _completingId = null;
    });
    // TODO: Persist the completed status to Firestore in the real implementation.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked as complete.')));
  }

  void _viewPet(FollowUp followUp) {
    final pet = mockPets.where((item) => item.id == followUp.petId).firstOrNull;
    if (pet == null) {
      // TODO: Replace the local lookup with a Firestore pet fetch by petId.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pet record could not be found.')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PetDetailsScreen(pet: pet, onBack: () => Navigator.of(context).pop())));
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Follow-Ups', style: AppTypography.pageTitle), const SizedBox(height: 5), const Text('Track and manage patient follow-up schedules.', style: AppTypography.pageSubtitle)]);
}

String _statusLabel(FollowUpStatus status) => switch (status) { FollowUpStatus.pending => 'Pending', FollowUpStatus.completed => 'Completed', FollowUpStatus.overdue => 'Overdue' };
