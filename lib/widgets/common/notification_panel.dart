import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/notification_model.dart';

/// A positioned popover panel showing clinic notifications.
///
/// Rendered as a [CompositedTransformFollower] anchored to the bell icon
/// via a [LayerLink], so it tracks the bell even if the layout shifts.
///
/// Usage:
/// ```dart
/// CompositedTransformTarget(link: _layerLink, child: bellButton)
/// // Then in an OverlayEntry:
/// NotificationPanel(
///   layerLink: _layerLink,
///   notifications: _notifications,
///   onDismiss: _close,
///   onMarkRead: (id) => ...,
/// )
/// ```
class NotificationPanel extends StatelessWidget {
  const NotificationPanel({
    required this.layerLink,
    required this.notifications,
    required this.onDismiss,
    required this.onMarkRead,
    super.key,
  });

  /// The [LayerLink] shared with the bell icon's [CompositedTransformTarget].
  final LayerLink layerLink;

  /// The current list of notifications to display.
  final List<AppNotification> notifications;

  /// Called when the user taps outside the panel or presses the close button.
  final VoidCallback onDismiss;

  /// Called with a notification [id] when the user taps a row to mark it read.
  ///
  /// TODO: In the real implementation, also navigate to the relevant
  /// pet/appointment/vaccination record based on [NotificationType].
  final ValueChanged<String> onMarkRead;

  int get _unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Transparent barrier to catch outside taps ──────────────────
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),

        // ── The panel itself, anchored below the bell ──────────────────
        CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-260, 54), // align right edge below the bell
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 320, maxWidth: 360),
              child: LightGlassPanel(
                borderRadius: 16,
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header ─────────────────────────────────────────
                    _PanelHeader(unreadCount: _unreadCount, onClose: onDismiss),

                    // ── Notification list ──────────────────────────────
                    if (notifications.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                        child: Center(
                          child: Text(
                            'No notifications',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ...notifications.map(
                        (n) => _NotificationRow(
                          notification: n,
                          onTap: () => onMarkRead(n.id),
                        ),
                      ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Panel header ─────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.unreadCount, required this.onClose});

  final int unreadCount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE55353).withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unreadCount unread',
                style: const TextStyle(
                  color: Color(0xFFE55353),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 17),
            tooltip: 'Close notifications',
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ── Notification row ──────────────────────────────────────────────────────────

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    final (iconData, iconColor) = _iconForType(notification.type);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : iconColor.withValues(alpha: .04),
          border: Border(
            top: BorderSide(color: AppColors.border.withValues(alpha: .60)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ──────────────────────────────────────────────────
            Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: .14),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 17),
            ),
            const SizedBox(width: 11),

            // ── Text content ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread dot
                      if (!isRead) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE55353),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: isRead
                          ? AppColors.textSecondary.withValues(alpha: .70)
                          : AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatRelativeTime(notification.timestamp),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static (IconData, Color) _iconForType(NotificationType type) => switch (type) {
        NotificationType.followUpDue => (Icons.warning_amber_rounded, Color(0xFFD69A16)),
        NotificationType.vaccinationDue => (Icons.vaccines_outlined, Color(0xFF1C9A72)),
        NotificationType.appointmentUpdate => (Icons.calendar_month_outlined, Color(0xFF3B82C4)),
      };
}
