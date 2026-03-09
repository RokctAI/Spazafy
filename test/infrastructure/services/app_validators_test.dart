import 'package:flutter_test/flutter_test.dart';
import 'package:billing_app/infrastructure/services/app_validators.dart';

void main() {
  group('AppValidators.required', () {
    test('returns error message if value is null', () {
      final validator = AppValidators.required('Required field');
      expect(validator(null), 'Required field');
    });

    test('returns error message if value is empty', () {
      final validator = AppValidators.required('Required field');
      expect(validator(''), 'Required field');
    });

    test('returns error message if value is whitespace', () {
      final validator = AppValidators.required('Required field');
      expect(validator('   '), 'Required field');
    });

    test('returns null if value is valid string', () {
      final validator = AppValidators.required('Required field');
      expect(validator('valid input'), isNull);
    });

    test('returns null if value length is exactly maxLength', () {
      final validator = AppValidators.required('Required field', maxLength: 10);
      expect(validator('1234567890'), isNull);
    });

    test('returns error message if value length exceeds maxLength', () {
      final validator = AppValidators.required('Required field', maxLength: 10);
      expect(validator('12345678901'), 'Input too long (max 10 characters)');
    });

    test('uses default maxLength of 255', () {
      final validator = AppValidators.required('Required field');
      final validString = List.filled(255, 'a').join();
      final invalidString = List.filled(256, 'a').join();

      expect(validator(validString), isNull);
      expect(validator(invalidString), 'Input too long (max 255 characters)');
    });
  });

  group('AppValidators.price', () {
    test('returns error message if value is null', () {
      expect(AppValidators.price(null), 'Please enter a price');
    });

    test('returns error message if value is empty', () {
      expect(AppValidators.price(''), 'Please enter a price');
    });

    test('returns error message if value is whitespace', () {
      expect(AppValidators.price('   '), 'Please enter a price');
    });

    test('returns error message if value is not a number', () {
      expect(AppValidators.price('abc'), 'Please enter a valid number');
    });

    test('returns error message if value is negative', () {
      expect(AppValidators.price('-10.5'), 'Price cannot be negative');
    });

    test('returns null if value is valid positive integer', () {
      expect(AppValidators.price('100'), isNull);
    });

    test('returns null if value is valid positive double', () {
      expect(AppValidators.price('99.99'), isNull);
    });

    test('returns null if value is zero', () {
      expect(AppValidators.price('0'), isNull);
      expect(AppValidators.price('0.0'), isNull);
    });
  });
}
