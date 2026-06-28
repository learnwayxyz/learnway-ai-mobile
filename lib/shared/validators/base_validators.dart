class BaseValidators {
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (cleanedValue.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  static String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final phoneRegex = RegExp(r'^0(2|5)\d{8}$');

    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return 'Please enter a valid number (e.g., 0241234567)';
    }

    return null;
  }

  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+',
    ).hasMatch(value)) {
      return 'Password must contain a special character, uppercase,\n lowercase, and number';
    }

    return null;
  }

  // Passphrase validator with detailed requirements
  static String? passphrase(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a passphrase';
    }

    final validation = PassphraseValidator.validate(value);
    if (!validation.isValid) {
      return validation.firstError;
    }

    return null;
  }

  // Passphrase confirmation validator
  static String? passphraseConfirmation(
    String? value,
    String? originalPassphrase,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your passphrase';
    }

    if (value != originalPassphrase) {
      return 'Passphrases do not match';
    }

    return null;
  }

  // Required field validator
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter ${fieldName ?? 'this field'}';
    }
    return null;
  }

  // Minimum length validator
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${fieldName ?? 'this field'}';
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }

    return null;
  }

  // Composite validator - combines multiple validators
  static String? compose(
    List<String? Function(String?)> validators,
    String? value,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }

  static String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length != 4) {
      return 'OTP must be exactly 4 digits';
    }

    return null;
  }

  static String? validateUsername(String username) {
    if (username.trim().isEmpty) {
      return 'Username is required';
    }

    if (username.trim().length < 3) {
      return 'Username must be at least 3 characters long';
    }

    if (username.trim().length > 20) {
      return 'Username must be less than 20 characters long';
    }

    final RegExp allowedPattern = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!allowedPattern.hasMatch(username.trim())) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    if (RegExp(r'^[0-9]').hasMatch(username.trim())) {
      return 'Username cannot start with a number';
    }

    return null;
  }

  static String? validateWalletPin(String? pin) {
    if (pin == null || pin.trim().isEmpty) {
      return 'PIN is required';
    }
    final trimmedPin = pin.trim();
    if (trimmedPin.length < 4) {
      return 'PIN must be at least 4 digits long';
    }
    if (!_isNumeric(trimmedPin)) {
      return 'PIN must contain only numeric digits';
    }
    return null;
  }

  static bool _isNumeric(String str) {
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }

  static String? validatePinMatch(String? pin1, String? pin2) {
    if (pin1 == null || pin2 == null) {
      return 'Both PINs are required';
    }

    if (pin1.trim() != pin2.trim()) {
      return 'PINs do not match';
    }

    return null;
  }
}

class PassphraseValidator {
  static PassphraseValidationResult validate(String passphrase) {
    return PassphraseValidationResult(
      hasMinLength: passphrase.length >= 6,
      hasUppercase: passphrase.contains(RegExp(r'[A-Z]')),
      hasLowercase: passphrase.contains(RegExp(r'[a-z]')),
      hasNumber: passphrase.contains(RegExp(r'[0-9]')),
      hasSpecialChar: passphrase.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    );
  }

  static bool isValidPassphrase(String passphrase) {
    final result = validate(passphrase);
    return result.isValid;
  }

  static List<PassphraseRequirement> getRequirements(String passphrase) {
    final validation = validate(passphrase);
    return [
      PassphraseRequirement(
        text: 'At least 6 characters',
        isValid: validation.hasMinLength,
      ),
      PassphraseRequirement(
        text: 'One uppercase letter (A-Z)',
        isValid: validation.hasUppercase,
      ),
      PassphraseRequirement(
        text: 'One lowercase letter (a-z)',
        isValid: validation.hasLowercase,
      ),
      PassphraseRequirement(
        text: 'One number (0-9)',
        isValid: validation.hasNumber,
      ),
      PassphraseRequirement(
        text: 'One special character (!@#\$%^&*)',
        isValid: validation.hasSpecialChar,
      ),
    ];
  }
}

class PassphraseValidationResult {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;

  const PassphraseValidationResult({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  bool get isValid =>
      hasMinLength &&
      hasUppercase &&
      hasLowercase &&
      hasNumber &&
      hasSpecialChar;

  String? get firstError {
    if (!hasMinLength) return 'Passphrase must be at least 8 characters long';
    if (!hasUppercase) return 'Passphrase must contain an uppercase letter';
    if (!hasLowercase) return 'Passphrase must contain a lowercase letter';
    if (!hasNumber) return 'Passphrase must contain a number';
    if (!hasSpecialChar) return 'Passphrase must contain a special character';
    return null;
  }
}

class PassphraseRequirement {
  final String text;
  final bool isValid;

  const PassphraseRequirement({required this.text, required this.isValid});
}
