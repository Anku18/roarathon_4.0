/// Indian grouping for point / rank numbers (2,480 · 4,82,310).
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

/// Rupees with Indian grouping (₹37,13,210).
String formatInr(int n) => '${n < 0 ? '-' : ''}₹${formatEnIn(n.abs())}';

/// Short cover amounts: crore from ₹1 Cr up (₹1.65 Cr), lakh below (₹7.5 L).
String formatInrShort(int n) {
  if (n >= 10000000) {
    return '₹${_trimZeros((n / 10000000).toStringAsFixed(2))} Cr';
  }
  return '₹${_trimZeros((n / 100000).toStringAsFixed(1))} L';
}

String _trimZeros(String s) =>
    s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Wall-clock time, 12-hour (3:31 PM).
String formatClock(DateTime t) {
  final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${t.hour < 12 ? 'AM' : 'PM'}';
}

/// Day and full month (19 September).
String formatDayMonth(DateTime d) => '${d.day} ${_months[d.month - 1]}';
