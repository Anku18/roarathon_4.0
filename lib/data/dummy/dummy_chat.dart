import '../../models/models.dart';
import 'dummy_streak.dart';

abstract final class DummyChat {
  static const greeting =
      'I’m Sher. Ask about Shercoins, the 8:45 call, streaks or referrals — I’ll answer from the dummy playbook.';

  static const suggestions = <String>[
    'How do Shercoins work?',
    'What is the 8:45 alert?',
    'How do I keep my streak?',
  ];

  static const replies = <CannedReply>[
    CannedReply(
      keywords: ['shercoin', 'coin', 'redeem', 'tick'],
      reply:
          'Shercoins are the season currency. Missions, check-ins and a correct 8:45 call add to the balance. Redeem them on You for classes, webinars or brokerage credit. Nothing here places an order.',
    ),
    CannedReply(
      keywords: ['8:45', '845', 'nifty', 'call', 'alert'],
      reply:
          'Every trading morning you call whether NIFTY 50 closes up or down. Locks at 9:15 AM, scores at the 3:30 PM close. Correct pays 50 Shercoins. Wrong costs nothing and is not advice.',
    ),
    CannedReply(
      keywords: ['streak', 'check in', 'check-in'],
      reply:
          'Tap the fire in the top bar to check in. Each trading-day check-in pays ${DummyStreak.checkInCoins} Shercoins. Week One at 7 days adds 100 more. Miss a day and the count restarts at 1. Gold tier unlocks at 14 days in a row.',
    ),
    CannedReply(
      keywords: ['refer', 'invite', 'friend', 'code'],
      reply:
          'Share code RM4K92. You both earn 500 Shercoins when your friend funds. Five funded referrals in a season unlocks the Recruiter badge and a free premium class.',
    ),
    CannedReply(
      keywords: ['mission', 'lesson', 'watchlist'],
      reply:
          'Today’s missions live on Home. Tick one off to add Shercoins instantly. You can untick it in this prototype — the coins come back off the balance.',
    ),
  ];

  static const fallback =
      'This is a dummy Sher. Try asking about Shercoins, the 8:45 NIFTY call, your streak, or referrals.';

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
