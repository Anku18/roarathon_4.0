import '../../models/models.dart';

/// Family wealth (screen 4e) for the Rohit prototype user. Swap for the
/// family API response; keep it around to check the arithmetic.
abstract final class DummyFamily {
  static final wealth = FamilyWealth(
    lastSyncedAt: DateTime(2026, 9, 10, 15, 31),
    interestNote:
        'Interest of ₹1,38,700 accrues across these deposits this year. '
        'Two sit on senior-citizen rates and renew automatically unless you stop them.',
    members: const [
      FamilyMember(
        key: 'RM',
        name: 'Rohit Menon',
        role: 'You · Gold tier',
        market: 482310,
        fd: 250000,
        gold: 0,
        delta: 6240,
      ),
      FamilyMember(
        key: 'PM',
        name: 'Priya Menon',
        role: 'Spouse · joint holder',
        market: 314600,
        fd: 500000,
        gold: 92000,
        delta: 2180,
      ),
      FamilyMember(
        key: 'AM',
        name: 'Anil Menon',
        role: 'Father · senior citizen',
        market: 642900,
        fd: 1200000,
        gold: 145000,
        delta: -1350,
      ),
      FamilyMember(
        key: 'DM',
        name: 'Diya Menon',
        role: 'Daughter · minor account',
        market: 86400,
        fd: 0,
        gold: 0,
        delta: 340,
        minor: true,
      ),
    ],
    deposits: const [
      FixedDeposit(
        ownerKey: 'RM',
        bank: 'HDFC Bank · 5-year',
        amount: 250000,
        rate: '7.10%',
        matures: 'Matures 14 Mar 2027',
        tag: '18 MONTHS LEFT',
      ),
      FixedDeposit(
        ownerKey: 'PM',
        bank: 'State Bank of India',
        amount: 500000,
        rate: '6.80%',
        matures: 'Matures 2 Nov 2026',
        tag: 'MATURES SOON',
      ),
      FixedDeposit(
        ownerKey: 'AM',
        bank: 'Bank of Baroda · senior',
        amount: 800000,
        rate: '7.35%',
        matures: 'Matures 21 Jan 2028',
        tag: 'BEST RATE',
      ),
      FixedDeposit(
        ownerKey: 'AM',
        bank: 'Post Office term deposit',
        amount: 400000,
        rate: '7.10%',
        matures: 'Matures 9 Jun 2027',
        tag: 'AUTO-RENEW',
      ),
    ],
    policies: [
      InsurancePolicy(
        ownerKey: 'RM',
        kind: 'TERM LIFE',
        name: 'HDFC Life Click 2 Protect',
        who: 'Rohit Menon · cover till 2054',
        cover: 10000000,
        premium: '₹14,200 a year · due 12 Oct',
        tag: 'ACTIVE',
        annualPremium: 14200,
        renewsOn: DateTime(2026, 10, 12),
      ),
      InsurancePolicy(
        ownerKey: InsurancePolicy.familyOwner,
        kind: 'HEALTH · FLOATER',
        name: 'Star Health Family Optima',
        who: 'Covers all four members',
        cover: 1000000,
        premium: '₹28,400 a year · due 3 Feb',
        tag: 'ACTIVE',
        annualPremium: 28400,
        renewsOn: DateTime(2027, 2, 3),
      ),
      InsurancePolicy(
        ownerKey: 'PM',
        kind: 'TERM LIFE',
        name: 'SBI Life eShield Next',
        who: 'Priya Menon · cover till 2049',
        cover: 5000000,
        premium: '₹9,800 a year · due 28 Nov',
        tag: 'ACTIVE',
        annualPremium: 9800,
        renewsOn: DateTime(2026, 11, 28),
      ),
      InsurancePolicy(
        ownerKey: 'AM',
        kind: 'HEALTH · SENIOR',
        name: 'Niva Bupa Senior First',
        who: 'Anil Menon · no waiting period left',
        cover: 500000,
        premium: '₹41,300 a year · due 19 Sep',
        tag: 'DUE IN 9 DAYS',
        annualPremium: 41300,
        renewsOn: DateTime(2026, 9, 19),
        lapseNote:
            'Anil’s cover lapses if the premium misses the date, and the '
            'no-waiting-period benefit restarts from scratch.',
      ),
    ],
  );
}
