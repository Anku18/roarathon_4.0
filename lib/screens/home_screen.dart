import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../theme/formatters.dart';
import '../widgets/paper.dart';
import 'ask_sher_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final seed = state.seed;

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
                    Text(
                      'Sharekhan',
                      style: AppTheme.font(
                        size: 18,
                        weight: FontWeight.w800,
                        letterSpacing: -0.45,
                      ),
                    ),
                    const Spacer(),
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
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: const BoxDecoration(
                                  color: AppColors.coral,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  state.unreadCount > 9 ? '9+' : '${state.unreadCount}',
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
                    const SizedBox(width: 10),
                    // ── Ticks pill ──
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(color: AppColors.lineStrong),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.coral,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatEnIn(state.ticks),
                            style: AppTheme.font(size: 13, weight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Kicker('TOTAL VALUE'),
                    const SizedBox(height: 4),
                    Text(
                      seed.portfolio.totalValueLabel,
                      style: AppTheme.font(
                        size: 44,
                        weight: FontWeight.w800,
                        letterSpacing: -1.6,
                        height: 1.04,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        seed.portfolio.todayChangeLabel,
                        style: AppTheme.font(
                          size: 13,
                          weight: FontWeight.w800,
                          color: AppColors.deep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _DailyCallPanel(),
              Row(
                children: [
                  Expanded(
                    child: PaperCard(
                      radius: 22,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Kicker('STREAK'),
                          const SizedBox(height: 2),
                          Text(
                            '${state.streak}',
                            style: AppTheme.font(
                              size: 30,
                              weight: FontWeight.w800,
                              letterSpacing: -1.2,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            state.goldLine(),
                            style: AppTheme.font(size: 11.5, color: AppColors.mute),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PaperCard(
                      radius: 22,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Kicker('REFERRALS'),
                          const SizedBox(height: 2),
                          Text(
                            '#${seed.profile.referralRank}',
                            style: AppTheme.font(
                              size: 30,
                              weight: FontWeight.w800,
                              letterSpacing: -1.2,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            '${seed.profile.fundedReferrals} funded · ${seed.profile.pendingReferrals} pending',
                            style: AppTheme.font(size: 11.5, color: AppColors.mute),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SectionHeader(
                "Today's missions",
                trailing: '${state.missionsDone.where((d) => d).length} of ${seed.missions.length} done',
              ),
              for (var i = 0; i < seed.missions.length; i++) ...[
                _MissionTile(
                  title: seed.missions[i].title,
                  subtitle: seed.missions[i].subtitle,
                  points: '+${seed.missions[i].points}',
                  done: state.missionsDone[i],
                  onTap: () => state.toggleMission(i),
                ),
                if (i != seed.missions.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 122,
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
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.cream),
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
    if (state.callDraft == null || _controller.isAnimating || _controller.isCompleted) {
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
          style: AppTheme.font(size: 13.5, weight: FontWeight.w700, color: AppColors.cream),
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
                  style: AppTheme.font(size: 11.5, color: AppColors.mute, height: 1.45),
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

class _MissionTile extends StatelessWidget {
  const _MissionTile({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.done,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String points;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? AppColors.ink : Colors.transparent,
              border: Border.all(
                color: done ? AppColors.ink : AppColors.mute.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: done
                ? const Icon(Icons.check, size: 12, color: AppColors.cream)
                : null,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.font(
                    size: 13.5,
                    color: done ? AppColors.mute : AppColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTheme.font(size: 11, color: AppColors.mute),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: AppTheme.font(size: 12.5, weight: FontWeight.w800, color: AppColors.deep),
          ),
        ],
      ),
    );
  }
}
