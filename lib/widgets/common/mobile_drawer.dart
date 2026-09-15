import 'package:flutter/material.dart';

import '../../core/constants/nav_items.dart';
import '../../core/theme/app_colors.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({
    required this.currentSection,
    required this.onSectionSelected,
    super.key,
  });

  final AppSection currentSection;
  final ValueChanged<AppSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final moduleItems = appNavItems.where((item) => !item.isAccountSection);
    final profile = appNavItems.firstWhere((item) => item.isAccountSection);
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
              child: const Row(
                children: [
                  _DrawerLogoMark(),
                  SizedBox(width: 12),
                  Text(
                    'VetBridge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ...moduleItems.map((item) => _DrawerItem(
                        item: item,
                        selected: currentSection == item.section,
                        onTap: () => _select(context, item.section),
                      )),
                  const Divider(height: 28),
                  _DrawerItem(
                    item: profile,
                    selected: currentSection == profile.section,
                    onTap: () => _select(context, profile.section),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(BuildContext context, AppSection section) {
    onSectionSelected(section);
    Navigator.pop(context);
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.item, required this.selected, required this.onTap});

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        selected: selected,
        selectedTileColor: AppColors.primary.withValues(alpha: .09),
        selectedColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(item.icon),
        title: Text(item.label),
        textColor: AppColors.textSecondary,
        iconColor: AppColors.textSecondary,
      ),
    );
  }
}

class _DrawerLogoMark extends StatelessWidget {
  const _DrawerLogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'V',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
