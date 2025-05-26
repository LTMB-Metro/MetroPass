import 'package:flutter/material.dart';
import '../themes/colors/colors.dart';

class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 30.0;
  static const double xxxl = 40.0;
  static const double xxxxl = 50.0;
}

/// UI Dimensions
class AppDimensions {
  static const double defaultPadding = 25.0;
  static const double buttonHeight = 50.0;
  static const double inputHeight = 45.0;
  static const double borderRadius = 10.0;
  static const double roundBorderRadius = 22.0;
  static const double iconSize = 20.0;
  static const double backButtonSize = 40.0;
}

/// Animation durations
class AppDurations {
  static const Duration short = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 1000);
  static const Duration extraLong = Duration(milliseconds: 1500);
}

/// Common text styles
class AppTextStyles {
  static const TextStyle greeting = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(MyColor.black),
  );

  static const TextStyle title = TextStyle(
    color: Color(MyColor.pr8),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: Color(MyColor.grey),
    fontSize: 14,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(MyColor.pr8),
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: Color(MyColor.black),
  );

  static const TextStyle errorText = TextStyle(
    color: Colors.red,
    fontSize: 12,
  );
}

/// Common decorations
class AppDecorations {
  static BoxDecoration get backButton => BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration roundedInput({bool hasError = false}) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppDimensions.roundBorderRadius),
    border: Border.all(
      color: hasError ? Colors.red : const Color(MyColor.pr3),
      width: 1,
    ),
  );

  static BoxDecoration get dividerLine => BoxDecoration(
    color: const Color(MyColor.pr3).withValues(alpha: 0.3),
  );
}

/// Message templates
class AppMessages {
  // Success messages
  static const String loginSuccess = 'Đăng nhập thành công';
  static const String registerSuccess = 'Đăng ký thành công! Vui lòng đăng nhập.';
  static const String googleSignInSuccess = 'Đăng nhập Google thành công';
  static const String otpSent = 'Mã OTP đã được gửi đến email của bạn';
  static const String otpResent = 'Đã gửi lại mã OTP';
  static const String verificationSuccess = 'Xác thực thành công! Đường dẫn đặt lại mật khẩu đã được gửi đến email của bạn.';

  // Error messages
  static const String loginFailed = 'Đăng nhập thất bại';
  static const String registerFailed = 'Đăng ký thất bại';
  static const String googleSignInFailed = 'Đăng nhập Google thất bại';
  static const String otpSendFailed = 'Gửi mã OTP thất bại';
  static const String otpResendFailed = 'Gửi lại mã OTP thất bại';
  static const String invalidOTP = 'Mã OTP không hợp lệ';
  static const String fillAllFields = 'Vui lòng điền đầy đủ thông tin hợp lệ';
  static const String enterValidEmail = 'Vui lòng nhập email hợp lệ';
  static const String enterValidOTP = 'Vui lòng nhập mã xác thực hợp lệ';
  static const String waitToResend = 'Vui lòng đợi {countdown}s để gửi lại';
  static const String genericError = 'Có lỗi xảy ra: {error}';

  // Info messages
  static const String forgotPasswordInfo = 'Nhập email để nhận mã xác nhận';
  static const String verificationInfo = 'Mã xác nhận đã được gửi đến email:\n{email}';
  static const String didntReceiveCode = 'Không nhận được mã? ';
  static const String resendText = 'Gửi lại';
  static const String resendWithCountdown = 'Gửi lại ({countdown}s)';
  static const String changeEmail = 'Thay đổi Email';
  static const String haveAccount = 'Bạn đã có tài khoản?';
  static const String noAccount = 'Bạn chưa có tài khoản?';
  static const String orText = 'hoặc';
}

/// Asset paths
class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String loginBackground = 'assets/images/login.png';
  static const String googleIcon = 'assets/images/email.png';
  static const String defaultAvatar = 'https://img.lovepik.com/free-png/20211204/lovepik-cartoon-avatar-png-image_401302777_wh1200.png';
}