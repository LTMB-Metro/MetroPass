import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  final String city = 'Ho Chi Minh';

  Future<Map<String, dynamic>?> fetchWeather() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
        print("🌍 URL gọi API: $url");
    final response = await http.get(url);
    print("📥 Status code: ${response.statusCode}");
  print("📄 Body: ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('❌ Lỗi khi lấy dữ liệu thời tiết: ${response.statusCode}');;
      return null;
    }
  }
}
