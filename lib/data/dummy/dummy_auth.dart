import '../../models/models.dart';

/// Dummy logins only. Add a row here, then a matching seed in `dummy_seeds.dart`.
abstract final class DummyAuth {
  static const accounts = <DummyAccount>[
    DummyAccount(clientId: 'RM4K92', password: 'demo123', seedId: 'rohit'),
  ];

  static const hint = 'Demo login · RM4K92 / demo123';

  static DummyAccount? match(String clientId, String password) {
    final id = clientId.trim().toUpperCase();
    final pw = password.trim();
    for (final account in accounts) {
      if (account.clientId.toUpperCase() == id && account.password == pw) {
        return account;
      }
    }
    return null;
  }

  static DummyAccount? byClientId(String clientId) {
    final id = clientId.trim().toUpperCase();
    for (final account in accounts) {
      if (account.clientId.toUpperCase() == id) return account;
    }
    return null;
  }
}
