import 'package:crypto/crypto.dart';
import 'dart:convert';

class PayVerificationHelper {
  PayVerificationHelper._();

  /// Generates a 5-digit verification code based on transaction details.
  /// This logic MUST be identical to the backend implementation.
  static String generateVerificationCode({
    required String orderId,
    required double amount,
    required String shopId,
    required String? secret,
  }) {
    if (secret == null || secret.isEmpty) {
      throw Exception(
        "Shop secret is missing. Cannot generate verification code.",
      );
    }
    // 1. Normalize amount to 2 decimal places to avoid precision issues
    final normalizedAmount = amount.toStringAsFixed(2);

    // 2. Use the dynamic secret if provided
    final salt = secret;

    // 3. Construct signature string
    final rawString = "$orderId|$normalizedAmount|$shopId|$salt";

    // 4. Hash the string using SHA-256
    final bytes = utf8.encode(rawString);
    final digest = sha256.convert(bytes);

    // 5. Convert hash to a large integer and take last 5 digits
    // We use a simple bitwise logic to get a stable positive integer from bytes
    int hashInt = 0;
    for (int i = 0; i < 4; i++) {
      hashInt = (hashInt << 8) | digest.bytes[i];
    }

    // Ensure positive and pad to 5 digits
    final code = (hashInt.abs() % 100000).toString().padLeft(5, '0');
    return code;
  }

  /// Validates if the entered code matches the expected signature.
  static bool verifyCode({
    required String enteredCode,
    required String orderId,
    required double amount,
    required String shopId,
    required String? secret,
  }) {
    if (enteredCode.length != 5) return false;
    final expectedCode = generateVerificationCode(
      orderId: orderId,
      amount: amount,
      shopId: shopId,
      secret: secret,
    );
    return enteredCode == expectedCode;
  }
}
