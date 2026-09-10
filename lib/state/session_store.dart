import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionStore {
  Future<String?> loadClientId();
  Future<void> saveClientId(String clientId);
  Future<String?> loadNotifications();
  Future<void> saveNotifications(String json);
  Future<void> clear();
}

class PrefsSessionStore implements SessionStore {
  PrefsSessionStore(this._prefs);

  static const _keyClient = 'sharekhan.dummy.clientId';
  static const _keyNotifs = 'sharekhan.notifications';
  final SharedPreferences _prefs;

  @override
  Future<String?> loadClientId() async => _prefs.getString(_keyClient);

  @override
  Future<void> saveClientId(String clientId) async {
    await _prefs.setString(_keyClient, clientId);
  }

  @override
  Future<String?> loadNotifications() async => _prefs.getString(_keyNotifs);

  @override
  Future<void> saveNotifications(String json) async {
    await _prefs.setString(_keyNotifs, json);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_keyClient);
    await _prefs.remove(_keyNotifs);
  }
}

class MemorySessionStore implements SessionStore {
  String? _clientId;
  String? _notifs;

  @override
  Future<String?> loadClientId() async => _clientId;

  @override
  Future<void> saveClientId(String clientId) async {
    _clientId = clientId;
  }

  @override
  Future<String?> loadNotifications() async => _notifs;

  @override
  Future<void> saveNotifications(String json) async {
    _notifs = json;
  }

  @override
  Future<void> clear() async {
    _clientId = null;
    _notifs = null;
  }
}
