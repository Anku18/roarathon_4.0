import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/dummy/dummy.dart';
import '../models/models.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../widgets/paper.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final seed = state.seed;
    final referrals = state.leaderboardTab == LeaderboardTab.referrals;
    final board = referrals ? seed.referralBoard : seed.accuracyBoard;

    return ScreenPad(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seed.seasonLabel,
                  style: AppTheme.font(
                    size: 11.5,
                    weight: FontWeight.w700,
                    color: AppColors.mute,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Leaderboard',
                  style: AppTheme.font(
                    size: 30,
                    weight: FontWeight.w800,
                    letterSpacing: -1.0,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'A referral counts once your friend funds their account.',
                  style: AppTheme.font(size: 12.5, color: AppColors.mute),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _TabPill(
                  label: 'Referrals',
                  on: referrals,
                  onTap: () => state.setLeaderboardTab(LeaderboardTab.referrals),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TabPill(
                  label: '8:45 accuracy',
                  on: !referrals,
                  onTap: () => state.setLeaderboardTab(LeaderboardTab.accuracy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < board.length; i++) ...[
            _BoardRow(row: board[i]),
            if (i != board.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 18),
          const SectionHeader('Your invites'),
          for (var i = 0; i < seed.invites.length; i++) ...[
            _InviteRow(invite: seed.invites[i]),
            if (i != seed.invites.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 14),
          PaperCard(
            color: AppColors.blush,
            radius: AppRadii.cardLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REFERRAL',
                  style: AppTheme.font(
                    size: 11,
                    weight: FontWeight.w800,
                    color: AppColors.deep,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${DummyReferrals.bountyCoins} Shercoins each, on funding',
                  style: AppTheme.font(
                    size: 19,
                    weight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Five funded referrals in a season earns the Recruiter badge and a free premium class.',
                  style: AppTheme.font(size: 12.5, color: AppColors.muteSoft, height: 1.4),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: seed.profile.referralCode),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied ${seed.profile.referralCode}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: AppColors.cream,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
                  child: Text(
                    'Share code · ${seed.profile.referralCode}',
                    style: AppTheme.font(
                      size: 13.5,
                      weight: FontWeight.w800,
                      color: AppColors.cream,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({required this.label, required this.on, required this.onTap});

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: on ? AppColors.ink : Colors.transparent,
          foregroundColor: on ? AppColors.cream : AppColors.ink,
          side: BorderSide(color: on ? AppColors.ink : AppColors.lineHeavy),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.font(
            size: 12.5,
            weight: FontWeight.w800,
            color: on ? AppColors.cream : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _BoardRow extends StatelessWidget {
  const _BoardRow({required this.row});

  final LeaderboardRow row;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: row.isYou ? AppColors.blush : AppColors.cream,
      borderColor: row.isYou ? AppColors.coralLine : AppColors.line,
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              row.rank,
              style: AppTheme.font(
                size: 15,
                weight: FontWeight.w800,
                letterSpacing: -0.3,
                color: AppColors.mute,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: row.isYou ? AppColors.coral : AppColors.ink,
            child: Text(
              row.initials,
              style: AppTheme.font(
                size: 12.5,
                weight: FontWeight.w800,
                color: AppColors.cream,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.name,
                  style: AppTheme.font(size: 14, weight: FontWeight.w800, letterSpacing: -0.2),
                ),
                Text(
                  row.sub,
                  style: AppTheme.font(size: 11, color: AppColors.mute),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                row.metric,
                style: AppTheme.font(size: 13.5, weight: FontWeight.w800),
              ),
              Text(
                row.coins,
                style: AppTheme.font(size: 11, color: AppColors.deep),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InviteRow extends StatelessWidget {
  const _InviteRow({required this.invite});

  final Invite invite;

  @override
  Widget build(BuildContext context) {
    final funded = invite.status == InviteStatus.funded;
    final tag = switch (invite.status) {
      InviteStatus.funded => '+${invite.coins}',
      InviteStatus.pending => 'Pending',
      InviteStatus.sent => 'Sent',
    };
    return PaperCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invite.name,
                  style: AppTheme.font(size: 13.5, weight: FontWeight.w700),
                ),
                Text(
                  invite.step,
                  style: AppTheme.font(size: 11, color: AppColors.mute),
                ),
              ],
            ),
          ),
          StatusPill(
            label: tag,
            background: funded ? AppColors.blush : AppColors.ink.withValues(alpha: 0.06),
            foreground: funded ? AppColors.deep : AppColors.mute,
          ),
        ],
      ),
    );
  }
}
