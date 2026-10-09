import 'package:flutter_test/flutter_test.dart';
import 'package:naira_spend_tracker/logic/money.dart';

void main() {
  group('formatNaira', () {
    test('formats zero', () {
      expect(formatNaira(0), '₦0');
    });

    test('drops .00 for whole naira and groups thousands', () {
      expect(formatNaira(250000), '₦2,500');
      expect(formatNaira(100000000), '₦1,000,000');
      expect(formatNaira(99900), '₦999');
    });

    test('keeps kobo when present', () {
      expect(formatNaira(125050), '₦1,250.50');
      expect(formatNaira(5), '₦0.05');
    });

    test('formats negative amounts', () {
      expect(formatNaira(-250000), '-₦2,500');
    });
  });

  group('parseNairaToKobo', () {
    test('parses plain and formatted amounts', () {
      expect(parseNairaToKobo('2500'), 250000);
      expect(parseNairaToKobo('2,500'), 250000);
      expect(parseNairaToKobo('₦2,500.50'), 250050);
      expect(parseNairaToKobo(' 2500.5 '), 250050);
    });

    test('rejects empty, zero and invalid input', () {
      expect(parseNairaToKobo(''), isNull);
      expect(parseNairaToKobo('0'), isNull);
      expect(parseNairaToKobo('0.00'), isNull);
      expect(parseNairaToKobo('abc'), isNull);
      expect(parseNairaToKobo('-5'), isNull);
      expect(parseNairaToKobo('12.345'), isNull);
    });

    test('round-trips with formatNaira', () {
      for (final kobo in [5, 99900, 125050, 100000000]) {
        expect(parseNairaToKobo(formatNaira(kobo)), kobo);
      }
    });
  });
}
