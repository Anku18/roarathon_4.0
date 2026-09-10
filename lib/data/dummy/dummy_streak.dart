import '../../models/models.dart';

abstract final class DummyStreak {
  static const checkInCoins = 40;
  static const startingStreak = 12;

  static const week = <WeekDayDef>[
    WeekDayDef(dow: 'M', n: 8, past: true, isToday: false),
    WeekDayDef(dow: 'T', n: 9, past: true, isToday: false),
    WeekDayDef(dow: 'W', n: 10, past: true, isToday: false),
    WeekDayDef(dow: 'T', n: 11, past: true, isToday: false),
    WeekDayDef(dow: 'F', n: 12, past: false, isToday: true),
    WeekDayDef(dow: 'M', n: 15, past: false, isToday: false),
    WeekDayDef(dow: 'T', n: 16, past: false, isToday: false),
  ];

  static const milestones = <StreakMilestone>[
    StreakMilestone(
      dayLabel: '07',
      title: 'Week One',
      subtitle: '100 Shercoins + Consistent badge',
      requiredDays: 7,
      bonusCoins: 100,
    ),
    StreakMilestone(
      dayLabel: '14',
      title: 'Gold tier',
      subtitle: '₹0 brokerage on your next 5 delivery orders',
      requiredDays: 14,
    ),
    StreakMilestone(
      dayLabel: '30',
      title: 'Month Maker',
      subtitle: '750 Shercoins + priority support',
      requiredDays: 30,
      bonusCoins: 750,
    ),
    StreakMilestone(
      dayLabel: '90',
      title: 'Quarter Club',
      subtitle: '2,500 Shercoins + fee-free SIP for a year',
      requiredDays: 90,
      bonusCoins: 2500,
    ),
  ];
}
