import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/app_shell.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';
import 'state/session_store.dart';
import 'theme/app_theme.dart';
import 'widgets/phone_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  // Initialise Firebase
  await Firebase.initializeApp();

  // Register background handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final prefs = await SharedPreferences.getInstance();
  final state = AppState(store: PrefsSessionStore(prefs));
  await state.restore();

  // Start notification service (request permission, get token, listen to FCM)
  await NotificationService.instance.init(state);

  runApp(SharekhanApp(state: state));
}

class SharekhanApp extends StatelessWidget {
  const SharekhanApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'Sharekhan Rewards',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          final padding = EdgeInsets.only(
            top: mq.padding.top > 0 ? mq.padding.top : mq.viewPadding.top,
            bottom: mq.padding.bottom > 0 ? mq.padding.bottom : mq.viewPadding.bottom,
            left: mq.padding.left > 0 ? mq.padding.left : mq.viewPadding.left,
            right: mq.padding.right > 0 ? mq.padding.right : mq.viewPadding.right,
          );
          return MediaQuery(
            data: mq.copyWith(padding: padding),
            child: PhoneShell(child: child ?? const SizedBox.shrink()),
          );
        },
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final loggedIn = AppScope.of(context).isLoggedIn;
    return loggedIn ? const AppShell() : const LoginScreen();
  }
}

/// Call from tests so Google Fonts does not hit the network.
void configureTestFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;
}
