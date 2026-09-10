import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_safe_area.dart';

class AskSherScreen extends StatefulWidget {
  const AskSherScreen({super.key});

  /// Hosted chatbot page. Swap this URL when the webpage is ready.
  static const chatbotUrl = 'http://10.13.17.168:8000/?ext_user_id=U998877&ext_user_name=Rohit%20Menon&ext_user_status=KYC_PENDING';

  @override
  State<AskSherScreen> createState() => _AskSherScreenState();
}

class _AskSherScreenState extends State<AskSherScreen> {
  late final WebViewController _controller;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.bg)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(AskSherScreen.chatbotUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AppSafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Ask Sher',
            style: AppTheme.font(
              size: 18,
              weight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.coral,
                  backgroundColor: AppColors.blush,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
