import 'dart:async';

import 'package:flutter/material.dart';

import '../data/dummy/dummy.dart';
import '../models/models.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../widgets/coins_pill.dart';
import '../widgets/net_bubble.dart';
import '../widgets/paper.dart';
import '../widgets/streak_sheet.dart';
import '../widgets/trade_sheet.dart';
import 'ask_sher_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Stack(
      children: [
        ScreenPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Investo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.font(
                          size: 18,
                          weight: FontWeight.w800,
                          letterSpacing: -0.45,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const StreakChip(),
                    const SizedBox(width: 6),
                    // ── Notification bell ──
                    GestureDetector(
                      onTap: () => showNotificationsSheet(context),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.lineStrong),
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              size: 18,
                              color: AppColors.ink,
                            ),
                          ),
                          if (state.unreadCount > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.coral,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  state.unreadCount > 9
                                      ? '9+'
                                      : '${state.unreadCount}',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.font(
                                    size: 9,
                                    weight: FontWeight.w800,
                                    color: AppColors.cream,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    CoinsPill(ticks: state.ticks),
                    const SizedBox(width: 4),
                    const NetBubble(),
                  ],
                ),
              ),
              _DailyCallPanel(),
              const _HomeMarketBoard(),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 100,
          child: Material(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AskSherScreen()),
                );
              },
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: AppColors.cream,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ask Sher',
                      style: AppTheme.font(
                        size: 12.5,
                        weight: FontWeight.w800,
                        color: AppColors.cream,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeMarketBoard extends StatefulWidget {
  const _HomeMarketBoard();

  @override
  State<_HomeMarketBoard> createState() => _HomeMarketBoardState();
}

class _HomeMarketBoardState extends State<_HomeMarketBoard> {
  bool _indices = true;
  final _feed = DummyMarketFeed();
  Timer? _timer;

  bool get _inWidgetTest => WidgetsBinding.instance.runtimeType
      .toString()
      .contains('TestWidgetsFlutterBinding');

  @override
  void initState() {
    super.initState();
    if (_inWidgetTest) return;
    _timer = Timer.periodic(const Duration(milliseconds: 450), (_) {
      if (!mounted) return;
      setState(_feed.tick);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indices = _feed.indices;
    final watchlist = _feed.watchlist;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _MarketTab(
                label: 'Indices',
                on: _indices,
                onTap: () => setState(() => _indices = true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MarketTab(
                label: 'Watchlist',
                on: !_indices,
                onTap: () => setState(() => _indices = false),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 8),
        // Row(
        //   children: [
        //     Container(
        //       width: 7,
        //       height: 7,
        //       decoration: const BoxDecoration(
        //         color: AppColors.coral,
        //         shape: BoxShape.circle,
        //       ),
        //     ),
        //     // const SizedBox(width: 6),
        //     // Text(
        //     //   'LIVE',
        //     //   style: AppTheme.font(
        //     //     size: 11,
        //     //     weight: FontWeight.w700,
        //     //     color: AppColors.mute,
        //     //     letterSpacing: 0.8,
        //     //   ),
        //     // ),
        //   ],
        // ),
        const SizedBox(height: 12),
        if (_indices)
          for (var i = 0; i < indices.length; i++) ...[
            _IndexRow(tick: indices[i]),
            if (i != indices.length - 1) const SizedBox(height: 8),
          ]
        else
          for (var i = 0; i < watchlist.length; i++) ...[
            _WatchRow(item: watchlist[i]),
            if (i != watchlist.length - 1) const SizedBox(height: 8),
          ],
      ],
    );
  }
}

class _MarketTab extends StatelessWidget {
  const _MarketTab({
    required this.label,
    required this.on,
    required this.onTap,
  });

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: on ? AppColors.ink : Colors.transparent,
          foregroundColor: on ? AppColors.cream : AppColors.ink,
          side: BorderSide(color: on ? AppColors.ink : AppColors.lineHeavy),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.font(
            size: 12.5,
            weight: FontWeight.w800,
            color: on ? AppColors.cream : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _IndexRow extends StatelessWidget {
  const _IndexRow({required this.tick});

  final IndexTick tick;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.delta(tick.up);
    return PaperCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tick.name,
                  style: AppTheme.font(
                    size: 14,
                    weight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Text(
                tick.changePts,
                style: AppTheme.font(
                  size: 13,
                  weight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tick.change,
                style: AppTheme.font(
                  size: 13,
                  weight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            tick.value,
            key: ValueKey(tick.value),
            style: AppTheme.font(
              size: 22,
              weight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'H ${tick.high}  ·  L ${tick.low}',
            style: AppTheme.font(size: 11.5, color: AppColors.mute),
          ),
        ],
      ),
    );
  }
}

class _WatchRow extends StatelessWidget {
  const _WatchRow({required this.item});

  final Holding item;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => showTradeSheet(context, item),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.symbol,
                  style: AppTheme.font(
                    size: 14,
                    weight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  item.qtyLine,
                  style: AppTheme.font(size: 11.5, color: AppColors.mute),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.value,
                key: ValueKey(item.value),
                style: AppTheme.font(size: 14, weight: FontWeight.w800),
              ),
              Text(
                item.change,
                style: AppTheme.font(
                  size: 12,
                  weight: FontWeight.w800,
                  color: AppColors.delta(item.up),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyCallPanel extends StatefulWidget {
  const _DailyCallPanel();

  @override
  State<_DailyCallPanel> createState() => _DailyCallPanelState();
}

class _DailyCallPanelState extends State<_DailyCallPanel>
    with SingleTickerProviderStateMixin {
  static const _fade = Duration(milliseconds: 450);

  late final AnimationController _controller;
  late final Animation<double> _hide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _fade);
    _hide = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final state = AppScope.of(context);
    if (state.callDraft == null ||
        _controller.isAnimating ||
        _controller.isCompleted) {
      return;
    }
    await _controller.forward();
    if (!mounted) return;
    state.submitCall();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          "We'll know the result post market, at the 3:30 PM close.",
          style: AppTheme.font(
            size: 13.5,
            weight: FontWeight.w700,
            color: AppColors.cream,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final seed = state.seed;

    if (state.callSubmitted) {
      return const SizedBox.shrink();
    }

    return SizeTransition(
      sizeFactor: Tween<double>(begin: 1, end: 0).animate(_hide),
      axisAlignment: -1,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(_hide),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PaperCard(
            radius: AppRadii.cardLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Kicker('8:45 ALERT', filled: true),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Locks 9:15 · 12:40 left',
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.font(size: 11.5, color: AppColors.mute),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  seed.dailyCall.question,
                  style: AppTheme.font(
                    size: 23,
                    weight: FontWeight.w800,
                    letterSpacing: -0.6,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  seed.dailyCall.subtitle,
                  style: AppTheme.font(size: 12.5, color: AppColors.mute),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _CallButton(
                        label: 'Closes up',
                        selected: state.callDraft == 'UP',
                        onTap: () => state.selectCall('UP'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CallButton(
                        label: 'Closes down',
                        selected: state.callDraft == 'DOWN',
                        onTap: () => state.selectCall('DOWN'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PaperButton(
                  label: 'Submit',
                  onPressed: state.callDraft == null ? null : _onSubmit,
                  height: 52,
                ),
                const SizedBox(height: 10),
                Text(
                  'One call a day. Correct pays ${seed.dailyCall.payCorrect} Shercoins, wrong costs nothing.',
                  style: AppTheme.font(
                    size: 11.5,
                    color: AppColors.mute,
                    height: 1.45,
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

class _CallButton extends StatelessWidget {
  const _CallButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.ink : AppColors.cream,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.lineHeavy),
          ),
          child: Text(
            label,
            style: AppTheme.font(
              size: 14.5,
              weight: FontWeight.w800,
              letterSpacing: -0.2,
              color: selected ? AppColors.cream : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
