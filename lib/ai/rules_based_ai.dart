import 'dart:convert';
import 'package:metropass/controllers/station_controller.dart';
import 'package:metropass/models/station_model.dart';

Future<String> getAIResponse(String input) async {
  final text = input.toLowerCase();

  // Chào hỏi và giới thiệu
  if (_matchesAny(text, [
    'xin chào', 'chào', 'hello', 'hi', 'good morning', 'good afternoon', 'good evening',
    'chào buổi sáng', 'chào buổi chiều', 'chào buổi tối'
  ])) {
    return 'Xin chào! Tôi là trợ lý AI MetroPass. Tôi có thể giúp bạn:\n'
        '- Tìm hiểu về các loại vé và giá cả\n'
        '- Xem thông tin các ga\n'
        '- Hướng dẫn đặt vé\n'
        '- Giải đáp thắc mắc về quy định\n'
        'Bạn cần hỗ trợ gì ạ?';
  }

  // Giới thiệu về bản thân
  if (_matchesAny(text, [
    'bạn là ai', 'bạn tên gì', 'ai đang trả lời', 'who are you',
    'bạn có thể làm gì', 'bạn giúp được gì'
  ])) {
    return 'Tôi là trợ lý AI MetroPass, được thiết kế để hỗ trợ bạn trong việc:\n'
        '- Tìm hiểu và đặt vé metro\n'
        '- Cung cấp thông tin về các ga\n'
        '- Hướng dẫn sử dụng dịch vụ\n'
        '- Giải đáp các thắc mắc thường gặp\n'
        'Bạn có thể hỏi tôi bất kỳ điều gì liên quan đến dịch vụ MetroPass.';
  }

  // Thông tin về số lượng ga
  if (_matchesAny(text, [
    'bao nhiêu ga', 'số lượng ga', 'số ga', 'có mấy ga',
    'tổng số ga', 'tuyến có mấy ga'
  ])) {
    final stations = await StationController().getAllStations();
    return 'Tuyến Metro hiện có ${stations.length} ga. Bạn có muốn xem danh sách các ga không?';
  }

  // Danh sách các ga
  if (_matchesAny(text, [
    'danh sách ga', 'liệt kê ga', 'tên các ga',
    'các ga', 'ga nào', 'ga gì'
  ])) {
    final stations = await StationController().getAllStations();
    final stationNames = stations.map((s) => '- ${s.stationName}').join('\n');
    return 'Danh sách các ga trên tuyến Metro:\n$stationNames\n'
        'Bạn muốn biết thêm thông tin về ga nào không?';
  }

  // Thông tin về ga đầu/ga cuối
  if (_matchesAny(text, ['ga đầu', 'ga xuất phát', 'ga bắt đầu'])) {
    final stations = await StationController().getAllStations();
    stations.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return 'Ga đầu tuyến là: ${stations.first.stationName}';
  }
  if (_matchesAny(text, ['ga cuối', 'ga kết thúc', 'ga cuối cùng'])) {
    final stations = await StationController().getAllStations();
    stations.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return 'Ga cuối tuyến là: ${stations.last.stationName}';
  }

  // Thông tin chi tiết về một ga cụ thể
  final gaInfoReg = RegExp(r'thông tin ga (.+)', caseSensitive: false, unicode: true);
  final gaInfoMatch = gaInfoReg.firstMatch(text);
  if (gaInfoMatch != null) {
    final gaName = gaInfoMatch.group(1)?.trim();
    final stations = await StationController().getAllStations();
    try {
      final ga = stations.firstWhere(
        (s) => s.stationName.toLowerCase() == gaName?.toLowerCase(),
      );
      return 'Thông tin ga ${ga.stationName}:\n'
          '- Mã ga: ${ga.code}\n'
          '- Loại ga: ${(ga.type == 'underground') ? 'Ga ngầm' : 'Ga trên cao'}\n'
          '- Tuyến: ${ga.zone}\n'
          '- Vị trí: ${ga.orderIndex}${_getOrdinalSuffix(ga.orderIndex)} ga trên tuyến';
    } catch (_) {
      return 'Không tìm thấy ga "$gaName". Bạn vui lòng kiểm tra lại tên ga.';
    }
  }

  // Giá vé lượt
  if (_matchesAny(text, ['vé lượt', 'vé lượt', 'giá vé lượt'])) {
    final stations = await StationController().getAllStations();
    final stationNames = stations.map((s) => '- ${s.stationName}').join('\n');
    return 'Giá vé lượt phụ thuộc vào khoảng cách giữa các ga:\n'
        '- 1-3 ga: 6.000đ\n'
        '- Mỗi ga tiếp theo: +1.000đ\n'
        'Hiện tại có các ga sau:\n'
        '$stationNames\n'
        'Bạn muốn đi từ ga nào đến ga nào? Vui lòng nhập theo mẫu: "Từ [Tên ga đi] đến [Tên ga đến]".';
  }

  // Giá vé ngày
  if (_matchesAny(text, ['vé 1 ngày', 'vé 1 ngày'])) {
    return jsonEncode({
      'message': 'Giá vé ngày: 40.000đ/ngày\n'
          '- Đi không giới hạn trong ngày\n'
          '- Tự động kích hoạt sau 30 ngày kể từ ngày mua vé\n'
          'Bạn muốn đặt vé ngày này không?',
      'action': 'payment',
      'ticket': {
        'description': 'Vé đi không giới hạn trong 1 ngày',
        'duration': 1,
        'note': 'Tự động kích hoạt sau 30 ngày kể từ ngày mua vé',
        'ticket_name': 'Vé ngày',
        'type': 'daily1',
        'categories': 'normal',
        'price': 40000,
        'from_code': '',
        'to_code': '',
        'qr_code_URL': ''
      }
    });
  }

  if (_matchesAny(text, ['vé 3 ngày', 'vé 3 ngày'])) {
    return jsonEncode({
      'message': 'Giá vé 3 ngày: 90.000đ/3 ngày\n'
          '- Đi không giới hạn trong 3 ngày\n'
          '- Tự động kích hoạt sau 90 ngày kể từ ngày mua vé\n'
          'Bạn muốn đặt vé này không?',
      'action': 'payment',
      'ticket': {
        'description': 'Vé đi không giới hạn trong 3 ngày',
        'duration': 3,
        'note': 'Tự động kích hoạt sau 90 ngày kể từ ngày mua vé',
        'ticket_name': 'Vé 3 ngày',
        'type': 'daily3',
        'categories': 'normal',
        'price': 90000,
        'from_code': '',
        'to_code': '',
        'qr_code_URL': ''
      }
    });
  }

  // Giá vé tháng
  if (_matchesAny(text, ['vé tháng', 'vé tháng'])) {
    return jsonEncode({
      'message': 'Giá vé tháng:\n'
          '- Người lớn: 300.000đ/tháng\n'
          '- Học sinh, sinh viên: 150.000đ/tháng\n'
          '- Đi không giới hạn trong tháng\n'
          '- Tự động kích hoạt sau 180 ngày kể từ ngày mua vé\n'
          'Bạn muốn đặt vé tháng không?',
      'action': 'payment',
      'ticket': {
        'description': 'Vé đi không giới hạn trong 1 tháng',
        'duration': 30,
        'note': 'Tự động kích hoạt sau 180 ngày kể từ ngày mua vé',
        'ticket_name': 'Vé tháng',
        'type': 'monthly',
        'categories': 'normal',
        'price': 300000,
        'from_code': '',
        'to_code': '',
        'qr_code_URL': ''
      }
    });
  }

  // Giá vé học sinh/sinh viên
  if (_matchesAny(text, ['giá vé học sinh', 'giá vé sinh viên', 'vé học sinh', 'vé sinh viên'])) {
    return jsonEncode({
      'message': 'Giá vé tháng học sinh, sinh viên:\n'
          '- 150.000đ/tháng\n'
          '- Đi không giới hạn trong tháng\n'
          '- Tự động kích hoạt sau 180 ngày kể từ ngày mua vé\n'
          '- Cần xuất trình thẻ học sinh/sinh viên khi sử dụng\n'
          'Bạn muốn đặt vé tháng học sinh/sinh viên không?',
      'action': 'payment',
      'ticket': {
        'description': 'Vé đi không giới hạn trong 1 tháng cho học sinh/sinh viên',
        'duration': 30,
        'note': 'Tự động kích hoạt sau 180 ngày kể từ ngày mua vé. Cần xuất trình thẻ học sinh/sinh viên khi sử dụng.',
        'ticket_name': 'Vé tháng học sinh/sinh viên',
        'type': 'HSSV',
        'categories': 'student',
        'price': 150000,
        'from_code': '',
        'to_code': '',
        'qr_code_URL': ''
      }
    });
  }

  // Hướng dẫn đặt vé
  if (_matchesAny(text, ['đặt vé', 'mua vé', 'cách đặt vé', 'cách mua vé'])) {
    return 'Để đặt vé, bạn có thể:\n'
        '1. Chọn loại vé phù hợp (vé lượt, vé ngày, vé tháng)\n'
        '2. Nếu là vé lượt, chọn ga đi và ga đến\n'
        '3. Chọn phương thức thanh toán\n'
        '4. Xác nhận thông tin và hoàn tất đặt vé\n'
        'Bạn muốn đặt loại vé nào?';
  }

  // Giờ hoạt động
  if (_matchesAny(text, ['giờ hoạt động', 'giờ mở cửa', 'giờ đóng cửa', 'thời gian hoạt động'])) {
    return 'Giờ hoạt động của Metro:\n'
        '- Từ thứ 2 đến thứ 6: 5:30 - 22:30\n'
        '- Thứ 7 và Chủ nhật: 5:30 - 23:00\n'
        'Lưu ý: Giờ hoạt động có thể thay đổi vào các ngày lễ.';
  }

  // Quy định sử dụng
  if (_matchesAny(text, ['quy định', 'nội quy', 'quy tắc', 'hướng dẫn sử dụng'])) {
    return 'Quy định sử dụng Metro:\n'
        '1. Mang theo vé khi đi tàu\n'
        '2. Xuất trình thẻ học sinh/sinh viên nếu sử dụng vé học sinh/sinh viên\n'
        '3. Không mang theo vật dụng nguy hiểm\n'
        '4. Không hút thuốc, ăn uống trên tàu\n'
        '5. Nhường ghế cho người già, trẻ em, phụ nữ có thai\n'
        '6. Giữ gìn vệ sinh chung\n'
        'Bạn cần biết thêm thông tin gì không?';
  }
  if (_matchesAny(text, ['vé', 'loại vé',])) {
    return 'Hiện tại có các loại vé như sau:n\n'
          '- Vé lượt\n'
          '- Vé 1 ngày\n'
          '- Vé 3 ngày\n'
          '- Vé tháng\n'
          '- Vé học sinh, sinh viên\n'
          'Bán muốn tìm hiều gì thêm về giá vé hay muốn đặt vé?'
    ;
  }

  // Cảm ơn
  if (_matchesAny(text, ['cảm ơn', 'thank', 'thanks'])) {
    return 'Rất vui được hỗ trợ bạn! Nếu bạn cần thêm thông tin, đừng ngại hỏi tôi nhé.';
  }

  // Mặc định
  return 'Xin lỗi, tôi chưa hiểu ý bạn. Bạn có thể:\n'
      '- Hỏi về giá vé\n'
      '- Xem thông tin các ga\n'
      '- Tìm hiểu quy định sử dụng\n'
      '- Hỏi về giờ hoạt động\n'
      'Hoặc liên hệ tổng đài hỗ trợ để được giúp đỡ.';
}

// Helper function to check if text matches any of the patterns
bool _matchesAny(String text, List<String> patterns) {
  return patterns.any((pattern) => text.contains(pattern));
}

// Helper function to get ordinal suffix
String _getOrdinalSuffix(int number) {
  if (number >= 11 && number <= 13) {
    return 'th';
  }
  switch (number % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
