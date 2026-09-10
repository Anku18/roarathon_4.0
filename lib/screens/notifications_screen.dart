import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_safe_area.dart';

/// Opens as a modal bottom sheet.
void showNotificationsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _NotificationsSheet(),
  );
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final notifications = state.notifications;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final today = notifications.where((n) => n.timestamp.isAfter(todayStart)).toList();
    final earlier = notifications.where((n) => !n.timestamp.isAfter(todayStart)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      snap: true,
      snapSizes: const [0.4, 0.72, 0.92],
      builder: (context, scrollController) {
        return AppSafeArea(
          top: false,
          child: Container(
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // ── Handle ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lineHeavy,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // ── Header ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
                child: Row(
                  children: [
                    Text(
                      'Notifications',
                      style: AppTheme.font(
                        size: 20,
                        weight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    if (notifications.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          state.markAllRead();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          backgroundColor: AppColors.blush,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Mark all read',
                          style: AppTheme.font(
                            size: 12,
                            weight: FontWeight.w700,
                            color: AppColors.deep,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Demo inject buttons (dev helper) ──────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    _DemoChip(
                      '📈 Market',
                      () => NotificationService.instance.injectDemoNotification(
                        state,
                        type: NotificationType.marketAlert,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DemoChip(
                      '🔥 Streak',
                      () => NotificationService.instance.injectDemoNotification(
                        state,
                        type: NotificationType.streak,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DemoChip(
                      '🎯 Mission',
                      () => NotificationService.instance.injectDemoNotification(
                        state,
                        type: NotificationType.mission,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DemoChip(
                      '👥 Referral',
                      () => NotificationService.instance.injectDemoNotification(
                        state,
                        type: NotificationType.referral,
                      ),
                    ),
                  ],
                ),
              ),

              // ── List ──────────────────────────────────────────────────
              Expanded(
                child: notifications.isEmpty
                    ? _EmptyState()
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        children: [
                          if (today.isNotEmpty) ...[
                            _SectionLabel('Today'),
                            const SizedBox(height: 8),
                            ...today.map(
                              (n) => _NotifTile(
                                notif: n,
                                onDismiss: () => state.dismissNotification(n.id),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (earlier.isNotEmpty) ...[
                            _SectionLabel('Earlier'),
                            const SizedBox(height: 8),
                            ...earlier.map(
                              (n) => _NotifTile(
                                notif: n,
                                onDismiss: () => state.dismissNotification(n.id),
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
          ),
        );
      },
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTheme.font(size: 10.5, weight: FontWeight.w700, color: AppColors.mute, letterSpacing: 0.8),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.notif, required this.onDismiss});
  final AppNotification notif;
  final VoidCallback onDismiss;

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey(notif.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismiss(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.blush,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.delete_outline, color: AppColors.coral, size: 22),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: notif.isRead ? AppColors.sand : AppColors.blush,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: notif.isRead ? AppColors.line : AppColors.coralLine,
              width: notif.isRead ? 1 : 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon bubble
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: notif.isRead ? AppColors.line : AppColors.coral.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(notif.typeIcon, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: AppTheme.font(
                              size: 13.5,
                              weight: notif.isRead ? FontWeight.w500 : FontWeight.w800,
                              color: notif.isRead ? AppColors.mute : AppColors.ink,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.coral,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      notif.body,
                      style: AppTheme.font(size: 12, color: AppColors.mute, height: 1.4),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _timeAgo(notif.timestamp),
                      style: AppTheme.font(size: 10.5, color: AppColors.mute),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  const _DemoChip(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.sand,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.lineStrong),
        ),
        child: Text(
          label,
          style: AppTheme.font(size: 11.5, weight: FontWeight.w700, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.sand,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.lineStrong),
            ),
            child: const Text('🔔', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: AppTheme.font(size: 16, weight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Market alerts, streak reminders\nand mission updates will appear here.',
            textAlign: TextAlign.center,
            style: AppTheme.font(size: 13, color: AppColors.mute, height: 1.5),
          ),
        ],
      ),
    );
  }
}
