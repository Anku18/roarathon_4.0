import '../../models/models.dart';
import 'dummy_streak.dart';

abstract final class DummyChat {
  static const greeting =
      'I’m Sher. Ask about Sherpoints, the pre-market quiz, streaks or referrals — I’ll answer from the dummy playbook.';

  static const suggestions = <String>[
    'How do Sherpoints work?',
    'What is the pre-market quiz?',
    'How do I keep my streak?',
  ];

  static const replies = <CannedReply>[
    CannedReply(
      keywords: ['sherpoint', 'shercoin', 'point', 'coin', 'redeem', 'tick'],
      reply:
          'Sherpoints are the season currency. Missions, check-ins and a correct pre-market quiz add to the balance. Redeem them on You for classes, webinars or brokerage credit. Nothing here places an order.',
    ),
    CannedReply(
      keywords: ['8:45', '845', 'nifty', 'call', 'alert', 'quiz', 'pre-market'],
      reply:
          'Every trading morning the pre-market quiz asks whether NIFTY 50 closes up or down. Locks at 9:15 AM, scores at the 3:30 PM close. Right answer pays 50 Sherpoints. Wrong costs nothing and is not advice.',
    ),
    CannedReply(
      keywords: ['streak', 'check in', 'check-in'],
      reply:
          'Tap the fire in the top bar to check in. Each trading-day check-in pays ${DummyStreak.checkInCoins} Sherpoints. Week One at 7 days adds 100 more. Miss a day and the count restarts at 1. Gold tier unlocks at 14 days in a row.',
    ),
    CannedReply(
      keywords: ['refer', 'invite', 'friend', 'code'],
      reply:
          'Share code RM4K92. You both earn 500 Sherpoints when your friend funds. Five funded referrals in a season unlocks the Recruiter badge and a free premium class.',
    ),
    CannedReply(
      keywords: ['mission', 'lesson', 'watchlist'],
      reply:
          'Today’s missions live on Home. Tick one off to add Sherpoints instantly. You can untick it in this prototype — the points come back off the balance.',
    ),
  ];

  static const fallback =
      'This is a dummy Sher. Try asking about Sherpoints, the pre-market quiz, your streak, or referrals.';

  static String replyFor(String message) {
    final q = message.toLowerCase();
    for (final canned in replies) {
      for (final keyword in canned.keywords) {
        if (q.contains(keyword)) return canned.reply;
      }
    }
    return fallback;
  }
}
