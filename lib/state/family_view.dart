import '../models/models.dart';

/// Everything the Family wealth screen shows, scoped to one member or to
/// [everyone]. Pure derivations over [FamilyWealth] so totals always agree
/// with the rows they summarise.
class FamilyView {
  const FamilyView(this.data, this.selectedKey);

  static const everyone = 'ALL';

  final FamilyWealth data;

  /// [everyone] or a [FamilyMember.key].
  final String selectedKey;

  bool get isEveryone => selectedKey == everyone;

  FamilyMember? get selected {
    for (final m in data.members) {
      if (m.key == selectedKey) return m;
    }
    return null;
  }

  List<FamilyMember> get members => isEveryone
      ? data.members
      : data.members.where((m) => m.key == selectedKey).toList();

  int get total => members.fold(0, (sum, m) => sum + m.total);
  int get delta => members.fold(0, (sum, m) => sum + m.delta);
  int get familyTotal => data.members.fold(0, (sum, m) => sum + m.total);

  /// Today's change as a percentage of the scoped total, unsigned.
  double get deltaPercent => total == 0 ? 0 : delta.abs() / total * 100;

  int amountIn(AssetClass asset) =>
      members.fold(0, (sum, m) => sum + m.amountIn(asset));

  /// Asset classes with a balance in scope, in display order. Zero-value
  /// classes are dropped so the split bar never draws an empty segment.
  List<(AssetClass, int)> get mix => [
        for (final asset in AssetClass.values)
          if (amountIn(asset) > 0) (asset, amountIn(asset)),
      ];

  /// Whole-number share of the scoped total.
  int percentOf(int amount) => total == 0 ? 0 : (amount / total * 100).round();

  /// Share of the whole family, not the scope — member bars stay comparable.
  double shareOfFamily(FamilyMember m) =>
      familyTotal == 0 ? 0 : m.total / familyTotal;

  List<FixedDeposit> get deposits => isEveryone
      ? data.deposits
      : data.deposits.where((d) => d.ownerKey == selectedKey).toList();

  int get depositTotal => deposits.fold(0, (sum, d) => sum + d.amount);

  /// A family floater shows in every scope.
  List<InsurancePolicy> get policies => data.policies
      .where((p) => isEveryone || p.ownerKey == selectedKey || p.coversFamily)
      .toList();

  int get coverTotal => policies.fold(0, (sum, p) => sum + p.cover);

  /// First policy in scope whose premium is due soon.
  InsurancePolicy? get duePolicy {
    for (final p in policies) {
      if (!p.isActive) return p;
    }
    return null;
  }

  /// Earliest upcoming renewal in scope, for the "nothing due" card.
  InsurancePolicy? get nextRenewal {
    InsurancePolicy? next;
    for (final p in policies) {
      if (p.renewsOn.isBefore(data.lastSyncedAt)) continue;
      if (next == null || p.renewsOn.isBefore(next.renewsOn)) next = p;
    }
    return next;
  }

  String ownerName(String key) {
    for (final m in data.members) {
      if (m.key == key) return m.name;
    }
    return key;
  }
}
