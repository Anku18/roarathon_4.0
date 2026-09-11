import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../theme/formatters.dart';

/// Rolls [ticks] from the previous value when the count changes.
class AnimatedCoinCount extends StatefulWidget {
  const AnimatedCoinCount({
    super.key,
    required this.ticks,
    required this.style,
  });

  final int ticks;
  final TextStyle style;

  @override
  State<AnimatedCoinCount> createState() => _AnimatedCoinCountState();
}

class _AnimatedCoinCountState extends State<AnimatedCoinCount> {
  late int _from;
  late int _to;

  @override
  void initState() {
    super.initState();
    _from = widget.ticks;
    _to = widget.ticks;
  }

  @override
  void didUpdateWidget(AnimatedCoinCount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ticks != widget.ticks) {
      _from = oldWidget.ticks;
      _to = widget.ticks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(_to),
      tween: Tween(begin: _from.toDouble(), end: _to.toDouble()),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text(formatEnIn(value.round()), style: widget.style);
      },
    );
  }
}

/// Header Sherpoint count that rolls and pops when [ticks] changes.
class CoinsPill extends StatefulWidget {
  const CoinsPill({super.key, required this.ticks});

  final int ticks;

  @override
  State<CoinsPill> createState() => _CoinsPillState();
}

class _CoinsPillState extends State<CoinsPill>
    with SingleTickerProviderStateMixin {
  late int _from;
  late int _to;
  late final AnimationController _bump;
  late final Animation<double> _scale;
  late final Animation<double> _deltaOpacity;
  late final Animation<Offset> _deltaSlide;

  @override
  void initState() {
    super.initState();
    _from = widget.ticks;
    _to = widget.ticks;
    _bump = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.14), weight: 32),
      TweenSequenceItem(tween: Tween(begin: 1.14, end: 1), weight: 68),
    ]).animate(CurvedAnimation(parent: _bump, curve: Curves.easeOut));
    _deltaOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 22),
      TweenSequenceItem(tween: ConstantTween(1), weight: 38),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 40),
    ]).animate(_bump);
    _deltaSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: const Offset(0, -1.05),
    ).animate(CurvedAnimation(parent: _bump, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _bump.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CoinsPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ticks != widget.ticks) {
      _from = oldWidget.ticks;
      _to = widget.ticks;
      _bump.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final delta = _to - _from;
    return ScaleTransition(
      scale: _scale,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            key: const Key('coins-pill'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(AppRadii.pill),
              border: Border.all(color: AppColors.lineStrong),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedCoinCount(
                  ticks: widget.ticks,
                  style: AppTheme.font(size: 13, weight: FontWeight.w800),
                ),
              ],
            ),
          ),
          if (delta != 0)
            Positioned(
              top: -16,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: FadeTransition(
                  opacity: _deltaOpacity,
                  child: SlideTransition(
                    position: _deltaSlide,
                    child: Text(
                      '${delta > 0 ? '+' : ''}$delta',
                      textAlign: TextAlign.center,
                      style: AppTheme.font(
                        size: 11,
                        weight: FontWeight.w800,
                        color: delta > 0 ? AppColors.gain : AppColors.loss,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
