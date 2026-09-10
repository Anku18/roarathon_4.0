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
      id: 's6',
      kicker: 'TRADE TIGER',
      title: 'Trade Tiger desktop, 30 days',
      subtitle: 'Full terminal: charts, option chain, and order blotter',
      cost: 1200,
    ),
    ShopItem(
      id: 's8',
      kicker: 'PATTERN FINDER',
      title: 'Pattern Finder, 7 days',
      subtitle: 'Scan charts for classic setups before the open',
      cost: 800,
    ),
    ShopItem(
      id: 's9',
      kicker: 'RESEARCH',
      title: 'Research calls, 30 days',
      subtitle: 'Desk notes and morning calls to your inbox',
      cost: 700,
    ),
    ShopItem(
      id: 's10',
      kicker: 'BROKERAGE',
      title: '10 trades, 2 trades off',
      subtitle: 'Place 10 delivery trades, the next 2 have ₹0 brokerage',
      cost: 400,
    ),

    ShopItem(
      id: 's4',
      kicker: 'COURSE',
      title: '40% off Derivatives Masterclass',
      subtitle: 'Six weeks, certified',
      cost: 1500,
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
