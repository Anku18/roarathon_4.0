import 'package:flutter/material.dart';

import '../data/dummy/dummy.dart';
import '../state/app_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_theme.dart';
import '../widgets/paper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _id = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await AppScope.of(context).login(_id.text, _password.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) {
        _error = "That client ID or password doesn't match the dummy accounts.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, top + 48, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.coral,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'S',
                style: AppTheme.font(
                  size: 34,
                  weight: FontWeight.w800,
                  color: AppColors.cream,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Sharekhan',
              style: AppTheme.font(
                size: 18,
                weight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rewards prototype',
              style: AppTheme.font(
                size: 32,
                weight: FontWeight.w800,
                letterSpacing: -0.9,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sign in with a dummy client ID. Nothing here talks to a live broker.',
              style: AppTheme.font(size: 14, color: AppColors.mute, height: 1.4),
            ),
            const SizedBox(height: 28),
            _Field(
              controller: _id,
              label: 'Client ID',
              hint: 'RM4K92',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _password,
              label: 'Password',
              hint: '••••••••',
              obscure: _obscure,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              suffix: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.mute,
                  size: 20,
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                style: AppTheme.font(size: 13, color: AppColors.deep, height: 1.4),
              ),
            ],
            const SizedBox(height: 22),
            PaperButton(
              label: _busy ? 'Signing in…' : 'Continue',
              onPressed: _busy ? null : _submit,
              height: 56,
            ),
            const SizedBox(height: 18),
            Text(
              DummyAuth.hint,
              style: AppTheme.font(size: 12.5, color: AppColors.mute),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTheme.font(
            size: 11,
            weight: FontWeight.w700,
            color: AppColors.mute,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: AppTheme.font(size: 16, weight: FontWeight.w700),
          cursorColor: AppColors.coral,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTheme.font(size: 16, color: AppColors.muteSoft),
            filled: true,
            fillColor: AppColors.cream,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.card),
              borderSide: const BorderSide(color: AppColors.lineStrong),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.card),
              borderSide: const BorderSide(color: AppColors.ink),
            ),
          ),
        ),
      ],
    );
  }
}
