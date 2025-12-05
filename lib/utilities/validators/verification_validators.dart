/// Comprehensive validators for volunteer verification form fields
class VerificationValidators {
  /// Validate full name (3-50 chars, letters/spaces/apostrophes only, no numbers, no hyphens)
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    value = value.trim();

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    // Check for numbers
    if (RegExp(r'\d').hasMatch(value)) {
      return 'Name cannot contain numbers';
    }

    // Check for hyphens
    if (value.contains('-')) {
      return 'Name cannot contain hyphens';
    }

    // Allow letters, spaces, apostrophes only
    if (!RegExp(r"^[a-zA-Z\s']+$").hasMatch(value)) {
      return 'Name can only contain characters';
    }

    return null;
  }

  /// Validate expertise field (3-100 chars, alphanumeric, spaces, commas, ampersands)
  static String? validateExpertise(String? value) {
    if (value == null || value.isEmpty) {
      return 'Area of expertise is required';
    }

    value = value.trim();

    if (value.length < 3) {
      return 'Expertise must be at least 3 characters';
    }

    if (value.length > 100) {
      return 'Expertise must not exceed 100 characters';
    }

    // Allow alphanumeric, spaces, commas, ampersands, and hyphens
    if (!RegExp(r"^[a-zA-Z0-9\s,&\-]+$").hasMatch(value)) {
      return 'Expertise contains invalid characters';
    }

    return null;
  }

  /// Validate CNIC (Pakistani: exactly 13 digits, format: XXXXX-XXXXXXX-X)
  static String? validateCNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNIC is required';
    }

    // Remove hyphens for counting
    final cleanCNIC = value.replaceAll('-', '').trim();

    if (cleanCNIC.length != 13) {
      return 'CNIC must be exactly 13 digits (format: XXXXX-XXXXXXX-X)';
    }

    if (!RegExp(r'^\d{13}$').hasMatch(cleanCNIC)) {
      return 'CNIC must contain only digits';
    }

    return null;
  }

  /// Validate Pakistani CNIC checksum (mod-11 algorithm)
  static bool validatePakistaniCNICChecksum(String cnic) {
    if (cnic.length != 13) return false;

    const weights = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int sum = 0;

    for (int i = 0; i < 12; i++) {
      final digit = int.parse(cnic[i]);
      sum += digit * weights[i];
    }

    final remainder = sum % 11;
    final checkDigit = (remainder == 0) ? 0 : (11 - remainder);
    final cnicCheckDigit = int.parse(cnic[12]);

    return checkDigit == cnicCheckDigit;
  }

  /// Validate description/reason (10-500 chars)
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please tell us why you want to volunteer';
    }

    value = value.trim();

    if (value.length < 10) {
      return 'Description must be at least 10 characters';
    }

    if (value.length > 500) {
      return 'Description must not exceed 500 characters';
    }

    return null;
  }

  /// Validate city (2-50 chars, letters/spaces/hyphens/apostrophes only)
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }

    value = value.trim();

    if (value.length < 2) {
      return 'City must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'City must not exceed 50 characters';
    }

    // Check for numbers
    if (RegExp(r'\d').hasMatch(value)) {
      return 'City cannot contain numbers';
    }

    // Allow letters, spaces, hyphens, apostrophes
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'City can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  /// Validate location (3-100 chars, alphanumeric with common location symbols)
  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }

    value = value.trim();

    if (value.length < 3) {
      return 'Location must be at least 3 characters';
    }

    if (value.length > 100) {
      return 'Location must not exceed 100 characters';
    }

    // Allow alphanumeric, spaces, commas, hyphens, slashes (for coordinates or addresses)
    if (!RegExp(r"^[a-zA-Z0-9\s,\-/\.()]+$").hasMatch(value)) {
      return 'Location contains invalid characters';
    }

    return null;
  }
}
