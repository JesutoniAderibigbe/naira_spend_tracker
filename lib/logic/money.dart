/// Formats an amount in kobo as naira, for example `₦2,500` or `₦1,250.50`.
///
/// Whole naira amounts drop the `.00` because that is how people actually
/// read prices in Nigeria. Negative amounts get a leading minus sign.
String formatNaira(int kobo) {
  final negative = kobo < 0;
  final absolute = kobo.abs();
  final naira = absolute ~/ 100;
  final remainder = absolute % 100;

  final digits = naira.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write(',');
    }
  }

  final decimals = remainder == 0
      ? ''
      : '.${remainder.toString().padLeft(2, '0')}';
  return '${negative ? '-' : ''}₦$buffer$decimals';
}

/// Parses user input such as `2500`, `2,500`, `₦2,500.50` or `2500.5` into
/// kobo. Returns null when the input is not a positive amount.
int? parseNairaToKobo(String input) {
  final cleaned = input.replaceAll(RegExp(r'[₦,\s]'), '');
  if (cleaned.isEmpty) return null;
  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(cleaned)) return null;

  final parts = cleaned.split('.');
  final naira = int.parse(parts[0]);
  final kobo = parts.length == 2 ? int.parse(parts[1].padRight(2, '0')) : 0;
  final total = naira * 100 + kobo;
  return total > 0 ? total : null;
}
