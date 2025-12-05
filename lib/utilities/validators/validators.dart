/// Comprehensive validation utilities for authentication forms
/// Handles email, password, name, CNIC, phone, expertise, and more
class AppValidators {
  // ============ EMAIL VALIDATION ============
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    if (value.length > 254) {
      return 'Email address is too long';
    }

    return null;
  }

  // ============ PASSWORD VALIDATION ============
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (value.length > 128) {
      return 'Password is too long';
    }

    // Optional: Stronger password rules

    if (!hasLowerCase(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!hasDigit(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // ============ NAME VALIDATION ============
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    final trimmed = value.trim();

    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters';
    }

    if (trimmed.length > 100) {
      return 'Name is too long';
    }

    // Only allow letters, spaces, hyphens, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Name can only contain character';
    }

    // Check for numbers (explicit check)
    if (hasDigit(trimmed)) {
      return 'Name cannot contain numbers';
    }

    // Check for multiple spaces
    if (trimmed.contains('  ')) {
      return 'Please use single spaces between names';
    }

    return null;
  }

  // ============ USERNAME VALIDATION ============
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 30) {
      return 'Username is too long';
    }

    // Allow only alphanumeric and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }


  // ============ CONFIRM PASSWORD VALIDATION ============
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ============ HELPER METHODS ============

  static bool hasUpperCase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  static bool hasLowerCase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  static bool hasDigit(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }

  static bool isNumeric(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  static bool isAlphanumeric(String value) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }

  static String sanitizeInput(String value) {
    return value.trim();
  }

  static bool isValidEmail(String email) {
    return validateEmail(email) == null;
  }

  static bool isValidPassword(String password) {
    return validatePassword(password) == null;
  }

  static bool isValidName(String name) {
    return validateName(name) == null;
  }
}
