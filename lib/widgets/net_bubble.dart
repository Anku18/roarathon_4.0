import 'package:flutter/material.dart';

import '../services/connectivity_service.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';

/// Header connectivity dot: green when online, coral with expanding waves when
/// offline. Driven by [AppState.isOnline]; tapping re-checks reachability.
class NetBubble extends StatefulWidget {
  const NetBubble({super.key});

  @override
  State<NetBubble> createState() => _NetBubbleState();
}

class _NetBubbleState extends State<NetBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waves = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppScope.of(context).isOnline) {
      _waves.stop();
    } else if (!_waves.isAnimating) {
      _waves.repeat();
    }
  }

  @override
  void dispose() {
    _waves.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final online = AppScope.of(context).isOnline;
    return Semantics(
      button: true,
      label: online ? 'Online' : 'No internet',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ConnectivityService.instance.refresh,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!online)
                for (var i = 0; i < 3; i++) _Wave(cycle: _waves, phase: i / 3),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: online ? AppColors.online : AppColors.coral,
                  boxShadow: [
                    BoxShadow(
                      color: online ? AppColors.onlineHalo : AppColors.coralHalo,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Wave extends StatelessWidget {
  const _Wave({required this.cycle, required this.phase});

  final Animation<double> cycle;
  final double phase;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cycle,
      builder: (context, child) {
        // Every ring runs the full cycle, shifted by a third (0 / 600 / 1200 ms).
        final t = (cycle.value - phase) % 1.0;
        final scale = 1 + 2.2 * Curves.easeOut.transform(t);
        final opacity =
            t < 0.7 ? 0.55 * (1 - Curves.easeOut.transform(t / 0.7)) : 0.0;
        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: const DecoratedBox(
        decoration: BoxDecoration(color: AppColors.coral, shape: BoxShape.circle),
        child: SizedBox(width: 12, height: 12),
      ),
    );
  }
}
