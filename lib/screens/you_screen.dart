import 'package:flutter/material.dart';

import '../data/dummy/dummy.dart';
import '../models/models.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../theme/formatters.dart';
import '../widgets/net_bubble.dart';
import '../widgets/paper.dart';
import '../widgets/streak_sheet.dart';

class YouScreen extends StatelessWidget {
  const YouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final seed = state.seed;
    final profile = seed.profile;

    return ScreenPad(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.ink,
                  child: Text(
                    profile.initials,
                    style: AppTheme.font(
                      size: 15,
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
                        profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.font(
                          size: 17,
                          weight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        '${profile.tier} tier · ${profile.fundedReferrals} funded referrals',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.font(size: 12, color: AppColors.mute),
                      ),
                    ],
                  ),
                ),
                const NetBubble(),
              ],
            ),
          ),
          PaperCard(
            radius: AppRadii.cardXl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Kicker('SHERCOIN BALANCE'),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formatEnIn(state.ticks),
                          style: AppTheme.font(
                            size: 44,
                            weight: FontWeight.w800,
                            letterSpacing: -1.6,
                            height: 1.05,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'earned this season',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.font(size: 12.5, color: AppColors.mute),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatChip(
                      k: 'STREAK',
                      v: '${state.streak} · ${formatEnIn(state.streakCoins)}',
                      color: AppColors.blush,
                      onTap: () => showStreakSheet(context),
                    ),
                    const SizedBox(width: 8),
                    const _StatChip(
                      k: '8:45 CALLS',
                      v: DummyRewards.accuracyLabel,
                      color: AppColors.sand,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      k: 'REFERRALS',
                      v: '${profile.fundedReferrals} funded',
                      color: AppColors.sand,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeader('Redeem', trailing: 'Learning & brokerage'),
          for (var i = 0; i < seed.shop.length; i++) ...[
            _ShopTile(
              item: seed.shop[i],
              ticks: state.ticks,
              redeemed: state.isRedeemed(seed.shop[i].id),
              onOpen: () => _openShop(context, seed.shop[i]),
            ),
            if (i != seed.shop.length - 1) const SizedBox(height: 9),
          ],
          const SizedBox(height: 16),
          SectionHeader('8:45 call record', trailing: seed.callRecordSummary),
          Row(
            children: [
              for (var i = 0; i < seed.callRecord.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _RecordCell(
                      mark:
                          i == seed.callRecord.length - 1 &&
                              state.prediction != null
                          ? '?'
                          : seed.callRecord[i],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${state.prediction == null ? 'Today is unscored until you call it from the 8:45 alert.' : "Today's call is in and shows as a pending square."} Scored at the 3:30 PM close. A call is a game entry, not investment advice, and never places an order.',
            style: AppTheme.font(
              size: 11.5,
              color: AppColors.mute,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader('Achievements', trailing: seed.achievementsSummary),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seed.achievements.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 9,
              crossAxisSpacing: 9,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, i) {
              if (i == 0) {
                return _BadgeCard(
                  item: Achievement(
                    mark: '${state.streak}',
                    name: 'Streak',
                    sub: '${formatEnIn(state.streakCoins)} coins',
                    earned: true,
                  ),
                  featured: true,
                );
              }
              return _BadgeCard(item: seed.achievements[i - 1]);
            },
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () => state.logout(),
            child: Text(
              'Log out',
              style: AppTheme.font(
                size: 13.5,
                weight: FontWeight.w800,
                color: AppColors.deep,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openShop(BuildContext context, ShopItem item) async {
    final state = AppScope.of(context);
    if (!state.canAfford(item)) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONFIRM REDEMPTION',
                style: AppTheme.font(
                  size: 11,
                  weight: FontWeight.w800,
                  color: AppColors.deep,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                style: AppTheme.font(
                  size: 23,
                  weight: FontWeight.w800,
                  letterSpacing: -0.6,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Spends ${formatEnIn(item.cost)} Shercoins. ${item.subtitle}. The voucher lands in your inbox within an hour and is valid for 90 days.',
                style: AppTheme.font(
                  size: 13,
                  color: AppColors.muteSoft,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: PaperButton(
                      label: 'REDEEM ${formatEnIn(item.cost)} COINS',
                      onPressed: () {
                        state.redeem(item);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.lineHeavy),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                      ),
                      child: Text(
                        'Close',
                        style: AppTheme.font(
                          size: 13.5,
                          weight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.k,
    required this.v,
    required this.color,
    this.onTap,
  });

  final String k;
  final String v;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                k,
                style: AppTheme.font(
                  size: 10,
                  weight: FontWeight.w700,
                  color: AppColors.mute,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                v,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.font(
                  size: 16,
                  weight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopTile extends StatelessWidget {
  const _ShopTile({
    required this.item,
    required this.ticks,
    required this.redeemed,
    required this.onOpen,
  });

  final ShopItem item;
  final int ticks;
  final bool redeemed;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final afford = ticks >= item.cost;
    final live = afford || redeemed;
    final costLabel = redeemed
        ? 'REDEEMED'
        : afford
        ? formatEnIn(item.cost)
        : 'NEED ${formatEnIn(item.cost)}';

    return PaperCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: afford && !redeemed ? onOpen : null,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.kicker,
                  style: AppTheme.font(
                    size: 10.5,
                    weight: FontWeight.w800,
                    color: live ? AppColors.deep : AppColors.muteSoft,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: AppTheme.font(
                    size: 14,
                    weight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: live ? AppColors.ink : AppColors.muteSoft,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: AppTheme.font(size: 11.5, color: AppColors.mute),
                ),
              ],
            ),
          ),
          StatusPill(
            label: costLabel,
            background: redeemed
                ? AppColors.ink
                : afford
                ? AppColors.blush
                : AppColors.ink.withValues(alpha: 0.06),
            foreground: redeemed
                ? AppColors.cream
                : afford
                ? AppColors.deep
                : AppColors.muteSoft,
          ),
        ],
      ),
    );
  }
}

class _RecordCell extends StatelessWidget {
  const _RecordCell({required this.mark});

  final String mark;

  @override
  Widget build(BuildContext context) {
    final bg = switch (mark) {
      'W' => AppColors.coral,
      '?' => AppColors.blush,
      _ => AppColors.cream,
    };
    final fg = switch (mark) {
      'W' => AppColors.cream,
      '·' => AppColors.ink.withValues(alpha: 0.35),
      _ => AppColors.ink,
    };
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.record),
        border: Border.all(
          color: mark == '·' ? AppColors.line : AppColors.lineHeavy,
        ),
      ),
      child: Text(
        mark,
        style: AppTheme.font(size: 12, weight: FontWeight.w800, color: fg),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.item, this.featured = false});

  final Achievement item;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final earned = item.earned;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: featured
            ? AppColors.blush
            : earned
            ? AppColors.cream
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: featured
              ? AppColors.coralLine
              : earned
              ? AppColors.lineHeavy
              : AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.mark,
            style: AppTheme.font(
              size: featured ? 28 : 20,
              weight: FontWeight.w800,
              letterSpacing: -0.4,
              height: featured ? 1.0 : null,
              color: earned ? AppColors.ink : AppColors.muteSoft,
            ),
          ),
          const Spacer(),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.font(
              size: 11.5,
              weight: FontWeight.w800,
              height: 1.2,
              color: earned ? AppColors.ink : AppColors.muteSoft,
            ),
          ),
          Text(
            item.sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.font(
              size: 10,
              color: (earned ? AppColors.ink : AppColors.muteSoft).withValues(
                alpha: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
