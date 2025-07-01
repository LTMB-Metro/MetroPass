import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> fallbackToOpenRouter(String prompt) async {
  final apiKey = dotenv.env['OPENROUTER_API_KEY'];
  const endpoint = 'https://openrouter.ai/api/v1/chat/completions';

  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
    'HTTP-Referer': 'https://your-app-domain.com', // đổi thành domain app nếu có
    'X-Title': 'MetroPassApp',
  };

  final body = jsonEncode({
    'model': 'mistralai/mistral-7b-instruct', // ✅ model hợp lệ
    'messages': [
      {
        'role': 'system',
        'content': 'Bạn là trợ lý AI MetroPass, hỗ trợ người dùng các câu hỏi liên quan đến tuyến Metro.'
      },
      {
        'role': 'user',
        'content': prompt
      }
    ],
    'temperature': 0.6,
  });

  final response = await http.post(Uri.parse(endpoint), headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content']?.trim() ?? 'Không có phản hồi từ OpenRouter.';
  } else {
    return 'Tôi chưa hiểu câu hỏi của bạn cho lắm. Bạn muốn mình hooxo trợ về gì?'
    '\n-Thông tin giá vé'
    '\n-Thông tin các ga'
    '\n...';
  }
}
