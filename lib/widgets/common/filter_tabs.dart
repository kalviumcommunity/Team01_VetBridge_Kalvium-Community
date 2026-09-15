import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class FilterTabs<T> extends StatelessWidget {
  const FilterTabs({
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
    super.key,
    this.allLabel = 'All',
  });

  final List<T> options;
  final T? selected;
  final ValueChanged<T?> onChanged;
  final String Function(T) labelBuilder;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterPill(label: allLabel, selected: selected == null, onTap: () => onChanged(null)),
          ...options.map((option) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _FilterPill(label: labelBuilder(option), selected: selected == option, onTap: () => onChanged(option)),
              )),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white.withValues(alpha: .65),
          borderRadius: BorderRadius.circular(20),
          border: selected ? null : Border.all(color: AppColors.border),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
