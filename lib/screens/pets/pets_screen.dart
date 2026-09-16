import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/pet_model.dart';
import 'pet_details_screen.dart';
import '../../widgets/common/branch_badge.dart';
import '../../services/pet_service.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/pet_avatar.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/pets/register_pet_dialog.dart';

/// Pet registry with search, filters, and mock registration.
class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _speciesFilter = 'All';
  String _statusFilter = 'All';

  List<Pet> _filterPets(List<Pet> allPets) {
    final query = _searchQuery.trim().toLowerCase();
    return allPets.where((pet) {
      final matchesQuery = query.isEmpty || [pet.id, pet.name, pet.ownerName, pet.ownerPhone, pet.microchipId ?? ''].any((value) => value.toLowerCase().contains(query));
      final matchesSpecies = _speciesFilter == 'All' || pet.species == _speciesFilter;
      final matchesStatus = _statusFilter == 'All' || pet.status.name == _statusFilter.toLowerCase();
      return matchesQuery && matchesSpecies && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 600;
    return Container(
      color: Colors.transparent,
      child: StreamBuilder<List<Pet>>(
        stream: PetService.instance.streamPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Loading pets...');
          }
          if (snapshot.hasError) {
            return Center(
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Error loading pets',
                message: snapshot.error.toString(),
              ),
            );
          }
          
          final allPets = snapshot.data ?? [];
          final filteredPets = _filterPets(allPets);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(onRegister: _openRegisterDialog),
                    const SizedBox(height: 22),
                    _FilterBar(
                      controller: _searchController,
                      species: _speciesFilter,
                      status: _statusFilter,
                      onSearchChanged: (value) => setState(() => _searchQuery = value),
                      onSpeciesChanged: (value) => setState(() => _speciesFilter = value!),
                      onStatusChanged: (value) => setState(() => _statusFilter = value!),
                    ),
                    const SizedBox(height: 18),
                    if (filteredPets.isEmpty)
                      const SizedBox(height: 280, child: EmptyState(icon: Icons.pets_outlined, title: 'No pets found', message: 'Try adjusting your search or filters.'))
                    else if (mobile)
                      _MobilePetList(pets: filteredPets)
                    else
                      _DesktopPetTable(pets: filteredPets),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openRegisterDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const RegisterPetDialog(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 14,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pets', style: AppTypography.pageTitle),
            const SizedBox(height: 5),
            const Text('Search and manage centralized pet records.', style: AppTypography.pageSubtitle),
          ],
        ),
        FilledButton.icon(
          onPressed: onRegister,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Register New Pet'),
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 13)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.controller, required this.species, required this.status, required this.onSearchChanged, required this.onSpeciesChanged, required this.onStatusChanged});

  final TextEditingController controller;
  final String species;
  final String status;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSpeciesChanged;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 650;
          final fields = [
            Expanded(child: SearchField(controller: controller, hint: 'Search by Pet ID, name, owner, phone or microchip ID', onChanged: onSearchChanged)),
            _FilterDropdown(value: species, items: const ['All', 'Dog', 'Cat', 'Rabbit', 'Bird', 'Other'], onChanged: onSpeciesChanged),
            _FilterDropdown(value: status, items: const ['All', 'Active', 'Inactive'], onChanged: onStatusChanged),
          ];
          return stacked
              ? Column(children: [fields[0], const SizedBox(height: 10), Row(children: [Expanded(child: fields[1]), const SizedBox(width: 10), Expanded(child: fields[2])])])
              : Row(children: [fields[0], const SizedBox(width: 12), fields[1], const SizedBox(width: 12), fields[2]]);
        },
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.value, required this.items, required this.onChanged});

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withValues(alpha: .72),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class _DesktopPetTable extends StatelessWidget {
  const _DesktopPetTable({required this.pets});

  final List<Pet> pets;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        children: [
          const _TableHeader(),
          const Divider(height: 18),
          ...pets.map((pet) => _DesktopPetRow(pet: pet)),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 2, child: _HeaderText('Pet')),
        Expanded(flex: 2, child: _HeaderText('Owner')),
        Expanded(child: _HeaderText('Species')),
        Expanded(flex: 2, child: _HeaderText('Current Branch')),
        Expanded(child: _HeaderText('Last Visit')),
        Expanded(child: _HeaderText('Status')),
        SizedBox(width: 28),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w800));
}

class _DesktopPetRow extends StatelessWidget {
  const _DesktopPetRow({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PetDetailsScreen(
              pet: pet,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(flex: 2, child: _PetIdentity(pet: pet)),
            Expanded(flex: 2, child: _OwnerIdentity(pet: pet)),
            Expanded(child: Text(pet.species, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
            Expanded(flex: 2, child: BranchBadge(branchName: pet.currentBranch)),
            Expanded(child: Text(_formatDate(pet.lastVisit), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
            Expanded(child: StatusBadge(label: pet.status == PetStatus.active ? 'Active' : 'Inactive', color: pet.status == PetStatus.active ? AppColors.statusSuccess : AppColors.textSecondary, backgroundColor: pet.status == PetStatus.active ? AppColors.statusSuccess.withValues(alpha: .10) : AppColors.border)),
            const SizedBox(width: 28, child: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20)),
          ],
        ),
      ),
    );
  }
}

class _PetIdentity extends StatelessWidget {
  const _PetIdentity({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) => Row(children: [PetAvatar(species: pet.species, size: 34), const SizedBox(width: 9), Expanded(child: _TwoLine(first: pet.name, second: pet.id))]);
}

class _OwnerIdentity extends StatelessWidget {
  const _OwnerIdentity({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) => _TwoLine(first: pet.ownerName, second: pet.ownerPhone);
}

class _TwoLine extends StatelessWidget {
  const _TwoLine({required this.first, required this.second});
  final String first;
  final String second;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(first, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(second, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))]);
}

class _MobilePetList extends StatelessWidget {
  const _MobilePetList({required this.pets});
  final List<Pet> pets;

  @override
  Widget build(BuildContext context) {
    return Column(children: pets.map((pet) => Padding(padding: const EdgeInsets.only(bottom: 14), child: _MobilePetCard(pet: pet))).toList());
  }
}

class _MobilePetCard extends StatelessWidget {
  const _MobilePetCard({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PetDetailsScreen(
              pet: pet,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: LightGlassPanel(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [PetAvatar(species: pet.species), const SizedBox(width: 10), Expanded(child: _TwoLine(first: pet.name, second: pet.id)), StatusBadge(label: pet.status == PetStatus.active ? 'Active' : 'Inactive', color: pet.status == PetStatus.active ? AppColors.statusSuccess : AppColors.textSecondary, backgroundColor: pet.status == PetStatus.active ? AppColors.statusSuccess.withValues(alpha: .10) : AppColors.border)]),
            const Divider(height: 24),
            _MobileDetail(label: 'Owner', value: '${pet.ownerName} · ${pet.ownerPhone}'),
            const SizedBox(height: 10),
            Row(children: [Expanded(child: _MobileDetail(label: 'Species', value: pet.species)), Expanded(child: _MobileDetail(label: 'Last visit', value: _formatDate(pet.lastVisit)))]),
            const SizedBox(height: 12),
            BranchBadge(branchName: pet.currentBranch),
          ],
        ),
      ),
    );
  }
}

class _MobileDetail extends StatelessWidget {
  const _MobileDetail({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)), const SizedBox(height: 3), Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700))]);
}

String _formatDate(DateTime? date) => date == null ? '—' : '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
