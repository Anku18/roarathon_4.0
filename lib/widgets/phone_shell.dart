import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// On wide screens, pin the prototype to the mock's 402pt phone width.
class PhoneShell extends StatelessWidget {
  const PhoneShell({super.key, required this.child});

  final Widget child;

  static const mockWidth = 402.0;
  static const mockHeight = 874.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width <= 520) return child;

    final height = math.min(mockHeight, size.height - 32);
    return ColoredBox(
      color: const Color(0xFFF3EFE6),
      child: Center(
        child: Container(
          width: mockWidth,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: AppColors.ink.withValues(alpha: 0.12), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(mockWidth, height),
              padding: const EdgeInsets.only(top: 12, bottom: 16),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
