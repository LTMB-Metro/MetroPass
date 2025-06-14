import 'dart:convert';
import 'package:metropass/controller/station_controller.dart';
import 'package:metropass/controller/ticket_type_controller.dart';
import 'package:metropass/models/station_model.dart';
Future<String> getAIResponse(String input) async {
  final text = input.toLowerCase();


  if (text.contains('bao nhiêu ga') || text.contains('số lượng ga') || text.contains('số ga') || text.contains('có mấy ga')) {
    final stations = await StationController().getAllStations();
    return 'Tuyến Metro hiện có ${stations.length} ga.';
  }
  // Các câu chào hỏi
  if (text.contains('xin chào') || text.contains('chào') || text.contains('hello') || text.contains('hi') || text.contains('good morning') || text.contains('good afternoon') || text.contains('good evening')) {
    return 'Xin chào! Tôi có thể giúp gì cho bạn về hệ thống đặt vé MetroPass?';
  }
  if (text.contains('bạn là ai') || text.contains('bạn tên gì') || text.contains('ai đang trả lời') || text.contains('who are you')) {
    return 'Tôi là trợ lý AI Metro. Bạn cần hỏi gì về vé, ga, hoặc thông tin tuyến metro?';
  }

  // Nhận diện câu hỏi dạng "giá vé từ ... đến ..." hoặc "từ ... đến ..."
  final regExp = RegExp(r'(giá( vé)? )?từ (.+?) đến (.+)', caseSensitive: false, unicode: true);
  final match = regExp.firstMatch(text);
  if (match != null) {
    final fromStation = match.group(3)?.trim();
    final toStation = match.group(4)?.trim();

    // Lấy danh sách ga và tìm vị trí
    final stations = await StationController().getAllStations();

    StationModel? from;
    StationModel? to;
    try {
      from = stations.firstWhere(
        (s) => s.stationName.toLowerCase() == fromStation?.toLowerCase(),
      );
    } catch (_) {
      from = null;
    }
    try {
      to = stations.firstWhere(
        (s) => s.stationName.toLowerCase() == toStation?.toLowerCase(),
      );
    } catch (_) {
      to = null;
    }

    if (from == null || to == null) {
      final stationNames = stations.map((s) => '- ${s.stationName}').join('\n');
      return 'Không tìm thấy ga bạn nhập. Vui lòng kiểm tra lại tên ga (ghi đúng chính tả, có thể copy từ danh sách ga bên dưới):\n$stationNames';
    }

    // Tính khoảng cách số ga
    final distance = (from.orderIndex - to.orderIndex).abs();

    // Quy tắc tính giá vé lượt
    int price = 6000;
    if(distance <= 3){
      price = 6000; // 6.000đ cho 1-3 ga
    } else {
      price = 6000 + (distance - 3) * 1000;
    }
    final ticket = await TicketTypeController().getTicketsOnce(
      fromStation: from,
      toStation: to,
      price: price,
    );
    
    return jsonEncode({
      'message': 'Giá vé lượt từ ${from.stationName} đến ${to.stationName} là: ${price.toString()}đ.\nBạn muốn đặt vé này không?',
      'action': 'payment',
      'ticket': {
        'description': ticket.description,
        'duration': ticket.duration,
        'note': ticket.note,
        'ticket_name': ticket.ticketName,      // snake_case
        'type': ticket.type,
        'categories': ticket.categories,
        'price': ticket.price,
        'from_code': ticket.fromCode,          // snake_case
        'to_code': ticket.toCode,              // snake_case
        'qr_code_URL': ticket.qrCodeURL,       // snake_case
      }
    });
  }

  // Giá vé lượt: hỏi ga đi/ga đến
  if (text.contains('vé lượt') || text.contains('vé lượt')) {
    final stations = await StationController().getAllStations(); // List<StationModel>
    final stationNames = stations.map((s) => '- ${s.stationName}').join('\n');
    return 'Giá vé lượt phụ thuộc vào khoảng cách giữa các ga.\n'
        'Hiện tại có các ga sau:\n'
        '$stationNames\n'
        'Bạn muốn đi từ ga nào đến ga nào? Vui lòng nhập theo mẫu: "Từ [Tên ga đi] đến [Tên ga đến]".';
  }

  // Giá vé ngày
  if (text.contains('vé 1 ngày') || text.contains('vé 1 ngày')) {
    return jsonEncode({
      'message': 'Giá vé ngày: 40.000đ/ngày, đi không giới hạn trong ngày.\nBạn muốn đặt vé ngày này không?',
      'action': 'payment',
      'ticket': {
        'description': '',
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
  if (text.contains('vé 3 ngày') || text.contains('vé 3 ngày')) {
    return jsonEncode({
      'message': 'Giá vé 3 ngày: 90.000đ/3 ngày, đi không giới hạn.\nBạn muốn đặt vé này không?',
      'action': 'payment',
      'ticket': {
        'description': '',
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
  if (text.contains('vé tháng') || text.contains('vé tháng')) {
    return jsonEncode({
      'message': 'Giá vé tháng: 300.000đ/tháng cho người lớn, 150.000đ/tháng cho học sinh, sinh viên.\nBạn muốn đặt vé tháng không?',
      'action': 'payment',
      'ticket': {
        'description': '',
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
  if (text.contains('giá vé học sinh') || text.contains('giá vé sinh viên')) {
    return jsonEncode({
      'message': 'Giá vé tháng học sinh, sinh viên: 150.000đ/tháng.\nBạn muốn đặt vé tháng học sinh/sinh viên không?',
      'action': 'payment',
      'ticket': {
        'description': '',
        'duration': 30,
        'note': 'Tự động kích hoạt sau 180 ngày kể từ ngày mua vé',
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

  // Gợi ý các loại vé khi hỏi giá chung
  if (text.contains('giá') || text.contains('giá vé')) {
    return 'Giá vé tùy loại:\n'
        '- Vé lượt\n'
        '- Vé 1 ngày\n'
        '- Vé 3 ngày\n'
        '- Vé tháng\n'
        'Bạn muốn xem giá loại vé nào? (ví dụ: "giá vé tháng")';
  }

  if (text.contains('vé lượt')) {
    return 'Vé lượt: Dùng cho 1 lần đi. Để biết giá chính xác, bạn vui lòng nhập: "Từ [Tên ga đi] đến [Tên ga đến]".';
  }
  if (text.contains('vé ngày')) {
    return 'Vé ngày có hai loại: vé 1 ngày và vé 3 ngày.\n'
        'Vé 1 ngày: 40.000đ/ngày, đi không giới hạn trong ngày.\n'
        'Vé 3 ngày: 90.000đ/3 ngày, đi không giới hạn trong 3 ngày.\n'
        'Bạn muốn đặt vé nào?';
  }
  if (text.contains('vé tháng')) {
    return 'Vé tháng: Đi không giới hạn trong 1 tháng, giá 200.000đ/tháng cho người lớn, 100.000đ/tháng cho học sinh, sinh viên.';
  }
  if (text.contains('vé học sinh') || text.contains('vé sinh viên')) {
    return 'Vé tháng học sinh, sinh viên: 100.000đ/tháng.';
  }

  if (text.contains('vé') || text.contains('ticket')) {
    return 'Bạn muốn hỏi về vé gì? Vé tháng, vé ngày hay vé lượt?';
  }
  if (text.contains('cảm ơn') || text.contains('thank')) {
    return 'Rất vui được hỗ trợ bạn!';
  }

  // Câu hỏi về số lượng nhà ga
  

  // Câu hỏi về danh sách nhà ga
  if (text.contains('danh sách ga') || text.contains('liệt kê ga') || text.contains('tên các ga')) {
    final stations = await StationController().getAllStations();
    final stationNames = stations.map((s) => '- ${s.stationName}').join('\n');
    return 'Danh sách các ga trên tuyến Metro:\n$stationNames';
  }

  // Câu hỏi về ga đầu, ga cuối
  if (text.contains('ga đầu') || text.contains('ga xuất phát')) {
    final stations = await StationController().getAllStations();
    stations.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return 'Ga đầu tuyến là: ${stations.first.stationName}';
  }
  if (text.contains('ga cuối') || text.contains('ga kết thúc')) {
    final stations = await StationController().getAllStations();
    stations.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return 'Ga cuối tuyến là: ${stations.last.stationName}';
  }

  // Câu hỏi về thông tin một ga cụ thể
  final gaInfoReg = RegExp(r'thông tin ga (.+)', caseSensitive: false, unicode: true);
  final gaInfoMatch = gaInfoReg.firstMatch(text);
  if (gaInfoMatch != null) {
    final gaName = gaInfoMatch.group(1)?.trim();
    final stations = await StationController().getAllStations();
    try {
      final ga = stations.firstWhere(
        (s) => s.stationName.toLowerCase() == gaName?.toLowerCase(),
      );
      return 'Thông tin ga ${ga.stationName}:\n- Mã ga: ${ga.code}\n- Loại ga: ${(ga.type == 'underground') ? 'Ga ngầm\n' : 'Ga trên cao\n'}- Tuyến: ${ga.zone}';
    } catch (_) {
      return 'Không tìm thấy ga "$gaName". Bạn vui lòng kiểm tra lại tên ga.';
    }
  }

  return 'Xin lỗi, tôi chưa hiểu ý bạn. Bạn có thể hỏi lại hoặc liên hệ tổng đài hỗ trợ.';
}
