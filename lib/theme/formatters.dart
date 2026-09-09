/// Indian grouping for coin / rank numbers (2,480 · 4,82,310).
String formatEnIn(int n) {
  final negative = n < 0;
  final digits = n.abs().toString();
  if (digits.length <= 3) {
    return '${negative ? '-' : ''}$digits';
  }
  final last3 = digits.substring(digits.length - 3);
  var rest = digits.substring(0, digits.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${negative ? '-' : ''}${parts.join(',')},$last3';
}
