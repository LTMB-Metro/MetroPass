import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/email_model.dart';

class EmailService {
  static const String _resendApiKey = 're_g7yqaZU8_6A6jSEw7ERDjTma7YkvwCg9g';
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Send OTP email via Resend API
  Future<bool> sendOTPEmail(String email, String otpCode) async {
    try {
      print('Bắt đầu gửi email OTP đến: $email');
      final response = await http.post(
        Uri.parse('https://api.resend.com/emails'),
        headers: {
          'Authorization': 'Bearer $_resendApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': 'MetroPass <onboarding@resend.dev>',
          'to': [email],
          'subject': '🔐 Mã Xác Thực MetroPass',
          'html': _buildEmailTemplate(email, otpCode),
        }),
      );

      if (response.statusCode == 200) {
        print('Gửi email OTP thành công đến: $email');
        return true;
      } else {
        print('Gửi email OTP thất bại. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi gửi email OTP: $e');
      throw Exception('Lỗi gửi email: $e');
    }
  }

  /// Send OTP code for password reset
  Future<OTPResult> sendOTPCode(String email) async {
    try {
      print('Kiểm tra email trong hệ thống: $email');
      final userQuery = await _db
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        print('Email không tồn tại trong hệ thống: $email');
        return OTPResult.failure('Email không có trong hệ thống');
      }

      print('Tạo mã OTP mới cho email: $email');
      final emailOTP = EmailModel.createNewOTP(email);
      await _db.collection("password_reset_otps").add(emailOTP.toMap());
      print('Lưu mã OTP vào Firestore thành công');

      final emailSent = await sendOTPEmail(email, emailOTP.otpCode);

      if (emailSent) {
        print('Gửi mã OTP thành công đến email: $email');
        return OTPResult.success('Mã OTP đã được gửi đến email của bạn (hết hạn sau 60 giây)');
      } else {
        print('Gửi email OTP thất bại cho: $email');
        return OTPResult.failure('Không thể gửi email. Vui lòng thử lại');
      }
    } catch (e) {
      print('Lỗi khi gửi mã OTP: $e');
      return OTPResult.failure('Đã xảy ra lỗi: $e');
    }
  }

  /// Verify OTP code
  Future<OTPResult> verifyOTPCode(String email, String otpCode) async {
    try {
      print('Bắt đầu xác thực mã OTP cho email: $email');
      final otpQuery = await _db
          .collection("password_reset_otps")
          .where("email", isEqualTo: email)
          .where("otpCode", isEqualTo: otpCode)
          .where("isUsed", isEqualTo: false)
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      if (otpQuery.docs.isEmpty) {
        print('Không tìm thấy mã OTP hợp lệ cho email: $email với mã: $otpCode');
        return OTPResult.failure('Mã OTP không hợp lệ');
      }

      final otpDoc = otpQuery.docs.first;
      final emailModel = EmailModel.fromSnapshot(otpDoc);

      if (emailModel.isExpired) {
        print('Mã OTP đã hết hạn cho email: $email');
        return OTPResult.failure('Mã OTP đã hết hạn');
      }

      await otpDoc.reference.update({'isUsed': true});
      print('Đánh dấu mã OTP đã sử dụng thành công');

      return OTPResult.success('Xác thực mã OTP thành công');
    } catch (e) {
      print('Lỗi khi xác thực mã OTP: $e');
      return OTPResult.failure('Đã xảy ra lỗi: $e');
    }
  }

  /// Clean up expired OTP codes
  Future<void> cleanupExpiredOTPs() async {
    try {
      print('Bắt đầu dọn dẹp các mã OTP hết hạn');
      final now = DateTime.now();
      final expiredOTPs = await _db
          .collection("password_reset_otps")
          .where("expiresAt", isLessThan: Timestamp.fromDate(now))
          .get();

      print('Tìm thấy ${expiredOTPs.docs.length} mã OTP hết hạn cần xóa');
      for (final doc in expiredOTPs.docs) {
        await doc.reference.delete();
      }
      print('Dọn dẹp mã OTP hết hạn hoàn tất');
    } catch (e) {
      print('Lỗi khi dọn dẹp mã OTP hết hạn: $e');
      throw Exception('Lỗi dọn dẹp OTP hết hạn: $e');
    }
  }

  String _buildEmailTemplate(String email, String otpCode) {
    return '''
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background: #ffffff;">
        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center; color: white; border-radius: 10px 10px 0 0;">
          <h1 style="margin: 0; font-size: 28px;">MetroPass</h1>
          <p style="margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;">Xác Thực Tài Khoản</p>
        </div>
        
        <div style="background: #f8f9fa; padding: 40px 30px; border-radius: 0 0 10px 10px;">
          <h2 style="color: #333; margin: 0 0 20px 0; font-size: 24px;">Mã Xác Thực OTP</h2>
          
          <p style="color: #555; font-size: 16px; line-height: 1.6;">Xin chào,</p>
          <p style="color: #555; font-size: 16px; line-height: 1.6;">
            Bạn đã yêu cầu đặt lại mật khẩu cho: <strong style="color: #333;">$email</strong>
          </p>
          
          <div style="background: white; padding: 25px; border-radius: 12px; text-align: center; margin: 25px 0; border: 2px dashed #667eea; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <h1 style="color: #667eea; font-size: 42px; margin: 0; letter-spacing: 12px; font-weight: bold;">$otpCode</h1>
            <p style="color: #666; margin: 15px 0 0 0; font-size: 14px;">Mã xác thực của bạn</p>
          </div>
          
          <div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px 20px; margin: 20px 0; border-radius: 4px;">
            <p style="margin: 0; color: #856404; font-size: 14px;">
              <strong>⚠️ Quan trọng:</strong> Mã này sẽ hết hạn sau <strong>60 giây</strong>. 
              Không chia sẻ mã này với bất kỳ ai.
            </p>
          </div>
          
          <p style="color: #555; font-size: 16px; line-height: 1.6; margin-top: 25px;">
            Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.
          </p>
          
          <div style="border-top: 1px solid #eee; padding-top: 20px; margin-top: 30px;">
            <p style="color: #999; font-size: 12px; text-align: center; margin: 0;">
              Email này được gửi tự động từ hệ thống MetroPass.<br>
              Vui lòng không trả lời email này.<br><br>
              <strong>© 2024 MetroPass. Tất cả quyền được bảo lưu.</strong>
            </p>
          </div>
        </div>
      </div>
    ''';
  }
}

/// Result wrapper for OTP operations
class OTPResult {
  final bool success;
  final String message;

  OTPResult._({required this.success, required this.message});

  factory OTPResult.success(String message) {
    return OTPResult._(success: true, message: message);
  }

  factory OTPResult.failure(String message) {
    return OTPResult._(success: false, message: message);
  }
}