import 'package:flutter/material.dart';

import '../data/dummy/dummy.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/paper.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = AppScope.of(context).seed;
    return ScreenPad(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
            child: Text(
              'Markets',
              style: AppTheme.font(
                size: 30,
                weight: FontWeight.w800,
                letterSpacing: -1.0,
                height: 1.1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
            child: Text(
              DummyMarkets.subtitle,
              style: AppTheme.font(size: 13, color: AppColors.mute, height: 1.45),
            ),
          ),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: seed.indices.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final idx = seed.indices[i];
                return PaperCard(
                  radius: 20,
                  padding: const EdgeInsets.fromLTRB(16, 14, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        idx.name,
                        style: AppTheme.font(
                          size: 10.5,
                          weight: FontWeight.w700,
                          color: AppColors.mute,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        idx.value,
                        style: AppTheme.font(size: 16, weight: FontWeight.w800, letterSpacing: -0.4),
                      ),
                      Text(
                        idx.change,
                        style: AppTheme.font(
                          size: 12,
                          weight: FontWeight.w800,
                          color: idx.up ? AppColors.deep : AppColors.mute,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          const SectionHeader('Dummy watchlist', trailing: 'Prototype'),
          for (var i = 0; i < seed.watchlist.length; i++) ...[
            PaperCard(
              radius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seed.watchlist[i].symbol,
                          style: AppTheme.font(size: 14, weight: FontWeight.w800, letterSpacing: -0.2),
                        ),
                        Text(
                          seed.watchlist[i].qtyLine,
                          style: AppTheme.font(size: 11.5, color: AppColors.mute),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        seed.watchlist[i].value,
                        style: AppTheme.font(size: 14, weight: FontWeight.w800),
                      ),
                      Text(
                        seed.watchlist[i].change,
                        style: AppTheme.font(
                          size: 12,
                          weight: FontWeight.w800,
                          color: seed.watchlist[i].up ? AppColors.deep : AppColors.mute,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (i != seed.watchlist.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
