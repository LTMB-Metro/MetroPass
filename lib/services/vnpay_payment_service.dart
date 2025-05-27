import 'dart:convert';
import 'package:http/http.dart' as http;

/// Gửi request đến server VNPay của bạn và nhận lại URL thanh toán
Future<String?> createVNPayPayment(int amount) async {
  try {
    final response = await http.post(
      Uri.parse('https://vnpay-render.onrender.com/vnpay_create_payment.php'),
      body: {
        'order_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'amount': amount.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final url = data['url'];

      // Xử lý nếu JSON bị escape ký tự \/
      if (url != null && url is String) {
        return url.replaceAll(r'\/', '/');
      }
    } else {
      print("VNPay API lỗi: ${response.statusCode}");
      print("Phản hồi: ${response.body}");
    }
  } catch (e) {
    print("VNPay error: $e");
  }
  return null;
}
