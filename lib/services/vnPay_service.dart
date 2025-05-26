import 'dart:convert';
import 'package:http/http.dart' as http;

class VNPayService {
  static Future<String?> createPayment(String orderId, int amount) async {
    try {
      final response = await http.post(
        Uri.parse('http://xjnmvppb.infinityfreeapp.com/vnpay_create_payment.php'),
        body: {
          'order_id': orderId,
          'amount': amount.toString(),
        },
      );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['payment_url'];
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi tạo thanh toán: $e');
      return null;
    }
  }
}
