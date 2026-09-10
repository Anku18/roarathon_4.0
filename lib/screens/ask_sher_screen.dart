import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../widgets/app_safe_area.dart';

class AskSherScreen extends StatefulWidget {
  const AskSherScreen({super.key});

  @override
  State<AskSherScreen> createState() => _AskSherScreenState();
}

class _AskSherScreenState extends State<AskSherScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final text = preset ?? _controller.text;
    if (text.trim().isEmpty) return;
    AppScope.of(context).sendChat(text);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return AppSafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Ask Sher',
            style: AppTheme.font(size: 18, weight: FontWeight.w800, letterSpacing: -0.4),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: state.chat.length,
                itemBuilder: (context, i) {
                  final turn = state.chat[i];
                  final align = turn.fromUser ? Alignment.centerRight : Alignment.centerLeft;
                  return Align(
                    alignment: align,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: turn.fromUser ? AppColors.ink : AppColors.cream,
                        borderRadius: BorderRadius.circular(20),
                        border: turn.fromUser ? null : Border.all(color: AppColors.line),
                      ),
                      child: Text(
                        turn.text,
                        style: AppTheme.font(
                          size: 14,
                          height: 1.4,
                          color: turn.fromUser ? AppColors.cream : AppColors.ink,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chip in state.seed.chatSuggestions)
                    ActionChip(
                      label: Text(
                        chip,
                        style: AppTheme.font(size: 12, weight: FontWeight.w700),
                      ),
                      backgroundColor: AppColors.cream,
                      side: const BorderSide(color: AppColors.lineStrong),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      onPressed: () => _send(chip),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12 + keyboard),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _send,
                      style: AppTheme.font(size: 15, weight: FontWeight.w600),
                      cursorColor: AppColors.coral,
                      decoration: InputDecoration(
                        hintText: 'Ask Sher…',
                        hintStyle: AppTheme.font(size: 15, color: AppColors.mute),
                        filled: true,
                        fillColor: AppColors.cream,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          borderSide: const BorderSide(color: AppColors.lineStrong),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          borderSide: const BorderSide(color: AppColors.ink),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: AppColors.coral,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.arrow_upward, color: AppColors.cream),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
