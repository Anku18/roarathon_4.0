import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionStore {
  Future<String?> loadClientId();
  Future<void> saveClientId(String clientId);
  Future<void> clear();
}

class PrefsSessionStore implements SessionStore {
  PrefsSessionStore(this._prefs);

  static const _key = 'sharekhan.dummy.clientId';
  final SharedPreferences _prefs;

  @override
  Future<String?> loadClientId() async => _prefs.getString(_key);

  @override
  Future<void> saveClientId(String clientId) async {
    await _prefs.setString(_key, clientId);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}

class MemorySessionStore implements SessionStore {
  String? _clientId;

  @override
  Future<String?> loadClientId() async => _clientId;

  @override
  Future<void> saveClientId(String clientId) async {
    _clientId = clientId;
  }

  @override
  Future<void> clear() async {
    _clientId = null;
  }
}
