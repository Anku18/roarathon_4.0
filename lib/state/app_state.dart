import 'package:flutter/foundation.dart';

import '../data/dummy/dummy.dart';
import '../models/models.dart';
import '../models/notification_model.dart';
import 'session_store.dart';

enum LeaderboardTab { referrals, accuracy }

class AppState extends ChangeNotifier {
  AppState({required SessionStore store}) : _store = store;

  final SessionStore _store;

  DummySeed? _seed;
  bool _ready = false;

  int ticks = 0;
  int streak = 0;
  bool claimedToday = false;
  List<bool> missionsDone = const [];
  String? callDraft; // UP | DOWN, before submit
  String? prediction; // UP | DOWN, after submit
  bool get callSubmitted => prediction != null;
  final List<String> shopDone = [];
  LeaderboardTab leaderboardTab = LeaderboardTab.referrals;
  final List<AppNotification> notifications = [];

  int get unreadCount => notifications.where((n) => !n.isRead).length;
  final List<ChatTurn> chat = [];

  DummySeed get seed {
    final s = _seed;
    if (s == null) {
      throw StateError('AppState used before a user was loaded');
    }
    return s;
  }

  UserProfile? get profile => _seed?.profile;
  bool get isLoggedIn => _seed != null;
  bool get ready => _ready;

  Future<void> restore() async {
    final clientId = await _store.loadClientId();
    if (clientId != null) {
      final account = DummyAuth.byClientId(clientId);
      if (account != null) {
        _applySeed(DummySeeds.byId(account.seedId));
      }
    }
    // Restore saved notifications
    final notifJson = await _store.loadNotifications();
    if (notifJson != null) {
      try {
        final loaded = AppNotification.listFromJsonString(notifJson);
        notifications
          ..clear()
          ..addAll(loaded);
      } catch (_) {
        // Corrupt data — ignore
      }
    }
    _ready = true;
    notifyListeners();
  }

  Future<bool> login(String clientId, String password) async {
    final account = DummyAuth.match(clientId, password);
    if (account == null) return false;
    _applySeed(DummySeeds.byId(account.seedId));
    await _store.saveClientId(account.clientId);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _seed = null;
    ticks = 0;
    streak = 0;
    claimedToday = false;
    missionsDone = const [];
    callDraft = null;
    prediction = null;
    shopDone.clear();
    leaderboardTab = LeaderboardTab.referrals;
    chat.clear();
    notifications.clear();
    await _store.clear();
    notifyListeners();
  }

  void _applySeed(DummySeed seed) {
    _seed = seed;
    ticks = seed.ticks;
    streak = seed.streak;
    claimedToday = seed.claimedToday;
    missionsDone = seed.missions.map((m) => m.doneByDefault).toList();
    callDraft = null;
    prediction = null;
    shopDone.clear();
    leaderboardTab = LeaderboardTab.referrals;
    chat
      ..clear()
      ..add(ChatTurn(fromUser: false, text: seed.chatGreeting));
  }

  void selectCall(String direction) {
    if (prediction != null) return;
    callDraft = direction;
    notifyListeners();
  }

  void submitCall() {
    if (prediction != null || callDraft == null) return;
    prediction = callDraft;
    notifyListeners();
  }

  void toggleMission(int index) {
    if (index < 0 || index >= missionsDone.length) return;
    final was = missionsDone[index];
    missionsDone = List.of(missionsDone)..[index] = !was;
    final pts = seed.missions[index].points;
    ticks += was ? -pts : pts;
    notifyListeners();
  }

  void checkIn() {
    if (claimedToday) return;
    claimedToday = true;
    streak += 1;
    ticks += seed.checkInCoins;
    notifyListeners();
  }

  void setLeaderboardTab(LeaderboardTab tab) {
    if (tab == leaderboardTab) return;
    leaderboardTab = tab;
    notifyListeners();
  }

  bool isRedeemed(String id) => shopDone.contains(id);

  bool canAfford(ShopItem item) => ticks >= item.cost && !isRedeemed(item.id);

  void redeem(ShopItem item) {
    if (!canAfford(item)) return;
    ticks -= item.cost;
    shopDone.add(item.id);
    notifyListeners();
  }

  void sendChat(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    chat.add(ChatTurn(fromUser: true, text: text));
    chat.add(ChatTurn(fromUser: false, text: DummyChat.replyFor(text)));
    notifyListeners();
  }

  String goldLine() {
    const goldAt = 14;
    final left = goldAt - streak;
    if (left <= 0) return 'Gold tier unlocked';
    return left == 1 ? '1 day to Gold tier' : '$left days to Gold tier';
  }

  void addNotification(AppNotification notification) {
    notifications.insert(0, notification);
    // Keep only the latest 20
    if (notifications.length > 20) {
      notifications.removeRange(20, notifications.length);
    }
    _persistNotifications();
    notifyListeners();
  }

  void markAllRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    _persistNotifications();
    notifyListeners();
  }

  void dismissNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    _persistNotifications();
    notifyListeners();
  }

  void _persistNotifications() {
    _store.saveNotifications(AppNotification.listToJsonString(notifications));
  }
}
