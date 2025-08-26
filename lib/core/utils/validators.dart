class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Optional: Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character (!@#\$%^&*)';
    }

    return null;
  }

  // Simple password validation (for login)
  static String? validateSimplePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Full name validation
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }

    // Remove extra spaces and check if it's just whitespace
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return 'Please enter your full name';
    }

    // Check if it contains at least first and last name (2 words)
    final nameParts =
        trimmedValue.split(' ').where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      return 'Please enter your full name (first and last name)';
    }

    // Check if each part has at least 2 characters
    for (final part in nameParts) {
      if (part.length < 2) {
        return 'Each name part must be at least 2 characters';
      }
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid phone number (7-15 digits)
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 20) {
      return 'Username must be less than 20 characters';
    }

    // Check if username contains only letters, numbers, and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }

    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Please enter a valid URL (e.g., https://example.com)';
      }
    } catch (e) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Date validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a date';
    }

    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Please enter a valid date';
    }

    return null;
  }

  // Age validation
  static String? validateAge(int? age) {
    if (age == null) {
      return 'Please enter your age';
    }

    if (age < 13) {
      return 'You must be at least 13 years old';
    }

    if (age > 120) {
      return 'Please enter a valid age';
    }

    return null;
  }

  // Credit card validation (Luhn algorithm)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a credit card number';
    }

    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it's all digits
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return 'Credit card number can only contain digits';
    }

    // Check length (13-19 digits)
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return 'Credit card number must be 13-19 digits';
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
      return 'Invalid credit card number';
    }

    return null;
  }

  // Postal code validation
  static String? validatePostalCode(String? value, String countryCode) {
    if (value == null || value.isEmpty) {
      return 'Please enter a postal code';
    }

    switch (countryCode.toUpperCase()) {
      case 'US':
        // US ZIP code: 5 digits or 5+4 format
        if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(value)) {
          return 'Please enter a valid US ZIP code';
        }
        break;
      case 'CA':
        // Canadian postal code: A1A 1A1 format
        if (!RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$').hasMatch(value)) {
          return 'Please enter a valid Canadian postal code';
        }
        break;
      case 'UK':
        // UK postcode: Various formats
        if (!RegExp(
          r'^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$',
          caseSensitive: false,
        ).hasMatch(value)) {
          return 'Please enter a valid UK postcode';
        }
        break;
      default:
        // Generic validation for other countries
        if (value.length < 3 || value.length > 10) {
          return 'Please enter a valid postal code';
        }
    }

    return null;
  }

  // Social Security Number validation (US)
  static String? validateSSN(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Social Security Number';
    }

    // Remove dashes and spaces
    final cleanSSN = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it's exactly 9 digits
    if (!RegExp(r'^\d{9}$').hasMatch(cleanSSN)) {
      return 'SSN must be exactly 9 digits';
    }

    // Check for invalid patterns
    if (cleanSSN == '000000000' ||
        cleanSSN == '111111111' ||
        cleanSSN == '999999999' ||
        cleanSSN.startsWith('000') ||
        cleanSSN.startsWith('666') ||
        cleanSSN.startsWith('9')) {
      return 'Invalid SSN';
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
    return 'Very Weak';
  }
}
