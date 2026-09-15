import 'package:flutter/material.dart';

import '../../core/constants/nav_items.dart';
import '../../core/theme/app_colors.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
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

    return SizedBox(
      width: 72,
      child: ColoredBox(
        color: AppColors.primary,
        child: Column(
          children: [
            const SizedBox(height: 18),
            const _LogoMark(),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: moduleItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = moduleItems.elementAt(index);
                  return _RailItem(
                    item: item,
                    selected: currentSection == item.section,
                    onTap: () => onSectionSelected(item.section),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: Colors.white.withValues(alpha: .18), height: 1),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _RailItem(
                item: profile,
                selected: currentSection == profile.section,
                onTap: () => onSectionSelected(profile.section),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailItem extends StatefulWidget {
  const _RailItem({required this.item, required this.selected, required this.onTap});

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final foreground = widget.selected || _hovered
        ? Colors.white
        : Colors.white.withValues(alpha: .65);
    return Tooltip(
      message: widget.item.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 44,
            decoration: BoxDecoration(
              color: widget.selected
                  ? Colors.white.withValues(alpha: .16)
                  : (_hovered ? Colors.white.withValues(alpha: .08) : null),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.item.icon, color: foreground, size: 21),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: const Text(
        'V',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
