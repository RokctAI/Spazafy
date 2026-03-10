class AppValidators {
  static String? Function(String?) required(
    String message, {
    int maxLength = 255,
  }) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      if (value.length > maxLength) {
        return 'Input too long (max $maxLength characters)';
      }
      return null;
    };
  }

  static String? price(String? value, {int maxLength = 255}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a price';
    }
    if (value.length > maxLength) {
      return 'Input too long (max $maxLength characters)';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }
}
