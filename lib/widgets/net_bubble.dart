import 'dart:async';

import 'package:flutter/material.dart';

import '../services/connectivity_service.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';

/// Header connectivity dot: green when online, coral with expanding waves when
/// offline. Driven by [AppState.isOnline]. Tapping re-checks reachability and
/// shows a small status popup under the dot.
class NetBubble extends StatefulWidget {
  const NetBubble({super.key});

  /// How long the status popup stays up after a tap.
  static const popupDuration = Duration(milliseconds: 2500);

  @override
  State<NetBubble> createState() => _NetBubbleState();
}

class _NetBubbleState extends State<NetBubble> with TickerProviderStateMixin {
  late final AnimationController _waves = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  late final AnimationController _popupFade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 160),
  );
  final _popup = OverlayPortalController();
  final _link = LayerLink();
  Timer? _hideTimer;

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
    _hideTimer?.cancel();
    _popupFade.dispose();
    _waves.dispose();
    super.dispose();
  }

  void _onTap() {
    ConnectivityService.instance.refresh();
    _hideTimer?.cancel();
    _popup.show();
    _popupFade.forward();
    _hideTimer = Timer(NetBubble.popupDuration, _hidePopup);
  }

  Future<void> _hidePopup() async {
    _hideTimer?.cancel();
    if (!_popup.isShowing) return;
    await _popupFade.reverse();
    // A new tap during the fade-out re-opens it; only hide if still dismissed.
    if (mounted && _popupFade.isDismissed) _popup.hide();
  }

  @override
  Widget build(BuildContext context) {
    final online = AppScope.of(context).isOnline;
    // Bubble and popup share a tap group, so only taps elsewhere close it.
    return TapRegion(
      groupId: _link,
      onTapOutside: (_) => _hidePopup(),
      child: CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _popup,
          overlayChildBuilder: (context) => CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, -4),
            child: Align(
              alignment: Alignment.topRight,
              child: TapRegion(
                groupId: _link,
                child: FadeTransition(
                  opacity: _popupFade,
                  child: ScaleTransition(
                    alignment: Alignment.topRight,
                    scale: Tween(begin: 0.92, end: 1.0).animate(
                      CurvedAnimation(parent: _popupFade, curve: Curves.easeOut),
                    ),
                    child: _StatusPopup(onTap: _hidePopup),
                  ),
                ),
              ),
            ),
          ),
          child: Semantics(
            button: true,
            label: online ? 'Online' : 'No internet',
            hint: 'Shows connection status',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onTap,
              child: SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!online)
                      for (var i = 0; i < 3; i++)
                        _Wave(cycle: _waves, phase: i / 3),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: online ? AppColors.online : AppColors.coral,
                        boxShadow: [
                          BoxShadow(
                            color: online
                                ? AppColors.onlineHalo
                                : AppColors.coralHalo,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPopup extends StatelessWidget {
  const _StatusPopup({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Reads the scope itself so the text flips live if the re-check lands
    // while the popup is open.
    final online = AppScope.of(context).isOnline;
    return Semantics(
      liveRegion: true,
      child: Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 9, 14, 9),
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(AppRadii.pill),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2917150F),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: online ? AppColors.online : AppColors.coral,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  online ? 'Internet is connected' : 'No internet connection',
                  style: AppTheme.font(
                    size: 12.5,
                    weight: FontWeight.w800,
                    color: AppColors.cream,
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
