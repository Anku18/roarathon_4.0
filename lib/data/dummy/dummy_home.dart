import '../../models/models.dart';

/// Home / portfolio / pre-market quiz / missions for the Rohit prototype user.
abstract final class DummyHome {
  static const portfolio = PortfolioSnapshot(
    totalValueLabel: '₹4,82,310',
    todayChangeLabel: '↑ ₹6,240 · 1.31% today',
    todayUp: true,
  );

  static const dailyCall = DailyCall(
    question: 'Will NIFTY 50 close up or down today?',
    subtitle: 'Question 1 of 1 · Answer before 9:15 AM',
    payCorrect: 50,
  );

  static const missions = <MissionDef>[
    MissionDef(
      id: 'watchlist',
      title: 'Review your watchlist',
      subtitle: '6 stocks moved more than 2% today',
      points: 30,
    ),
    MissionDef(
      id: 'sip_lesson',
      title: 'Finish the lesson “What an SIP actually does”',
      subtitle: '3 min · Learn',
      points: 60,
    ),
    MissionDef(
      id: 'price_alert',
      title: 'Set one price alert',
      subtitle: 'Alerts bring you back on the right day',
      points: 25,
      doneByDefault: true,
    ),
  ];
}
