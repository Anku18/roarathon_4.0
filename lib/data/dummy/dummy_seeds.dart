import '../../models/models.dart';
import 'dummy_chat.dart';
import 'dummy_home.dart';
import 'dummy_markets.dart';
import 'dummy_referrals.dart';
import 'dummy_rewards.dart';
import 'dummy_streak.dart';

/// Assembled dummy worlds. Add a new seed here when you add a login.
abstract final class DummySeeds {
  static const rohit = DummySeed(
    profile: UserProfile(
      clientId: 'RM4K92',
      name: 'Rohit Menon',
      initials: 'RM',
      tier: 'Gold',
      referralCode: 'RM4K92',
      fundedReferrals: 4,
      pendingReferrals: 1,
      referralRank: 9,
    ),
    ticks: DummyRewards.startingTicks,
    streak: DummyStreak.startingStreak,
    claimedToday: false,
    portfolio: DummyHome.portfolio,
    dailyCall: DummyHome.dailyCall,
    missions: DummyHome.missions,
    week: DummyStreak.week,
    milestones: DummyStreak.milestones,
    checkInCoins: DummyStreak.checkInCoins,
    seasonLabel: DummyReferrals.seasonLabel,
    referralBoard: DummyReferrals.referralBoard,
    accuracyBoard: DummyReferrals.accuracyBoard,
    invites: DummyReferrals.invites,
    shop: DummyRewards.shop,
    achievements: DummyRewards.achievements,
    callRecord: DummyRewards.callRecord,
    callRecordSummary: DummyRewards.callRecordSummary,
    achievementsSummary: DummyRewards.achievementsSummary,
    indices: DummyMarkets.indices,
    watchlist: DummyMarkets.watchlist,
    chatGreeting: DummyChat.greeting,
    chatSuggestions: DummyChat.suggestions,
    cannedReplies: DummyChat.replies,
    fallbackReply: DummyChat.fallback,
  );

  static DummySeed byId(String seedId) {
    switch (seedId) {
      case 'rohit':
        return rohit;
      default:
        return rohit;
    }
  }
}
