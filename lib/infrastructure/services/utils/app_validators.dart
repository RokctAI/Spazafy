import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

abstract class AppValidators {
  AppValidators._();
  static bool isValidEmail(String email) => RegExp(
    "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$",
  ).hasMatch(email);

  static bool checkEmail(String email) =>
      RegExp("/^[0-9 ()+-]+\$/").hasMatch(email);

  static bool isValidPassword(String password) => password.length > 5;

  static String? isNotEmptyValidator(String? title) {
    if (title?.isEmpty ?? true) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    return null;
  }

  static String? emailCheck(String? text) {
    if (text == null || text.trim().isEmpty) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    if (!isValidEmail(text)) {
      return AppHelpers.getTranslation(TrKeys.emailIsNotValid);
    }
    return null;
  }

  static String? isValidPrice(String? title) {
    if (title?.isEmpty ?? true) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    } else if ((num.tryParse(title ?? "0") ?? 0) <= 0) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsNotMinusOrZero);
    }
    return null;
  }

  static bool isValidConfirmPassword(String password, String confirmPassword) =>
      password == confirmPassword;

  static bool arePasswordsTheSame(String password, String confirmPassword) =>
      password == confirmPassword;

  static String? maxQtyCheck(String? value, num? minQty) {
    if (value == null || value.isEmpty) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    final num? qty = num.tryParse(value);
    if (qty == null) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    if (minQty != null && qty < minQty) {
      return "Max quantity must be greater than min quantity";
    }
    return null;
  }

  static String? minQtyCheck(String? value) {
    if (value == null || value.isEmpty) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    final num? qty = num.tryParse(value);
    if (qty == null) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    if (qty <= 0) {
      return "Min quantity must be greater than 0";
    }
    return null;
  }

  static String? emptyCheck(String? text) {
    if (text == null || text.trim().isEmpty) {
      return AppHelpers.getTranslation(TrKeys.thisFieldIsRequired);
    }
    return null;
  }
}
