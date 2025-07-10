class Validators {
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _nameRegex = RegExp(r'^[a-zA-ZÀ-ỹ\s]+$');
  static final _passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)');
  static final _otpRegex = RegExp(r'^[0-9]+$');
  // Regex cho số điện thoại Việt Nam (bắt đầu bằng 0, có 10 chữ số)
  static final _phoneRegex = RegExp(r'^0[3|5|7|8|9][0-9]{8}$');

  // Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final email = value.trim();
    if (!_emailRegex.hasMatch(email)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // Validate email for submission
  static String? validateEmailRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    return validateEmail(value);
  }

  // Validate password format
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  // Validate password for submission
  static String? validatePasswordRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    return validatePassword(value);
  }

  // Validate strong password
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    if (!_passwordRegex.hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ cái và 1 chữ số';
    }
    return null;
  }

  // Validate strong password for submission
  static String? validateStrongPasswordRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    return validateStrongPassword(value);
  }

  // Validate confirm password
  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) return null;

    if (value != originalPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  // Validate confirm password for submission
  static String? validateConfirmPasswordRequired(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    return validateConfirmPassword(value, originalPassword);
  }

  // Validate username/name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final name = value.trim();
    if (name.length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }

    if (name.length > 50) {
      return 'Tên không được quá 50 ký tự';
    }

    if (!_nameRegex.hasMatch(name)) {
      return 'Tên chỉ được chứa chữ cái và khoảng trắng';
    }
    return null;
  }

  // Validate username for submission
  static String? validateNameRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên người dùng';
    }
    return validateName(value);
  }

  // Validate OTP code
  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final otp = value.trim();
    if (otp.length != 6) {
      return 'Mã xác thực phải có 6 chữ số';
    }

    if (!_otpRegex.hasMatch(otp)) {
      return 'Mã xác thực chỉ được chứa số';
    }
    return null;
  }

  // Validate OTP for submission
  static String? validateOTPRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mã xác thực';
    }
    return validateOTP(value);
  }

  // Validate phone number format (Vietnam)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final phone = value.trim().replaceAll(' ', '').replaceAll('-', '');

    if (phone.length != 10) {
      return 'Số điện thoại phải có đúng 10 chữ số';
    }

    if (!phone.startsWith('0')) {
      return 'Số điện thoại phải bắt đầu bằng số 0';
    }

    if (!_phoneRegex.hasMatch(phone)) {
      return 'Số điện thoại không đúng định dạng Việt Nam';
    }
    return null;
  }

  // Validate phone number for submission
  static String? validatePhoneNumberRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    return validatePhoneNumber(value);
  }

  // Check if email is valid
  static bool isEmailValid(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  // Check if OTP is valid
  static bool isOTPValid(String otp) {
    return otp.length == 6 && _otpRegex.hasMatch(otp);
  }

  // Check if phone number is valid
  static bool isPhoneNumberValid(String phone) {
    final cleanPhone = phone.trim().replaceAll(' ', '').replaceAll('-', '');
    return cleanPhone.length == 10 && _phoneRegex.hasMatch(cleanPhone);
  }
}
