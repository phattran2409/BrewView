class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email của bạn';
    }

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Vui lòng nhập địa chỉ email hợp lệ';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một chữ cái in hoa';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một chữ cái thường';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một số';
    }

    // Optional: Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt (!@#\$%^&*)';
    }

    return null;
  }

  // Simple password validation (for login)
  static String? validateSimplePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu của bạn';
    }

    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }

    if (value != password) {
      return 'Mật khẩu không khớp';
    }

    return null;
  }

  // Full name validation
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }

    // Remove extra spaces and check if it's just whitespace
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }

    // Check if it contains at least first and last name (2 words)
    final nameParts =
        trimmedValue.split(' ').where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      return 'Vui lòng nhập đầy đủ họ và tên';
    }

    // Check if each part has at least 2 characters
    for (final part in nameParts) {
      if (part.length < 2) {
        return 'Mỗi phần của tên phải có ít nhất 2 ký tự';
      }
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid phone number (7-15 digits)
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Vui lòng nhập số điện thoại hợp lệ';
    }

    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên người dùng';
    }

    if (value.length < 3) {
      return 'Tên người dùng phải có ít nhất 3 ký tự';
    }

    if (value.length > 20) {
      return 'Tên người dùng phải ít hơn 20 ký tự';
    }

    // Check if username contains only letters, numbers, and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Tên người dùng chỉ được chứa chữ cái, số và dấu gạch dưới';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập URL';
    }

    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Vui lòng nhập URL hợp lệ (ví dụ: https://example.com)';
      }
    } catch (e) {
      return 'Vui lòng nhập URL hợp lệ';
    }

    return null;
  }

  // Date validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập ngày';
    }

    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Vui lòng nhập ngày hợp lệ';
    }

    return null;
  }

  // Age validation
  static String? validateAge(int? age) {
    if (age == null) {
      return 'Vui lòng nhập tuổi của bạn';
    }

    if (age < 13) {
      return 'Bạn phải từ 13 tuổi trở lên';
    }

    if (age > 120) {
      return 'Vui lòng nhập tuổi hợp lệ';
    }

    return null;
  }

  // Credit card validation (Luhn algorithm)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số thẻ tín dụng';
    }

    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it's all digits
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return 'Số thẻ tín dụng chỉ được chứa số';
    }

    // Check length (13-19 digits)
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return 'Số thẻ tín dụng phải từ 13-19 số';
    }

    // Luhn algorithm validation
    int sum = 0;
    bool alternate = false;

    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cleanNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'Số thẻ tín dụng không hợp lệ';
    }

    return null;
  }

  // Postal code validation
  static String? validatePostalCode(String? value, String countryCode) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã bưu điện';
    }

    switch (countryCode.toUpperCase()) {
      case 'US':
        // US ZIP code: 5 digits or 5+4 format
        if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(value)) {
          return 'Vui lòng nhập mã ZIP hợp lệ của Mỹ';
        }
        break;
      case 'CA':
        // Canadian postal code: A1A 1A1 format
        if (!RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$').hasMatch(value)) {
          return 'Vui lòng nhập mã bưu điện hợp lệ của Canada';
        }
        break;
      case 'UK':
        // UK postcode: Various formats
        if (!RegExp(
          r'^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$',
          caseSensitive: false,
        ).hasMatch(value)) {
          return 'Vui lòng nhập mã bưu điện hợp lệ của Anh';
        }
        break;
      default:
        // Generic validation for other countries
        if (value.length < 3 || value.length > 10) {
          return 'Vui lòng nhập mã bưu điện hợp lệ';
        }
    }

    return null;
  }

  // Social Security Number validation (US)
  static String? validateSSN(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số an sinh xã hội';
    }

    // Remove dashes and spaces
    final cleanSSN = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it's exactly 9 digits
    if (!RegExp(r'^\d{9}$').hasMatch(cleanSSN)) {
      return 'Số an sinh xã hội phải có đúng 9 số';
    }

    // Check for invalid patterns
    if (cleanSSN == '000000000' ||
        cleanSSN == '111111111' ||
        cleanSSN == '999999999' ||
        cleanSSN.startsWith('000') ||
        cleanSSN.startsWith('666') ||
        cleanSSN.startsWith('9')) {
      return 'Số an sinh xã hội không hợp lệ';
    }

    return null;
  }

  // Password strength checker
  static Map<String, bool> checkPasswordStrength(String password) {
    return {
      'length': password.length >= 8,
      'uppercase': RegExp(r'[A-Z]').hasMatch(password),
      'lowercase': RegExp(r'[a-z]').hasMatch(password),
      'numbers': RegExp(r'[0-9]').hasMatch(password),
      'special': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
    };
  }

  // Get password strength score (0-100)
  static int getPasswordStrengthScore(String password) {
    final checks = checkPasswordStrength(password);
    int score = 0;

    if (checks['length']!) score += 20;
    if (checks['uppercase']!) score += 20;
    if (checks['lowercase']!) score += 20;
    if (checks['numbers']!) score += 20;
    if (checks['special']!) score += 20;

    // Bonus for longer passwords
    if (password.length >= 12) score += 10;
    if (password.length >= 16) score += 10;

    return score;
  }

  // Get password strength level
  static String getPasswordStrengthLevel(String password) {
    final score = getPasswordStrengthScore(password);

    if (score >= 90) return 'Very Strong';
    if (score >= 80) return 'Strong';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    if (score >= 20) return 'Weak';
    return 'Rất yếu';
  }
}
