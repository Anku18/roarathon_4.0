import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';

class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = AppColors.cream,
    this.borderColor = AppColors.line,
    this.radius = AppRadii.cardLg,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color borderColor;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final body = Container(
          width: constraints.maxWidth.isFinite ? constraints.maxWidth : null,
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor),
          ),
          child: child,
        );
        if (onTap == null) return body;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: body,
          ),
        );
      },
    );
  }
}

class Kicker extends StatelessWidget {
  const Kicker(
    this.text, {
    super.key,
    this.color = AppColors.mute,
    this.filled = false,
  });

  final String text;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text,
      style: AppTheme.font(
        size: 11.5,
        weight: FontWeight.w700,
        color: filled ? AppColors.cream : color,
        letterSpacing: 1.1,
      ),
    );
    if (!filled) return label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.coral,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: label,
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.background = AppColors.blush,
    this.foreground = AppColors.deep,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        label,
        style: AppTheme.font(
          size: 10.5,
          weight: FontWeight.w800,
          color: foreground,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.font(
                size: 16,
                weight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: AppTheme.font(size: 11.5, color: AppColors.mute),
            ),
        ],
      ),
    );
  }
}

class PaperButton extends StatelessWidget {
  const PaperButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = true,
    this.trailing,
    this.height = 50,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final String? trailing;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final bg = primary ? AppColors.coral : AppColors.cream;
    final fg = primary ? AppColors.cream : AppColors.ink;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: enabled ? bg : AppColors.sand,
          foregroundColor: enabled ? fg : AppColors.mute,
          disabledBackgroundColor: AppColors.sand,
          disabledForegroundColor: AppColors.mute,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            side: primary
                ? BorderSide.none
                : const BorderSide(color: AppColors.lineHeavy),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: trailing == null
            ? Text(
                label,
                style: AppTheme.font(
                  size: 13.5,
                  weight: FontWeight.w800,
                  color: enabled ? fg : AppColors.mute,
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTheme.font(
                        size: 15,
                        weight: FontWeight.w800,
                        color: enabled ? fg : AppColors.mute,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                  Text(
                    trailing!,
                    style: AppTheme.font(
                      size: 15,
                      weight: FontWeight.w800,
                      color: enabled ? fg : AppColors.mute,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ScreenPad extends StatelessWidget {
  const ScreenPad({
    super.key,
    required this.child,
    this.bottom = 190,
  });

  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, top + 8, 16, bottom),
      child: child,
    );
  }
}
