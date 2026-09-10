import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_scope.dart';
import '../state/family_view.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../theme/formatters.dart';
import '../widgets/net_bubble.dart';
import '../widgets/paper.dart';

/// Screen 4e — one family's holdings, deposits and insurance. A member chip
/// scopes every number on the screen to that person.
class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final view = state.family;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8, bottom: 190),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(data: view.data, online: state.isOnline),
          _MemberChips(view: view, onSelect: state.selectFamilyMember),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.topCenter,
              children: [...previous, ?current],
            ),
            child: _ScopedBody(
              key: ValueKey(view.selectedKey),
              view: view,
              onSelect: state.selectFamilyMember,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.data, required this.online});

  final FamilyWealth data;
  final bool online;

  @override
  Widget build(BuildContext context) {
    final synced = formatClock(data.lastSyncedAt);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Kicker('FAMILY · ${data.members.length} MEMBERS LINKED'),
                const SizedBox(height: 3),
                Text(
                  'Family wealth',
                  style: AppTheme.font(
                    size: 30,
                    weight: FontWeight.w800,
                    letterSpacing: -1.05,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  online
                      ? 'Holdings, deposits and cover in one place. Updated $synced.'
                      : 'No internet. Showing the last sync at $synced.',
                  style: AppTheme.font(size: 12.5, color: AppColors.mute),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Padding(padding: EdgeInsets.only(top: 6), child: NetBubble()),
        ],
      ),
    );
  }
}

class _MemberChips extends StatelessWidget {
  const _MemberChips({required this.view, required this.onSelect});

  final FamilyView view;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final members = view.data.members;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          _Chip(
            label: 'Everyone',
            initials: '${members.length}',
            selected: view.isEveryone,
            onTap: () => onSelect(FamilyView.everyone),
          ),
          for (final m in members) ...[
            const SizedBox(width: 8),
            _Chip(
              label: m.firstName,
              initials: m.key,
              selected: view.selectedKey == m.key,
              onTap: () => onSelect(m.key),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.initials,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String initials;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: BorderSide(color: selected ? AppColors.ink : AppColors.line),
    );
    return Material(
      color: selected ? AppColors.ink : AppColors.cream,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(9, 8, 14, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.coral : AppColors.chipIdle,
                  ),
                  child: Text(
                    initials,
                    style: AppTheme.font(
                      size: 10.5,
                      weight: FontWeight.w800,
                      color: selected ? AppColors.cream : AppColors.muteStrong,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTheme.font(
                    size: 12.5,
                    weight: FontWeight.w800,
                    color: selected ? AppColors.cream : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Everything below the chips; keyed by scope so the swap cross-fades.
class _ScopedBody extends StatelessWidget {
  const _ScopedBody({super.key, required this.view, required this.onSelect});

  final FamilyView view;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final first = view.selected?.firstName;
    final deposits = view.deposits;
    final policies = view.policies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroCard(view: view),
        _Section(
          'Who holds what',
          trailing: first == null ? 'Tap to scope' : 'Showing $first only',
        ),
        _RowList(
          bottom: 16,
          children: [
            for (final m in view.members)
              _MemberRow(
                member: m,
                share: view.shareOfFamily(m),
                selected: view.selectedKey == m.key,
                onTap: () => onSelect(
                  view.selectedKey == m.key ? FamilyView.everyone : m.key,
                ),
              ),
          ],
        ),
        _Section(
          'Fixed deposits',
          trailing: deposits.isEmpty
              ? 'None yet'
              : '${deposits.length} ${deposits.length == 1 ? 'deposit' : 'deposits'}'
                  ' · ${formatInr(view.depositTotal)}',
        ),
        _RowList(
          bottom: 8,
          children: [
            if (deposits.isEmpty) _DashedNote(_noDepositsLine(view.selected)),
            for (final d in deposits)
              _DepositRow(deposit: d, owner: view.ownerName(d.ownerKey)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          child: deposits.isEmpty
              ? null
              : Text(
                  view.isEveryone
                      ? view.data.interestNote
                      : 'Rates are locked for the full term. Breaking a deposit '
                          'early costs 1% of the interest earned.',
                  style: AppTheme.font(
                    size: 11.5,
                    color: AppColors.mute,
                    height: 1.5,
                  ),
                ),
        ),
        _Section(
          'Insurance',
          trailing: policies.isEmpty
              ? 'None yet'
              : '${formatInrShort(view.coverTotal)} total cover',
        ),
        _RowList(
          bottom: 12,
          children: [
            if (policies.isEmpty)
              _DashedNote(
                first == null
                    ? 'No policies linked yet.'
                    : 'No policies in $first’s name.',
              ),
            for (final p in policies) _PolicyRow(policy: p),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _PremiumAlert(view: view),
        ),
      ],
    );
  }

  static String _noDepositsLine(FamilyMember? member) {
    if (member == null) return 'No deposits linked yet.';
    final line = 'No deposits in ${member.firstName}’s name.';
    return member.minor
        ? '$line A minor account can hold a deposit with a guardian as joint holder.'
        : line;
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, {required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
      child: SectionHeader(title, trailing: trailing),
    );
  }
}

class _RowList extends StatelessWidget {
  const _RowList({required this.bottom, required this.children});

  final double bottom;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 9),
            children[i],
          ],
        ],
      ),
    );
  }
}

Color _assetColor(AssetClass asset) => switch (asset) {
      AssetClass.market => AppColors.coral,
      AssetClass.fd => AppColors.ink,
      AssetClass.gold => AppColors.gold,
    };

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.view});

  final FamilyView view;

  @override
  Widget build(BuildContext context) {
    final first = view.selected?.firstName;
    final up = view.delta >= 0;
    final mix = view.mix;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: PaperCard(
        radius: AppRadii.cardXl,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Kicker(
              first == null
                  ? 'FAMILY NET WORTH'
                  : "${first.toUpperCase()}'S NET WORTH",
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formatInr(view.total),
                style: AppTheme.font(
                  size: 42,
                  weight: FontWeight.w800,
                  letterSpacing: -1.68,
                  height: 1.05,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // A loss gets the neutral treatment, not the gain pink.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
              decoration: BoxDecoration(
                color: up ? AppColors.blush : AppColors.lossFill,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Text(
                '${up ? '↑' : '↓'} ${formatInr(view.delta.abs())}'
                ' · ${view.deltaPercent.toStringAsFixed(2)}% today',
                style: AppTheme.font(
                  size: 13,
                  weight: FontWeight.w800,
                  color: up ? AppColors.deep : AppColors.muteStrong,
                ),
              ),
            ),
            if (mix.isNotEmpty) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  for (var i = 0; i < mix.length; i++) ...[
                    if (i > 0) const SizedBox(width: 3),
                    Expanded(
                      flex: mix[i].$2,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: _assetColor(mix[i].$1),
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < mix.length; i++) ...[
                if (i > 0) const SizedBox(height: 9),
                _LegendRow(
                  asset: mix[i].$1,
                  amount: mix[i].$2,
                  percent: view.percentOf(mix[i].$2),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.asset,
    required this.amount,
    required this.percent,
  });

  final AssetClass asset;
  final int amount;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _assetColor(asset),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(asset.label, style: AppTheme.font(size: 12.5)),
        ),
        const SizedBox(width: 9),
        Text(
          formatInr(amount),
          style: AppTheme.font(size: 12.5, weight: FontWeight.w800),
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 38,
          child: Text(
            '$percent%',
            textAlign: TextAlign.right,
            style: AppTheme.font(size: 11.5, color: AppColors.muteSoft),
          ),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.share,
    required this.selected,
    required this.onTap,
  });

  final FamilyMember member;

  /// Fraction of the whole family's total, 0–1.
  final double share;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      radius: AppRadii.card,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: selected ? AppColors.blush : AppColors.cream,
      borderColor: selected ? AppColors.coralLine : AppColors.line,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.coral : AppColors.ink,
              ),
              child: Text(
                member.key,
                style: AppTheme.font(
                  size: 12.5,
                  weight: FontWeight.w800,
                  color: AppColors.cream,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: AppTheme.font(
                      size: 14,
                      weight: FontWeight.w800,
                      letterSpacing: -0.21,
                    ),
                  ),
                  Text(
                    member.role,
                    style: AppTheme.font(size: 11, color: AppColors.mute),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 5,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppColors.track,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: share.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.coral,
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatInr(member.total),
                  style: AppTheme.font(size: 14, weight: FontWeight.w800),
                ),
                Text(
                  '${(share * 100).round()}% of family',
                  style: AppTheme.font(size: 11, color: AppColors.muteSoft),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DepositRow extends StatelessWidget {
  const _DepositRow({required this.deposit, required this.owner});

  final FixedDeposit deposit;
  final String owner;

  @override
  Widget build(BuildContext context) {
    final soon = deposit.maturesSoon;
    return PaperCard(
      radius: AppRadii.card,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deposit.bank,
                      style: AppTheme.font(
                        size: 14,
                        weight: FontWeight.w800,
                        letterSpacing: -0.21,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      owner,
                      style: AppTheme.font(size: 11, color: AppColors.mute),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatInr(deposit.amount),
                    style: AppTheme.font(
                      size: 15,
                      weight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    '${deposit.rate} p.a.',
                    style: AppTheme.font(
                      size: 11,
                      weight: FontWeight.w800,
                      color: AppColors.deep,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatusPill(
                label: deposit.tag,
                background: soon ? AppColors.coral : AppColors.blush,
                foreground: soon ? AppColors.cream : AppColors.deep,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  deposit.matures,
                  style: AppTheme.font(size: 11.5, color: AppColors.mute),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.policy});

  final InsurancePolicy policy;

  @override
  Widget build(BuildContext context) {
    final due = !policy.isActive;
    return PaperCard(
      radius: AppRadii.card,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      borderColor: due ? AppColors.coralAlert : AppColors.line,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policy.kind,
                      style: AppTheme.font(
                        size: 10.5,
                        weight: FontWeight.w800,
                        color: AppColors.deep,
                        letterSpacing: 0.84,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      policy.name,
                      style: AppTheme.font(
                        size: 14,
                        weight: FontWeight.w800,
                        letterSpacing: -0.21,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      policy.who,
                      style: AppTheme.font(size: 11, color: AppColors.mute),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatInrShort(policy.cover),
                    style: AppTheme.font(
                      size: 15,
                      weight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'cover',
                    style: AppTheme.font(size: 11, color: AppColors.muteSoft),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatusPill(
                label: policy.tag,
                background: due ? AppColors.coral : AppColors.tagNeutral,
                foreground: due ? AppColors.cream : AppColors.muteStrong,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  policy.premium,
                  style: AppTheme.font(size: 11.5, color: AppColors.mute),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumAlert extends StatelessWidget {
  const _PremiumAlert({required this.view});

  final FamilyView view;

  @override
  Widget build(BuildContext context) {
    final due = view.duePolicy;
    final next = view.nextRenewal;
    final String title;
    final String body;
    final String cta;
    if (due != null) {
      final amount = formatInr(due.annualPremium);
      title = '${due.name} renews ${formatDayMonth(due.renewsOn)}';
      body = [
        '$amount for the year.',
        if (due.lapseNote != null) due.lapseNote!,
      ].join(' ');
      cta = 'Pay $amount';
    } else {
      title = 'Nothing due in the next 30 days';
      body = next == null
          ? 'No renewals are coming up.'
          : 'The next premium is the ${next.name} renewal on '
              '${formatDayMonth(next.renewsOn)}, '
              '${formatInr(next.annualPremium)} for the year.';
      cta = 'See the calendar';
    }

    return PaperCard(
      radius: AppRadii.cardLg,
      color: AppColors.blush,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREMIUM DUE',
            style: AppTheme.font(
              size: 11,
              weight: FontWeight.w800,
              color: AppColors.deep,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: AppTheme.font(
              size: 19,
              weight: FontWeight.w800,
              letterSpacing: -0.57,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppTheme.font(
              size: 12.5,
              color: AppColors.muteStrong,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              _PillButton(
                label: cta,
                primary: true,
                onPressed: () => _notWiredYet(context, cta),
              ),
              _PillButton(
                label: 'Remind me',
                primary: false,
                onPressed: () => _notWiredYet(context, 'Remind me'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Destinations for Pay / Remind me / See the calendar are still a product
  // decision; say so instead of silently doing nothing.
  static void _notWiredYet(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          '“$action” isn’t connected yet.',
          style: AppTheme.font(
            size: 13.5,
            weight: FontWeight.w700,
            color: AppColors.cream,
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.primary,
    required this.onPressed,
  });

  final String label;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: primary
          ? BorderSide.none
          : const BorderSide(color: AppColors.lineHeavy),
    );
    return Material(
      color: primary ? AppColors.coral : Colors.transparent,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: SizedBox(
          height: 46,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: AppTheme.font(
                  size: 13.5,
                  weight: FontWeight.w800,
                  color: primary ? AppColors.cream : AppColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty-state card with a 1px dashed outline.
class _DashedNote extends StatelessWidget {
  const _DashedNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const _DashedRRectPainter(
        color: AppColors.lineDashed,
        radius: AppRadii.card,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Text(
          text,
          style: AppTheme.font(size: 12.5, color: AppColors.mute, height: 1.5),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const _dash = 4.0;
  static const _gap = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.5),
          Radius.circular(radius),
        ),
      );
    for (final metric in outline.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += _dash + _gap) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + _dash, metric.length)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}
