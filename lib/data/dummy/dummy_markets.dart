import '../../models/models.dart';

/// Placeholder Markets tab — dummy indices + watchlist only.
abstract final class DummyMarkets {
  static const subtitle =
      'Full markets board is coming. This is a dummy watchlist so the tab isn’t empty.';

  static const indices = <IndexTick>[
    IndexTick(name: 'NIFTY 50', value: '24,853.10', change: '+0.16%', up: true),
    IndexTick(name: 'SENSEX', value: '81,204.44', change: '+0.12%', up: true),
    IndexTick(name: 'BANKNIFTY', value: '51,118.80', change: '−0.08%', up: false),
  ];

  static const watchlist = <Holding>[
    Holding(
      symbol: 'HDFCBANK',
      qtyLine: '42 qty · avg ₹1,486',
      value: '₹68,124',
      change: '+1.8%',
      up: true,
    ),
    Holding(
      symbol: 'INFY',
      qtyLine: '30 qty · avg ₹1,392',
      value: '₹43,530',
      change: '+0.4%',
      up: true,
    ),
    Holding(
      symbol: 'TATAMOTORS',
      qtyLine: '55 qty · avg ₹962',
      value: '₹51,205',
      change: '−0.7%',
      up: false,
    ),
    Holding(
      symbol: 'PARAG PARIKH FLEXI',
      qtyLine: 'SIP ₹5,000 · 12th',
      value: '₹1,84,900',
      change: '+2.1%',
      up: true,
    ),
  ];
}
