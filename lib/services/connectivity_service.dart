import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../state/app_state.dart';

/// Feeds [AppState.isOnline]. A transport check alone is not enough — Android
/// reports "connected" behind a captive portal — so every transport change is
/// confirmed with a reachability ping.
class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final _internet = InternetConnection();
  StreamSubscription<InternetStatus>? _statusSub;
  StreamSubscription<List<ConnectivityResult>>? _transportSub;
  AppState? _appState;

  /// Call once from [main].
  void init(AppState appState) {
    _appState = appState;
    _statusSub?.cancel();
    _transportSub?.cancel();

    _statusSub = _internet.onStatusChange.listen(
      (status) => appState.setOnline(status == InternetStatus.connected),
      onError: (Object e) => debugPrint('[Net] Status stream failed: $e'),
    );

    _transportSub = Connectivity().onConnectivityChanged.listen(
      (results) {
        if (results.every((r) => r == ConnectivityResult.none)) {
          appState.setOnline(false);
        } else {
          refresh();
        }
      },
      onError: (Object e) => debugPrint('[Net] Transport stream failed: $e'),
    );
  }

  /// Re-check reachability now, e.g. when the header bubble is tapped.
  Future<void> refresh() async {
    final state = _appState;
    if (state == null) return;
    try {
      state.setOnline(await _internet.hasInternetAccess);
    } catch (e) {
      debugPrint('[Net] Reachability check failed: $e');
    }
  }
}
