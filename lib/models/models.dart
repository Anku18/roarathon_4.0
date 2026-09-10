class DummyAccount {
  const DummyAccount({
    required this.clientId,
    required this.password,
    required this.seedId,
  });

  final String clientId;
  final String password;

  /// Key into [DummySeeds] — swap this to point a login at another dataset.
  final String seedId;
}

class UserProfile {
  const UserProfile({
    required this.clientId,
    required this.name,
    required this.initials,
    required this.tier,
    required this.referralCode,
    required this.fundedReferrals,
    required this.pendingReferrals,
    required this.referralRank,
  });

  final String clientId;
  final String name;
  final String initials;
  final String tier;
  final String referralCode;
  final int fundedReferrals;
  final int pendingReferrals;
  final int referralRank;
}

class PortfolioSnapshot {
  const PortfolioSnapshot({
    required this.totalValueLabel,
    required this.todayChangeLabel,
    required this.todayUp,
  });

  final String totalValueLabel;
  final String todayChangeLabel;
  final bool todayUp;
}

class DailyCall {
  const DailyCall({
    required this.question,
    required this.subtitle,
    required this.upCrowdPercent,
    required this.downCrowdPercent,
    required this.payCorrect,
  });

  final String question;
  final String subtitle;
  final int upCrowdPercent;
  final int downCrowdPercent;
  final int payCorrect;
}

class MissionDef {
  const MissionDef({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.points,
    this.doneByDefault = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final int points;
  final bool doneByDefault;
}

class StreakMilestone {
  const StreakMilestone({
    required this.dayLabel,
    required this.title,
    required this.subtitle,
    required this.requiredDays,
  });

  final String dayLabel;
  final String title;
  final String subtitle;
  final int requiredDays;
}

class WeekDayDef {
  const WeekDayDef({
    required this.dow,
    required this.n,
    required this.past,
    required this.isToday,
  });

  final String dow;
  final int n;
  final bool past;
  final bool isToday;
}

class LeaderboardRow {
  const LeaderboardRow({
    required this.rank,
    required this.name,
    required this.initials,
    required this.metric,
    required this.coins,
    required this.sub,
    this.isYou = false,
  });

  final String rank;
  final String name;
  final String initials;
  final String metric;
  final String coins;
  final String sub;
  final bool isYou;
}

enum InviteStatus { funded, pending, sent }

class Invite {
  const Invite({
    required this.name,
    required this.step,
    required this.status,
    this.coins,
  });

  final String name;
  final String step;
  final InviteStatus status;
  final int? coins;
}

class ShopItem {
  const ShopItem({
    required this.id,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.cost,
  });

  final String id;
  final String kicker;
  final String title;
  final String subtitle;
  final int cost;
}

class Achievement {
  const Achievement({
    required this.mark,
    required this.name,
    required this.sub,
    required this.earned,
  });

  final String mark;
  final String name;
  final String sub;
  final bool earned;
}

class Holding {
  const Holding({
    required this.symbol,
    required this.qtyLine,
    required this.value,
    required this.change,
    required this.up,
  });

  final String symbol;
  final String qtyLine;
  final String value;
  final String change;
  final bool up;
}

class IndexTick {
  const IndexTick({
    required this.name,
    required this.value,
    required this.change,
    required this.changePts,
    required this.high,
    required this.low,
    required this.up,
  });

  final String name;
  final String value;
  final String change;
  final String changePts;
  final String high;
  final String low;
  final bool up;
}

class ChatTurn {
  const ChatTurn({required this.fromUser, required this.text});

  final bool fromUser;
  final String text;
}

class CannedReply {
  const CannedReply({required this.keywords, required this.reply});

  final List<String> keywords;
  final String reply;
}

/// Immutable snapshot used to seed [AppState] after login.
class DummySeed {
  const DummySeed({
    required this.profile,
    required this.ticks,
    required this.streak,
    required this.claimedToday,
    required this.portfolio,
    required this.dailyCall,
    required this.missions,
    required this.week,
    required this.milestones,
    required this.checkInCoins,
    required this.seasonLabel,
    required this.referralBoard,
    required this.accuracyBoard,
    required this.invites,
    required this.shop,
    required this.achievements,
    required this.callRecord,
    required this.callRecordSummary,
    required this.achievementsSummary,
    required this.indices,
    required this.watchlist,
    required this.chatGreeting,
    required this.chatSuggestions,
    required this.cannedReplies,
    required this.fallbackReply,
  });

  final UserProfile profile;
  final int ticks;
  final int streak;
  final bool claimedToday;
  final PortfolioSnapshot portfolio;
  final DailyCall dailyCall;
  final List<MissionDef> missions;
  final List<WeekDayDef> week;
  final List<StreakMilestone> milestones;
  final int checkInCoins;
  final String seasonLabel;
  final List<LeaderboardRow> referralBoard;
  final List<LeaderboardRow> accuracyBoard;
  final List<Invite> invites;
  final List<ShopItem> shop;
  final List<Achievement> achievements;
  final List<String> callRecord;
  final String callRecordSummary;
  final String achievementsSummary;
  final List<IndexTick> indices;
  final List<Holding> watchlist;
  final String chatGreeting;
  final List<String> chatSuggestions;
  final List<CannedReply> cannedReplies;
  final String fallbackReply;
}
