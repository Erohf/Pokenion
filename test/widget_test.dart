import 'package:flutter_test/flutter_test.dart';
import 'package:pokenion/domain/models/status_condition.dart';

void main() {
  group('status stacking rules', () {
    test('burn and poison stack with each other and a special', () {
      var s = <StatusCondition>{};
      s = applyStatus(s, StatusCondition.burned);
      s = applyStatus(s, StatusCondition.poisoned);
      s = applyStatus(s, StatusCondition.asleep);
      expect(s, {
        StatusCondition.burned,
        StatusCondition.poisoned,
        StatusCondition.asleep,
      });
    });

    test('specials replace each other (no accumulation)', () {
      var s = <StatusCondition>{StatusCondition.asleep};
      s = applyStatus(s, StatusCondition.paralyzed);
      expect(s.contains(StatusCondition.asleep), isFalse);
      expect(s.contains(StatusCondition.paralyzed), isTrue);
      expect(s.where((c) => c.isSpecial).length, 1);
    });

    test('same condition never doubles', () {
      var s = <StatusCondition>{StatusCondition.poisoned};
      s = applyStatus(s, StatusCondition.poisoned);
      expect(s.length, 1);
    });
  });
}
