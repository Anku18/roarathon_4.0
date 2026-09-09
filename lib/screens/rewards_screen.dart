import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../widgets/paper.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final seed = state.seed;

    return ScreenPad(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
            child: Text(
              'Your streak',
              style: AppTheme.font(
                size: 18,
                weight: FontWeight.w800,
                letterSpacing: -0.45,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.coral,
              borderRadius: BorderRadius.circular(AppRadii.cardXl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAYS IN A ROW',
                  style: AppTheme.font(
                    size: 11.5,
                    weight: FontWeight.w700,
                    color: AppColors.cream,
                    letterSpacing: 1.4,
                  ),
                ),
                Text(
                  '${state.streak}',
                  style: AppTheme.font(
                    size: 76,
                    weight: FontWeight.w800,
                    color: AppColors.cream,
                    letterSpacing: -3.5,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 270),
                  child: Text(
                    'A check-in counts when you open the app on a trading day. Miss one and it restarts at 1.',
                    style: AppTheme.font(
                      size: 13,
                      color: AppColors.cream,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (final day in seed.week)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: _DayCell(
                            day: day,
                            claimed: state.claimedToday,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PaperButton(
            label: state.claimedToday ? 'Checked in today' : 'Check in for today',
            trailing: state.claimedToday ? '+${seed.checkInCoins} coins' : '+${seed.checkInCoins}',
            primary: !state.claimedToday,
            onPressed: state.checkIn,
            height: 58,
          ),
          const SizedBox(height: 18),
          const SectionHeader('Milestones'),
          for (var i = 0; i < seed.milestones.length; i++) ...[
            _MilestoneTile(
              item: seed.milestones[i],
              streak: state.streak,
            ),
            if (i != seed.milestones.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.claimed});

  final WeekDayDef day;
  final bool claimed;

  @override
  Widget build(BuildContext context) {
    final on = day.past || (day.isToday && claimed);
    final todayOpen = day.isToday && !claimed;
    return Column(
      children: [
        Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on
                ? AppColors.cream
                : todayOpen
                    ? AppColors.cream.withValues(alpha: 0.28)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.day),
            border: Border.all(
              color: on || todayOpen ? Colors.transparent : AppColors.cream.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            '${day.n}',
            style: AppTheme.font(
              size: 13,
              weight: FontWeight.w800,
              color: on ? AppColors.ink : AppColors.cream,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day.dow,
          style: AppTheme.font(size: 10, color: AppColors.cream),
        ),
      ],
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.item, required this.streak});

  final StreakMilestone item;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final done = streak >= item.requiredDays;
    final locked = item.requiredDays >= 90 && !done;
    final left = item.requiredDays - streak;
    final tag = done
        ? 'Done'
        : locked
            ? 'Locked'
            : '$left to go';

    return PaperCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done
                  ? AppColors.coral
                  : locked
                      ? AppColors.ink.withValues(alpha: 0.06)
                      : AppColors.blush,
            ),
            child: Text(
              item.dayLabel,
              style: AppTheme.font(
                size: 14,
                weight: FontWeight.w800,
                color: done
                    ? AppColors.cream
                    : locked
                        ? AppColors.muteSoft
                        : AppColors.deep,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTheme.font(
                    size: 14,
                    weight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: locked ? AppColors.muteSoft : AppColors.ink,
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
            label: tag,
            background: done
                ? AppColors.ink
                : locked
                    ? Colors.transparent
                    : AppColors.blush,
            foreground: done
                ? AppColors.cream
                : locked
                    ? AppColors.muteSoft
                    : AppColors.deep,
          ),
        ],
      ),
    );
  }
}
