import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/notification_model.dart';
import 'notification_panel.dart';

/// Top application bar used in both the desktop [Row] layout and as the
/// mobile [Scaffold.appBar].
///
/// Converted to [StatefulWidget] to hold local notification state and
/// the open/closed state of [NotificationPanel].
class AppTopBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  /// Local copy of notifications — mutable so that marking one read
  /// re-renders the badge count immediately.
  late List<AppNotification> _notifications;

  /// Overlay entry for the notification panel; non-null while the panel is open.
  OverlayEntry? _overlayEntry;

  /// LayerLink that anchors the panel to the bell icon.
  final _bellLayerLink = LayerLink();

  bool get _panelOpen => _overlayEntry != null;

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    // Start from a fresh copy of the mock list so mutations stay local to
    // this widget instance and don't bleed into the global mock.
    _notifications = mockNotifications.map((n) => n.markRead()..isRead = n.isRead).toList();
  }

  @override
  void dispose() {
    _closePanel();
    super.dispose();
  }

  // ── Panel lifecycle ───────────────────────────────────────────────────────

  void _togglePanel() {
    if (_panelOpen) {
      _closePanel();
    } else {
      _openPanel();
    }
  }

  void _openPanel() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (_) => NotificationPanel(
        layerLink: _bellLayerLink,
        notifications: _notifications,
        onDismiss: _closePanel,
        onMarkRead: _markRead,
      ),
    );
    overlay.insert(_overlayEntry!);
    setState(() {}); // update bell highlight if desired
  }

  void _closePanel() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  void _markRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index < 0) return;
    setState(() {
      _notifications[index] = _notifications[index].markRead();
    });
    // Rebuild the overlay so the panel reflects the new read state.
    _overlayEntry?.markNeedsBuild();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 700;
    return Container(
      height: widget.preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (widget.showMenuButton) ...[
            IconButton(
              tooltip: 'Open navigation',
              onPressed: widget.onMenuTap,
              icon: const Icon(Icons.menu_rounded),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(child: narrow ? _SearchIconButton() : const _SearchField()),
          const SizedBox(width: 16),
          _BranchSelector(branch: widget.currentBranch),
          const SizedBox(width: 14),
          _NotificationButton(
            layerLink: _bellLayerLink,
            unreadCount: _unreadCount,
            isOpen: _panelOpen,
            onTap: _togglePanel,
          ),
          const SizedBox(width: 14),
          _UserMenu(name: widget.userName, initials: widget.userInitials),
        ],
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

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

/// Bell icon button with a live badge count.
///
/// Uses [CompositedTransformTarget] so [NotificationPanel] can anchor
/// to this widget's position via a shared [LayerLink].
class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.layerLink,
    required this.unreadCount,
    required this.isOpen,
    required this.onTap,
  });

  final LayerLink layerLink;
  final int unreadCount;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: onTap,
            icon: Icon(
              isOpen ? Icons.notifications_rounded : Icons.notifications_none_outlined,
              color: isOpen ? AppColors.primary : null,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: 6,
              right: 6,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE55353),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
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
