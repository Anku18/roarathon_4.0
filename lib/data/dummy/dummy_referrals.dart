import '../../models/models.dart';

abstract final class DummyReferrals {
  static const seasonLabel = 'SEPTEMBER SEASON · 21 DAYS LEFT';
  static const bountyCoins = 500;
  static const recruiterTarget = 5;

  static const invites = <Invite>[
    Invite(
      name: 'Sanjana K.',
      step: 'Account funded 4 Sep',
      status: InviteStatus.funded,
      coins: 500,
    ),
    Invite(
      name: 'Arjun T.',
      step: 'KYC submitted, funding pending',
      status: InviteStatus.pending,
    ),
    Invite(
      name: 'Priya N.',
       step: 'KYC submitted, funding pending',
      status: InviteStatus.pending,
    ),
  ];

  static const referralBoard = <LeaderboardRow>[
    LeaderboardRow(
      rank: '01',
      name: 'Ananya Rao',
      initials: 'AR',
      metric: '11 funded',
      coins: '5,500 coins',
      sub: 'Recruiter tier',
    ),
    LeaderboardRow(
      rank: '02',
      name: 'Kabir Shah',
      initials: 'KS',
      metric: '8 funded',
      coins: '4,000 coins',
      sub: 'Recruiter tier',
    ),
    LeaderboardRow(
      rank: '03',
      name: 'Meera Iyer',
      initials: 'MI',
      metric: '7 funded',
      coins: '3,500 coins',
      sub: 'Recruiter tier',
    ),
    LeaderboardRow(
      rank: '08',
      name: 'Devansh Patel',
      initials: 'DP',
      metric: '5 funded',
      coins: '2,500 coins',
      sub: 'Recruiter tier',
    ),
    LeaderboardRow(
      rank: '09',
      name: 'You',
      initials: 'RM',
      metric: '4 funded',
      coins: '2,000 coins',
      sub: '1 to Recruiter',
      isYou: true,
    ),
    LeaderboardRow(
      rank: '10',
      name: 'Nikhil Verma',
      initials: 'NV',
      metric: '4 funded',
      coins: '2,000 coins',
      sub: '1 to Recruiter',
    ),
  ];

  /// Coins = correct calls × 50, same payout as the 8:45 alert.
  static const accuracyBoard = <LeaderboardRow>[
    LeaderboardRow(
      rank: '01',
      name: 'Meera Iyer',
      initials: 'MI',
      metric: '84% · 50 calls',
      coins: '2,100 coins',
      sub: '42 correct · Since June',
    ),
    LeaderboardRow(
      rank: '02',
      name: 'streaksaint',
      initials: 'SS',
      metric: '81% · 96 calls',
      coins: '3,900 coins',
      sub: '78 correct · Since June',
    ),
    LeaderboardRow(
      rank: '03',
      name: 'Kabir Shah',
      initials: 'KS',
      metric: '77% · 39 calls',
      coins: '1,500 coins',
      sub: '30 correct · Since June',
    ),
    LeaderboardRow(
      rank: '07',
      name: 'You',
      initials: 'RM',
      metric: '69% · 26 calls',
      coins: '900 coins',
      sub: '18 correct · Since June',
      isYou: true,
    ),
    LeaderboardRow(
      rank: '08',
      name: 'Ananya Rao',
      initials: 'AR',
      metric: '68% · 50 calls',
      coins: '1,700 coins',
      sub: '34 correct · Since June',
    ),
    LeaderboardRow(
      rank: '09',
      name: 'chartwala',
      initials: 'CW',
      metric: '64% · 25 calls',
      coins: '800 coins',
      sub: '16 correct · Since June',
    ),
  ];
}
