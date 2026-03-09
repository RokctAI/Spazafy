import 'package:flutter_test/flutter_test.dart';
import 'package:billing_app/infrastructure/services/app_validators.dart';

void main() {
  group('AppValidators.required', () {
    test('should return error message when value is null', () {
      final validator = AppValidators.required('Required');
      expect(validator(null), 'Required');
    });

    test('should return error message when value is empty string', () {
      final validator = AppValidators.required('Required');
      expect(validator(''), 'Required');
    });

    test('should return error message when value is whitespace only', () {
      final validator = AppValidators.required('Required');
      expect(validator('   '), 'Required');
    });

    test('should return null when value is valid', () {
      final validator = AppValidators.required('Required');
      expect(validator('Valid Input'), null);
    });

    test('should return error for very long strings (fixed vulnerability)', () {
      final validator = AppValidators.required('Required');
      final longString = 'a' * 256;
      expect(validator(longString), 'Input too long (max 255 characters)');
    });

    test('should allow custom maxLength', () {
      final validator = AppValidators.required('Required', maxLength: 10);
      expect(validator('a' * 10), null);
      expect(validator('a' * 11), 'Input too long (max 10 characters)');
    });
  });
}
