import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/dummy/dummy.dart';
import '../models/models.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';

Future<void> showTradeSheet(BuildContext context, Holding item) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
    ),
    builder: (_) => _TradeSheet(item: item),
  );
}

class _TradeSheet extends StatefulWidget {
  const _TradeSheet({required this.item});

  final Holding item;

  @override
  State<_TradeSheet> createState() => _TradeSheetState();
}

class _TradeSheetState extends State<_TradeSheet> {
  String? _side;

  Future<void> _place(String side) async {
    if (_side != null) return;
    final state = AppScope.of(context);
    setState(() => _side = side);
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.pop(context);
    state.placeDummyTrade(symbol: widget.item.symbol, side: side);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final done = _side != null;
    final buy = _side == 'BUY';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lineHeavy,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (done) ...[
              Center(
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.62, end: 1),
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: buy
                              ? AppColors.gain.withValues(alpha: 0.12)
                              : AppColors.blush,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 32,
                          color: buy ? AppColors.gain : AppColors.coral,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${buy ? 'Buy' : 'Sell'} order placed',
                      style: AppTheme.font(
                        size: 20,
                        weight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.symbol} · +${DummyMarkets.tradeCoins} Shercoins',
                      style: AppTheme.font(size: 13.5, color: AppColors.mute),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                item.symbol,
                style: AppTheme.font(
                  size: 24,
                  weight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              Text(
                '${item.qtyLine}  ·  ${item.value}',
                style: AppTheme.font(size: 13, color: AppColors.mute),
              ),
              const SizedBox(height: 6),
              Text(
                item.change,
                style: AppTheme.font(
                  size: 14,
                  weight: FontWeight.w800,
                  color: AppColors.delta(item.up),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _SideButton(
                      label: 'Buy',
                      color: AppColors.gain,
                      onTap: () => _place('BUY'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SideButton(
                      label: 'Sell',
                      color: AppColors.loss,
                      onTap: () => _place('SELL'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.cream,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.font(
            size: 15,
            weight: FontWeight.w800,
            color: AppColors.cream,
          ),
        ),
      ),
    );
  }
}
