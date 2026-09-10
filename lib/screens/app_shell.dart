import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_safe_area.dart';
import '../widgets/paper_nav.dart';
import 'home_screen.dart';
import 'markets_screen.dart';
import 'refer_screen.dart';
import 'rewards_screen.dart';
import 'you_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    HomeScreen(),
    MarketsScreen(),
    RewardsScreen(),
    ReferScreen(),
    YouScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AppSafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IndexedStack(index: _index, children: _pages),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              child: PaperNav(
                index: _index,
                onSelect: (i) => setState(() => _index = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
