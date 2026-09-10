import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import 'paper.dart';

class StreakChip extends StatelessWidget {
  const StreakChip({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return GestureDetector(
      key: const Key('top-streak'),
      onTap: () => showStreakSheet(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 7, 10, 7),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(color: AppColors.lineStrong),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 16,
                  color: state.streak > 0
                      ? AppColors.coral
                      : AppColors.muteSoft,
                ),
                if (!state.claimedToday)
                  const Positioned(
                    right: -2,
                    top: -1,
                    child: SizedBox(
                      width: 6,
                      height: 6,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.coral,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 5),
            Text(
              '${state.streak}',
              style: AppTheme.font(size: 13, weight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showStreakSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
    ),
    builder: (_) => const StreakSheet(),
  );
}

class StreakSheet extends StatelessWidget {
  const StreakSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final seed = state.seed;
    final next = seed.milestones
        .where((m) => state.streak < m.requiredDays)
        .firstOrNull;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lineHeavy,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.blush,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.coral,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.streak} day streak',
                      style: AppTheme.font(
                        size: 22,
                        weight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    Text(
                      next == null
                          ? state.goldLine()
                          : '${next.requiredDays - state.streak} to ${next.title}',
                      style: AppTheme.font(size: 12.5, color: AppColors.mute),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _todayLabel(DateTime.now()),
            style: AppTheme.font(size: 12.5, color: AppColors.mute),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final day in WeekDayDef.calendarWeek())
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _DayCell(day: day, claimed: state.claimedToday),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          PaperButton(
            label: state.claimedToday
                ? 'Checked in today'
                : 'Check in for today',
            trailing: '+${seed.checkInCoins}',
            primary: !state.claimedToday,
            onPressed: state.claimedToday ? null : state.checkIn,
          ),
          const SizedBox(height: 10),
          Text(
            'A check-in counts on a trading day. Miss one and the streak restarts at 1.',
            style: AppTheme.font(
              size: 11.5,
              color: AppColors.mute,
              height: 1.4,
            ),
          ),
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
    final on = !day.weekend && (day.past || (day.isToday && claimed));
    final todayOpen = !day.weekend && day.isToday && !claimed;
    return Column(
      children: [
        Container(
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on
                ? AppColors.coral
                : todayOpen
                ? AppColors.blush
                : day.weekend
                ? AppColors.sand
                : AppColors.cream,
            borderRadius: BorderRadius.circular(AppRadii.day),
            border: Border.all(
              color: on || todayOpen ? AppColors.coralLine : AppColors.line,
            ),
          ),
          child: Text(
            '${day.n}',
            style: AppTheme.font(
              size: 12.5,
              weight: FontWeight.w800,
              color: on
                  ? AppColors.cream
                  : day.weekend
                  ? AppColors.muteSoft
                  : AppColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(day.dow, style: AppTheme.font(size: 10, color: AppColors.mute)),
      ],
    );
  }
}

String _todayLabel(DateTime now) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
}
