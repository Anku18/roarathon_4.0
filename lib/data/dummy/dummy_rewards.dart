import '../../models/models.dart';

abstract final class DummyRewards {
  static const startingTicks = 2480;
  static const callRecordSummary = '18 of 26 · 69%';
  static const achievementsSummary = '7 of 20 earned';
  static const accuracyLabel = '69%';

  static const callRecord = <String>[
    'W',
    'W',
    'L',
    'W',
    'W',
    'W',
    'L',
    'W',
    'W',
    '·',
  ];

  static const shop = <ShopItem>[
    ShopItem(
      id: 's1',
      kicker: 'WEBINAR',
      title: 'Live webinar voucher',
      subtitle: 'Any Sharekhan Classroom session',
      cost: 300,
    ),
    ShopItem(
      id: 's2',
      kicker: 'CLASS',
      title: 'Basic class: Reading a chart',
      subtitle: '90 minutes, live with an analyst',
      cost: 600,
    ),
    ShopItem(
      id: 's3',
      kicker: 'BROKERAGE',
      title: '₹500 brokerage credit',
      subtitle: 'Applies to your next 30 days of orders',
      cost: 500,
    ),
    ShopItem(
      id: 's4',
      kicker: 'COURSE',
      title: '40% off Derivatives Masterclass',
      subtitle: 'Six weeks, certified',
      cost: 1500,
    ),
    ShopItem(
      id: 's5',
      kicker: 'COURSE',
      title: 'Full access · any premium course',
      subtitle: 'One course, your pick',
      cost: 4000,
    ),
  ];

  static const achievements = <Achievement>[
    Achievement(mark: '01', name: 'First Order', sub: 'Mar 2024', earned: true),
    Achievement(mark: '07', name: 'Week One', sub: 'Aug 2026', earned: true),
    Achievement(mark: 'SIP', name: 'Auto Pilot', sub: '6 months', earned: true),
    Achievement(mark: '↑↓', name: 'Called It', sub: '10 correct calls', earned: true),
    Achievement(mark: '×3', name: 'Diversified', sub: '3 sectors', earned: true),
    Achievement(mark: '@', name: 'Recruiter', sub: '4 of 5 funded', earned: true),
    Achievement(mark: '★', name: 'Classroom', sub: 'First class attended', earned: true),
    Achievement(mark: '7×', name: 'Analyst', sub: '7 calls in a row', earned: false),
    Achievement(mark: '30', name: 'Month Maker', sub: '18 days left', earned: false),
  ];
}
