import 'package:billing_app/infrastructure/services/app_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators', () {
    group('required', () {
      const errorMessage = 'Field is required';
      final validator = AppValidators.required(errorMessage);

      test('should return error message if value is null', () {
        expect(validator(null), errorMessage);
      });

      test('should return error message if value is empty', () {
        expect(validator(''), errorMessage);
      });

      test('should return error message if value is only whitespace', () {
        expect(validator('   '), errorMessage);
        expect(validator('\n'), errorMessage);
        expect(validator('\t'), errorMessage);
      });

      test('should return null if value is not empty', () {
        expect(validator('valid input'), isNull);
        expect(validator('  valid  '), isNull);
        expect(validator('0'), isNull);
      });
    });

    group('price', () {
      test('should return error message if value is null', () {
        expect(AppValidators.price(null), 'Please enter a price');
      });

      test('should return error message if value is empty', () {
        expect(AppValidators.price(''), 'Please enter a price');
      });

      test('should return error message if value is only whitespace', () {
        expect(AppValidators.price('   '), 'Please enter a price');
        expect(AppValidators.price('\n\t'), 'Please enter a price');
      });

      test('should return error message if value is not a number', () {
        expect(AppValidators.price('abc'), 'Please enter a valid number');
        expect(AppValidators.price('12.34.56'), 'Please enter a valid number');
        expect(AppValidators.price('12,34'), 'Please enter a valid number');
        expect(AppValidators.price('12a'), 'Please enter a valid number');
        expect(AppValidators.price('++10'), 'Please enter a valid number');
        expect(AppValidators.price('10-'), 'Please enter a valid number');
        expect(AppValidators.price('.'), 'Please enter a valid number');
        expect(AppValidators.price(' '), 'Please enter a price');
      });

      test('should return error message if value is negative', () {
        expect(AppValidators.price('-10'), 'Price cannot be negative');
        expect(AppValidators.price('-0.01'), 'Price cannot be negative');
        expect(AppValidators.price('-0'), isNull); // -0 is 0.0 which is not < 0
      });

      test('should return null if value is zero', () {
        expect(AppValidators.price('0'), isNull);
        expect(AppValidators.price('0.0'), isNull);
        expect(AppValidators.price('0.00'), isNull);
        expect(AppValidators.price('.0'), isNull);
        expect(AppValidators.price('0.'), isNull);
      });

      test('should return null if value is a positive number', () {
        expect(AppValidators.price('10'), isNull);
        expect(AppValidators.price('99.99'), isNull);
        expect(AppValidators.price('0.01'), isNull);
        expect(AppValidators.price('1000000'), isNull);
        expect(AppValidators.price('+50.5'), isNull);
        expect(AppValidators.price('1.23e2'), isNull); // Scientific notation
      });

      test('should handle leading and trailing spaces', () {
        expect(AppValidators.price(' 10.5 '), isNull);
        expect(AppValidators.price('\t5.0\n'), isNull);
      });

      test('should handle very large numbers', () {
        expect(AppValidators.price('999999999999999.99'), isNull);
      });

      test('should handle very small positive numbers', () {
        expect(AppValidators.price('0.0000000001'), isNull);
      });
    });
  });
}
