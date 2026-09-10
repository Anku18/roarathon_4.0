import 'package:flutter_test/flutter_test.dart';

import 'package:roarathon_4/data/dummy/dummy.dart';
import 'package:roarathon_4/models/models.dart';
import 'package:roarathon_4/state/family_view.dart';
import 'package:roarathon_4/theme/formatters.dart';

void main() {
  FamilyView scope(String key) => FamilyView(DummyFamily.wealth, key);

  test('everyone matches the handoff totals', () {
    final v = scope(FamilyView.everyone);
    expect(formatInr(v.total), '₹37,13,210');
    expect(v.delta, 7410);
    expect(v.deltaPercent.toStringAsFixed(2), '0.20');
    expect(v.mix.map((m) => v.percentOf(m.$2)), [41, 53, 6]);
    expect(formatInr(v.depositTotal), '₹19,50,000');
    expect(formatInrShort(v.coverTotal), '₹1.65 Cr');
    expect(v.duePolicy?.name, 'Niva Bupa Senior First');
  });

  test('member totals agree with their deposit rows', () {
    for (final m in DummyFamily.wealth.members) {
      expect(scope(m.key).depositTotal, m.fd, reason: m.name);
    }
  });

  test('scoping to Anil', () {
    final v = scope('AM');
    expect(v.members.single.name, 'Anil Menon');
    expect(v.delta, -1350);
    expect(v.deposits, hasLength(2));
    expect(v.policies.map((p) => p.name), [
      'Star Health Family Optima',
      'Niva Bupa Senior First',
    ]);
    // Member bars are a share of the whole family, not the scope.
    expect((v.shareOfFamily(v.members.single) * 100).round(), 54);
  });

  test('Diya has no deposits or gold but keeps the floater', () {
    final v = scope('DM');
    expect(v.deposits, isEmpty);
    expect(v.mix.map((m) => m.$1), [AssetClass.market]);
    expect(v.policies.single.coversFamily, isTrue);
    expect(v.duePolicy, isNull);
    expect(v.nextRenewal?.name, 'Star Health Family Optima');
  });

  test('next renewal is the earliest in scope', () {
    expect(scope('RM').nextRenewal?.name, 'HDFC Life Click 2 Protect');
    expect(scope('PM').nextRenewal?.name, 'SBI Life eShield Next');
  });

  test('formatters', () {
    expect(formatInrShort(10000000), '₹1 Cr');
    expect(formatInrShort(15000000), '₹1.5 Cr');
    expect(formatInrShort(1000000), '₹10 L');
    expect(formatInrShort(750000), '₹7.5 L');
    expect(formatClock(DateTime(2026, 9, 10, 15, 31)), '3:31 PM');
    expect(formatClock(DateTime(2026, 9, 10, 0, 5)), '12:05 AM');
    expect(formatDayMonth(DateTime(2026, 9, 19)), '19 September');
  });
}
