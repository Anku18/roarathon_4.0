import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Insets content away from status bar, nav bar, and display cutouts.
///
/// On Android 15+ edge-to-edge, [MediaQuery.padding] can be zero while
/// [MediaQuery.viewPadding] still holds the system insets. This uses the
/// larger of the two so screens never draw under the system UI.
class AppSafeArea extends StatelessWidget {
  const AppSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  static EdgeInsets insetsOf(
    BuildContext context, {
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    final data = MediaQuery.of(context);
    final padding = data.padding;
    final view = data.viewPadding;
    return EdgeInsets.only(
      top: top ? math.max(padding.top, view.top) : 0,
      bottom: bottom ? math.max(padding.bottom, view.bottom) : 0,
      left: left ? math.max(padding.left, view.left) : 0,
      right: right ? math.max(padding.right, view.right) : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: insetsOf(
        context,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: top,
        removeBottom: bottom,
        removeLeft: left,
        removeRight: right,
        child: child,
      ),
    );
  }
}
