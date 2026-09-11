import 'package:flutter/material.dart';

import '../data/dummy/dummy.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../widgets/app_safe_area.dart';
import '../widgets/paper.dart';

class ClosureScreen extends StatefulWidget {
  const ClosureScreen({super.key});

  @override
  State<ClosureScreen> createState() => _ClosureScreenState();
}

class _ClosureScreenState extends State<ClosureScreen> {
  final _path = <ClosureNode>[];

  ClosureNode? get _leaf =>
      _path.isNotEmpty && _path.last.resolution != null ? _path.last : null;

  String get _prompt {
    if (_path.isEmpty) return DummyClosure.rootPrompt;
    return _path.last.prompt ?? DummyClosure.rootPrompt;
  }

  List<ClosureNode> get _choices {
    if (_path.isEmpty) return DummyClosure.roots;
    return _path.last.children;
  }

  void _back() {
    if (_path.isEmpty) {
      Navigator.pop(context);
      return;
    }
    setState(() => _path.removeLast());
  }

  void _pick(ClosureNode node) {
    setState(() => _path.add(node));
  }

  Future<void> _stillClose() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONFIRM CLOSURE',
                style: AppTheme.font(
                  size: 11,
                  weight: FontWeight.w800,
                  color: AppColors.deep,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DummyClosure.confirmTitle,
                style: AppTheme.font(
                  size: 22,
                  weight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DummyClosure.confirmBody,
                style: AppTheme.font(
                  size: 13,
                  color: AppColors.muteSoft,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              PaperButton(
                label: 'Request closure',
                onPressed: () => Navigator.pop(ctx, true),
              ),
              const SizedBox(height: 10),
              PaperButton(
                label: DummyClosure.keepLabel,
                primary: false,
                onPressed: () => Navigator.pop(ctx, false),
              ),
            ],
          ),
        );
      },
    );
    if (confirmed != true || !mounted) return;
    final state = AppScope.of(context);
    Navigator.of(context).pop();
    await state.logout();
  }

  @override
  Widget build(BuildContext context) {
    final resolution = _leaf?.resolution;

    return AppSafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Text(
            DummyClosure.title,
            style: AppTheme.font(
              size: 18,
              weight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: _back,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            // const Kicker(DummyClosure.kicker),
            // const SizedBox(height: 8),
            // Text(
            //   DummyClosure.intro,
            //   style: AppTheme.font(
            //     size: 13.5,
            //     color: AppColors.mute,
            //     height: 1.45,
            //   ),
            // ),
            if (_path.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var i = 0; i < _path.length; i++)
                    _PathChip(
                      label: _path[i].label,
                      onTap: () => setState(() {
                        _path.removeRange(i + 1, _path.length);
                      }),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            if (resolution != null)
              _CallbackCard(
                resolution: resolution,
                onDone: () => Navigator.pop(context),
                onClose: _stillClose,
              )
            else ...[
              Text(
                _prompt,
                style: AppTheme.font(
                  size: 20,
                  weight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 12),
              for (final node in _choices) ...[
                _OptionTile(
                  label: node.label,
                  selected: false,
                  onTap: () => _pick(node),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _PathChip extends StatelessWidget {
  const _PathChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.sand,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            label,
            style: AppTheme.font(size: 11.5, weight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _CallbackCard extends StatelessWidget {
  const _CallbackCard({
    required this.resolution,
    required this.onDone,
    required this.onClose,
  });

  final ClosureResolution resolution;
  final VoidCallback onDone;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      radius: AppRadii.cardLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Kicker(resolution.kicker, filled: true),
          const SizedBox(height: 10),
          Text(
            resolution.title,
            style: AppTheme.font(
              size: 22,
              weight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            resolution.body,
            style: AppTheme.font(
              size: 13.5,
              color: AppColors.mute,
              height: 1.45,
            ),
          ),
          if (resolution.history.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'Your recent tickets',
              style: AppTheme.font(size: 12, weight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            for (final line in resolution.history)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: AppTheme.font(size: 13, color: AppColors.muteSoft),
                ),
              ),
          ],
          const SizedBox(height: 16),
          PaperButton(label: DummyClosure.keepLabel, onPressed: onDone),
          const SizedBox(height: 10),
          PaperButton(
            label: DummyClosure.stillCloseLabel,
            primary: false,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: selected ? AppColors.blush : AppColors.cream,
      borderColor: selected ? AppColors.coralLine : AppColors.line,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTheme.font(size: 14, weight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.mute),
        ],
      ),
    );
  }
}
