import 'dart:math';

import '../../models/models.dart';
import 'dummy_markets.dart';

/// Live dummy ticks for Home. Starts from [DummyMarkets] and nudges quotes.
class DummyMarketFeed {
  DummyMarketFeed({Random? random}) : _rng = random ?? Random() {
    _indices = DummyMarkets.indices.map(_LiveIndex.fromTick).toList();
    _watch = DummyMarkets.watchlist.map(_LiveStock.fromHolding).toList();
  }

  final Random _rng;
  late final List<_LiveIndex> _indices;
  late final List<_LiveStock> _watch;

  List<IndexTick> get indices =>
      _indices.map((q) => q.toTick()).toList(growable: false);

  List<Holding> get watchlist =>
      _watch.map((q) => q.toHolding()).toList(growable: false);

  void tick() {
    final indexHits = 1 + _rng.nextInt(min(4, _indices.length));
    final stockHits = 1 + _rng.nextInt(min(4, _watch.length));
    for (final i in _pick(_indices.length, indexHits)) {
      _indices[i].bump(_rng);
    }
    for (final i in _pick(_watch.length, stockHits)) {
      _watch[i].bump(_rng);
    }
  }

  List<int> _pick(int len, int n) {
    final order = List<int>.generate(len, (i) => i)..shuffle(_rng);
    return order.take(n).toList();
  }
}

class _LiveIndex {
  _LiveIndex({
    required this.name,
    required this.ltp,
    required this.prevClose,
    required this.high,
    required this.low,
    required this.step,
  });

  factory _LiveIndex.fromTick(IndexTick tick) {
    final ltp = parseMarketNumber(tick.value);
    final pts = parseMarketNumber(tick.changePts);
    return _LiveIndex(
      name: tick.name,
      ltp: ltp,
      prevClose: ltp - pts,
      high: parseMarketNumber(tick.high),
      low: parseMarketNumber(tick.low),
      step: ltp < 50 ? 0.01 : (ltp < 15000 ? 0.05 : 0.25),
    );
  }

  final String name;
  final double prevClose;
  final double step;
  double ltp;
  double high;
  double low;

  void bump(Random rng) {
    final moves = rng.nextInt(7) - 3;
    if (moves == 0) return;
    var next = ltp + moves * step;
    final floor = prevClose * 0.985;
    final ceil = prevClose * 1.015;
    ltp = next.clamp(floor, ceil).toDouble();
    if (ltp > high) high = ltp;
    if (ltp < low) low = ltp;
  }

  IndexTick toTick() {
    final pts = ltp - prevClose;
    final pct = prevClose == 0 ? 0.0 : pts / prevClose * 100;
    const decimals = 2;
    return IndexTick(
      name: name,
      value: formatMarketNumber(ltp, decimals: decimals),
      changePts: formatMarketSigned(pts, decimals: decimals),
      change: formatMarketSigned(pct, decimals: 2, suffix: '%'),
      high: formatMarketNumber(high, decimals: decimals),
      low: formatMarketNumber(low, decimals: decimals),
      up: pts >= 0,
    );
  }
}

class _LiveStock {
  _LiveStock({
    required this.symbol,
    required this.qtyLine,
    required this.ltp,
    required this.prevClose,
    required this.step,
  });

  factory _LiveStock.fromHolding(Holding item) {
    final ltp = parseMarketNumber(item.value);
    final pct = parseMarketNumber(item.change);
    final prev = ltp / (1 + pct / 100);
    return _LiveStock(
      symbol: item.symbol,
      qtyLine: item.qtyLine,
      ltp: ltp,
      prevClose: prev,
      step: ltp < 200 ? 0.05 : 0.10,
    );
  }

  final String symbol;
  final String qtyLine;
  final double prevClose;
  final double step;
  double ltp;

  void bump(Random rng) {
    final moves = rng.nextInt(9) - 4;
    if (moves == 0) return;
    final next = ltp + moves * step;
    ltp = next.clamp(prevClose * 0.975, prevClose * 1.025).toDouble();
  }

  Holding toHolding() {
    final pct = prevClose == 0 ? 0.0 : (ltp - prevClose) / prevClose * 100;
    return Holding(
      symbol: symbol,
      qtyLine: qtyLine,
      value: '₹${formatMarketNumber(ltp)}',
      change: formatMarketSigned(pct, suffix: '%'),
      up: pct >= 0,
    );
  }
}

double parseMarketNumber(String raw) {
  final t = raw
      .replaceAll('₹', '')
      .replaceAll(',', '')
      .replaceAll('%', '')
      .replaceAll('\u2212', '-')
      .replaceAll('+', '')
      .trim();
  return double.parse(t);
}

String formatMarketNumber(double n, {int decimals = 2}) {
  final sign = n < 0 ? '\u2212' : '';
  final abs = n.abs();
  final parts = abs.toStringAsFixed(decimals).split('.');
  final whole = parts[0];
  final buf = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    if (i > 0 && fromEnd % 3 == 0) buf.write(',');
    buf.write(whole[i]);
  }
  if (decimals == 0) return '$sign$buf';
  return '$sign$buf.${parts[1]}';
}

String formatMarketSigned(double n, {int decimals = 2, String suffix = ''}) {
  if (n > 0) return '+${formatMarketNumber(n, decimals: decimals)}$suffix';
  if (n < 0) return '${formatMarketNumber(n, decimals: decimals)}$suffix';
  return '${formatMarketNumber(0, decimals: decimals)}$suffix';
}
