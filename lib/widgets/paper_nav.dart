import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';

class PaperNav extends StatelessWidget {
  const PaperNav({
    super.key,
    required this.index,
    required this.onSelect,
    this.labels = const ['Home', 'Markets', 'Refer', 'You'],
  });

  final int index;
  final ValueChanged<int> onSelect;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadii.nav),
        border: Border.all(color: AppColors.lineStrong),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onSelect(i),
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 44,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == index
                              ? AppColors.coral
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        labels[i],
                        style: AppTheme.font(
                          size: 10.5,
                          color: i == index
                              ? AppColors.ink
                              : AppColors.muteSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
