import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/email_service.dart';
import '../services/auth_service.dart';

enum PasswordResetStep {
  enterEmail,
  sendingOTP,
  enterOTP,
  verifyingOTP,
  completed,
}

class PasswordResetController extends ChangeNotifier {
  final EmailService _emailService = EmailService();
  final AuthService _authService = AuthService();

  PasswordResetStep _currentStep = PasswordResetStep.enterEmail;
  String _email = '';
  String? _errorMessage;
  bool _isLoading = false;
  int _otpResendCooldown = 0;
  BuildContext? _context;

  // Getters
  PasswordResetStep get currentStep => _currentStep;
  String get email => _email;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get canResendOTP => _otpResendCooldown == 0;
  int get otpResendCooldown => _otpResendCooldown;

  /// Set context for the controller
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Send OTP to email
  Future<bool> sendOTP(String email) async {
    _setLoading(true);
    _clearError();
    _email = email;

    try {
      print('Gửi OTP đến email: $email');
      final result = await _emailService.sendOTPCode(email);

      if (result.success) {
        print('Gửi OTP thành công');
        _setStep(PasswordResetStep.enterOTP);
        _startResendCooldown();
        _setLoading(false);
        return true;
      } else {
        print('Gửi OTP thất bại: ${result.message}');
        _setError(result.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Lỗi khi gửi OTP: $e');
      _setError('Lỗi gửi OTP: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Verify OTP code and send password reset email
  Future<bool> verifyOTPAndSendResetEmail(String otpCode) async {
    if (_context == null) {
      _setError('Context is not set');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      print('Xác thực OTP: $otpCode cho email: $_email');
      final otpResult = await _emailService.verifyOTPCode(_email, otpCode);

      if (otpResult.success) {
        print('Xác thực OTP thành công, gửi email đặt lại mật khẩu');

        // Send password reset email after successful OTP verification
        final resetResult = await _authService.resetPassword(_email, _context!);

        if (resetResult['success']) {
          print('Gửi email đặt lại mật khẩu thành công');
          _setStep(PasswordResetStep.completed);
          _setLoading(false);
          return true;
        } else {
          print(
            'Gửi email đặt lại mật khẩu thất bại: ${resetResult['message']}',
          );
          _setError(
            'Gửi email đặt lại mật khẩu thất bại: ${resetResult['message']}',
          );
          _setLoading(false);
          return false;
        }
      } else {
        print('Xác thực OTP thất bại: ${otpResult.message}');
        _setError(otpResult.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Lỗi khi xác thực OTP: $e');
      _setError('Lỗi xác thực OTP: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Resend OTP code
  Future<bool> resendOTP() async {
    if (_otpResendCooldown > 0) return false;

    _setLoading(true);
    _clearError();

    try {
      print('Gửi lại OTP đến email: $_email');
      final result = await _emailService.sendOTPCode(_email);

      if (result.success) {
        print('Gửi lại OTP thành công');
        _startResendCooldown();
        _setLoading(false);
        return true;
      } else {
        print('Gửi lại OTP thất bại: ${result.message}');
        _setError(result.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Lỗi khi gửi lại OTP: $e');
      _setError('Lỗi gửi lại OTP: $e');
      _setLoading(false);
      return false;
    }
  }

  // Navigation methods
  void goBackToEmail() {
    print('Quay lại bước nhập email');
    _setStep(PasswordResetStep.enterEmail);
    _clearError();
  }

  /// Reset entire flow
  void resetFlow() {
    print('Đặt lại toàn bộ quá trình reset mật khẩu');
    _currentStep = PasswordResetStep.enterEmail;
    _email = '';
    _errorMessage = null;
    _isLoading = false;
    _otpResendCooldown = 0;
    notifyListeners();
  }

  void _setStep(PasswordResetStep step) {
    _currentStep = step;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() => _clearError();

  void _startResendCooldown() {
    _otpResendCooldown = 60;
    _updateCooldown();
  }

  void _updateCooldown() {
    if (_otpResendCooldown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        _otpResendCooldown--;
        notifyListeners();
        if (_otpResendCooldown > 0) {
          _updateCooldown();
        }
      });
    }
  }

  // Validation helpers
  bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isOTPValid(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
