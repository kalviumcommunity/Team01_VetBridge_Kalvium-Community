import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.currentBranch,
    required this.onMenuTap,
    required this.showMenuButton,
    required this.userName,
    required this.userInitials,
    super.key,
  });

  final String currentBranch;
  final VoidCallback onMenuTap;
  final bool showMenuButton;
  final String userName;
  final String userInitials;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 700;
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (showMenuButton) ...[
            IconButton(
              tooltip: 'Open navigation',
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(child: narrow ? _SearchIconButton() : const _SearchField()),
          const SizedBox(width: 16),
          _BranchSelector(branch: currentBranch),
          const SizedBox(width: 14),
          const _NotificationButton(),
          const SizedBox(width: 14),
          _UserMenu(name: userName, initials: userInitials),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search pets, owners, records...',
          prefixIcon: const Icon(Icons.search, size: 19),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _SearchIconButton extends StatelessWidget {
  const _SearchIconButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        tooltip: 'Search',
        onPressed: () {},
        icon: const Icon(Icons.search),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.background,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}

class _BranchSelector extends StatelessWidget {
  const _BranchSelector({required this.branch});

  final String branch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Wire branch selection to the authenticated clinic session.
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, color: AppColors.primary, size: 7),
            const SizedBox(width: 6),
            Text(branch, style: const TextStyle(fontSize: 12, color: AppColors.ink)),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_outlined),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(color: Color(0xFFE55353), shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}

class _UserMenu extends StatelessWidget {
  const _UserMenu({required this.name, required this.initials});

  final String name;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Wire profile menu and logout to session management.
      },
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.mint,
            child: Text(
              initials,
              style: const TextStyle(color: AppColors.tealDark, fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
          if (MediaQuery.sizeOf(context).width >= 760) ...[
            const SizedBox(width: 8),
            Text(name, style: const TextStyle(color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600)),
            const Icon(Icons.keyboard_arrow_down, size: 17),
          ],
        ],
      ),
    );
  }
}
