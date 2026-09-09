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
      step: 'Invite opened, not signed up',
      status: InviteStatus.sent,
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
      sub: 'Recruiter tier',
      isYou: true,
    ),
    LeaderboardRow(
      rank: '10',
      name: 'Nikhil Verma',
      initials: 'NV',
      metric: '4 funded',
      coins: '2,000 coins',
      sub: 'Recruiter tier',
    ),
  ];

  static const accuracyBoard = <LeaderboardRow>[
    LeaderboardRow(
      rank: '01',
      name: 'Meera Iyer',
      initials: 'MI',
      metric: '84% · 42 calls',
      coins: '2,100 coins',
      sub: 'Since June',
    ),
    LeaderboardRow(
      rank: '02',
      name: 'streaksaint',
      initials: 'SS',
      metric: '81% · 96 calls',
      coins: '4,800 coins',
      sub: 'Since June',
    ),
    LeaderboardRow(
      rank: '03',
      name: 'Kabir Shah',
      initials: 'KS',
      metric: '77% · 38 calls',
      coins: '1,900 coins',
      sub: 'Since June',
    ),
    LeaderboardRow(
      rank: '07',
      name: 'You',
      initials: 'RM',
      metric: '69% · 26 calls',
      coins: '1,300 coins',
      sub: 'Since June',
      isYou: true,
    ),
    LeaderboardRow(
      rank: '08',
      name: 'Ananya Rao',
      initials: 'AR',
      metric: '68% · 51 calls',
      coins: '2,550 coins',
      sub: 'Since June',
    ),
    LeaderboardRow(
      rank: '09',
      name: 'chartwala',
      initials: 'CW',
      metric: '64% · 30 calls',
      coins: '1,500 coins',
      sub: 'Since June',
    ),
  ];
}
